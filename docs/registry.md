---
layout: doc
---
# Registry Settings


## Machine.All.json

**Computer level settings for all Windows 10 and above.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.99999.0 |
### Set Machine Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer | DisableEdgeDesktopShortcutCreation | 1 | DWord | Prevents the Microsoft Edge short added to the public desktop | False |
| HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate | CreateDesktopShortcutDefault | 0 | Dword | Prevent the Microsoft Edge shortcut from being added to the desktop | False |
| HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate | RemoveDesktopShortcutDefault | 1 | Dword | Prevent the Microsoft Edge shortcut from being added to the desktop | False |
| HKLM:\SOFTWARE\Policies\Microsoft\Edge | SearchbarAllowed | 0 | Dword | Prevent the Microsoft Edge search bar from being added to the desktop | False |
| HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes | MS Shell Dlg | Tahoma | String | Replaces the `MS Shell Dlg` font with `Tahoma` for UI consistency | False |
| HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes | MS Shell Dlg 2 | Tahoma | String | Replaces the `MS Shell Dlg 2` font with `Tahoma` for UI consistency | False |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location | Value | Allow | String | Enables location services | False |
| HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate | Start | 3 | DWord | Enable Set time zone automatically | False |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer | DisableEdgeDesktopShortcutCreation | 1 | DWord | Prevents the Microsoft Edge short added to the public desktop | False |
| HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate | CreateDesktopShortcutDefault | 0 | Dword | Prevent the Microsoft Edge shortcut from being added to the desktop | False |
| HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate | RemoveDesktopShortcutDefault | 1 | Dword | Prevent the Microsoft Edge shortcut from being added to the desktop | False |
| HKLM:\SOFTWARE\Policies\Microsoft\Edge | SearchbarAllowed | 0 | Dword | Prevent the Microsoft Edge search bar from being added to the desktop | False |
| HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes | MS Shell Dlg | Tahoma | String | Replaces the `MS Shell Dlg` font with `Tahoma` for UI consistency | False |
| HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes | MS Shell Dlg 2 | Tahoma | String | Replaces the `MS Shell Dlg 2` font with `Tahoma` for UI consistency | False |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location | Value | Allow | String | Enables location services | False |


## Machine.Client.json

**Computer level settings for Windows client editions.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.99999.0 |
### Set Machine Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer | DisableEdgeDesktopShortcutCreation | 1 | DWord | Prevents the Microsoft Edge short added to the public desktop | False |
| HKLM:\Software\Policies\Microsoft\Windows\CloudContent | DisableWindowsConsumerFeatures | 1 | DWord | Disables the Microsoft Windows consumer features | False |
| HKLM:\Software\Policies\Microsoft\Windows\CloudContent | DisableCloudOptimizedContent | 1 | DWord | Disables the customisation of the taskbar with additional shortcuts (e.g. new Outlook) | False |

### Remove Machine Registry Vaues

| path | note |
| ---- | ---- |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate | Removes the Dev Home app from the Windows Update Orchestrator to prevent automatic install on Windows 11 |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate | Removes the Dev Home app from the Windows Update Orchestrator to prevent automatic install on Windows 11 |
| HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate | Removes the Dev Home app from the Windows Update Orchestrator to prevent automatic install on Windows 11 |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate | Removes the Outlook (new) app from the Windows Update Orchestrator to prevent automatic install on Windows 11 |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate | Removes the Outlook (new) app from the Windows Update Orchestrator to prevent automatic install on Windows 11 |
| HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate | Removes the Outlook (new) app from the Windows Update Orchestrator to prevent automatic install on Windows 11 |
| HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\MS_Outlook | Removes the Outlook (new) app from the Windows Update Orchestrator to prevent automatic install on Windows 10 |


## Machine.TeamsCopilot.json

**Computer level settings for Windows 11 21H2 to 23H2. Removes Microsoft Teams Chat and the Copilot button on the taskbar.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.22000.0 | 10.0.22631.0 |
### Set Machine Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKLM:\Software\Microsoft\Windows\CurrentVersion\Communications | ConfigureChatAutoInstall | 0 | DWord | Prevents the install of the consumer Microsoft Teams client | False |
| HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ShowCopilotButton | 0 | DWord | Removes the Copilot button from the taskbar | False |


## User.All.json

