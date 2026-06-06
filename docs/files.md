---
layout: doc
---
# Files

## Machine.Client.json

**Computer level settings for Windows client editions.**

| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.99999.0 |

| Source | Destination |
| ------ | ----------- |
| apps\initial_preferences.json | C:\Program Files (x86)\Microsoft\Edge\Application\initial_preferences |

## User.Windows10.json

**Default user profile settings for Windows 10.**

| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.20999.0 |

| Source | Destination |
| ------ | ----------- |
| start\Windows10StartMenuLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |

## User.Windows11.json

**Default user profile settings for Windows 11.**

| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.22000.0 | 10.0.29999.0 |

| Source | Destination |
| ------ | ----------- |
| start\Windows11StartMenuLayout.json | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.json |
| start\Windows11TaskbarLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |
| start\Windows11Start.bin | C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin |

## User.Windows2022RDS.json

**Default user profile settings for all Windows Server 2022 and below editions.**

| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.20348.0 |

| Source | Destination |
| ------ | ----------- |
| start\WindowsRDSStartMenuLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |

## User.Windows2022Server.json

**Default user profile settings for all Windows Server 2022 and below editions.**

| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.14393.0 | 10.0.20348.0 |

| Source | Destination |
| ------ | ----------- |
| start\WindowsServerStartMenuLayout.xml | C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml |

## User.Windows2025RDS.json

**Default user profile settings for Windows Server 2025 Remote Desktop Services Host and above.**

| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.26100.0 | 10.0.99999.0 |

| Source | Destination |
| ------ | ----------- |
| apps\initial_preferences.json | C:\Program Files (x86)\Microsoft\Edge\Application\initial_preferences |
| start\Windows2025RDSStart.bin | C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin |

## User.Windows2025Server.json

**Default user profile settings for Windows Server 2025 and above.**

| Minimum build | Maximum build |
| ------------- | ------------- |
| 10.0.26100.0 | 10.0.99999.0 |

| Source | Destination |
| ------ | ----------- |
| apps\initial_preferences.json | C:\Program Files (x86)\Microsoft\Edge\Application\initial_preferences |
