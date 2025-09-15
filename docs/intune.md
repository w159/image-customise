---
layout: doc
---
# Install with Microsoft Intune

## Install as a Win32 App

The solution is also provided in `.intunewin` format to enable direct import into Microsoft Intune without re-packaging.

Settings for importing the Windows Enterprise Defaults as a Win32 package into Intune are maintained here: [App.json](https://github.com/aaronparker/defaults/blob/main/App.json). This can be used with the [IntuneWin32AppPackager](https://github.com/MSEndpointMgr/IntuneWin32AppPackager) to automate import into Intune.

::: info
To enable support for multiple languages, create multiple Win32 applications with different command lines - one for each required language.
:::

![Windows Enterprise Defaults as a Win32 application in Microsoft Intune](/assets/img/intuneapp.jpeg)

### Enrollment Status Page

To ensure the solution applies to a target machine during Windows Autopilot, add the application package to the list of Blocking Apps in the [Enrollment Status Page](https://learn.microsoft.com/autopilot/enrollment-status).

![Adding the Windows Enterprise Defaults to an Enrollment Status Page](/assets/img/enrollmentstatuspage.jpeg)

### Detection

Once installed, the following registry information can be used to detect that the package is installed:

* Key - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{f38de27b-799e-4c30-8a01-bfdedc622944}`
* Value - `DisplayVersion`
* Data - `2211.29.129` (the version number of the current release)

## Platform Script

`Remove-AppxApps.ps1` can be run as a standalone script, seperate from the rest of the solution. This script can be deployed from Intune as a [platform script](https://learn.microsoft.com/intune/intune-service/apps/powershell-scripts); however, you will need to first edit the script to enable it to run.

The `ConfirmImpact` property must be changed from `High` to `Low` - edit this on line 38 in the script:

```powershell
[CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "Default", ConfirmImpact = "Low")]
```

![Running Remove-AppxApps.ps1 as a platform script](/assets/img/platform-script.jpeg)
