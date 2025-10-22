---
layout: doc
---
# Frequently Asked Questions

**Q: Does the Windows Enterprise Defaults support Citrix Virtual Apps and Desktops?**

**A:** Yes. Windows Enterprise Defaults helps customise a Windows image and Windows desktops, so it supports any physical or virtual desktop environment.

**Q: Is the the Windows Enterprise Defaults an optimisation tool?**

**A:** Yes; however, for virtual desktop environments, it is recommended to also use dedicated optimisation tools such as the Microsoft Virtual Desktop Optimisation Tool, Citrix Optimizer, or the Windows OS Optimization Tool for Horizon.

**Q: How do I customise the list of AppX / Store apps to remove?**

**A:** Edit `Remove-AppxApps.ps1` and customise the list of apps in the `SafePackageList` or the `TargetedPackageList` parameters, depending on whether you're running the script in default mode or targeted mode.

**Q: If I remove AppX / Store apps with Defaults, how do I reinstall them?**

**A:** If you haven't customised `Remove-AppxApps.ps1` and remove an app from your image or desktops inadvertently, re-deploy the target apps with Intune. For example, the solution will remove all default apps from Windows including Solitaire. Enable end-users to [reinstall the app on-demand via the Intune Company Portal](https://learn.microsoft.com/en-us/intune/intune-service/apps/store-apps-microsoft).
