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

    if ($json.MachineRegistry.Set.Count -gt 0 -or $json.MachineRegistry.Remove.Count -gt 0 -or $json.UserRegistry.Set.Count -gt 0) {
        $Markdown += "`n"
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += "`n"
        $Markdown += $Table | New-MDTable -Shrink

        if ($json.MachineRegistry.Set.Count -gt 0) {
            $Markdown += New-MDHeader -Text "Set Machine Registry Values" -Level 3
            $Markdown += "`n"
            $Markdown += $json.MachineRegistry.Set | New-MDTable -Shrink
            $Markdown += "`n"
        }

        if ($json.MachineRegistry.Remove.Count -gt 0) {
            $Markdown += New-MDHeader -Text "Remove Machine Registry Vaues" -Level 3
            $Markdown += "`n"
            $Markdown += $json.MachineRegistry.Remove | New-MDTable -Shrink
            $Markdown += "`n"
        }

        if ($json.UserRegistry.Set.Count -gt 0) {
            $Markdown += New-MDHeader -Text "Set User Registry Values" -Level 3
            $Markdown += "`n"
            $Markdown += $json.UserRegistry.Set | New-MDTable -Shrink
            $Markdown += "`n"
        }
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

    if ($json.Capabilities.Remove.Count -gt 0 -or $json.Features.Disable.Count -gt 0 -or $json.Packages.Remove.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"

        if ($json.Capabilities.Remove.Count -gt 0) {
            $Markdown += New-MDHeader -Text "Removed Capabilities" -Level 3
            $Markdown += "`n"
            $Markdown += $json.Capabilities.Remove | ForEach-Object {
                [PSCustomObject]@{
                    "Capability" = $_
                }
            } | New-MDTable -Shrink
            $Markdown += "`n"
        }

        if ($json.Features.Disable.Count -gt 0) {
            $Markdown += New-MDHeader -Text "Disabled Features" -Level 3
            $Markdown += "`n"
            $Markdown += $json.Features.Disable | ForEach-Object {
                [PSCustomObject]@{
                    "Feature" = $_
                }
            } | New-MDTable -Shrink
            $Markdown += "`n"
        }

        if ($json.Packages.Remove.Count -gt 0) {
            $Markdown += New-MDHeader -Text "Removed Packages" -Level 3
            $Markdown += "`n"
            $Markdown += $json.Packages.Remove | ForEach-Object {
                [PSCustomObject]@{
                    "Package" = $_
                }
            } | New-MDTable -Shrink
            $Markdown += "`n"
        }
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

    if ($json.Shortcuts.Edit.Count -gt 0) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Shortcuts.Edit | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion
