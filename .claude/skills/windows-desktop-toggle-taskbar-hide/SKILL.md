---
name: windows-desktop-toggle-taskbar-hide
description: Toggles the "Automatically hide the taskbar in desktop mode" setting on Windows. Use this skill when the user wants to hide or show the taskbar automatically.
---
To enable auto-hiding the Windows taskbar:
pwsh -File .agent\skills\windows-desktop-toggle-taskbar-hide\enable-auto-hide.ps1

To disable auto-hiding the Windows taskbar:
pwsh -File .agent\skills\windows-desktop-toggle-taskbar-hide\disable-auto-hide.ps1