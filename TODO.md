# TODO - Future Enhancements

This document tracks planned features and improvements for future releases.

## Priority: High

### Testing Improvements

- [ ] Add Pester unit tests for PowerShell functions
  - Test privilege detection
  - Test download functions
  - Test extraction logic
  - Test error handling

- [ ] Automated integration tests on multiple Windows versions
  - Windows 10 Home
  - Windows 10 Pro
  - Windows 11 Home  
  - Windows 11 Pro

### Security Enhancements

- [ ] Digital signature verification after download
  - Verify Microsoft's signature on executables
  - Alert if signature is invalid or missing
  - Fail installation if verification fails

- [ ] SHA256 hash verification
  - Maintain known-good hashes for each tool
  - Verify downloaded files match expected hashes
  - Update hashes with each release

## Priority: Medium

### Additional Tools

- [ ] Add TCPView support
  - Network connection monitoring
  - Real-time TCP/UDP traffic analysis

- [ ] Add Process Monitor (ProcMon) support
  - System activity monitoring
  - File system and registry tracking

- [ ] Add Sysmon support
  - Windows system event logging
  - Advanced threat detection

- [ ] Create "full suite" option
  - Install complete Sysinternals Suite
  - User selects specific tools or all

### Configuration Options

- [ ] Configuration file support
  - YAML or JSON config file
  - Specify custom installation paths
  - Select which tools to install
  - Set download timeouts

- [ ] Command-line parameters
  - `-Path` for custom install location
  - `-Tools` to specify which tools (comma-separated)
  - `-Silent` for unattended installation
  - `-NoElevate` to skip privilege check (fail if not admin)

### Usability Improvements

- [ ] Interactive menu mode
  - Let user select tools from list
  - Choose installation path
  - Configure options interactively

- [ ] Desktop shortcuts creation
  - Optional shortcuts to tools
  - Add context menu integration

- [ ] PATH environment variable integration
  - Add tools to system PATH (optional)
  - Launch tools from any PowerShell session

## Priority: Low

### Package Managers

- [ ] Chocolatey package
  - Create and publish Chocolatey package
  - `choco install lab-win-sec-tools`

- [ ] Scoop manifest
  - Create Scoop manifest
  - `scoop install lab-win-sec-tools`

### Documentation

- [ ] Video tutorial
  - Screen recording of installation
  - Walkthrough of basic usage
  - Upload to YouTube

- [ ] Animated GIFs
  - Installation process
  - Tool usage examples
  - Add to README.md

- [ ] PDF guide
  - Printable version of GUIDE.md
  - Include in releases

### Tool Enhancements

- [ ] Auto-update checker
  - Check for newer versions on GitHub
  - Notify user if update available
  - One-click update

- [ ] Backup/restore settings
  - Save Process Explorer configuration
  - Save Autoruns filters
  - Restore after reinstall

- [ ] Pre-configured settings
  - Auto-enable VirusTotal integration
  - Auto-accept EULAs (with user consent)
  - Auto-configure optimal settings

## Completed ✅

- [x] Initial PowerShell installer script
- [x] README.md with quick start
- [x] Comprehensive GUIDE.md
- [x] Security best practices (SECURITY.md)
- [x] Contributing guidelines
- [x] MIT License
- [x] GitHub Actions CI/CD
- [x] PSScriptAnalyzer integration
- [x] Markdown linting

## Ideas for Discussion

### Community Features

- Share tool configurations
- User-submitted malware analysis reports
- Community-maintained IOC lists

### Integration

- Integration with Windows Defender
- Integration with Wireshark
- Integration with Volatility (memory forensics)

### Advanced Features

- Malware sandbox automation scripts
- Automated reporting templates
- Integration with MITRE ATT&CK framework

## Won't Do (Out of Scope)

- ❌ Linux/macOS support (Windows-specific tools)
- ❌ GUI installer (PowerShell script is intentionally simple)
- ❌ Actual malware samples (legal/ethical concerns)
- ❌ Automated malware analysis (too complex for this project)

## Contributing Ideas

Have a feature suggestion?

1. Check if it's already listed here
2. Open a [GitHub Discussion](https://github.com/GrandDay/lab-win-sec-tools/discussions)
3. Get community feedback
4. Submit a PR if you want to implement it!

---

**Last Updated:** October 22, 2025

**Next Review:** Before each major release
