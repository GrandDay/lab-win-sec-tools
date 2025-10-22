# Installation and Usage Guide

This guide provides comprehensive instructions for installing and using the Windows Malware Lab Tools Installer.

## Table of Contents

- [System Requirements](#system-requirements)
- [Installation Methods](#installation-methods)
- [Post-Installation Setup](#post-installation-setup)
- [Tool Usage](#tool-usage)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [FAQ](#faq)

## System Requirements

### Operating System

- **Windows 10** (64-bit) or **Windows 11** (64-bit)
- Both Home and Pro editions are supported
- Server editions are not officially tested but should work

### Software Requirements

- **PowerShell 5.1 or higher** (included with Windows 10/11)
- **.NET Framework 4.5 or higher** (included with Windows 10/11)
- **Administrator privileges** (required for installation)

### Hardware Requirements

- **Disk Space:** ~10 MB for tools
- **RAM:** 4 GB minimum (8 GB recommended for analysis work)
- **Internet:** Active connection required for download

### Network Requirements

The installer needs to download tools from:

- `download.sysinternals.com` (Microsoft's official CDN)

Ensure your firewall allows PowerShell to make outbound HTTPS connections.

## Installation Methods

### Method 1: One-Liner (Recommended)

This is the fastest method for most users.

**Step 1:** Open PowerShell as Administrator

- Press `Win + X` and select "Windows PowerShell (Admin)" or "Terminal (Admin)"
- Or search for "PowerShell" in Start menu, right-click, and select "Run as administrator"

**Step 2:** Run the installation command

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -Command "Invoke-Expression (Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1').Content"
```

**Step 3:** Wait for completion

The script will:

- Download Process Explorer and Autoruns
- Extract them to `C:\Tools\`
- Unblock the files
- Display a success message

### Method 2: Clone and Run

This method allows you to review the script before execution.

**Step 1:** Clone the repository

```powershell
git clone https://github.com/GrandDay/lab-win-sec-tools.git
cd lab-win-sec-tools
```

**Step 2:** Open PowerShell as Administrator

Navigate to the cloned directory.

**Step 3:** Run the installer

```powershell
.\install.ps1
```

### Method 3: Manual Download

**Step 1:** Download the repository

Visit [https://github.com/GrandDay/lab-win-sec-tools](https://github.com/GrandDay/lab-win-sec-tools) and click "Code" → "Download ZIP"

**Step 2:** Extract the ZIP file

Extract to a folder of your choice (e.g., `C:\Downloads\lab-win-sec-tools`)

**Step 3:** Run PowerShell as Administrator

```powershell
cd C:\Downloads\lab-win-sec-tools
.\install.ps1
```

### Method 4: Windows Package Manager (Alternative)

For advanced users who prefer `winget`:

```powershell
winget install Microsoft.Sysinternals.ProcessExplorer
winget install Microsoft.Sysinternals.Autoruns
```

**Note:** This installs to default locations, not `C:\Tools\` as expected by the lab guide.

## Post-Installation Setup

### Verify Installation

After installation, verify the tools are in place:

```powershell
Test-Path "C:\Tools\ProcessExplorer\procexp64.exe"
Test-Path "C:\Tools\Autoruns\Autoruns64.exe"
```

Both should return `True`.

### Process Explorer Setup

#### First Launch

```powershell
Start-Process "C:\Tools\ProcessExplorer\procexp64.exe" -Verb RunAs
```

#### Configure VirusTotal Integration

1. Click **Options** → **VirusTotal.com**
2. Check **"Check VirusTotal.com"**
3. (Optional) Enter your VirusTotal API key for higher rate limits
4. Click **OK**

#### Accept EULA

On first run, you'll need to accept the Sysinternals License Agreement.

#### Replace Task Manager (Optional)

To replace Task Manager with Process Explorer:

1. Click **Options** → **Replace Task Manager**
2. Now pressing `Ctrl+Shift+Esc` will launch Process Explorer

### Autoruns Setup

#### First Launch

```powershell
Start-Process "C:\Tools\Autoruns\Autoruns64.exe" -Verb RunAs
```

#### Recommended Settings

1. **Hide Microsoft Entries:** Options → Hide Microsoft Entries (makes finding suspicious items easier)
2. **Verify Code Signatures:** Options → Scan Options → Verify Code Signatures
3. **Check VirusTotal:** Options → Scan Options → Check VirusTotal.com

#### Accept EULA

Accept the license agreement on first run.

## Tool Usage

### Process Explorer

#### Basic Usage

**Launch:**

```powershell
Start-Process "C:\Tools\ProcessExplorer\procexp64.exe" -Verb RunAs
```

**Key Features:**

- **Tree View:** Shows parent-child process relationships
- **Color Coding:**
  - Pink: Services
  - Purple: Packed executables (potential malware)
  - Gray: Suspended processes
- **Search:** Ctrl+F to find processes by name
- **Properties:** Double-click any process for detailed info

#### Malware Analysis Tasks

**Check VirusTotal Scores:**

1. Right-click process → Check VirusTotal
2. Look for detection ratios (e.g., "5/70" means 5 engines detected it)

**Examine Suspicious Processes:**

1. Right-click process → Properties
2. Check **Image** tab: Path, company, signature
3. Check **Strings** tab: Look for suspicious URLs or commands
4. Check **TCP/IP** tab: Network connections
5. Check **Threads** tab: Unusual thread activity

**Find Handles:**

- Use **Find → Find Handle or DLL** (Ctrl+F) to search for file locks or loaded DLLs

### Autoruns

#### Basic Usage

**Launch:**

```powershell
Start-Process "C:\Tools\Autoruns\Autoruns64.exe" -Verb RunAs
```

**Key Features:**

- **Categories:** Logon, Services, Scheduled Tasks, etc.
- **Color Coding:**
  - Pink: No publisher information
  - Yellow: Unsigned entries
  - Red: VirusTotal detections
- **Search:** Filter entries with search box

#### Malware Analysis Tasks

**Find Persistence Mechanisms:**

1. Click **Everything** to scan all auto-start locations
2. Enable **Hide Microsoft Entries** to reduce noise
3. Look for:
   - Unsigned entries (yellow)
   - Entries with VirusTotal hits (red)
   - Suspicious paths (temp folders, user directories)
   - Misspelled Windows processes

**Investigate Suspicious Entry:**

1. Right-click entry → Properties (to see file location)
2. Right-click entry → Process Explorer (to see running process)
3. Right-click entry → Search Online (Google the filename)

**Disable Malicious Entry:**

1. Uncheck the entry to disable it
2. Delete the entry (right-click → Delete) if confirmed malicious
3. **Caution:** Only disable/delete if you're certain it's malicious

## Troubleshooting

### Common Issues

#### "Execution Policy" Error

**Problem:** PowerShell blocks script execution

**Solution:**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then re-run the installer.

#### "Access Denied" Error

**Problem:** Not running as Administrator

**Solution:** Right-click PowerShell and select "Run as administrator"

#### Download Fails

**Symptoms:**

- "The remote server returned an error"
- "Could not connect"

**Solutions:**

1. **Check Internet Connection:**

   ```powershell
   Test-NetConnection download.sysinternals.com -Port 443
   ```

2. **Check Firewall:** Ensure PowerShell can make outbound HTTPS requests

3. **Use Manual Download:** Download tools manually from [Sysinternals](https://docs.microsoft.com/en-us/sysinternals/)

4. **Proxy Issues:** If behind a corporate proxy:

   ```powershell
   $proxy = [System.Net.WebRequest]::GetSystemWebProxy()
   $proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
   ```

#### Files Blocked by Windows

**Problem:** "Windows protected your PC" warning when launching tools

**Solution:**

```powershell
Unblock-File -Path "C:\Tools\ProcessExplorer\*"
Unblock-File -Path "C:\Tools\Autoruns\*"
```

#### Tools Won't Launch

**Problem:** Double-clicking the .exe does nothing

**Solutions:**

1. **Run as Administrator:**

   ```powershell
   Start-Process "C:\Tools\ProcessExplorer\procexp64.exe" -Verb RunAs
   ```

2. **Check Antivirus:** Some AV software blocks Sysinternals tools (false positive)

3. **Reinstall:** Delete `C:\Tools\` and re-run installer

### Advanced Troubleshooting

#### Enable Script Logging

To debug installation issues:

```powershell
$VerbosePreference = "Continue"
.\install.ps1
```

#### Manual Verification

Check if directories exist:

```powershell
Get-ChildItem "C:\Tools\" -Recurse
```

Check file hashes (verify integrity):

```powershell
Get-FileHash "C:\Tools\ProcessExplorer\procexp64.exe" -Algorithm SHA256
```

#### Clean Installation

Remove existing installation:

```powershell
Remove-Item "C:\Tools\" -Recurse -Force
```

Then re-run the installer.

## Uninstallation

### Remove Tools

To completely uninstall:

```powershell
Remove-Item "C:\Tools\ProcessExplorer" -Recurse -Force
Remove-Item "C:\Tools\Autoruns" -Recurse -Force
```

### Remove Parent Directory (Optional)

If no other tools are in `C:\Tools\`:

```powershell
Remove-Item "C:\Tools\" -Recurse -Force
```

### Undo Process Explorer Task Manager Replacement

If you replaced Task Manager with Process Explorer:

1. Open Process Explorer as Administrator
2. Click **Options** → **Replace Task Manager** (to toggle off)

## FAQ

### Q: Do I need to run these tools as Administrator?

**A:** Yes, both Process Explorer and Autoruns require elevated privileges to access all processes and system locations.

### Q: Are these tools safe?

**A:** Yes, Process Explorer and Autoruns are official Microsoft Sysinternals tools, digitally signed by Microsoft.

### Q: Will this work on Windows Server?

**A:** Probably, but it's not officially tested. Windows Server 2016+ should work.

### Q: Can I install to a different location?

**A:** Yes, edit the `$TOOLS_BASE_DIR` variable in `install.ps1`. However, the lab guide assumes `C:\Tools\`.

### Q: Do I need an internet connection after installation?

**A:** Not for the tools themselves, but VirusTotal integration requires internet access.

### Q: How do I update the tools?

**A:** Re-run the installer. It will download the latest versions and overwrite existing files.

### Q: Can I use this in a VM?

**A:** Yes! This is ideal for malware analysis labs in isolated VMs.

### Q: What if I get VirusTotal rate limit errors?

**A:** Get a free VirusTotal API key from [virustotal.com](https://www.virustotal.com/) and add it to Process Explorer (Options → VirusTotal.com).

### Q: Are there other Sysinternals tools I should know about?

**A:** Yes! Check out:

- **TCPView:** Network connection monitor
- **ProcMon:** Process Monitor (advanced system activity tracking)
- **Sysmon:** System Monitor (logs process creation, network connections)

Download from [Sysinternals Suite](https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite).

## Additional Resources

- [Sysinternals Official Documentation](https://docs.microsoft.com/en-us/sysinternals/)
- [Process Explorer Documentation](https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer)
- [Autoruns Documentation](https://docs.microsoft.com/en-us/sysinternals/downloads/autoruns)
- [Lab Guide (Notion)](https://www.notion.so/feb27b10193a482c932d179cd6f7e7bb)

## Support

If you encounter issues not covered here:

- **GitHub Issues:** [Report a bug](https://github.com/GrandDay/lab-win-sec-tools/issues)
- **Discussions:** [Ask questions](https://github.com/GrandDay/lab-win-sec-tools/discussions)

---

**Last Updated:** October 22, 2025
