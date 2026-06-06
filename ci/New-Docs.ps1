#Requires -Module "MarkdownPS"
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [System.String] $Path
)
$Configs = Get-ChildItem -Path "$Path/*.json" -Recurse

$Layout = @"
---
layout: doc
---

"@

#region Registry settings
$OutFile = [System.IO.Path]::Combine("docs/registry.md")
$Markdown = $Layout
$Markdown += New-MDHeader -Text "Registry Settings" -Level 1
$Markdown += "`n"
foreach ($file in $Configs) {
    if ($file.Name -like "_*") { continue }
    $json = Get-Content -Path $file.FullName | ConvertFrom-Json

    if ($json.MachineRegistry.Set.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        if ($null -ne $json.MachineRegistry.Type) {
            $Table | Add-Member -MemberType "NoteProperty" -Name "Type" -Value $json.MachineRegistry.Type
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.MachineRegistry.Set | Select-Object -Property  @{ Name = "path"; Expression = { $_.path -replace "\\", " \" } }, "name", "value", "note" | New-MDTable -Shrink
        $Markdown += "`n"
    }

    if ($json.UserRegistry.Set.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        if ($null -ne $json.UserRegistry.Type) {
            $Table | Add-Member -MemberType "NoteProperty" -Name "Type" -Value $json.UserRegistry.Type
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.UserRegistry.Set | Select-Object -Property  @{ Name = "path"; Expression = { $_.path -replace "\\", " \" } }, "name", "value", "note" | New-MDTable -Shrink
        $Markdown += "`n"
    }

    if ($json.MachineRegistry.Remove.Count -gt 0) {
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        if ($null -ne $json.MachineRegistry.Type) {
            $Table | Add-Member -MemberType "NoteProperty" -Name "Type" -Value $json.MachineRegistry.Type
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.MachineRegistry.Remove | Select-Object -Property  @{ Name = "path"; Expression = { $_.path -replace "\\", " \" } }, "note" | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion

#region Capabilities and features
$OutFile = [System.IO.Path]::Combine("docs/features.md")
$Markdown = $Layout
$Markdown += New-MDHeader -Text "Removed Capabilities and Features" -Level 1
$Markdown += "`n"
foreach ($file in $Configs) {
    if ($file.Name -like "_*") { continue }
    $json = Get-Content -Path $file.FullName | ConvertFrom-Json

    if ($json.Capabilities.Remove.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Capabilities.Remove | ForEach-Object {
            [PSCustomObject]@{
                "Capability" = $_
            }
        } | New-MDTable -Shrink
        $Markdown += "`n"
    }

    if ($json.Features.Disable.Count -gt 0) {
        $Markdown += "`n"
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Features.Disable | ForEach-Object {
            [PSCustomObject]@{
                "Feature" = $_
            }
        } | New-MDTable -Shrink
        $Markdown += "`n"
    }

    if ($json.Packages.Remove.Count -gt 0) {
        $Markdown += "`n"
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Packages.Remove | ForEach-Object {
            [PSCustomObject]@{
                "Feature" = $_
            }
        } | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion

#region Paths
$OutFile = [System.IO.Path]::Combine("docs/paths.md")
$Markdown = $Layout
$Markdown += New-MDHeader -Text "Removed Paths" -Level 1
$Markdown += "`n"
foreach ($file in $Configs) {
    if ($file.Name -like "_*") { continue }
    $json = Get-Content -Path $file.FullName | ConvertFrom-Json

    if ($json.Paths.Remove.Count -gt 0) {
        $Markdown += "`n"
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Paths.Remove | ForEach-Object {
            [PSCustomObject]@{
                "Path" = $_
            }
        } | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion

#region Services
$OutFile = [System.IO.Path]::Combine("docs/services.md")
$Markdown = $Layout
$Markdown += New-MDHeader -Text "Services" -Level 1
$Markdown += "`n"
foreach ($file in $Configs) {
    if ($file.Name -like "_*") { continue }
    $json = Get-Content -Path $file.FullName | ConvertFrom-Json

    if ($json.Services.Enable.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Services.Enable | ForEach-Object {
            [PSCustomObject]@{
                "Service" = $_
            }
        } | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion

#region Files
$OutFile = [System.IO.Path]::Combine("docs/files.md")
$Markdown = $Layout
$Markdown += New-MDHeader -Text "Files" -Level 1
$Markdown += "`n"
foreach ($file in $Configs) {
    if ($file.Name -like "_*") { continue }
    $json = Get-Content -Path $file.FullName | ConvertFrom-Json

    if ($json.Files.Copy.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Files.Copy | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion

#region Shortcuts
$OutFile = [System.IO.Path]::Combine("docs/shortcuts.md")
$Markdown = $Layout
$Markdown += New-MDHeader -Text "Shortcuts" -Level 1
$Markdown += "`n"
foreach ($file in $Configs) {
    if ($file.Name -like "_*") { continue }
    $json = Get-Content -Path $file.FullName | ConvertFrom-Json

    if ($json.Shortcuts.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Shortcuts | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion

#region Start Menu
$OutFile = [System.IO.Path]::Combine("docs/startmenu.md")
$Markdown = $Layout
$Markdown += New-MDHeader -Text "Start Menu" -Level 1
$Markdown += "`n"
foreach ($file in $Configs) {
    if ($file.Name -like "_*") { continue }
    $json = Get-Content -Path $file.FullName | ConvertFrom-Json

    if ($null -ne $json.StartMenu) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        if ($null -ne $json.StartMenu.Type) {
            $Table | Add-Member -MemberType "NoteProperty" -Name "Type" -Value $json.StartMenu.Type
        }
        if ($null -ne $json.StartMenu.Feature) {
            $Table | Add-Member -MemberType "NoteProperty" -Name "Feature" -Value $json.StartMenu.Feature
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        if ($json.StartMenu.Exists.Count -gt 0) { $Markdown += $json.StartMenu.Exists | New-MDTable -Shrink }
        if ($json.StartMenu.NotExists.Count -gt 0) { $Markdown += $json.StartMenu.NotExists | New-MDTable -Shrink }
        if ($json.StartMenu.Windows10.Count -gt 0) { $Markdown += $json.StartMenu.Windows10 | New-MDTable -Shrink }
        if ($json.StartMenu.Windows11.Count -gt 0) { $Markdown += $json.StartMenu.Windows11 | New-MDTable -Shrink }
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion
