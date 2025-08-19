<#
    Update a Windows install with Visual C++ Redistributables, .NET Runtime,
        Windows App SDK, Desktop App Installer, PowerShell, and OneDrive
#>
[CmdletBinding(SupportsShouldProcess = $false)]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $Path = "${Env:SystemDrive}\Apps" #Path to save binaries
)

# Configure the environment
$ProgressPreference = "SilentlyContinue"
$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Create path
New-Item -Path $Path -ItemType "Directory" -Force | Out-Null

# Install VcRedists
$VcList = @{
    x64   = "https://aka.ms/vs/17/release/VC_redist.x64.exe"
    x86   = "https://aka.ms/vs/17/release/VC_redist.x86.exe"
    arm64 = "https://aka.ms/vs/17/release/VC_redist.arm64.exe"
}
switch ($Env:PROCESSOR_ARCHITECTURE) {
    "AMD64" {
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
    "ARM64" {
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
$Version = Invoke-RestMethod -Uri $VersionUrl -UseBasicParsing
$DotNet = @{
    x64   = "https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/$Version/windowsdesktop-runtime-$Version-win-x64.exe"
    arm64 = "https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/$Version/windowsdesktop-runtime-$Version-win-arm64.exe"
}
switch ($Env:PROCESSOR_ARCHITECTURE) {
    "AMD64" {
        $DotNet.x64 | ForEach-Object {
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
    "ARM64" {
        $DotNet.x64, $DotNet.arm64 | ForEach-Object {
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


# Install the Microsoft Windows App SDK
# https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads
function Resolve-Url ($Url) {
    try {
        $req = [System.Net.WebRequest]::Create($Url)
        $req.Method = "HEAD"
        $req.AllowAutoRedirect = $false
        $resp = $req.GetResponse()
        return $resp.GetResponseHeader("Location")

    }
    catch [System.Net.WebException] {
        $resp = $_.Exception.Response
        return $resp.GetResponseHeader("Location")
    }
    finally {
        $resp.Close()
        $resp.Dispose()
    }
}
$AppSdk = @{
    x64   = "https://aka.ms/windowsappsdk/1.7/latest/windowsappruntimeinstall-x64.exe"
    arm64 = "https://aka.ms/windowsappsdk/1.7/latest/windowsappruntimeinstall-arm64.exe"
}
switch ($Env:PROCESSOR_ARCHITECTURE) {
    "AMD64" {
        $AppSdk.x64 | ForEach-Object {
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $_ -Leaf)
            Invoke-WebRequest -Uri (Resolve-Url -Url $_) -OutFile $OutFile -UseBasicParsing
        }
    }
    "ARM64" {
        $AppSdk.arm64 | ForEach-Object {
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $_ -Leaf)
            Invoke-WebRequest -Uri (Resolve-Url -Url $_) -OutFile $OutFile -UseBasicParsing
        }
    }
    default { throw "Unsupported architecture." }
}
$params = @{
    FilePath     = $OutFile
    ArgumentList = "--msix --quiet"
    Wait         = $true
    NoNewWindow  = $true
}
Start-Process @params


# Desktop App Installer
# https://learn.microsoft.com/en-us/windows/msix/app-installer/install-update-app-installer
$OutFile = "$Path\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$params = @{
    Uri             = "https://aka.ms/getwinget"
    OutFile         = $OutFile
    UseBasicParsing = $true
}
Invoke-WebRequest @params
try {
    Add-AppxPackage -Path $OutFile
}
catch {
    Add-AppxPackage -Path $OutFile -ErrorAction "SilentlyContinue" -ForceApplicationShutdown
}

# PowerShell LTS
$VersionUrl = "https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/metadata.json"
$Version = (Invoke-RestMethod -Uri $VersionUrl -UseBasicParsing).LTSReleaseTag[0] -replace "v", ""
$Pwsh = @{
    x64   = "https://github.com/PowerShell/PowerShell/releases/download/v$Version/PowerShell-$Version-win-x64.msi"
    arm64 = "https://github.com/PowerShell/PowerShell/releases/download/v$Version/PowerShell-$Version-win-arm64.msi"
}
switch ($Env:PROCESSOR_ARCHITECTURE) {
    "AMD64" {
        $Pwsh.x64 | ForEach-Object {
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $_ -Leaf)
            Invoke-WebRequest -Uri $_ -OutFile $OutFile -UseBasicParsing
        }
    }
    "ARM64" {
        $Pwsh.arm64 | ForEach-Object {
            $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $_ -Leaf)
            Invoke-WebRequest -Uri $_ -OutFile $OutFile -UseBasicParsing
        }
    }
    default { throw "Unsupported architecture." }
}
$params = @{
    FilePath     = "$Env:SystemRoot\System32\msiexec.exe"
    ArgumentList = "/package `"$OutFile`" /quiet /norestart USE_MU=1 ENABLE_MU=1"
    Wait         = $true
    NoNewWindow  = $true
}
Start-Process @params


# Update Microsoft OneDrive and install per-machine
$params = @{
    Uri             = "https://g.live.com/1rewlive5skydrive/OneDriveProductionV2"
    ContentType     = "application/xml; charset=utf-8"
    Method          = "Default"
    OutFile         = "$Path\OneDrive.xml"
    UseBasicParsing = $true
}
Invoke-WebRequest @params
[System.Xml.XmlDocument]$OneDriveXml = Get-Content -Path "$Path\OneDrive.xml" -Encoding "utf8"
switch ($Env:PROCESSOR_ARCHITECTURE) {
    "AMD64" {
        $Url = $OneDriveXml.root.update.amd64binary.url
        $OutFile = Join-Path -Path $Path -ChildPath (Split-Path -Path $Url -Leaf)
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
    }
    "ARM64" {
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
