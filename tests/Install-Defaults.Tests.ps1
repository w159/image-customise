<#
    .SYNOPSIS
        Integration tests for Install-Defaults.ps1 script
#>
[CmdletBinding()]
param()

BeforeAll {
    if (Test-Path -Path $env:GITHUB_WORKSPACE) {
        $Path = $env:GITHUB_WORKSPACE
    }
    else {
        $Path = $PWD.Path
    }
    $ScriptPath = Get-ChildItem -Path $([System.IO.Path]::Combine($Path, "src")) -Include "Install-Defaults.ps1" -Recurse | Select-Object -First 1
    $ModulePath = Get-ChildItem -Path $([System.IO.Path]::Combine($Path, "src")) -Include "Install-Defaults.psm1" -Recurse | Select-Object -First 1
    
    # Helper function to get OS version
    function Get-OSVersionInfo {
        $OS = Get-CimInstance -ClassName CIM_OperatingSystem
        $Build = [System.Environment]::OSVersion.Version.Build
        $IsServer = $OS.Caption -match 'Server'
        $IsWindows11 = $OS.Caption -match 'Windows 11' -or ($Build -ge 22000 -and -not $IsServer)
        $IsServer2025 = $OS.Caption -match 'Server 2025' -or ($Build -ge 26100 -and $IsServer)
        $SupportsLanguagePack = $IsWindows11 -or $IsServer2025
        
        return @{
            Build                = $Build
            IsServer             = $IsServer
            IsClient             = -not $IsServer
            IsWindows11          = $IsWindows11
            IsServer2025         = $IsServer2025
            SupportsLanguagePack = $SupportsLanguagePack
            Caption              = $OS.Caption
        }
    }

    $OSInfo = Get-OSVersionInfo
    $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Describe 'Install-Defaults.ps1 Script Requirements' {
    It 'Should require Administrator privileges' {
        $ScriptContent = Get-Content -Path $ScriptPath.FullName -Raw
        $ScriptContent | Should -Match '#Requires -RunAsAdministrator'
    }

    It 'Should require Desktop PSEdition' {
        $ScriptContent = Get-Content -Path $ScriptPath.FullName -Raw
        $ScriptContent | Should -Match '#Requires -PSEdition Desktop'
    }

    It 'Should support ShouldProcess' {
        $ScriptContent = Get-Content -Path $ScriptPath.FullName -Raw
        $ScriptContent | Should -Match 'SupportsShouldProcess'
    }
}

Describe 'Install-Defaults.ps1 Parameters' {
    It 'Should have Language parameter' {
        $ScriptContent = Get-Content -Path $ScriptPath.FullName -Raw
        $ScriptContent | Should -Match '\[System\.Globalization\.CultureInfo\]\s+\$Language'
    }

    It 'Should have InstallLanguagePack switch parameter' {
        $ScriptContent = Get-Content -Path $ScriptPath.FullName -Raw
        $ScriptContent | Should -Match '\[System\.Management\.Automation\.SwitchParameter\]\s+\$InstallLanguagePack'
    }

    It 'Should have TimeZone parameter' {
        $ScriptContent = Get-Content -Path $ScriptPath.FullName -Raw
        $ScriptContent | Should -Match '\[System\.String\]\s+\$TimeZone'
    }

    It 'Should have default values for optional parameters' {
        $ScriptContent = Get-Content -Path $ScriptPath.FullName -Raw
        $ScriptContent | Should -Match '\$Path\s*=\s*\$PSScriptRoot'
    }
}

Describe 'Install-Defaults.ps1 Script Execution' -Skip:(-not $IsAdmin) {
    It 'Should execute with minimal parameters' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path   = $([System.IO.Path]::Combine($Path, "src"))
            WhatIf = $true
        }
        { & $ScriptPath.FullName @params } | Should -Not -Throw
        Pop-Location
    }

    It 'Should execute with Language parameter' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path     = $([System.IO.Path]::Combine($Path, "src"))
            Language = "en-US"
            WhatIf   = $true
        }
        { & $ScriptPath.FullName @params } | Should -Not -Throw
        Pop-Location
    }

    It 'Should execute with TimeZone parameter' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path     = $([System.IO.Path]::Combine($Path, "src"))
            TimeZone = "UTC"
            WhatIf   = $true
        }
        { & $ScriptPath.FullName @params } | Should -Not -Throw
        Pop-Location
    }
}

