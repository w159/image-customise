<#
    .SYNOPSIS
        Main Pester function tests.
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[CmdletBinding()]
param()

BeforeDiscovery {
    $BasePath = if ($env:GITHUB_WORKSPACE) { $env:GITHUB_WORKSPACE } else { Split-Path -Path $PSScriptRoot -Parent }
    $Scripts = @(Get-ChildItem -Path $([System.IO.Path]::Combine($BasePath, "src")) -Include "Remove-Defaults.ps1" -Recurse)
}

Describe "Uninstall script execution validation" {
    BeforeAll {
        $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }

    Context "Validate <File.Name>" -ForEach $Scripts {
        BeforeAll {
            $File = $_
        }

        It "<File.Name> should execute OK" -Skip:(-not $IsAdmin) {
            Push-Location -Path $File.DirectoryName
            & $File.FullName | Should -Be 0
            Pop-Location
        }
    }
}
