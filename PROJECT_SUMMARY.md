# Windows Malware Lab Tools Installer - Project Summary

## Overview

This repository provides an automated PowerShell installer for Windows security analysis tools required for malware analysis labs. It follows the same structure and philosophy as the APT-Cache-Proxy-Configurator project.

## Project Goals Achieved

✅ **One-Command Setup** - Single PowerShell one-liner installs everything  
✅ **Ease of Use** - Simple for students with minimal technical knowledge  
✅ **Minimal Complexity** - No unnecessary dependencies or configuration  
✅ **Proper Privileges** - Automatic UAC elevation when needed  
✅ **Official Sources** - Downloads only from Microsoft's Sysinternals CDN  
✅ **Well Documented** - Comprehensive guides for all user levels  
✅ **Security Focused** - Best practices for malware analysis safety  

## Repository Structure

```bash
lab-win-sec-tools/
├── install.ps1                 # Main installation script (450 lines)
├── README.md                   # Project overview and quick start
├── LICENSE                     # MIT License
├── CHANGELOG.md                # Version history
├── CONTRIBUTING.md             # Contribution guidelines
├── RELEASE_CHECKLIST.md        # Release process for maintainers
├── SECURITY_POLICY.md          # Vulnerability reporting policy
├── PROJECT_STRUCTURE.md        # This file structure documentation
├── QUICK_REFERENCE.md          # One-page reference card
│
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI/CD
│
├── docs/
│   ├── README.md               # Documentation index
│   ├── GUIDE.md                # Complete installation & usage guide
│   └── SECURITY.md             # Security best practices
│
└── examples/
    └── EXAMPLES.md             # Advanced usage templates
```

## Core Features

### Installation Script (`install.ps1`)

**Capabilities:**

- Windows 10/11 compatibility check
- PowerShell version verification
- Automatic privilege elevation
- Downloads Process Explorer and Autoruns from Microsoft
- Extracts to `C:\Tools\ProcessExplorer\` and `C:\Tools\Autoruns\`
- Unblocks files to prevent security warnings
- Comprehensive error handling
- Color-coded console output
- Progress feedback

**Error Handling:**

- Download failures with retry suggestions
- Permission issues with clear guidance
- Missing directories automatically created
- Network connectivity validation
- TLS 1.2+ enforcement for secure downloads

### Documentation

**README.md** - Main entry point:

- Quick start with one-liner
- Tool descriptions
- Multiple installation methods
- Basic troubleshooting
- Links to detailed docs

**docs/GUIDE.md** - Comprehensive guide (500+ lines):

- System requirements
- All installation methods in detail
- Post-installation setup for each tool
- Process Explorer usage for malware analysis
- Autoruns usage for persistence detection
- Extensive troubleshooting section
- FAQ with 10+ common questions

**docs/SECURITY.md** - Security best practices (450+ lines):

- Safe installation practices
- VM setup for malware analysis
- Network isolation techniques
- VirusTotal privacy considerations
- Incident response procedures
- Legal and ethical guidelines
- Data protection measures

**CONTRIBUTING.md** - Developer guide:

- Code of conduct
- Development setup
- PowerShell coding standards
- Documentation standards
- Pull request process
- Testing requirements

**examples/EXAMPLES.md** - Advanced usage:

- Custom installation paths
- Silent installation scripts
- Batch installation across multiple machines
- Uninstall scripts
- Update scripts
- Task Scheduler integration
- Adding additional tools

## Installation Methods

### Method 1: One-Liner (Recommended)

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -Command "Invoke-Expression (Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1').Content"
```

### Method 2: Git Clone

```powershell
git clone https://github.com/GrandDay/lab-win-sec-tools.git
cd lab-win-sec-tools
.\install.ps1
```

### Method 3: Manual Download

Download ZIP from GitHub, extract, and run `install.ps1`

### Method 4: Windows Package Manager (Alternative)

```powershell
winget install Microsoft.Sysinternals.ProcessExplorer
winget install Microsoft.Sysinternals.Autoruns
```

## Tools Installed

| Tool | Purpose | Location |
|------|---------|----------|
| **Process Explorer** | Advanced process monitoring, malware detection, VirusTotal integration | `C:\Tools\ProcessExplorer\procexp64.exe` |
| **Autoruns** | Auto-start program analysis, persistence detection | `C:\Tools\Autoruns\Autoruns64.exe` |

## Security Considerations

**Safe by Design:**

- All downloads from official Microsoft CDN
- HTTPS (TLS 1.2+) enforced
- No telemetry or data collection
- No persistent changes to system (except tool installation)
- Execution policy bypass is temporary (not persistent)

