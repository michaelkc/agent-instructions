$code = @"
using System;
using System.Runtime.InteropServices;

public class AccessibilityOps {
    // Import the SystemParametersInfo API
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfo", SetLastError = true)]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, ref STICKYKEYS pvParam, uint fWinIni);

    [DllImport("user32.dll", EntryPoint = "SystemParametersInfo", SetLastError = true)]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, ref FILTERKEYS pvParam, uint fWinIni);

    // Define the structures
    [StructLayout(LayoutKind.Sequential)]
    public struct STICKYKEYS {
        public uint cbSize;
        public uint dwFlags;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct FILTERKEYS {
        public uint cbSize;
        public uint dwFlags;
        public uint iWaitMSec;
        public uint iDelayMSec;
        public uint iRepeatMSec;
        public uint iBounceMSec;
    }

    // Constants
    public const uint SPI_GETSTICKYKEYS = 0x003A;
    public const uint SPI_SETSTICKYKEYS = 0x003B;
    public const uint SPI_GETFILTERKEYS = 0x0032;
    public const uint SPI_SETFILTERKEYS = 0x0033;
    
    // SPIF flags update the INI file (Registry) and broadcast the change
    public const uint SPIF_UPDATEINIFILE = 0x01;
    public const uint SPIF_SENDCHANGE = 0x02;

    // Feature Flags
    public const uint SKF_STICKYKEYSON = 0x00000001;
    public const uint SKF_HOTKEYACTIVE = 0x00000004;
    public const uint FKF_FILTERKEYSON = 0x00000001;
    public const uint FKF_HOTKEYACTIVE = 0x00000004;

    public static void DisableFeatures() {
        // --- Disable StickyKeys ---
        STICKYKEYS sk = new STICKYKEYS();
        sk.cbSize = (uint)Marshal.SizeOf(sk);
        
        // Get current state
        SystemParametersInfo(SPI_GETSTICKYKEYS, sk.cbSize, ref sk, 0);
        
        // Turn OFF Feature and Turn OFF Hotkey
        sk.dwFlags &= ~SKF_STICKYKEYSON;
        sk.dwFlags &= ~SKF_HOTKEYACTIVE;

        // Set new state
        bool successSK = SystemParametersInfo(SPI_SETSTICKYKEYS, sk.cbSize, ref sk, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
        Console.WriteLine("StickyKeys Disabled: " + successSK);

        // --- Disable FilterKeys ---
        FILTERKEYS fk = new FILTERKEYS();
        fk.cbSize = (uint)Marshal.SizeOf(fk);

        // Get current state
        SystemParametersInfo(SPI_GETFILTERKEYS, fk.cbSize, ref fk, 0);

        // Turn OFF Feature and Turn OFF Hotkey
        fk.dwFlags &= ~FKF_FILTERKEYSON;
        fk.dwFlags &= ~FKF_HOTKEYACTIVE;

        // Set new state
        bool successFK = SystemParametersInfo(SPI_SETFILTERKEYS, fk.cbSize, ref fk, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
        Console.WriteLine("FilterKeys Disabled: " + successFK);
    }
}
"@

Add-Type -TypeDefinition $code
[AccessibilityOps]::DisableFeatures()
