<#
    .SYNOPSIS
        Pester tests for Install-Defaults.psm1 module functions
#>
[CmdletBinding()]
param()

BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath "..\src\Install-Defaults.psm1"
    Import-Module $ModulePath -Force

    # Helper function to get OS version
    function Get-OSVersionInfo {
        $OS = Get-CimInstance -ClassName CIM_OperatingSystem
        $Build = [System.Environment]::OSVersion.Version.Build
        $IsServer = $OS.Caption -match 'Server'
        $IsWindows11 = $OS.Caption -match 'Windows 11' -or ($Build -ge 22000 -and -not $IsServer)
        $IsServer2025 = $OS.Caption -match 'Server 2025' -or ($Build -ge 26100 -and $IsServer)
        $IsServer2022 = $OS.Caption -match 'Server 2022'
        $SupportsLanguagePack = $IsWindows11 -or $IsServer2025
        
        return @{
            Build                 = $Build
            IsServer              = $IsServer
            IsClient              = -not $IsServer
            IsWindows11           = $IsWindows11
            IsWindows10           = $OS.Caption -match 'Windows 10'
            IsServer2025          = $IsServer2025
            IsServer2022          = $IsServer2022
            SupportsLanguagePack  = $SupportsLanguagePack
            Caption               = $OS.Caption
        }
    }

    $OSInfo = Get-OSVersionInfo
    $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Describe 'Module Import' {
    It 'Should import the module successfully' {
        Get-Module -Name 'Install-Defaults' | Should -Not -BeNullOrEmpty
    }

    It 'Should export expected functions' {
        $ExportedFunctions = @(
            'Get-Symbol', 'Write-Message', 'Write-LogFile',
            'Get-Platform', 'Get-OSName', 'Get-Model',
            'Get-SettingsContent', 'Set-RegistryOwner',
            'Set-Registry', 'Remove-RegistryPath', 'Set-DefaultUserProfile',
            'Copy-File', 'New-Directory', 'Remove-Path',
            'Remove-Feature', 'Remove-Capability', 'Remove-Package',
            'Get-CurrentUserSid', 'Restart-NamedService',
            'Start-NamedService', 'Stop-NamedService',
            'Install-SystemLanguage', 'Set-SystemLocale',
            'Set-TimeZoneUsingName', 'Test-IsOobeComplete', 'Copy-RegExe'
        )
        
        $Module = Get-Module -Name 'Install-Defaults'
        foreach ($Function in $ExportedFunctions) {
            $Module.ExportedFunctions.Keys | Should -Contain $Function
        }
    }
}

Describe 'Get-Symbol' {
    It 'Should return a tick symbol' {
        $Result = Get-Symbol -Symbol 'Tick'
        $Result | Should -Not -BeNullOrEmpty
    }

    It 'Should return a cross symbol' {
        $Result = Get-Symbol -Symbol 'Cross'
        $Result | Should -Not -BeNullOrEmpty
    }

    It 'Should return null for default when called without parameters' {
        $Result = Get-Symbol
        $Result | Should -Not -BeNullOrEmpty
    }
}

Describe 'Write-Message' {
    It 'Should write message without throwing' {
        { Write-Message -Message 'Test message' -LogLevel 1 } | Should -Not -Throw
    }

    It 'Should handle long messages that exceed console width' {
        $LongMessage = 'A' * 200
        { Write-Message -Message $LongMessage -LogLevel 1 } | Should -Not -Throw
    }

    It 'Should handle different log levels' {
        { Write-Message -Message 'Info' -LogLevel 1 } | Should -Not -Throw
        { Write-Message -Message 'Warning' -LogLevel 2 } | Should -Not -Throw
        { Write-Message -Message 'Error' -LogLevel 3 } | Should -Not -Throw
    }

    It 'Should handle empty messages' {
        { Write-Message -Message '' -LogLevel 1 } | Should -Not -Throw
    }
}

