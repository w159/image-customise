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

    $json = Get-Content -Path $file.FullName | ConvertFrom-Json
    if ($null -ne $json.Registry.Set) {
        $Markdown += New-MDHeader -Text $file.Name -Level 2
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        if ($null -ne $json.Registry.Type) {
            $Table | Add-Member -MemberType "NoteProperty" -Name "Type" -Value $json.Registry.Type
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Registry.Set | Select-Object -Property  @{ Name = "path"; Expression = { $_.path -replace "\\", " \" } }, "name", "value", "note" | New-MDTable -Shrink
        $Markdown += "`n"
    }

    if ($null -ne $json.Registry.Remove) {
        $Markdown += "`n"
        $Markdown += "**$($json.Description)**`n`n"
        $Table = [PSCustomObject]@{
            "Minimum build" = $json.MinimumBuild
            "Maximum build" = $json.MaximumBuild
        }
        if ($null -ne $json.Registry.Type) {
            $Table | Add-Member -MemberType "NoteProperty" -Name "Type" -Value $json.Registry.Type
        }
        $Markdown += $Table | New-MDTable -Shrink
        $Markdown += "`n"
        $Markdown += $json.Registry.Remove | Select-Object -Property  @{ Name = "path"; Expression = { $_.path -replace "\\", " \" } }, "note" | New-MDTable -Shrink
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

    $json = Get-Content -Path $file.FullName | ConvertFrom-Json
    if ($null -ne $json.Capabilities.Remove) {
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

    if ($null -ne $json.Features.Disable) {
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

    if ($null -ne $json.Packages.Remove) {
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

    $json = Get-Content -Path $file.FullName | ConvertFrom-Json
    if ($null -ne $json.Paths.Remove) {
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

    $json = Get-Content -Path $file.FullName | ConvertFrom-Json
    if ($null -ne $json.Services.Enable) {
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
        $Markdown += $json.StartMenu.Exists | New-MDTable -Shrink
        $Markdown += $json.StartMenu.NotExists | New-MDTable -Shrink
        $Markdown += $json.StartMenu.Windows10 | New-MDTable -Shrink
        $Markdown += $json.StartMenu.Windows11 | New-MDTable -Shrink
        $Markdown += "`n"
    }
}
($Markdown.TrimEnd("`n")) | Out-File -FilePath $OutFile -Force -Encoding "Utf8"
#endregion