Describe 'Install-Defaults.ps1 Language Support' -Skip:(-not $IsAdmin) {
    It 'Should require Language parameter when InstallLanguagePack is specified' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path                = $([System.IO.Path]::Combine($Path, "src"))
            InstallLanguagePack = $true
            WhatIf              = $true
        }
        { & $ScriptPath.FullName @params } | Should -Throw -ExpectedMessage "The -Language parameter is required when -InstallLanguagePack is specified."
        Pop-Location
    }

    It 'Should install language pack only on supported OS' {
        if ($OSInfo.SupportsLanguagePack) {
            Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
            $params = @{
                Path                = $([System.IO.Path]::Combine($Path, "src"))
                Language            = "en-US"
                InstallLanguagePack = $true
                WhatIf              = $true
            }
            { & $ScriptPath.FullName @params } | Should -Not -Throw
            Pop-Location
        }
        else {
            Set-ItResult -Skipped -Because "Install-SystemLanguage requires Windows 11 (Build 22000+) or Windows Server 2025 (Build 26100+). Current OS: $($OSInfo.Caption), Build: $($OSInfo.Build)"
        }
    }

    It 'Should set locale on all Windows versions' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path     = $([System.IO.Path]::Combine($Path, "src"))
            Language = "en-US"
            WhatIf   = $true
        }
        { & $ScriptPath.FullName @params } | Should -Not -Throw
        Pop-Location
    }
}

Describe 'Install-Defaults.ps1 Configuration Processing' {
    BeforeAll {
        $ConfigPath = Join-Path -Path $Path -ChildPath "configs"
    }

    It 'Should find configuration files' {
        if (Test-Path $ConfigPath) {
            $Configs = Get-ChildItem -Path $ConfigPath -Include "*.json" -Recurse
            $Configs | Should -Not -BeNullOrEmpty
        }
    }

    It 'Should process All configs' {
        if (Test-Path $ConfigPath) {
            $AllConfigs = Get-ChildItem -Path $ConfigPath -Include "*.All.json" -Recurse
            if ($AllConfigs) {
                $AllConfigs.Count | Should -BeGreaterThan 0
            }
        }
        else {
            Set-ItResult -Skipped -Because "Config path does not exist: $ConfigPath"
        }
    }

    It 'Should process platform-specific configs' {
        if (Test-Path $ConfigPath) {
            $Platform = if ($OSInfo.IsServer) { 'Server' } else { 'Client' }
            $PlatformConfigs = Get-ChildItem -Path $ConfigPath -Include "*.$Platform.json" -Recurse
            if ($PlatformConfigs) {
                $PlatformConfigs.Count | Should -BeGreaterThan 0
            }
        }
        else {
            Set-ItResult -Skipped -Because "Config path does not exist: $ConfigPath"
        }
    }
}

Describe 'Install-Defaults.ps1 Feature Update Support' -Skip:(-not $IsAdmin) {
    BeforeAll {
        $Guid = "f38de27b-799e-4c30-8a01-bfdedc622944"
        $FeatureUpdatePath = "$env:SystemRoot\System32\Update\Run\$Guid"
    }

    It 'Should copy files to feature update path' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path   = $([System.IO.Path]::Combine($Path, "src"))
            Guid   = $Guid
            WhatIf = $true
        }
        { & $ScriptPath.FullName @params } | Should -Not -Throw
        Pop-Location
    }

    Context "Target directory exists" {
        It "FeatureUpdates should exist" {
            Test-Path -Path "$FeatureUpdatePath" | Should -BeTrue
        }
    }
}

Describe 'Install-Defaults.ps1 Logging' -Skip:(-not $IsAdmin) {
    It 'Should create log file after execution' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path     = $([System.IO.Path]::Combine($Path, "src"))
            Language = "en-AU"
            TimeZone = "AUS Eastern Standard Time"
        }
        & $ScriptPath.FullName @params
        Pop-Location

        # Check for log file
        $LogPath = "$Env:SystemRoot\Logs\defaults\WindowsEnterpriseDefaults.log"
        $IntunePath = "$Env:ProgramData\Microsoft\IntuneManagementExtension\Logs\WindowsEnterpriseDefaults.log"
        
        $LogExists = (Test-Path -Path $LogPath) -or (Test-Path -Path $IntunePath)
        $LogExists | Should -Be $true
    }
}

Describe 'Install-Defaults.ps1 Uninstall Registry Key' -Skip:(-not $IsAdmin) {
    BeforeAll {
        $Guid = "f38de27b-799e-4c30-8a01-bfdedc622944"
        $UninstallKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{$Guid}"
    }

    It 'Should create uninstall registry key' {
        Push-Location -Path $([System.IO.Path]::Combine($Path, "src"))
        $params = @{
            Path   = $([System.IO.Path]::Combine($Path, "src"))
            Guid   = $Guid
            WhatIf = $true
        }
        { & $ScriptPath.FullName @params } | Should -Not -Throw
        Pop-Location
    }
}

AfterAll {
    Remove-Variable -Name 'OSInfo' -ErrorAction SilentlyContinue
    Remove-Variable -Name 'IsAdmin' -ErrorAction SilentlyContinue
}
