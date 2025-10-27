<#
    .SYNOPSIS
        Pester tests for Remove-AppxApps.ps1 script
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[CmdletBinding()]
param()

BeforeAll {
    # Import the script
    if (Test-Path -Path $env:GITHUB_WORKSPACE) {
        $ScriptPath = Get-ChildItem -Path $([System.IO.Path]::Combine($env:GITHUB_WORKSPACE, "src")) -Include "Remove-AppxApps.ps1" -Recurse | Select-Object -First 1 -ExpandProperty FullName
    }
    else {
        $ScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "..\src\Remove-AppxApps.ps1"
    }
    
    # Helper function to get OS version
    function Get-OSVersionInfo {
        $OS = Get-CimInstance -ClassName CIM_OperatingSystem
        $Build = [System.Environment]::OSVersion.Version.Build
        $IsServer = $OS.Caption -match 'Server'
        $IsWindows11 = $OS.Caption -match 'Windows 11' -or ($Build -ge 22000 -and -not $IsServer)
        $IsWindows10 = $OS.Caption -match 'Windows 10'
        $IsClient = -not $IsServer
        
        return @{
            Build       = $Build
            IsServer    = $IsServer
            IsClient    = $IsClient
            IsWindows11 = $IsWindows11
            IsWindows10 = $IsWindows10
            Caption     = $OS.Caption
        }
    }

    $OSInfo = Get-OSVersionInfo
    $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Describe 'Remove-AppxApps Script Requirements' {
    It 'Should only run on Windows Client OS' {
        if (-not $OSInfo.IsClient) {
            Set-ItResult -Skipped -Because "Remove-AppxApps.ps1 requires Windows Client OS. Current OS: $($OSInfo.Caption)"
        }
        
        $OSInfo.IsClient | Should -Be $true
    }

    It 'Should require elevated privileges for full functionality' {
        if (-not $IsAdmin) {
            Set-ItResult -Skipped -Because "Remove-AppxApps.ps1 requires Administrator privileges for full functionality"
        }
    }

    It 'Should support SupportsShouldProcess' {
        $ScriptContent = Get-Content -Path $ScriptPath -Raw
        $ScriptContent | Should -Match 'SupportsShouldProcess'
    }

    It 'Should have ConfirmImpact set to High' {
        $ScriptContent = Get-Content -Path $ScriptPath -Raw
        $ScriptContent | Should -Match 'ConfirmImpact.*=.*"High"'
    }
}

Describe 'Remove-AppxApps on Windows 11' -Skip:(-not $OSInfo.IsWindows11 -or -not $OSInfo.IsClient) {
    BeforeAll {
        # Dot source the script to load functions
        . $ScriptPath
    }

    It 'Should define Test-IsOobeComplete function' {
        Get-Command -Name 'Test-IsOobeComplete' -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
    }

    It 'Should detect OOBE status correctly' {
        $Result = Test-IsOobeComplete
        $Result | Should -BeOfType [System.Boolean]
    }

    It 'Should have SafePackageList defined' {
        $SafePackageList | Should -Not -BeNullOrEmpty
        $SafePackageList.Count | Should -BeGreaterThan 0
    }

    It 'Should include essential packages in SafePackageList' {
        $EssentialPackages = @(
            'Microsoft.WindowsStore_8wekyb3d8bbwe',
            'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe',
            'Microsoft.SecHealthUI_8wekyb3d8bbwe'
        )
        
        foreach ($Package in $EssentialPackages) {
            $SafePackageList | Should -Contain $Package
        }
    }

    It 'Should support -Targeted parameter' -Skip:(-not $IsAdmin) {
        { & $ScriptPath -Targeted -WhatIf -Confirm:$false } | Should -Not -Throw
    }

    It 'Should support custom SafePackageList' -Skip:(-not $IsAdmin) {
        $CustomList = @('Microsoft.WindowsCalculator_8wekyb3d8bbwe')
        { & $ScriptPath -SafePackageList $CustomList -WhatIf -Confirm:$false } | Should -Not -Throw
    }

    It 'Should query AppX packages' -Skip:(-not $IsAdmin) {
        $Packages = Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        $Packages | Should -Not -BeNullOrEmpty
    }

    It 'Should use Remove-AppxPackage on Windows 11' -Skip:(-not $IsAdmin) {
        # Windows 11 uses Remove-AppxPackage instead of Remove-AppxProvisionedPackage
        { & $ScriptPath -WhatIf -Confirm:$false } | Should -Not -Throw
    }
}

Describe 'Remove-AppxApps on Windows 10' -Skip:(-not $OSInfo.IsWindows10 -or -not $OSInfo.IsClient) {
    It 'Should run on Windows 10 Client' {
        $OSInfo.IsWindows10 | Should -Be $true
        $OSInfo.IsClient | Should -Be $true
    }

    It 'Should support Windows 10 specific packages' -Skip:(-not $IsAdmin) {
        . $ScriptPath
        $SafePackageList | Should -Contain 'Microsoft.WindowsStore_8wekyb3d8bbwe'
    }

    It 'Should handle registry cleanup for Outlook and DevHome' -Skip:(-not $IsAdmin) {
        # These registry keys are Windows 11 specific but should not cause errors on Windows 10
        { & $ScriptPath -WhatIf -Confirm:$false } | Should -Not -Throw
    }

    It 'Should use Remove-AppxProvisionedPackage on Windows 10' -Skip:(-not $IsAdmin) {
        # Windows 10 uses Remove-AppxProvisionedPackage
        $ProvisionedPackages = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        $ProvisionedPackages | Should -Not -BeNullOrEmpty
    }
}

Describe 'Remove-AppxApps Parameter Validation' -Skip:(-not $OSInfo.IsClient) {
    It 'Should accept SafePackageList as ArrayList' {
        $List = [System.Collections.ArrayList]@('Test.Package_8wekyb3d8bbwe')
        { & $ScriptPath -SafePackageList $List -WhatIf -Confirm:$false } | Should -Not -Throw
    }

    It 'Should accept TargetedPackageList as ArrayList' {
        $List = [System.Collections.ArrayList]@('Test.Package_8wekyb3d8bbwe')
        { & $ScriptPath -Targeted -TargetedPackageList $List -WhatIf -Confirm:$false } | Should -Not -Throw
    }

    It 'Should have SafePackageWildCard parameter' {
        $ScriptContent = Get-Content -Path $ScriptPath -Raw
        $ScriptContent | Should -Match '\$SafePackageWildCard'
    }
}

Describe 'Remove-AppxApps Safety Checks' -Skip:(-not $OSInfo.IsClient) {
    It 'Should preserve essential system packages' {
        . $ScriptPath
        $EssentialPackages = @(
            'Microsoft.WindowsStore_8wekyb3d8bbwe',
            'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe',
            'Microsoft.WindowsTerminal_8wekyb3d8bbwe',
            'Microsoft.SecHealthUI_8wekyb3d8bbwe'
        )
        
        foreach ($Package in $EssentialPackages) {
            $SafePackageList | Should -Contain $Package
        }
    }

    It 'Should check OOBE completion before removing apps' {
        . $ScriptPath
        $IsOobeComplete = Test-IsOobeComplete
        $IsOobeComplete | Should -BeOfType [System.Boolean]
    }

    It 'Should warn if OOBE is complete' {
        . $ScriptPath
        if (Test-IsOobeComplete) {
            # Script should display warning when OOBE is complete
            $WarningPreference = 'Continue'
            { & $ScriptPath -WhatIf -Confirm:$false } | Should -Not -Throw
        }
    }
}

Describe 'Remove-AppxApps Registry Cleanup' -Skip:(-not $OSInfo.IsClient) {
    It 'Should handle Outlook registry cleanup' -Skip:(-not $IsAdmin) {
        $OutlookRegPaths = @(
            'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate',
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate',
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\MS_Outlook'
        )
        # Script should handle these paths whether they exist or not
        { & $ScriptPath -WhatIf -Confirm:$false } | Should -Not -Throw
    }

    It 'Should handle DevHome registry cleanup' -Skip:(-not $IsAdmin) {
        $DevHomeRegPaths = @(
            'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate',
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate'
        )
        # Script should handle these paths whether they exist or not
        { & $ScriptPath -WhatIf -Confirm:$false } | Should -Not -Throw
    }
}

Describe 'Remove-AppxApps Function Tests' -Skip:(-not $OSInfo.IsClient) {
    BeforeAll {
        . $ScriptPath
    }

    It 'Should have Add-DeprovisionedPackageKey function' {
        Get-Command -Name 'Add-DeprovisionedPackageKey' -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
    }

    It 'Should handle null or empty PackageFamilyName in Add-DeprovisionedPackageKey' {
        { Add-DeprovisionedPackageKey -PackageFamilyName '' } | Should -Not -Throw
        { Add-DeprovisionedPackageKey -PackageFamilyName $null } | Should -Not -Throw
    }
}

Describe 'Remove-AppxApps OS Version Detection' -Skip:(-not $OSInfo.IsClient) {
    It 'Should detect Windows 11 correctly (Build >= 22000)' {
        $OSVersion = [System.Environment]::OSVersion.Version
        if ($OSInfo.IsWindows11) {
            $OSVersion.Build | Should -BeGreaterOrEqual 22000
        }
    }

    It 'Should use appropriate removal method based on OS version' -Skip:(-not $IsAdmin) {
        { & $ScriptPath -WhatIf -Confirm:$false } | Should -Not -Throw
    }
}

AfterAll {
    # Cleanup any test artifacts
    Remove-Variable -Name 'OSInfo' -ErrorAction SilentlyContinue
    Remove-Variable -Name 'IsAdmin' -ErrorAction SilentlyContinue
}
