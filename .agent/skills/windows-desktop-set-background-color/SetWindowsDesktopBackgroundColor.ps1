# SetWindowsDesktopBackgroundColor.ps1
# Usage: .\SetWindowsDesktopBackgroundColor.ps1 color #AA0000

param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("color")]
    [string]$Command,

    [Parameter(Position = 1, Mandatory = $true)]
    [string]$Color
)

if ($Command -eq "color") {
    if ($Color -match "^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$") {
        $hex = $Matches[1]
        if ($hex.Length -eq 3) {
            # Expand #RGB to #RRGGBB
            $r_hex = $hex.Substring(0, 1) * 2
            $g_hex = $hex.Substring(1, 1) * 2
            $b_hex = $hex.Substring(2, 1) * 2
        } else {
            $r_hex = $hex.Substring(0, 2)
            $g_hex = $hex.Substring(2, 2)
            $b_hex = $hex.Substring(4, 2)
        }
        
        $r = [Convert]::ToUInt32($r_hex, 16)
        $g = [Convert]::ToUInt32($g_hex, 16)
        $b = [Convert]::ToUInt32($b_hex, 16)
        
        # COLORREF is 0x00BBGGRR
        $colorRef = $r + ($g -shl 8) + ($b -shl 16)
    } else {
        Write-Error "Invalid color format. Use #RRGGBB or #RGB"
        exit 1
    }

    if (-not ("Win32DesktopV2.Helper" -as [type])) {
        $csharpCode = @'
using System;
using System.Runtime.InteropServices;

namespace Win32DesktopV2 {
    [ComImport]
    [Guid("B92B56A9-8B55-4E14-9A89-0199BBB6F93B")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IDesktopWallpaper
    {
        void SetWallpaper([MarshalAs(UnmanagedType.LPWStr)] string monitorID, [MarshalAs(UnmanagedType.LPWStr)] string wallpaper);
        void GetWallpaper([MarshalAs(UnmanagedType.LPWStr)] string monitorID, [MarshalAs(UnmanagedType.LPWStr)] out string wallpaper);
        void GetMonitorDevicePathAt(uint monitorIndex, [MarshalAs(UnmanagedType.LPWStr)] out string monitorID);
        void GetMonitorDevicePathCount(out uint count);
        void GetMonitorRECT([MarshalAs(UnmanagedType.LPWStr)] string monitorID, out Rect displayRect);
        void SetBackgroundColor(uint color);
        void GetBackgroundColor(out uint color);
        void SetPosition(int position);
        void GetPosition(out int position);
        void SetSlideshow(IntPtr items);
        void GetSlideshow(out IntPtr items);
        void SetSlideshowOptions(int options, uint slideshowTick);
        void GetSlideshowOptions(out int options, out uint slideshowTick);
        void AdvanceSlideshow([MarshalAs(UnmanagedType.LPWStr)] string monitorID, int direction);
        void GetStatus(out int state);
        void Enable([MarshalAs(UnmanagedType.Bool)] bool enable);
    }

    [ComImport]
    [Guid("C2CF3110-460E-4fc1-B9D0-8A1C0C9CC4BD")]
    public class DesktopWallpaper { }

    [StructLayout(LayoutKind.Sequential)]
    public struct Rect
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    public static class Helper {
        public static void SetSolidColor(uint color) {
            var dw = (IDesktopWallpaper)new DesktopWallpaper();
            dw.SetBackgroundColor(color);
            dw.Enable(false);
        }
    }
}
'@
        Add-Type -TypeDefinition $csharpCode
    }

    try {
        [Win32DesktopV2.Helper]::SetSolidColor($colorRef)
        Write-Host "Background color set to $Color"
    } catch {
        Write-Error "Failed to set background color: $_"
    }
}
