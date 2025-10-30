---
layout: doc
---
# Frequently Asked Questions

**Q: Does the Windows Enterprise Defaults support Citrix Virtual Apps and Desktops and other virtual desktop environments?**

**A:** Yes. Windows Enterprise Defaults helps customise a Windows image and Windows desktops, so it supports any physical or virtual desktop environment. You can use this tool on physical Windows PCs, Azure Virtual Desktop, Windows 365, third-party virtual desktop infrastructure, Remote Desktop Services etc.

---

**Q: Is the the Windows Enterprise Defaults an optimisation tool?**

**A:** Yes; _however_, for virtual desktop environments, it is recommended use this in addition to dedicated optimisation tools such as the [Microsoft Virtual Desktop Optimisation Tool](https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool), the [Citrix Optimizer Tool](https://support.citrix.com/external/article/CTX224676/citrix-optimizer-tool.html), or the [Windows OS Optimization Tool for Horizon](https://customerconnect.omnissa.com/downloads/info/slug/desktop_end_user_computing/os_optimization_tool/2412#drivers_tools).

---

**Q: How do I customise the list of AppX / Store apps to remove?**

**A:** Edit `Remove-AppxApps.ps1` and customise the list of apps in the `SafePackageList` or the `TargetedPackageList` parameters, depending on whether you're running the script in default mode or targeted mode. Editing this script is useful for when you are running the Defaults as a complete solution or `Remove-AppxApps.ps1` as an Intune platform or remediation script. If you are running `Remove-AppxApps.ps1` directly, these parameters can be passed an array of AppX PackageFamilyNames without making changes to the script.

---

**Q: If I remove AppX / Store apps with Defaults, how do I reinstall them?**

**A:** If you haven't customised `Remove-AppxApps.ps1` and remove an app from your image or desktops inadvertently, re-deploy the target apps with Intune. For example, the solution will remove all default apps from Windows including Solitaire. Enable end-users to [reinstall theese apps on-demand via the Intune Company Portal](https://learn.microsoft.com/en-us/intune/intune-service/apps/store-apps-microsoft).