**Default user profile settings for all Windows editions**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.99999.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Network\Persistent Connections | SaveConnections | No | String | Prevents persistent mapped drives in Explorer. Assumes scripts or GPP are used to map network drives | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Enabled | 0 | DWord | Turns off the feature that lets apps use the advertising ID | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\AppHost | EnableWebContentEvaluation | 1 | DWord | Turns on Smart Screen for apps | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SystemPaneSuggestionsEnabled | 0 | DWord | Disables app suggestions in the Start menu | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SilentInstalledAppsEnabled | 0 | DWord | Disables app suggestions in the Start menu | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Search | BingSearchEnabled | 0 | DWord | Disables web search in the Start menu for better responsiveness | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | LaunchTo | 1 | DWord | Configures File Explorer to start on This PC | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | HideFileExt | 0 | DWord | Enables the display of file extensions in File Explorer | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | SeparateProcess | 1 | DWord | Runs File Explorer windows in different processes so that one window crash won't affect all windows | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | TaskbarGlomLevel | 0 | DWord | Configures Taskbar buttons on the primary monitor to combine when the Taskbar is full | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | MMTaskbarGlomLevel | 0 | DWord | Configures Taskbar buttons on secondary monitors to combine when the Taskbar is full | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | Start_IrisRecommendations | 0 | DWord | Remove 'Recommendations for tips, shortcuts, new apps, and more' in the Start menu | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | PeopleBand | 0 | DWord | Removes the People icon from the Taskbar on Windows 10 | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement | ScoobeSystemSettingEnabled | 0 | DWord | Disable 'Suggest ways to get the most out of Windows and finish setting up this device' Screen in Settings / System / Notifications | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Search | SearchboxTaskbarMode | 3 | DWord | Collapses the Search box into an icon on the Taskbar | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Search | SearchboxTaskbarModeCache | 3 | DWord | Required to support the setting selected for SearchboxTaskbarMode | False |
| HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged | Value | Allow | String | Enables location services for Win32 applications | False |
| HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location | Value | Allow | String | Enables location services for Universal Windows Platform Apps | False |
| HKCU:\Control Panel\Accessibility | MessageDuration | 30 | DWord | Increase the timeout for new notifications - Dismiss notifications after this amount of time | False |
| HKCU:\Software\Adobe\Acrobat Reader\DC\AVAlert\cCheckbox | iAppDoNotTakePDFOwnershipAtLaunchWin10 | 1 | DWord | Prevents the default file type dialog box at Adobe Acrobat Reader DC first launch | False |
| HKCU:\Software\Adobe\Adobe Acrobat\DC\AVAlert\cCheckbox | iAppDoNotTakePDFOwnershipAtLaunchWin10 | 1 | DWord | Prevents the default file type dialog box at Adobe Acrobat Pro/Standard DC first launch | False |
| HKCU:\Software\Microsoft\Windows\DWM | ColorPrevalence | 1 | DWord | Enables 'Show accent colour on title bars and window borders' | False |


## User.Client.json

**Default user profile settings for all Windows client editions**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.99999.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers | BackgroundType | 0 | DWord | Sets the desktop background type to a picture | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings | EnabledState | 0 | DWord | Disables Windows spotlight | False |
| HKCU:\Console\%%Startup | DelegationConsole | {2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69} | String | Sets Windows Terminal as the default terminal | False |
| HKCU:\Console\%%Startup | DelegationTerminal | {E12CFF52-A866-4C77-9A90-F570A7AA2C6B} | String | Sets Windows Terminal as the default terminal | False |


## User.Virtual.json

**Default user profile settings for all Windows editions on virtual machines.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.99999.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize | EnableBlurBehind | 0 | DWord | Disable blur for the Start menu, Taskbar and windows | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize | EnableTransparency | 0 | DWord | Disable transparency for the Start menu, Taskbar and windows | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | IconsOnly | 1 | DWord | Show icons only and not document previews | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ListviewAlphaSelect | 0 | DWord | Disables the translucent selection rectangle in File Explorer | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ListviewShadow | 0 | DWord | Disables drop shadows on icons in File Explorer | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ShowCompColor | 1 | DWord | Changes the font colour for compressed NTFS files / directories | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ShowInfoTip | 1 | DWord | Disables tooltips in File Explorer | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | TaskbarAnimations | 0 | DWord | Disables animations in the Taskbar | False |
| HKCU:\Software\Microsoft\Windows\DWM | EnableAeroPeek | 0 | DWord | Disables Peek at desktop and Taskbar thumbnail live previews | False |
| HKCU:\Software\Microsoft\Windows\DWM | AlwaysHibernateThumbnails | 0 | DWord | Disables Taskbar preview thumbnail cache | False |
| HKCU:\Control Panel\Desktop | DragFullWindows | 1 | String | Disables the display of the window contents when dragging | False |
| HKCU:\Control Panel\Desktop\WindowMetrics | MinAnimate | 0 | String | Disables animations for minimise and maximise actions for windows | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-310093Enabled | 0 | DWord | Disables 'Show me the Windows welcome experience after updates and occasionally when I sign in to highlight what's new and suggested' | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_8wekyb3d8bbwe | Disabled | 1 | DWord | Prevents the Photos app from running in the background | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_8wekyb3d8bbwe | DisabledByUser | 1 | DWord | Prevents the Photos app from running in the background | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe | Disabled | 1 | DWord | Prevents the Your Phone app from running in the background | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe | DisabledByUser | 1 | DWord | Prevents the Your Phone app from running in the background | False |


## User.Windows10.json

**Default user profile settings for Windows 10.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.20999.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent | AccentColor | 4289992518 | DWord | Sets the accent colour on window title bars and borders | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent | AccentPalette | 86CAFF005FB2F2001E91EA000063B10000427500002D4F000020380000CC6A00 | String | Sets the accent colour on window title bars and borders | False |
| HKCU:\Software\Microsoft\Windows\DWM | AccentColor | 4289815296 | DWord | Sets the accent colour on window title bars and borders | False |
| HKCU:\Software\Microsoft\Windows\DWM | ColorizationAfterglow | 3288359857 | DWord | Sets the accent colour on window title bars and borders | False |
| HKCU:\Software\Microsoft\Windows\DWM | ColorizationColor | 3288359857 | DWord | Sets the accent colour on window title bars and borders | False |