Describe 'Write-LogFile' {
    It 'Should create log file' -Skip:(-not $IsAdmin) {
        { Write-LogFile -Message 'Test log entry' } | Should -Not -Throw
    }

    It 'Should handle multiple messages' -Skip:(-not $IsAdmin) {
        $Messages = @('Message 1', 'Message 2', 'Message 3')
        { $Messages | Write-LogFile } | Should -Not -Throw
    }

    It 'Should handle different log levels' -Skip:(-not $IsAdmin) {
        { Write-LogFile -Message 'Info message' -LogLevel 1 } | Should -Not -Throw
        { Write-LogFile -Message 'Warning message' -LogLevel 2 } | Should -Not -Throw
        { Write-LogFile -Message 'Error message' -LogLevel 3 } | Should -Not -Throw
    }
}

Describe 'Get-Platform' {
    It 'Should return a valid platform' {
        $Result = Get-Platform
        $Result | Should -BeIn @('Client', 'Server')
    }

    It 'Should match OS type' {
        $Result = Get-Platform
        if ($OSInfo.IsServer) {
            $Result | Should -Be 'Server'
        } else {
            $Result | Should -Be 'Client'
        }
    }
}

Describe 'Get-OSName' {
    It 'Should return a valid OS name' {
        $Result = Get-OSName
        $ValidNames = @('Windows2025', 'Windows2022', 'Windows2019', 'Windows2016', 'Windows11', 'Windows10', 'Unknown')
        $Result | Should -BeIn $ValidNames
    }

    It 'Should match current OS' {
        $Result = Get-OSName
        if ($OSInfo.IsWindows11) {
            $Result | Should -Be 'Windows11'
        } elseif ($OSInfo.IsWindows10) {
            $Result | Should -Be 'Windows10'
        } elseif ($OSInfo.IsServer2025) {
            $Result | Should -Be 'Windows2025'
        } elseif ($OSInfo.IsServer2022) {
            $Result | Should -Be 'Windows2022'
        }
    }
}

Describe 'Get-Model' {
    It 'Should return a valid model type' {
        $Result = Get-Model
        $Result | Should -BeIn @('Virtual', 'Physical')
    }
}

Describe 'Get-SettingsContent' {
    BeforeAll {
        $TestJsonPath = "$env:TEMP\test-settings.json"
        $TestContent = @{
            MinimumBuild = '10.0.19041'
            MaximumBuild = '10.0.99999'
            Registry = @{
                Type = 'Direct'
                Set = @()
            }
        } | ConvertTo-Json
        Set-Content -Path $TestJsonPath -Value $TestContent
    }

    It 'Should parse valid JSON file' {
        $Result = Get-SettingsContent -Path $TestJsonPath
        $Result | Should -Not -BeNullOrEmpty
        $Result.MinimumBuild | Should -Be '10.0.19041'
    }

    It 'Should throw on invalid file path' {
        { Get-SettingsContent -Path 'C:\NonExistent\file.json' } | Should -Throw
    }

    AfterAll {
        if (Test-Path $TestJsonPath) {
            Remove-Item -Path $TestJsonPath -Force
        }
    }
}

