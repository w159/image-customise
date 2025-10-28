---
layout: doc
---
# Start Menu

## User-Windows2025.Server.json

**Default user profile settings for Windows Server 2025 and above.**

| Minimum build | Maximum build | Type | Feature |
| ------------- | ------------- | ---- | ------- |
| 10.0.26100 | 10.0.99999 | Server | RDS-RD-Server |

| Source | Destination |
| ------ | ----------- |
| start\Windows2025RDSStart.bin | C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin |

## User.Client.json

**Default user profile settings for all Windows client editions**

| Minimum build | Maximum build | Type | Feature |
| ------------- | ------------- | ---- | ------- |
| 10.0.14393 | 10.0.99999 | Client |  |

| Source | Destination |
| ------ | ----------- |
| start\Windows10StartMenuLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |

| Source | Destination |
| ------ | ----------- |
| start\Windows11StartMenuLayout.json | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.json |
| start\Windows11TaskbarLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |
| start\Windows11Start.bin | C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin |

## User.Server.json

**Default user profile settings for all Windows Server editions.**

| Minimum build | Maximum build | Type | Feature |
| ------------- | ------------- | ---- | ------- |
| 10.0.14393 | 10.0.20348 | Server | RDS-RD-Server |

| Source | Destination |
| ------ | ----------- |
| start\WindowsRDSStartMenuLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |

| Source | Destination |
| ------ | ----------- |
| start\WindowsServerStartMenuLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |
