# Quick Reference Card

One-page reference for the Windows Malware Lab Tools Installer.

## Installation

### One-Liner (Recommended)

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -Command "Invoke-Expression (Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1').Content"
```

### Manual Install

```powershell
git clone https://github.com/GrandDay/lab-win-sec-tools.git
cd lab-win-sec-tools
.\install.ps1
```

## What Gets Installed

| Tool | Location | Executable |
|------|----------|------------|
| Process Explorer | `C:\Tools\ProcessExplorer\` | `procexp64.exe` |
| Autoruns | `C:\Tools\Autoruns\` | `Autoruns64.exe` |

## Launching Tools

### Process Explorer

```powershell
Start-Process "C:\Tools\ProcessExplorer\procexp64.exe" -Verb RunAs
```

### Autoruns

```powershell
Start-Process "C:\Tools\Autoruns\Autoruns64.exe" -Verb RunAs
```

## First-Time Setup

### Process Explorer

1. **Enable VirusTotal:**
   - Options → VirusTotal.com → Check "Check VirusTotal.com"

2. **Accept EULA:** Click "Agree" on first launch

3. **Replace Task Manager (Optional):**
   - Options → Replace Task Manager

### Autoruns

1. **Hide Microsoft Entries:**
   - Options → Hide Microsoft Entries

2. **Enable VirusTotal:**
   - Options → Scan Options → Check VirusTotal.com

3. **Accept EULA:** Click "Agree" on first launch

## Common Commands

### Verify Installation

```powershell
Test-Path "C:\Tools\ProcessExplorer\procexp64.exe"
Test-Path "C:\Tools\Autoruns\Autoruns64.exe"
```

### Uninstall

```powershell
Remove-Item "C:\Tools\ProcessExplorer" -Recurse -Force
Remove-Item "C:\Tools\Autoruns" -Recurse -Force
```

### Update

```powershell
# Just re-run the installer - it downloads latest versions
.\install.ps1
```

## Troubleshooting

### Execution Policy Error

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Files Blocked

```powershell
Unblock-File -Path "C:\Tools\ProcessExplorer\*"
Unblock-File -Path "C:\Tools\Autoruns\*"
```

### Download Fails

```powershell
# Test connectivity
Test-NetConnection download.sysinternals.com -Port 443
```

## Malware Analysis Quick Tips

### Process Explorer - Find Malware

1. **Check VirusTotal scores:** Right-click process → Check VirusTotal
2. **Look for purple processes:** Packed executables (suspicious)
3. **Examine properties:** Double-click → Image/Strings/TCP/IP tabs
4. **Verify signatures:** Options → Verify Image Signatures

### Autoruns - Find Persistence

1. **Scan everything:** Click "Everything" tab
2. **Hide Microsoft:** Options → Hide Microsoft Entries
3. **Look for:**
   - Yellow entries (unsigned)
   - Red entries (VirusTotal hits)
   - Suspicious paths (temp folders, user directories)
4. **Investigate:** Right-click → Properties / Search Online

## Safety Reminders

- ⚠️ **ALWAYS use VMs for malware analysis**
- ⚠️ **Never analyze on your primary system**
- ⚠️ **Take snapshots before analysis**
- ⚠️ **Isolate network (host-only or no network)**
- ⚠️ **Don't execute unknown files outside VMs**

## System Requirements

- Windows 10 or 11 (64-bit)
- PowerShell 5.1+
- Administrator privileges
- Internet connection (for download)

## Help & Support

- **Documentation:** [Full Guide](docs/GUIDE.md)
- **Security:** [Security Best Practices](docs/SECURITY.md)
- **GitHub:** [Issues](https://github.com/GrandDay/lab-win-sec-tools/issues)
- **Lab Guide:** [Notion](https://www.notion.so/feb27b10193a482c932d179cd6f7e7bb)

## Quick Keyboard Shortcuts

### Process Explorer

- `Ctrl+F` - Find handle or DLL
- `Ctrl+H` - Toggle handles view
- `Ctrl+D` - Toggle DLLs view
- `Ctrl+L` - Toggle lower pane
- `Delete` - Kill process (be careful!)

### Autoruns

- `Ctrl+F` - Find
- `F5` - Refresh
- `Space` - Toggle entry (enable/disable)
- `Delete` - Delete entry (dangerous!)

---

**Print this page and keep it handy during your lab!**

**Repository:** [github.com/GrandDay/lab-win-sec-tools](https://github.com/GrandDay/lab-win-sec-tools)
