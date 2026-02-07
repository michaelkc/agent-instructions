---
name: windows-desktop-set-background-color
description: Allows setting the background color of the Windows Desktop
---
To set the Windows desktop background color to a specific solid color, run the PowerShell script located in this directory: `SetWindowsDesktopBackgroundColor.ps1`.

### Usage
```powershell
.\SetWindowsDesktopBackgroundColor.ps1 color "<hex_color>"
```

### Parameters
- `color`: The command to execute. Always use "color".
- `<hex_color>`: The color in hex format (e.g., `#FF0000` for red, `#0000FF` for blue, `#71797E` for Steel Grey).

### Examples
Set background to Red:
```powershell
.\SetWindowsDesktopBackgroundColor.ps1 color "#FF0000"
```

Set background to Steel Grey:
```powershell
.\SetWindowsDesktopBackgroundColor.ps1 color "#71797E"
```