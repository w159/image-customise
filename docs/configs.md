---
layout: doc
---
# Configurations

Configuration changes are implemented with `Install-Defaults.ps1`. This script reads configurations in JSON format and configures the local Windows instance with Windows feature states, registry settings, copies files into specified paths, imports a default Start menu, and modifies the default user profile.

Configurations are stored in the following JSON files with the logic to make changes to Windows includes in `Install-Defaults.ps1`:

* [Machine.All.json](https://github.com/aaronparker/defaults/blob/main/src/configs/Machine.All.json)
* [Machine.Client.json](https://github.com/aaronparker/defaults/blob/main/src/configs/Machine.Client.json)
* [Machine.RDS.json](https://github.com/aaronparker/defaults/blob/main/src/configs/Machine.RDS.json)
* [Machine.TeamsCopilot.json](https://github.com/aaronparker/defaults/blob/main/src/configs/Machine.TeamsCopilot.json)
* [User.All.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.All.json)
* [User.Client.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Client.json)
* [User.Virtual.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Virtual.json)
* [User.Windows10.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Windows10.json)
* [User.Windows11.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Windows11.json)
* [User.Windows2022RDS.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Windows2022RDS.json)
* [User.Windows2022Server.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Windows2022Server.json)
* [User.Windows2025RDS.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Windows2025RDS.json)
* [User.Windows2025Server.json](https://github.com/aaronparker/defaults/blob/main/src/configs/User.Windows2025Server.json)

## Applicability

The applicability of the configurations is determined

JSON files are gathered based on properties of the local Windows instance. The following keywords, used in the file names, ensure that the right JSON files are selected:

* `client` - Windows 10 or Windows 11
* `server` - Windows Server (e.g. Windows Server 2022, 2025)
* `rds-server` - Windows Server Remote Desktop Services hosts
* `multisession` - Not currently used. Intended for Windows multi-session in the future

Each JSON file includes a `MinimumBuild` and `MaximumBuild` properties that are used to ensure configurations only apply to a specific versions of Windows. For example, the property might ensure that configurations only apply to Windows 10 version `10.0.19041` and above.

All JSON files the `config` directory are read and then filtered based on these properties to create a list of configurations to apply to the current system.

## Configuration Viewer

The repository includes a read-only WPF viewer script to inspect configuration files:

```powershell
.\src\Start-DefaultsViewer.ps1
```

The viewer reads JSON files from `src\configs`, shows all available profiles in a list, and renders each section with a user-friendly detail panel. Item-level descriptions are shown from `note` fields where available and from the configuration schema where possible.

![](/img/configviewer.png)

## Other Configurations

`Install-Defaults.ps1` performs additional tasks not defined in the JSON configuration files:

* Removes inbox Universal Windows Platform (AppX) apps - see [Remove UWP apps](https://stealthpuppy.com/defaults/appxapps/)
* Copies the solution as a [Run custom actions during feature update](https://learn.microsoft.com/en-gb/windows-hardware/manufacture/desktop/windows-setup-enable-custom-actions?view=windows-11). This enables the Custom Defaults to be re-run during an in-place upgrade

## Script Process Visualisation

Here's an visualisation of how the `Install-Defaults.ps1` works:

![Script Process Visualisation](/img/install-defaults-process.svg)
