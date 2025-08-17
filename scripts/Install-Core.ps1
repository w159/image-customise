
$Path = "C:\Apps"
New-Item -Path $Path -ItemType "Directory" -Force -ErrorAction "SilentlyContinue" | Out-Null

# Trust the PSGallery for modules
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Install-PackageProvider -Name "PowerShellGet" -MinimumVersion "2.2.5" -Force -ErrorAction "SilentlyContinue"
Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"

# Install the Evergreen module; https://stealthpuppy.com/evergreen
# Install the VcRedist module; https://vcredist/
foreach ($Module in "Evergreen", "VcRedist") {
    $InstalledModule = Get-Module -Name $Module -ListAvailable -ErrorAction "SilentlyContinue" | `
        Sort-Object -Property @{ Expression = { [System.Version]$_.Version }; Descending = $true } -ErrorAction "SilentlyContinue" | `
        Select-Object -First 1
    $PublishedModule = Find-Module -Name $Module -ErrorAction "SilentlyContinue"
    if (($null -eq $InstalledModule) -or ([System.Version]$PublishedModule.Version -gt [System.Version]$InstalledModule.Version)) {
        $params = @{
            Name               = $Module
            SkipPublisherCheck = $true
            Force              = $true
            ErrorAction        = "Stop"
        }
        Install-Module @params
    }
}

Import-Module -Name "VcRedist" -Force
Get-VcList | Save-VcRedist -Path $Path | Install-VcRedist -Silent

Import-Module -Name "Evergreen" -Force
$App = Get-EvergreenApp -Name "Microsoft.NET" | `
    Where-Object { $_.Installer -eq "windowsdesktop" -and $_.Architecture -eq "x64" -and $_.Channel -match "LTS" }
$OutFile = Save-EvergreenApp -InputObject $App -CustomPath $Path -ErrorAction "Stop"

foreach ($File in $OutFile) {
    $params = @{
        FilePath     = $File.FullName
        ArgumentList = "/install /quiet /norestart"
        Wait = $true
        NoNewWindow = $true
        ErrorAction = "Stop"
    }
    Start-Process @params
}

$App = Get-EvergreenApp -Name "MicrosoftOneDrive" | `
    Where-Object { $_.Ring -eq "Production" -and $_.Throttle -eq "100" -and $_.Architecture -eq "x64" } | `
    Sort-Object -Property @{ Expression = { [System.Version]$_.Version }; Descending = $true } | Select-Object -First 1
$OutFile = Save-EvergreenApp -InputObject $App -CustomPath $Path -ErrorAction "Stop"

# Install
reg add "HKLM\Software\Microsoft\OneDrive" /v "AllUsersInstall" /t REG_DWORD /d 1 /reg:64 /f *> $null
$params = @{
    FilePath     = $OutFile.FullName
    ArgumentList = "/silent /allusers"
    Wait         = $false
            NoNewWindow = $true
        ErrorAction = "Stop"
}
Start-Process @params
do {
    Start-Sleep -Seconds 5
} while (Get-Process -Name "OneDriveSetup" -ErrorAction "SilentlyContinue")
Get-Process -Name "OneDrive" -ErrorAction "SilentlyContinue" | ForEach-Object {
    Stop-Process -Name $_.Name -Force -ErrorAction "SilentlyContinue"
}

New-Item -Path $Env:Temp -ItemType "Directory" -ErrorAction "SilentlyContinue" | Out-Null


$App = Get-EvergreenApp -Name "Microsoft.NET" | `
    Where-Object { $_.Installer -eq "windowsdesktop" -and $_.Architecture -eq "x64" -and $_.Channel -match "LTS" }
$OutFile = Save-EvergreenApp -InputObject $App -CustomPath $Path -ErrorAction "Stop"

foreach ($File in $OutFile) {
    $params = @{
        FilePath     = $File.FullName
        ArgumentList = "/install /quiet /norestart"
    Wait         = $true
            NoNewWindow = $true
        ErrorAction = "Stop"
}
Start-Process @params
}

Remove-Item -Path $Path -Recurse -Force -ErrorAction "SilentlyContinue"
