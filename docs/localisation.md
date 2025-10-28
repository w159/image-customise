---
layout: doc
---
# Localising Windows

`Install-Defaults.ps1` can configure system-wide language / locale settings, and on Windows 10/11 and Windows Server 2025 install language packs. Here's an example installing the English Australia locale settings and language support:

```powershell
.\Install-Defaults.ps1 -Language "en-AU" -InstallLanguagePack
```

Use `Install-Defaults.ps1 -Language "<language code>"` to set local settings for a specified language. This will configure culture, locale, and language settings using the language value specified.

This parameter supports the **bcp47** tag of the language to install (e.g., `en-AU`, `en-GB`, `fr-FR`). No locale, or regional settings will be applied without specifying the `-Language` parameter.

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

## Language Packs

The `-InstallLanguagePack` parameter is required to install a language pack in addition to modifying the locale. This uses the [Install-Language](https://learn.microsoft.com/en-au/powershell/module/languagepackmanagement/install-language) module to install the appropriate language pack. This module is only available on current version of Windows 10, Windows 11 and Windows Server 2025.

The language pack to support the value specified in `-Language` will be installed.

::: info
Language packs can take some time to install (typically between 10-15 minutes, depending on the PC / VM specs and your internet connection). Language pack installs have been observed to be quicker on a Windows install with the latest Windows Updates; however, no definitive method to speed up language pack installs has yet been determined.
:::

## Set a Time Zone

For Windows 10 and Windows 11, the solution will enable location settings for physical PCs that will automatically se the time zone in most scenarios. However, `Install-Defaults.ps1` can directly set a time zone when specified on the `-TimeZone` parameter. Use `Install-Defaults.ps1 -TimeZone "Time zone name"` to set the required time zone.

To view the list of valid time zone names to pass to this parameter, use `Get-TimeZone -ListAvailable`, and use the time zone name on the `Id` property. Localising Windows and setting the appropriate time zone would look like this:

```powershell
.\Install-Defaults.ps1 -Language "en-AU" -TimeZone "AUS Eastern Standard Time"
```
