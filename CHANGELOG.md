# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features
- Pester automated tests
- Support for additional Sysinternals tools (TCPView, ProcMon, Sysmon)
- Configuration file for custom installation paths
- Silent installation mode for automated deployments
- Verification of digital signatures post-download

## [1.0.0] - 2025-10-22

### Added
- Initial release of Windows Malware Lab Tools Installer
- PowerShell script to automate installation of Process Explorer and Autoruns
- Automatic privilege elevation when not running as Administrator
- Download from official Microsoft Sysinternals CDN
- Automatic extraction to `C:\Tools\ProcessExplorer` and `C:\Tools\Autoruns`
- File unblocking to prevent security warnings
- Comprehensive error handling and user feedback
- Color-coded console output for better readability
- Windows 10/11 compatibility checks
- PowerShell 5.1+ version verification
- One-liner installation command for quick setup
- Complete documentation:
  - README.md with quick start guide
  - GUIDE.md with detailed installation and troubleshooting
  - SECURITY.md with security best practices
  - CONTRIBUTING.md for contributors
- MIT License
- Repository structure following APT-Cache-Proxy-Configurator model

### Security
- All downloads use HTTPS (TLS 1.2+)
- Downloads only from official Microsoft sources
- File integrity maintained through direct CDN access
- Automatic file unblocking for legitimate security tools
- No telemetry or data collection

---

## Version History

### Legend

- `Added` - New features
- `Changed` - Changes in existing functionality
- `Deprecated` - Soon-to-be removed features
- `Removed` - Removed features
- `Fixed` - Bug fixes
- `Security` - Security improvements or fixes

---

**Note:** This project is in active development. Check the [GitHub repository](https://github.com/GrandDay/lab-win-sec-tools) for the latest updates.