**User Safety:**

- Comprehensive security documentation
- VM usage strongly recommended for malware analysis
- Network isolation guidelines
- Snapshot/restore procedures
- Incident response guidance

## Testing & Quality Assurance

### Automated Testing (GitHub Actions)

**CI Pipeline (`.github/workflows/ci.yml`):**

- PSScriptAnalyzer linting on every commit
- PowerShell syntax validation
- Download URL verification
- Markdown documentation linting

### Manual Testing Requirements

**Tested on:**

- Windows 10 Home (fresh install)
- Windows 10 Pro (fresh install)
- Windows 11 Home (fresh install)
- Windows 11 Pro (fresh install)

**Test scenarios:**

- Fresh installation
- Upgrade (existing tools)
- Network failure handling
- Non-admin user elevation
- Firewall blocking

## Contributing

**We Welcome:**

- Bug reports via GitHub Issues
- Feature suggestions via GitHub Discussions
- Pull requests for improvements
- Documentation enhancements

**Standards:**

- PowerShell best practices
- PSScriptAnalyzer compliance
- Comprehensive function documentation
- Clear commit messages

## Release Process

**Checklist:** See `RELEASE_CHECKLIST.md`

**Steps:**

1. Update version numbers
2. Update CHANGELOG.md
3. Run full test suite
4. Create release branch
5. Tag release
6. Create GitHub release
7. Verify one-liner works

## License

**MIT License** - Permissive open source license allowing:

- Commercial use
- Modification
- Distribution
- Private use

## Comparison to APT-Cache-Proxy-Configurator

**Similarities:**

- Single-script installation
- Comprehensive documentation structure
- Security-focused approach
- MIT licensed
- Well-commented code
- GitHub Actions CI/CD

**Differences:**

- Platform: Windows (PowerShell) vs Linux (Bash)
- Scope: Tool installation vs Network configuration
- Privileges: Admin elevation vs root access
- Sources: Microsoft CDN vs Debian repositories

## Support

- **Issues:** [GitHub Issues](https://github.com/GrandDay/lab-win-sec-tools/issues)
- **Discussions:** [GitHub Discussions](https://github.com/GrandDay/lab-win-sec-tools/discussions)
- **Security:** See `SECURITY_POLICY.md`
- **Lab Guide:** [Notion Document](https://www.notion.so/feb27b10193a482c932d179cd6f7e7bb)

## Future Enhancements (Planned)

- Pester automated tests
- Additional Sysinternals tools (TCPView, ProcMon, Sysmon)
- Configuration file for custom paths
- Silent mode for automated deployments
- Digital signature verification
- Chocolatey package

## Metrics

- **Total Files:** 15
- **PowerShell Code:** ~450 lines
- **Documentation:** ~2,500 lines
- **Languages:** PowerShell, Markdown, YAML
- **Maintainability:** High (well-structured, documented)

## Key Differentiators

1. **Education-Focused:** Designed specifically for students
2. **Safety-First:** Extensive security documentation
3. **Zero Configuration:** Works out of the box
4. **Official Sources:** Only Microsoft-signed tools
5. **Transparent:** Open source, readable code
6. **Well-Tested:** CI/CD pipeline, multiple Windows versions

## Repository Links

- **Main Repository:** `https://github.com/GrandDay/lab-win-sec-tools`
- **Raw Installer:** `https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1`
- **Issues:** `https://github.com/GrandDay/lab-win-sec-tools/issues`
- **Releases:** `https://github.com/GrandDay/lab-win-sec-tools/releases`

## Acknowledgments

- **Microsoft Sysinternals** - For excellent free security tools
- **APT-Cache-Proxy-Configurator** - Repository structure model
- **Lab Design** - Based on Windows malware analysis best practices

---

## Next Steps

### For Users

1. Run the one-liner to install tools
2. Read `QUICK_REFERENCE.md` for basics
3. Follow lab guide on Notion
4. Review `docs/SECURITY.md` for safety

### For Contributors

1. Read `CONTRIBUTING.md`
2. Review `PROJECT_STRUCTURE.md`
3. Set up development environment
4. Submit improvements via PR

### For Maintainers

1. Follow `RELEASE_CHECKLIST.md` for releases
2. Monitor GitHub Issues
3. Review and merge PRs
4. Keep documentation current

---

**Project Status:** ✅ **Ready for Initial Release (v1.0.0)**

**Last Updated:** October 22, 2025

**Maintained by:** GrandDay
