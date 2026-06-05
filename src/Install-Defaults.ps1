#Requires -RunAsAdministrator
#Requires -PSEdition Desktop
<#
    .SYNOPSIS
    Implements Configuration changes to a default install of Windows to enable an enterprise ready installation.

    .PARAMETER Language
    A CultureInfo value that defines the locale / language configuration to install and configure for Windows.

    .PARAMETER TimeZone
    A string that is the StandardName or DaylightName properties of the TimeZoneInfo object. Use 'Get-TimeZone -ListAvailable' to list available time zones.

    .PARAMETER Path
    Path to where the scripts and configuration files are located.

    .PARAMETER Guid
    A GUID string that identifies the solution installation for detection via the Uninstall key in the Windows registry.

    .PARAMETER Publisher
    String that represents the publisher information that will be stored in the Uninstall key in the Windows registry.

    .PARAMETER RunOn
    Date time stamp that will be stored in the Uninstall key in the Windows registry.

    .PARAMETER Project
    A string that defines the name for the solution. This string will be used for the custom event log to track the installation and stored in the Windows registry.

    .PARAMETER Helplink
    A string that defines a URL for the solution. This string will be written to the Uninstall key in the Windows registry.

    .PARAMETER FeatureUpdatePath
    A directory path in which the solution will be copied into to enable running during Windows feature updates.

    .EXAMPLE
    PS C:\image-defaults> .\Install-Defaults.ps1 -Language "en-AU" -TimeZone "AUS Eastern Standard Time" -Verbose

    .NOTES
    NAME: Install-Defaults.ps1
    AUTHOR: Aaron Parker
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.Globalization.CultureInfo] $Language, # Set the specified locale / language

    [Parameter(Mandatory = $false)]
    [ValidateScript({
            if ($_ -and -not $PSBoundParameters.ContainsKey('Language')) {
                throw "The -Language parameter is required when -InstallLanguagePack is specified."
            }
            return $true
        })]
    [System.Management.Automation.SwitchParameter] $InstallLanguagePack, # Install the language pack for the specified language

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $TimeZone,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $Path = $PSScriptRoot,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $Guid = "f38de27b-799e-4c30-8a01-bfdedc622944",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $Publisher = "stealthpuppy",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $RunOn = $(Get-Date -Format "yyyy-MM-dd"),

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $Project = "Windows Enterprise Defaults",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $Helplink = "https://stealthpuppy.com/defaults/",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String] $FeatureUpdatePath = "$env:SystemRoot\System32\update\run\$Guid"
)

#region Restart if running in a 32-bit session
if (!([System.Environment]::Is64BitProcess)) {
    if ([System.Environment]::Is64BitOperatingSystem) {

        # Create a string from the passed parameters
        [System.String]$ParameterString = ""
        foreach ($Parameter in $PSBoundParameters.GetEnumerator()) {
            $ParameterString += " -$($Parameter.Key) $($Parameter.Value)"
        }

        # Execute the script in a 64-bit process with the passed parameters
        $Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$($MyInvocation.MyCommand.Definition)`"$ParameterString"
        $ProcessPath = $(Join-Path -Path $Env:SystemRoot -ChildPath "\Sysnative\WindowsPowerShell\v1.0\powershell.exe")
        $params = @{
            FilePath     = $ProcessPath
            ArgumentList = $Arguments
            Wait         = $true
            WindowStyle  = "Hidden"
        }
        Start-Process @params
        exit 0
    }
}
#endregion

#region Configure the environment
Set-StrictMode -Version Latest
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
$InformationPreference = [System.Management.Automation.ActionPreference]::continue
$ProgressPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
$WarningPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

try {
    # Get start time of the script
    $StartTime = Get-Date

    # Configure working path
    if ($Path.Length -eq 0) { $WorkingPath = $PWD.Path } else { $WorkingPath = $Path }
    Push-Location -Path $WorkingPath
    #endregion

    #region Import functions
    $ModuleFile = $(Join-Path -Path $PSScriptRoot -ChildPath "Install-Defaults.psm1")
    Test-Path -Path $ModuleFile -PathType "Leaf" -ErrorAction "Stop" | Out-Null
    Import-Module -Name $ModuleFile -Force -ErrorAction "Stop"
    Write-LogFile -Message "Execution path: $WorkingPath"
    #endregion

    # Start logging
    $PSProcesses = Get-CimInstance -ClassName "Win32_Process" -Filter "Name = 'powershell.exe'" | Select-Object -Property "CommandLine"
    foreach ($Process in $PSProcesses) {
        Write-LogFile -Message "Running process: $($Process.CommandLine)"
    }

    #region Get system properties
    $Platform = Get-Platform

    $Build = ([System.Environment]::OSVersion.Version).Build
    $OSVersion = [System.Environment]::OSVersion.Version
    Write-LogFile -Message "Build: $Build"

    $Model = Get-Model
    $OSName = Get-OSName

    $DisplayVersion = Get-ChildItem -Path $WorkingPath -Include "VERSION.txt" -Recurse | Get-Content -Raw
    Write-LogFile -Message "Script version: $DisplayVersion"
    #endregion

    #region Gather configs
    $ConfigurationFiles = @(Get-ChildItem -Path "$WorkingPath\configs" -Include "*.json" -Recurse)
    Write-LogFile -Message "Found: $($ConfigurationFiles.Count) configuration files"

    # Read the configuration files, convert from JSON, and filter based on the platform, model, and build of the local system
    $Configurations = $ConfigurationFiles | `
        ForEach-Object { Get-Content -Path $_.FullName -Raw | ConvertFrom-Json } | `
        Where-Object { $Platform -in $_.Targets.Platforms -and $Model -in $_.Targets.Models } | `
        Where-Object { [System.Version]$OSVersion -ge [System.Version]$_.MinimumBuild } | `
        Where-Object { [System.Version]$OSVersion -le [System.Version]$_.MaximumBuild }
    Write-LogFile -Message "Found: $($Configurations.Count) applicable configuration sets to apply"
    #endregion

    #region Implement the settings defined in each config file
    foreach ($ConfigSet in $Configurations) {
        Write-LogFile -Message "Configuration set: $($ConfigSet.Description)" 

        #region Configure machine level settings
        if ($ConfigSet.MachineRegistry.ChangeOwner.Length -gt 0) {
            foreach ($Item in $ConfigSet.MachineRegistry.ChangeOwner) {
                Set-RegistryOwner -RootKey $Item.Root -Key $Item.Key -Sid $Item.Sid
            }
        }
        Set-Registry -Setting $ConfigSet.MachineRegistry.Set
        Remove-RegistryPath -Path $ConfigSet.MachineRegistry.Remove

        foreach ($Shortcut in $ConfigSet.Shortcuts.Edit) {
            Set-Shortcut -Path $Shortcut.Path -Arguments $Shortcut.Arguments
        }

        Copy-File -Path $ConfigSet.Files.Copy -Parent $WorkingPath
        Remove-Path -Path $ConfigSet.Paths.Remove

        Remove-Feature -Feature $ConfigSet.Features.Disable
        Remove-Capability -Capability $ConfigSet.Capabilities.Remove
        Remove-Package -Package $ConfigSet.Packages.Remove

        Stop-NamedService -Service $ConfigSet.Services.Stop
        Start-NamedService -Service $ConfigSet.Services.Start
        Restart-NamedService -Service $ConfigSet.Services.Restart
        #endregion

        # Set default user profile settings
        Set-DefaultUserProfile -Setting $ConfigSet.UserRegistry.Set
    }
    #endregion

    #region If on a client OS, remove AppX applications
    if ($Platform -eq "Client") {
        if (Test-IsOobeComplete) {
            # If OOBE is complete, we should play it safe and not attempt to remove AppX apps
            # Explicitly call Remove-AppxApps.ps1 instead, e.g. for gold images
            Write-LogFile -Message "OOBE is complete. To remove AppX apps, explicitly call Remove-AppxApps.ps1" -LogLevel 2
        }
        else {
            # Run the script to remove AppX/UWP apps; Get the script location
            $Script = Get-ChildItem -Path $WorkingPath -Include "Remove-AppxApps.ps1" -Recurse -ErrorAction "Continue"
            if ($null -eq $Script) {
                Write-LogFile -Message "Script not found: $WorkingPath\Remove-AppxApps.ps1" -LogLevel 3
            }
            else {
                Write-LogFile -Message "Run script: $WorkingPath\Remove-AppxApps.ps1"
                $Apps = & $Script.FullName  -Confirm:$false
                foreach ($App in $Apps) { Write-LogFile -Message "Removed AppX app: $App" }
            }
        }
    }
    #endregion

    #region Set system language, locale and regional settings
    if ($PSBoundParameters.ContainsKey('Language')) {
        if ($OSVersion -ge [System.Version]"10.0.22000") {

            if ($InstallLanguagePack.IsPresent) {
                # Set language support by installing the specified language pack
                Install-SystemLanguage -Language $Language
            }

            # Set locale settings
            Set-SystemLocale -Language $Language
        }
        else {
            # On Windows Server 2022 or below, use dism to install language packs
            # https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-languages-and-international-servicing-command-line-options

            # Set locale settings
            Set-SystemLocale -Language $Language
        }
    }
    else {
        Write-LogFile -Message "-Language parameter not specified. Skipping install language support"
    }

    if ($PSBoundParameters.ContainsKey('TimeZone')) {
        Set-TimeZoneUsingName -TimeZone $TimeZone
    }
    else {
        Write-LogFile -Message "-TimeZone parameter not specified. Skipping set time zone"
    }
    #endregion

    #region Copy the source files for use with upgrades
    if (Test-Path -Path "$FeatureUpdatePath\Install-Defaults.ps1" -PathType "Leaf") {
        Write-LogFile -Message "Skipping copy to $FeatureUpdatePath"
    }
    else {
        try {
            Write-LogFile -Message "New directory: $FeatureUpdatePath"
            New-Item -Path $FeatureUpdatePath -ItemType "Directory" -Force -ErrorAction "SilentlyContinue" | Out-Null
            Copy-Item -Path "$WorkingPath\*" -Destination $FeatureUpdatePath -Recurse -ErrorAction "SilentlyContinue"
            Write-LogFile -Message "Copied $WorkingPath\* to $FeatureUpdatePath"
        }
        catch {
            Write-LogFile -Message $_.Exception.Message -LogLevel 3
        }
    }
}
#endregion
catch {
    Write-LogFile -Message "Unhandled error in Install-Defaults.ps1" -LogLevel 3
    Write-LogFile -Message "Error: $($_.Exception.Message)" -LogLevel 3
    Write-LogFile -Message "Type: $($_.Exception.GetType().FullName)" -LogLevel 3
    Write-LogFile -Message "Script: $($_.InvocationInfo.ScriptName)" -LogLevel 3
    Write-LogFile -Message "Line: $($_.InvocationInfo.ScriptLineNumber)" -LogLevel 3
    Write-LogFile -Message "Offset: $($_.InvocationInfo.OffsetInLine)" -LogLevel 3
    #Write-LogFile -Message "Command: $($_.InvocationInfo.MyCommand)" -LogLevel 3
    Write-LogFile -Message "Line text: $($_.InvocationInfo.Line.Trim())" -LogLevel 3
    #Write-LogFile -Message "Position: $($_.InvocationInfo.PositionMessage)" -LogLevel 3
    Write-LogFile -Message "Category: $($_.CategoryInfo)" -LogLevel 3
    Write-LogFile -Message "FullyQualifiedErrorId: $($_.FullyQualifiedErrorId)" -LogLevel 3
    #Write-LogFile -Message "ScriptStackTrace: $($_.ScriptStackTrace)" -LogLevel 3
}

#region Set uninstall registry value for detecting as an installed application
$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
New-Item -Path "$Key\{$Guid}" -Type "RegistryKey" -Force -ErrorAction "Continue" | Out-Null
if ($PSCmdlet.ShouldProcess("Set uninstall key values")) {
    Set-ItemProperty -Path "$Key\{$Guid}" -Name "DisplayName" -Value $Project -Type "String" -Force -ErrorAction "Continue" | Out-Null
    Set-ItemProperty -Path "$Key\{$Guid}" -Name "Publisher" -Value $Publisher -Type "String" -Force -ErrorAction "Continue" | Out-Null
    Set-ItemProperty -Path "$Key\{$Guid}" -Name "DisplayVersion" -Value $DisplayVersion -Type "String" -Force -ErrorAction "Continue" | Out-Null
    Set-ItemProperty -Path "$Key\{$Guid}" -Name "RunOn" -Value $RunOn -Type "String" -Force -ErrorAction "Continue" | Out-Null
    Set-ItemProperty -Path "$Key\{$Guid}" -Name "SystemComponent" -Value 1 -Type "DWord" -Force -ErrorAction "Continue" | Out-Null
    Set-ItemProperty -Path "$Key\{$Guid}" -Name "HelpLink" -Value $HelpLink -Type "String" -Force -ErrorAction "Continue" | Out-Null
}
#endregion

# Write last entry to the event log and output 0 so that we don't fail image builds
$EndTime = (Get-Date) - $StartTime
Write-LogFile -Message "Install-Defaults.ps1 complete. Elapsed time: $EndTime"
exit 0