## User.Windows11.json

**Default user profile settings for Windows 11.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.22000.0 | 10.0.29999.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | TaskbarMn | 0 | DWord | Remove the Chat icon from the Taskbar - note: this value should not be needed on Windows 11 23H2 or higher | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | TaskbarDa | 0 | DWord | Remove the Widgets icon from the Taskbar - note: this value is protected by permissions | True |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Start | VisiblePlaces | 188 36 138 20 12 214 137 66 160 128 110 217 187 162 72 130 134 8 115 82 170 81 67 66 159 123 39 118 88 70 89 212 | Binary | Adds 'Settings' and 'File Explorer' next to the power button on the Start menu. | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Start | PlacesInitializedVersion | 2 | Dword | Required to support the setting selected for VisiblePlaces. | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ShowNotificationIcon | 1 | DWord | Enables 'Notifications / Show notification bell icon' | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoInstalledPWAs | CopilotPWAPreinstallCompleted | 1 | DWord | Tells Windows that the Copilot PWA has been installed | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy | TailoredExperiencesWithDiagnosticDataEnabled | 0 | DWord | Disables 'Settings / Privacy & Security / Recommendations & offers / Personalised offers' | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\AdvertisingInfo | Value | 0 | DWord | Disables 'Settings / Privacy & Security / Recommendations & offers / Advertising ID' | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Enabled | 0 | DWord | Disables 'Settings / Privacy & Security / Recommendations & offers / Advertising ID' | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-338393Enabled | 0 | DWord | Disables suggested content in the Settings app | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-353694Enabled | 0 | DWord | Disables suggested content in the Settings app | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-353696Enabled | 0 | DWord | Disables suggested content in the Settings app | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-338388Enabled | 0 | DWord | Disables suggested content in the Settings app | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-338389Enabled | 0 | DWord | Disables suggested content in the Settings app | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | RotatingLockScreenEnabled | 0 | DWord | Disables Windows Spotlight on the Lock Screen | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-338387Enabled | 0 | DWord | Disables Windows Spotlight subscribed content on the Lock Screen | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager | SubscribedContent-338387Enabled | 0 | DWord | Disables Windows Spotlight subscribed content on the Lock Screen | False |


## User.Windows2022RDS.json

**Default user profile settings for all Windows Server 2022 and below editions.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.20348.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\ServerManager | DoNotOpenServerManagerAtLogon | 1 | DWord | Prevents Server Manager from starting at login | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize | EnableBlurBehind | 1 | DWord | Disable blur for the Start menu, Taskbar and windows | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Search | SearchboxTaskbarMode | 0 | DWord | Hides the Search icon on the Taskbar | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ShowTaskViewButton | 0 | DWord | Removes the Task View button on the Taskbar | False |


## User.Windows2022Server.json

**Default user profile settings for all Windows Server 2022 and below editions.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.20348.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\ServerManager | DoNotOpenServerManagerAtLogon | 1 | DWord | Prevents Server Manager from starting at login | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize | EnableBlurBehind | 1 | DWord | Disable blur for the Start menu, Taskbar and windows | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Search | SearchboxTaskbarMode | 0 | DWord | Hides the Search icon on the Taskbar | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced | ShowTaskViewButton | 0 | DWord | Removes the Task View button on the Taskbar | False |


## User.Windows2025RDS.json

**Default user profile settings for Windows Server 2025 Remote Desktop Services Host and above.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.26100.0 | 10.0.99999.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\ServerManager | DoNotOpenServerManagerAtLogon | 1 | DWord | Prevents Server Manager from starting at login | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Start | VisiblePlaces | 188 36 138 20 12 214 137 66 160 128 110 217 187 162 72 130 134 8 115 82 170 81 67 66 159 123 39 118 88 70 89 212 | Binary | Adds 'Settings' and 'File Explorer' next to the power button on the Start menu. | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Start | PlacesInitializedVersion | 2 | Dword | Required to support the setting selected for VisiblePlaces. | False |


## User.Windows2025Server.json

**Default user profile settings for Windows Server 2025 and above.**


| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.26100.0 | 10.0.99999.0 |
### Set User Registry Values

| path | name | value | type | note | protected |
| ---- | ---- | ----- | ---- | ---- | --------- |
| HKCU:\Software\Microsoft\ServerManager | DoNotOpenServerManagerAtLogon | 1 | DWord | Prevents Server Manager from starting at login | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Start | VisiblePlaces | 188 36 138 20 12 214 137 66 160 128 110 217 187 162 72 130 134 8 115 82 170 81 67 66 159 123 39 118 88 70 89 212 | Binary | Adds 'Settings' and 'File Explorer' next to the power button on the Start menu. | False |
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Start | PlacesInitializedVersion | 2 | Dword | Required to support the setting selected for VisiblePlaces. | False |
