# Contributing to Windows Malware Lab Tools Installer

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive experience for everyone.

### Our Standards

**Positive behavior includes:**

- Using welcoming and inclusive language
- Respecting differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community

**Unacceptable behavior includes:**

- Harassment, trolling, or discriminatory comments
- Publishing others' private information
- Other conduct inappropriate for a professional setting

## How Can I Contribute?

### Reporting Bugs

Before submitting a bug report:

1. **Check existing issues:** Your bug may already be reported
2. **Test on a clean system:** Ensure it's reproducible
3. **Gather information:** OS version, PowerShell version, error messages

**Submit a bug report:**

1. Use the [GitHub Issues](https://github.com/GrandDay/lab-win-sec-tools/issues) page
2. Use a clear and descriptive title
3. Include:
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Screenshots (if applicable)
   - System information

**Example bug report:**

```
Title: Installation fails on Windows 10 Home with TLS error

**Environment:**
- OS: Windows 10 Home 21H2
- PowerShell: 5.1.19041.2364

**Steps to reproduce:**
1. Run install.ps1 as Administrator
2. Script downloads Process Explorer successfully
3. Script fails when downloading Autoruns

**Expected:** Both tools download successfully

**Actual:** Error: "The request was aborted: Could not create SSL/TLS secure channel"

**Additional context:**
Corporate network with strict TLS requirements
```

### Suggesting Enhancements

**Before suggesting:**

1. Check if the feature already exists
2. Review existing enhancement requests
3. Consider if it aligns with project goals

**Submit an enhancement:**

1. Open a [GitHub Issue](https://github.com/GrandDay/lab-win-sec-tools/issues)
2. Tag it as "enhancement"
3. Include:
   - Clear description of the feature
   - Use cases
   - Why it would be useful
   - Potential implementation approach

### Pull Requests

**We welcome pull requests for:**

- Bug fixes
- Documentation improvements
- New features (discuss in an issue first)
- Code quality improvements

## Development Setup

### Prerequisites

- **OS:** Windows 10/11 for testing
- **PowerShell:** 5.1 or higher
- **Git:** For version control
- **Editor:** VS Code recommended (with PowerShell extension)

### Fork and Clone

```powershell
# Fork the repo on GitHub, then:
git clone https://github.com/YOUR-USERNAME/lab-win-sec-tools.git
cd lab-win-sec-tools
```

### Testing Your Changes

**Create a test VM:**

Use Windows 10/11 VM for testing to avoid affecting your main system.

**Test the installer:**

```powershell
# Test locally
.\install.ps1

# Verify installation
Test-Path "C:\Tools\ProcessExplorer\procexp64.exe"
Test-Path "C:\Tools\Autoruns\Autoruns64.exe"
```

**Test error handling:**

```powershell
# Simulate no admin rights (run as normal user)
# Simulate network failure (disconnect network before running)
# Simulate missing directories (remove C:\Tools\ first)
```

### Code Style

Run PowerShell linting:

```powershell
# Install PSScriptAnalyzer
Install-Module -Name PSScriptAnalyzer -Force

# Analyze code
Invoke-ScriptAnalyzer -Path .\install.ps1 -Recurse
```

## Coding Standards

### PowerShell Style Guide

**Follow these conventions:**

1. **Use approved verbs:** `Get-`, `Set-`, `New-`, `Remove-`, etc.

   ```powershell
   # Good
   function Get-ToolStatus { }

   # Bad
   function CheckTool { }
   ```

2. **PascalCase for functions:**

   ```powershell
   function Install-SecurityTool { }
   ```

3. **camelCase for variables:**

   ```powershell
   $toolName = "Process Explorer"
   ```

4. **ALL_CAPS for constants:**

   ```powershell
   $TOOLS_BASE_DIR = "C:\Tools"
   ```

5. **Use explicit parameter types:**

   ```powershell
   # Good
   param(
       [string]$ToolName,
       [int]$MaxRetries = 3
   )

   # Bad
   param(
       $ToolName,
       $MaxRetries = 3
   )
   ```

6. **Comment complex logic:**

   ```powershell
   # Download file with retry logic
   for ($i = 0; $i -lt $maxRetries; $i++) {
       try {
           Invoke-WebRequest -Uri $url -OutFile $destination
           break
       }
       catch {
           Write-Warning "Retry $($i + 1)/$maxRetries"
       }
   }
   ```

7. **Use cmdlet-binding:**

   ```powershell
   [CmdletBinding()]
   param()
   ```

### Documentation Standards

**Function documentation:**

```powershell
function Get-Tool {
    <#
    .SYNOPSIS
        Download a tool from specified URL
    
    .DESCRIPTION
        Downloads a security tool from the official Microsoft source
        with error handling and retry logic.
    
    .PARAMETER Url
        The URL to download from
    
    .PARAMETER Destination
        The local file path to save to
    
    .PARAMETER ToolName
        Human-readable name of the tool
    
    .EXAMPLE
        Get-Tool -Url "https://example.com/tool.zip" -Destination "C:\temp\tool.zip" -ToolName "Process Explorer"
    
    .NOTES
        Requires internet connection and administrator privileges
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,
        
        [Parameter(Mandatory=$true)]
        [string]$Destination,
        
        [Parameter(Mandatory=$true)]
        [string]$ToolName
    )
    
    # Implementation...
}
```

### Error Handling

**Use try/catch blocks:**

```powershell
try {
    # Operation that might fail
    Invoke-WebRequest -Uri $url -OutFile $destination
    Write-Success "Download complete"
}
catch {
    Write-ErrorMessage "Download failed: $_"
    throw $_
}
```

**Provide helpful error messages:**

```powershell
# Good
Write-ErrorMessage "Failed to create directory: $path. Ensure you have administrator privileges."

# Bad
Write-Host "Error"
```

### Security Best Practices

1. **Validate inputs:**

   ```powershell
   if (-not $url.StartsWith("https://")) {
       throw "Only HTTPS URLs are allowed"
   }
   ```

2. **Use TLS 1.2+:**

   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   ```

3. **Never hardcode credentials:**

   ```powershell
   # Bad
   $password = "hardcoded123"

   # Good
   $credential = Get-Credential
   ```

4. **Sanitize paths:**

   ```powershell
   $safePath = [System.IO.Path]::GetFullPath($userInput)
   ```

## Submitting Changes

### Commit Messages

**Format:**

```
<type>: <subject>

<body>

<footer>
```

**Types:**

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Formatting changes
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance tasks

**Example:**

```
feat: Add retry logic for downloads

- Implement exponential backoff for failed downloads
- Add configurable max retry count
- Improve error messages for network failures

Closes #42
```

### Pull Request Process

1. **Create a feature branch:**

   ```powershell
   git checkout -b feature/add-retry-logic
   ```

2. **Make your changes:**

   - Write code following style guide
   - Add documentation
   - Test thoroughly

3. **Commit your changes:**

   ```powershell
   git add .
   git commit -m "feat: Add retry logic for downloads"
   ```

4. **Push to your fork:**

   ```powershell
   git push origin feature/add-retry-logic
   ```

5. **Create Pull Request:**

   - Go to GitHub and create PR
   - Fill out PR template
   - Link related issues

6. **Address review feedback:**

   - Make requested changes
   - Push updates to same branch
   - Respond to reviewer comments

### PR Checklist

Before submitting, ensure:

- [ ] Code follows style guide
- [ ] All functions have documentation
- [ ] Changes are tested on Windows 10/11
- [ ] No PSScriptAnalyzer warnings
- [ ] README.md updated (if needed)
- [ ] GUIDE.md updated (if needed)
- [ ] Commit messages are clear

## Testing

### Manual Testing

**Test scenarios:**

1. **Fresh install:**
   - Clean Windows 10/11 VM
   - No existing `C:\Tools\` directory
   - Run installer

2. **Upgrade install:**
   - Existing tools in `C:\Tools\`
   - Run installer (should overwrite)

3. **Network failure:**
   - Disconnect network mid-download
   - Verify error handling

4. **Permission issues:**
   - Run as non-admin user
   - Verify elevation prompt

5. **Firewall blocking:**
   - Block PowerShell in firewall
   - Verify error message

### Automated Testing (Future)

We plan to add Pester tests in the future:

```powershell
# Example Pester test (not yet implemented)
Describe "Install-SecurityTools" {
    It "Creates tools directory" {
        # Test logic
        Test-Path "C:\Tools" | Should -Be $true
    }
}
```

## Release Process

(For maintainers)

1. **Update version:**
   - Update version in script comments
   - Update CHANGELOG.md

2. **Tag release:**

   ```powershell
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

3. **Create GitHub release:**
   - Use tag
   - Add release notes
   - Attach any binaries (if applicable)

## Questions?

**Need help?**

- Open a [GitHub Discussion](https://github.com/GrandDay/lab-win-sec-tools/discussions)
- Ask in [GitHub Issues](https://github.com/GrandDay/lab-win-sec-tools/issues)

**Want to discuss major changes?**

Open an issue first to discuss your ideas before investing time in coding.

---

Thank you for contributing to making malware analysis education more accessible!
