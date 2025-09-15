---
layout: doc
---
# Installing Defaults

## Install

Installation of the Windows Enterprise Defaults will depend on where you are running the installation - via the Windows OOBE (1) (with Windows Autopilot or Windows Autopilot device preparation), in an image creation solution, or manually.

::: info
Windows OOBE stands for Windows Out-of-Box Experience. It's the setup process that occurs when you turn on a new Windows device for the first time or after resetting it to its factory settings. During OOBE, you're guided through various steps to personalize and configure your device, such as: connecting to a Wi-Fi network, setting up device preferences like region, keyboard layout, and privacy settings, and signing in with a Microsoft account.
:::

Installation is handled with two scripts:

* `Install-Defaults.ps1` - this script installs the solution including configuring Windows optimisations and the default user profile
* `Remove-AppxApps.ps1` - the script removes AppX or Store apps from Windows. This is only called by `Install-Defaults.ps1` during OOBE, otherwise you will need to run this script directly

If you're deploying the solution via Windows Autopilot, use the following command:

```batch
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy RemoteSigned -File .\Install-Defaults.ps1
```

If you're deploying the solution via other tools, e.g. ConfigMgr, MDT or in an image pipeline, run both scripts:

```powershell
.\Remove-AppxApps.ps1 -Confirm:$false
.\Install-Defaults.ps1
```

## Detection

Once installed, the following registry information can be used to detect that the package is installed:

* Key - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{f38de27b-799e-4c30-8a01-bfdedc622944}`
* Value - `DisplayVersion`
* Data - `2211.29.129` (the version number of the current release)
