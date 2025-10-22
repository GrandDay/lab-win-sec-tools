# Security Best Practices

This document outlines security considerations and best practices when using the Windows Malware Lab Tools Installer and the associated analysis tools.

## Table of Contents

- [Safe Installation Practices](#safe-installation-practices)
- [Malware Analysis Safety](#malware-analysis-safety)
- [Tool Security Features](#tool-security-features)
- [Network Security](#network-security)
- [Data Protection](#data-protection)
- [Incident Response](#incident-response)

## Safe Installation Practices

### Verify Source Authenticity

**Always download from official sources:**

- **This installer:** Only from [github.com/GrandDay/lab-win-sec-tools](https://github.com/GrandDay/lab-win-sec-tools)
- **Sysinternals tools:** Downloaded automatically from `download.sysinternals.com` (Microsoft's official CDN)

**Before running any script:**

1. Review the code (it's open source for transparency)
2. Check the repository for recent updates or security notices
3. Verify the GitHub repository belongs to the expected owner

### Understand Execution Policy

The installer uses `-ExecutionPolicy Bypass` to run without permanently changing your system settings.

**What this means:**

- The policy bypass is temporary (only for that execution)
- Your system's execution policy remains unchanged
- No persistent security settings are modified

**Alternative (more secure):**

```powershell
# Download and review first
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1" -OutFile "install.ps1"

# Review the script
notepad install.ps1

# Run after review
.\install.ps1
```

### Administrator Privileges

**Why required:**

- Creating directories in `C:\` requires admin rights
- Installing system-level tools needs elevation
- Accessing all processes requires admin privileges

**Best practice:**

- Only grant admin rights when you understand what the script does
- Review UAC prompts carefully
- Don't disable UAC permanently

### File Integrity

The installer automatically unblocks downloaded files, which removes the "downloaded from internet" flag.

**Verify file integrity manually (optional):**

```powershell
# Check digital signature
Get-AuthenticodeSignature "C:\Tools\ProcessExplorer\procexp64.exe"

# Should show:
# Status: Valid
# SignerCertificate: CN=Microsoft Corporation, ...
```

## Malware Analysis Safety

### Use Isolated Environments

**CRITICAL:** Never analyze live malware on your primary workstation.

**Recommended environments:**

1. **Virtual Machine (VM):**
   - Use VMware, VirtualBox, or Hyper-V
   - Take snapshots before analysis
   - Disable shared folders and clipboard
   - Use host-only networking

2. **Physical Air-Gapped System:**
   - Dedicated analysis machine
   - No network connection
   - Removable storage for file transfer (carefully sanitized)

3. **Cloud Sandbox:**
   - Use services like ANY.RUN, Joe Sandbox, or Hybrid Analysis
   - For initial triage before local analysis

### Network Isolation

**For VM-based labs:**

```powershell
# Windows Firewall: Block all outbound connections (if analyzing live malware)
New-NetFirewallRule -DisplayName "Block All Outbound" -Direction Outbound -Action Block
```

**Better approach:** Configure VM networking:

- **Host-Only:** VM can talk to host, not internet
- **Internal:** VM can talk to other VMs in same network only
- **NAT with firewall:** Controlled internet access with monitoring

### Snapshot Before Analysis

**For VMs (example using Hyper-V):**

```powershell
# Create snapshot
Checkpoint-VM -Name "MalwareLabVM" -SnapshotName "PreAnalysis-$(Get-Date -Format 'yyyyMMdd-HHmm')"

# After analysis, restore
Restore-VMSnapshot -Name "PreAnalysis-20251022-1400" -VMName "MalwareLabVM" -Confirm:$false
```

### Handle Samples Carefully

**File handling rules:**

1. **Password-protect suspicious files:**

   ```powershell
   # Compress with password (standard password: "infected")
   Compress-Archive -Path "suspicious.exe" -DestinationPath "sample.zip"
   ```

2. **Never execute directly:** Only in isolated environment

3. **Use hashes for identification:**

   ```powershell
   Get-FileHash "suspicious.exe" -Algorithm SHA256 | Format-List
   ```

4. **Scan with VirusTotal before local analysis:**
   - Right-click in Process Explorer → Check VirusTotal
   - Or upload hash only (not file) to VirusTotal to avoid tipping off attacker

## Tool Security Features

### Process Explorer Security

**Built-in protections:**

- **Code Signature Verification:** Shows if executables are signed
- **VirusTotal Integration:** Checks file hashes against known malware database
- **Kernel Driver Protection:** Runs with driver to detect rootkits

**Enable all security features:**

1. Options → Difference Highlight Duration → 2 seconds (shows new processes)
2. Options → Confirm Kill (prevents accidental process termination)
3. View → Show Lower Pane → Handles (monitor file access)

**Verify Process Explorer itself:**

```powershell
# Check Process Explorer's signature
Get-AuthenticodeSignature "C:\Tools\ProcessExplorer\procexp64.exe"
```

### Autoruns Security

**Security scanning features:**

- **Code Signature Verification:** Identifies unsigned auto-start entries
- **VirusTotal Integration:** Scans auto-start items
- **Hide Microsoft Entries:** Reduces noise, highlights third-party items

**Safe usage:**

1. **Never delete entries you don't recognize without research**
2. **Disable first, reboot, test, then delete** (if system stable after disable)
3. **Export before making changes:**

   ```powershell
   # Autoruns → File → Save (save current configuration)
   ```

### VirusTotal Rate Limits

**Free tier limits:**

- 4 requests per minute
- 500 requests per day

**Best practices:**

1. **Get an API key:** Free at [virustotal.com](https://www.virustotal.com/)
2. **Prioritize suspicious items:** Don't scan everything
3. **Use file hashes:** Uploads share samples with VT (hash-only queries don't)

**Add API key:**

- Process Explorer: Options → VirusTotal.com → Enter API Key
- Autoruns: Options → Scan Options → VirusTotal.com → Enter API Key

## Network Security

### Firewall Considerations

The installer needs outbound HTTPS access to:

- `raw.githubusercontent.com` (to download installer script)
- `download.sysinternals.com` (to download tools)

**After installation (for malware analysis):**

```powershell
# Block internet access for analysis VM
New-NetFirewallRule -DisplayName "Block Malware Analysis VM" -Direction Outbound -Action Block -RemoteAddress Internet
```

### Proxy Environments

If behind a corporate proxy:

```powershell
# Configure proxy for PowerShell
$proxy = [System.Net.WebRequest]::GetSystemWebProxy()
$proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

# Or set explicitly
$env:HTTP_PROXY = "http://proxy.company.com:8080"
$env:HTTPS_PROXY = "http://proxy.company.com:8080"
```

### VirusTotal Privacy

**What VirusTotal sees:**

- File hash (SHA-256)
- Your IP address
- Timestamp of query

**What gets shared:**

- If you upload a file (not just hash), it becomes publicly accessible
- File hash queries are logged but files aren't shared

**Privacy best practices:**

1. **Hash-only queries:** Right-click in Process Explorer → Check VirusTotal (uses hash)
2. **Avoid uploading sensitive files:** Use hash lookup instead
3. **Use API key:** Provides higher rate limits and better privacy controls

## Data Protection

### Sensitive Information

**Process Explorer can display:**

- Command-line arguments (may contain passwords, API keys)
- Environment variables (may contain secrets)
- Memory strings (may contain credentials)

**Protect sensitive data:**

1. **Redact screenshots:** Before sharing, blur sensitive info
2. **Don't share memory dumps:** May contain credentials
3. **Use VMs for untrusted analysis:** Isolate from production environment

### Log Files

Process Explorer and Autoruns don't create persistent logs by default.

**If you save logs:**

```powershell
# Autoruns saves logs here (if you export)
# Review before sharing externally
notepad "C:\Users\$env:USERNAME\Documents\AutorunsLog.arn"
```

**Secure deletion:**

```powershell
# Securely delete sensitive logs (requires SDelete from Sysinternals)
sdelete -p 3 "C:\Users\$env:USERNAME\Documents\MalwareAnalysis\*"
```

### Screen Sharing

**When sharing your screen during analysis:**

1. **Close unrelated applications:** Avoid exposing other work
2. **Disable notifications:** Prevent sensitive popups
3. **Use focused window sharing:** Only share Process Explorer window, not full screen

## Incident Response

### If You Accidentally Execute Malware

**Immediate actions:**

1. **Disconnect network:**

   ```powershell
   Disable-NetAdapter -Name "*" -Confirm:$false
   ```

2. **Identify malicious process:** Use Process Explorer to find unusual processes

3. **Kill the process:**

   ```powershell
   # In Process Explorer: right-click → Kill Process Tree
   # Or via PowerShell:
   Stop-Process -Name "suspicious.exe" -Force
   ```

4. **Check persistence:** Use Autoruns to find auto-start entries

5. **Take a memory dump (if VM):** For forensics

   ```powershell
   # Hyper-V example
   Checkpoint-VM -Name "MalwareLabVM" -SnapshotName "PostIncident-$(Get-Date -Format 'yyyyMMdd-HHmm')"
   ```

6. **Restore from snapshot:** If in VM

7. **Run full antivirus scan:** If on physical machine

### Reporting

**If you discover malware in the wild:**

1. **Preserve evidence:** Take screenshots, save hashes
2. **Report to VirusTotal:** Upload sample (if safe to do so)
3. **Report to CERT:** Contact your local CERT/CSIRT
4. **Notify affected parties:** If malware came from email, website, etc.

### Post-Incident Cleanup

**On physical machines:**

```powershell
# Full system scan
Update-MpSignature
Start-MpScan -ScanType FullScan

# Check Windows Defender detection history
Get-MpThreatDetection
```

**Best practice:** Reimage the system if you suspect active infection.

## Educational Use Guidelines

### Responsible Disclosure

**If you find vulnerabilities:**

1. **Don't publicly disclose immediately:** Give vendors time to patch (90 days standard)
2. **Use coordinated disclosure:** Contact vendor security team
3. **Document responsibly:** Don't provide weaponized exploits in public writeups

### Legal Considerations

**Important reminders:**

- **Computer Fraud and Abuse Act (CFAA):** Unauthorized access is illegal (U.S. law)
- **International laws:** Many countries have similar laws
- **Lab environment only:** Never test on systems you don't own or have explicit permission to test
- **Malware possession:** Some jurisdictions restrict possession of malware (even for research)

**Safe practices:**

- Use VMs for all malware analysis
- Only analyze samples in authorized lab environments
- Respect Terms of Service for cloud platforms
- Get written authorization before penetration testing

### Ethical Hacking

**Follow these principles:**

1. **Authorization:** Only test systems you own or have permission for
2. **Scope:** Stay within defined boundaries
3. **Confidentiality:** Protect data you discover during analysis
4. **Disclosure:** Report findings to appropriate parties
5. **No harm:** Don't destroy data or disrupt operations

## Additional Security Resources

### Malware Analysis Resources

- [SANS Malware Analysis Cheat Sheet](https://www.sans.org/security-resources/posters)
- [Practical Malware Analysis Book](https://nostarch.com/malware)
- [ANY.RUN Cybersecurity Blog](https://any.run/cybersecurity-blog/)

### Secure Tool Downloads

- [Microsoft Sysinternals](https://docs.microsoft.com/en-us/sysinternals/)
- [Sysinternals Suite (complete)](https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite)

### Incident Response

- [NIST Incident Response Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r2.pdf)
- [SANS Incident Response Steps](https://www.sans.org/white-papers/)

---

**Remember:** Security is a shared responsibility. Always prioritize safety when working with potentially malicious software.

**Last Updated:** October 22, 2025
