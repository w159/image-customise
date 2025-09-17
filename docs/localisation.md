---
layout: doc
---
# Localising Windows

`Install-Defaults.ps1` can configure system-wide language / locale settings, and on Windows 10/11 and Windows Server 2025 install language packs. Here's an example installing the English Australia locale settings and language support:

```powershell
.\Install-Defaults.ps1 -Language "en-AU"
```

Use `Install-Defaults.ps1 -Language "<language code>"` to install a language pack and set local settings for a specified language. This parameter supports the **bcp47** tag of the language to install (e.g., `en-AU`, `en-GB`, `fr-FR`). No locale, regional settings or language packs will be installed unless this parameter is specified.

This uses the [Install-Language](https://learn.microsoft.com/en-au/powershell/module/languagepackmanagement/install-language) module to install the appropriate language pack. This module is only available on current version of Windows 10, Windows 11 and Windows Server 2025.

::: info
Installation of a language pack on Windows 10 requires a reboot.
:::

Additional locale settings can be configured for any version of Windows 10, Windows 11 and Windows Server 2016+ with the `International` PowerShell module. `Install-Defaults.ps1` will also configure culture, locale, and language settings using the language value specified in `-Language`.

Below is a summary of the commands used to configure these settings:

```powershell
[System.Globalization.CultureInfo] $Language = "en-AU"
Import-Module -Name "International"
Set-Culture -CultureInfo $Language
Set-WinSystemLocale -SystemLocale $Language
Set-WinUILanguageOverride -Language $Language
Set-WinUserLanguageList -LanguageList $Language.Name -Force
$RegionInfo = New-Object -TypeName "System.Globalization.RegionInfo" -ArgumentList $Language
Set-WinHomeLocation -GeoId $RegionInfo.GeoId
Set-SystemPreferredUILanguage -Language $Language
```

::: warning
Run `Remove-AppxApps.ps1` before using `Install-Defaults.ps1` to install language packs, otherwise the language pack may be removed.
:::

# Set a Time Zone

For Windows 10 and Windows 11, the solution will enable location settings for physical PCs that will automatically se the time zone in most scenarios. However, `Install-Defaults.ps1` can directly set a time zone when specified on the `-TimeZone` parameter. Use `Install-Defaults.ps1 -TimeZone "Time zone name"` to set the required time zone.

To view the list of valid time zone names to pass to this parameter, use `Get-TimeZone -ListAvailable`, and use the time zone name on the `Id` property. Localising Windows and setting the appropriate time zone would look like this:

```powershell
.\Install-Defaults.ps1 -Language "en-AU" -TimeZone "AUS Eastern Standard Time"
```
