<#
    Update a Windows install with Visual C++ Redistributables, .NET Runtime, and OneDrive
#>

# Path to save binaries
$Path = "C:\Apps"

# Configure the environment
$ProgressPreference = "SilentlyContinue"
$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"
if ([System.Enum]::IsDefined([System.Net.SecurityProtocolType], "Tls13")) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls13
}
else {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
}

# Create path
New-Item -Path $Path -ItemType "Directory" -Force | Out-Null

# Install VcRedists
$VcList = @{
    x64   = "https://aka.ms/vs/17/release/VC_redist.x64.exe"
    x86   = "https://aka.ms/vs/17/release/VC_redist.x86.exe"
    arm64 = "https://aka.ms/vs/17/release/VC_redist.arm64.exe"
}
switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
    "X64" {
        $VcList.x86, $VcList.x64 | ForEach-Object {
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $_ -Leaf)
            Invoke-WebRequest -Uri $_ -OutFile $OutFile -UseBasicParsing
            $params = @{
                FilePath     = $OutFile
                ArgumentList = "/install /quiet /norestart"
                Wait         = $true
                NoNewWindow  = $true
            }
            Start-Process @params
        }
    }
    "Arm64" {
        $VcList.x86, $VcList.x64, $VcList.arm64 | ForEach-Object {
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $_ -Leaf)
            Invoke-WebRequest -Uri $_ -OutFile $OutFile -UseBasicParsing
            $params = @{
                FilePath     = $OutFile
                ArgumentList = "/install /quiet /norestart"
                Wait         = $true
                NoNewWindow  = $true
            }
            Start-Process @params
        }
    }
    default { throw "Unsupported architecture." }
}

# Install the Microsoft .NET LTS
$VersionUrl = "https://dotnetcli.blob.core.windows.net/dotnet/Runtime/LTS/latest.version"
$DotNet = @{
    x64   = "https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/#version/windowsdesktop-runtime-#version-win-x64.exe"
    arm64 = "https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/#version/windowsdesktop-runtime-#version-win-arm64.exe"
}
switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
    "X64" {
        $DotNet.x64 | ForEach-Object {
            $Version = Invoke-RestMethod -Uri $VersionUrl -UseBasicParsing
            $Url = $_ -replace "#version", $Version
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $Url -Leaf)
            Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
            $params = @{
                FilePath     = $OutFile
                ArgumentList = "/install /quiet /norestart"
                Wait         = $true
                NoNewWindow  = $true
            }
            Start-Process @params
        }
    }
    "Arm64" {
        $DotNet.x64, $DotNet.arm64 | ForEach-Object {
            $Version = Invoke-RestMethod -Uri $VersionUrl -UseBasicParsing
            $Url = $_ -replace "#version", $Version
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $Url -Leaf)
            Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
            $params = @{
                FilePath     = $OutFile
                ArgumentList = "/install /quiet /norestart"
                Wait         = $true
                NoNewWindow  = $true
            }
            Start-Process @params
        }
    }
    default { throw "Unsupported architecture." }
}

# Update Microsoft OneDrive and install per-machine
$params = @{
    Uri             = "https://g.live.com/1rewlive5skydrive/OneDriveProductionV2"
    ContentType     = "application/xml; charset=utf-8"
    Method          = "Default"
    OutFile         = "$Path\OneDrive.xml"
    PassThru        = $false
    UseBasicParsing = $true
}
Invoke-WebRequest @params
[System.Xml.XmlDocument]$OneDriveXml = Get-Content -Path "$Path\OneDrive.xml" -Encoding "utf8"
switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
    "X64" {
        $Url = $OneDriveXml.root.update.amd64binary.url
        $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $Url -Leaf)
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
    }
    "Arm64" {
        $Url = $OneDriveXml.root.update.arm64binary.url
        $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $Url -Leaf)
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
    }
    default { throw "Unsupported architecture." }
}
reg add "HKLM\Software\Microsoft\OneDrive" /v "AllUsersInstall" /t REG_DWORD /d 1 /reg:64 /f *> $null
$params = @{
    FilePath     = $OutFile
    ArgumentList = "/silent /allusers"
    Wait         = $false
    NoNewWindow  = $true
    ErrorAction  = "Stop"
}
Start-Process @params
do {
    Start-Sleep -Seconds 5
} while (Get-Process -Name "OneDriveSetup" -ErrorAction "SilentlyContinue")
Get-Process -Name "OneDrive" -ErrorAction "SilentlyContinue" | ForEach-Object {
    Stop-Process -Name $_.Name -Force -ErrorAction "SilentlyContinue"
}

# Cleanup downloads
Remove-Item -Path $Path -Recurse -Force -ErrorAction "SilentlyContinue"