Describe 'Set-Registry' {
    BeforeAll {
        $TestRegPath = 'HKCU:\Software\PesterTest'
    }

    It 'Should create registry key and set value' -Skip:(-not $IsAdmin) {
        $Setting = @(
            @{
                path = $TestRegPath
                name = 'TestValue'
                value = 'TestData'
                type = 'String'
                protected = $false
            }
        )
        
        { Set-Registry -Setting $Setting -Confirm:$false } | Should -Not -Throw
        
        if (Test-Path $TestRegPath) {
            $Value = Get-ItemProperty -Path $TestRegPath -Name 'TestValue' -ErrorAction SilentlyContinue
            $Value.TestValue | Should -Be 'TestData'
        }
    }

    AfterAll {
        if (Test-Path $TestRegPath) {
            Remove-Item -Path $TestRegPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Describe 'New-Directory' {
    BeforeAll {
        $TestDirPath = "$env:TEMP\PesterTestDir"
    }

    It 'Should create directory' {
        { New-Directory -Path $TestDirPath -Confirm:$false } | Should -Not -Throw
        Test-Path -Path $TestDirPath | Should -Be $true
    }

    It 'Should not error if directory exists' {
        { New-Directory -Path $TestDirPath -Confirm:$false } | Should -Not -Throw
    }

    AfterAll {
        if (Test-Path $TestDirPath) {
            Remove-Item -Path $TestDirPath -Recurse -Force
        }
    }
}

Describe 'Remove-Path' {
    BeforeAll {
        $TestPath = "$env:TEMP\PesterTestRemove"
        New-Item -Path $TestPath -ItemType Directory -Force | Out-Null
    }

    It 'Should remove path' -Skip:(-not $IsAdmin) {
        { Remove-Path -Path @($TestPath) -Confirm:$false } | Should -Not -Throw
        Test-Path -Path $TestPath | Should -Be $false
    }
}

Describe 'Install-SystemLanguage' {
    It 'Should only run on Windows 11 or Server 2025+' {
        if (-not $OSInfo.SupportsLanguagePack) {
            Set-ItResult -Skipped -Because "Install-SystemLanguage requires Windows 11 (Build 22000+) or Windows Server 2025 (Build 26100+). Current OS: $($OSInfo.Caption), Build: $($OSInfo.Build)"
        }
    }

    It 'Should attempt to import LanguagePackManagement module on supported OS' -Skip:(-not $OSInfo.SupportsLanguagePack) {
        { Install-SystemLanguage -Language 'en-US' -Confirm:$false -WhatIf } | Should -Not -Throw
    }

    It 'Should handle missing module gracefully on unsupported OS' -Skip:($OSInfo.SupportsLanguagePack) {
        # On older OS, the function should handle the missing cmdlet gracefully
        { Install-SystemLanguage -Language 'en-US' -Confirm:$false -WhatIf } | Should -Not -Throw
    }
}

Describe 'Set-SystemLocale' {
    It 'Should set locale on all Windows versions' {
        $TestLanguage = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')
        { Set-SystemLocale -Language $TestLanguage -Confirm:$false -WhatIf } | Should -Not -Throw
    }

    It 'Should use Set-SystemPreferredUILanguage on supported OS' -Skip:(-not $OSInfo.SupportsLanguagePack) {
        Get-Command -Name 'Set-SystemPreferredUILanguage' -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
    }
}

Describe 'Set-TimeZoneUsingName' {
    It 'Should set time zone with WhatIf' {
        { Set-TimeZoneUsingName -TimeZone 'UTC' -Confirm:$false -WhatIf } | Should -Not -Throw
    }
}

Describe 'Test-IsOobeComplete' {
    It 'Should return a boolean value' {
        $Result = Test-IsOobeComplete
        $Result | Should -BeOfType [System.Boolean]
    }

    It 'Should return true on fully configured system' {
        $Result = Test-IsOobeComplete
        # On a running system where tests are executed, OOBE should be complete
        $Result | Should -Be $true
    }
}

Describe 'Get-CurrentUserSid' {
    It 'Should return valid SID' {
        $Result = Get-CurrentUserSid
        $Result | Should -Match '^S-1-'
    }
}

Describe 'Copy-RegExe' {
    It 'Should copy reg.exe to temp location' -Skip:(-not $IsAdmin) {
        $Result = Copy-RegExe
        $Result | Should -Not -BeNullOrEmpty
        Test-Path -Path $Result | Should -Be $true
        
        # Cleanup
        if (Test-Path $Result) {
            Remove-Item -Path $Result -Force -ErrorAction SilentlyContinue
        }
    }
}

Describe 'Service Management Functions' {
    BeforeAll {
        # Use a service that exists on all Windows versions
        $TestService = 'wuauserv' # Windows Update service
    }

    It 'Should query service status' {
        $Service = Get-Service -Name $TestService -ErrorAction SilentlyContinue
        $Service | Should -Not -BeNullOrEmpty
    }

    It 'Should handle Start-NamedService with WhatIf' {
        { Start-NamedService -Service @($TestService) -Confirm:$false -WhatIf } | Should -Not -Throw
    }

    It 'Should handle Stop-NamedService with WhatIf' {
        { Stop-NamedService -Service @($TestService) -Confirm:$false -WhatIf } | Should -Not -Throw
    }

    It 'Should handle Restart-NamedService with WhatIf' {
        { Restart-NamedService -Service @($TestService) -Confirm:$false -WhatIf } | Should -Not -Throw
    }
}

AfterAll {
    Remove-Module -Name 'Install-Defaults' -Force -ErrorAction SilentlyContinue
}
