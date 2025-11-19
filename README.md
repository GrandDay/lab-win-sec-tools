# Windows Malware Lab Tools Installer


[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)

> **Automated installer for Windows security analysis tools required for the "Finding and Scanning Suspicious Processes for Malware in Windows 11" lab.**

This project automates the download and installation of essential security tools needed to complete a Windows 11 malware analysis lab. It handles all the tedious setup steps so students can focus on learning malware detection and analysis techniques.

## 🎯 Quick Start

**For Students:** Run this one command in an elevated PowerShell prompt:

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -Command "Invoke-Expression (Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1').Content"
```

That's it! The script will automatically:

- ✅ Check for administrator privileges (and elevate if needed)
- ✅ Create the required directories (`C:\Tools\ProcessExplorer`, `C:\Tools\Autoruns`)
- ✅ Download Process Explorer and Autoruns from Microsoft's official sources
- ✅ Extract and prepare the tools for use
- ✅ Unblock files to prevent security warnings

## 📋 What Gets Installed

This installer sets up the following tools from Microsoft Sysinternals:

| Tool | Version | Purpose | Install Location |
|------|---------|---------|------------------|
| **Process Explorer** | Latest | Advanced process monitoring and analysis | `C:\Tools\ProcessExplorer\` |
| **Autoruns** | Latest | View and manage auto-start programs | `C:\Tools\Autoruns\` |

All tools are downloaded directly from **Microsoft's official Sysinternals sources** to ensure authenticity and security.

## 🔧 Requirements

- **OS:** Windows 10 or Windows 11 (64-bit)
- **PowerShell:** Version 5.1 or higher (included with Windows 10/11)
- **Permissions:** Administrator access
- **Internet:** Active internet connection to download tools

## 📖 Alternative Installation Methods

### Method 1: Clone and Run Locally

If you prefer to review the script before running it:

```powershell
# Clone the repository
git clone https://github.com/GrandDay/lab-win-sec-tools.git
cd lab-win-sec-tools

# Run the installer (as Administrator)
.\install.ps1
```

### Method 2: Manual Download

1. Download the repository as a ZIP file
2. Extract to a folder
3. Right-click PowerShell and select "Run as Administrator"
4. Navigate to the extracted folder
5. Run `.\install.ps1`

### Method 3: Using Windows Package Manager (Advanced)

For advanced users with `winget` installed:

```powershell
winget install Microsoft.Sysinternals.ProcessExplorer
winget install Microsoft.Sysinternals.Autoruns
```

**Note:** This method installs to default locations, not the `C:\Tools\` structure expected by the lab guide.

## 🚀 Usage After Installation

Once installation is complete, you can launch the tools:

### Process Explorer

```powershell
# Launch as Administrator (required)
Start-Process "C:\Tools\ProcessExplorer\procexp64.exe" -Verb RunAs
```

**First-time setup:**

1. Enable VirusTotal integration: Options → VirusTotal.com → Check "Check VirusTotal.com"
2. Submit your VirusTotal API key (optional, for higher rate limits)

### Autoruns

```powershell
# Launch as Administrator (required)
Start-Process "C:\Tools\Autoruns\Autoruns64.exe" -Verb RunAs
```

**Usage tips:**

- Scan all auto-start locations to find persistent malware
- Use filters to hide known Microsoft entries
- Look for suspicious unsigned entries or unusual paths

## 🛡️ Security Considerations

- **Official Sources Only:** All tools are downloaded from Microsoft's official Sysinternals CDN
- **HTTPS Downloads:** All downloads use encrypted HTTPS connections
- **File Verification:** The script unblocks files after download to prevent false security warnings
- **No Telemetry:** This installer collects no user data or analytics

## 📚 Documentation

- [Detailed Installation Guide](docs/GUIDE.md) - Comprehensive setup and troubleshooting
- [Lab Manual Reference](https://www.notion.so/Lab-Finding-and-Scanning-Suspicious-Processes-for-Malware-in-Windows-11-feb27b10193a482c932d179cd6f7e7bb?source=copy_link) - Original lab instructions
- [Security Best Practices](docs/SECURITY.md) - Safe usage guidelines

## 🔍 How It Works

The installer performs these steps automatically:

1. **Environment Check** - Verifies Windows 10/11 and PowerShell version
2. **Privilege Escalation** - Prompts for admin rights if not already elevated
3. **Directory Creation** - Creates `C:\Tools\ProcessExplorer` and `C:\Tools\Autoruns`
4. **Download Phase** - Fetches latest tool versions from Microsoft
5. **Extraction** - Unzips archives to their respective directories
6. **File Preparation** - Unblocks executables to prevent security prompts
7. **Verification** - Confirms all files are in place and ready

## 🐛 Troubleshooting

### "Execution policy" error

Run PowerShell as Administrator and execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Download fails

- Check your internet connection
- Verify firewall isn't blocking PowerShell
- Try the manual download method

### Tools won't launch

Make sure to run as Administrator:

```powershell
Start-Process "C:\Tools\ProcessExplorer\procexp64.exe" -Verb RunAs
```

For more detailed troubleshooting, see [docs/GUIDE.md](docs/GUIDE.md).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Test your changes on Windows 10/11
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Microsoft Sysinternals** - For providing exceptional free security tools
- Original lab design inspired by practical malware analysis techniques

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/GrandDay/lab-win-sec-tools/issues)
- **Discussions:** [GitHub Discussions](https://github.com/GrandDay/lab-win-sec-tools/discussions)

---

**⚠️ Educational Use Only:** This toolkit is designed for educational purposes in controlled lab environments. Always follow responsible disclosure practices and legal guidelines when analyzing malware.
