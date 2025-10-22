# Security Policy

## Supported Versions

We release security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly.

### How to Report

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, please report security issues via:

1. **GitHub Security Advisories** (preferred):
   - Go to [Security Advisories](https://github.com/GrandDay/lab-win-sec-tools/security/advisories)
   - Click "Report a vulnerability"
   - Fill out the form with details

2. **Email** (alternative):
   - Contact the maintainer directly (see GitHub profile)
   - Use subject line: "SECURITY: [Brief Description]"
   - Include detailed information about the vulnerability

### What to Include

Please provide:

- **Description:** Clear description of the vulnerability
- **Impact:** What could an attacker achieve?
- **Reproduction Steps:** Step-by-step instructions to reproduce
- **Affected Versions:** Which versions are vulnerable?
- **Suggested Fix:** If you have ideas for a fix (optional)
- **Proof of Concept:** Code or screenshots demonstrating the issue (if applicable)

### Response Timeline

We take security seriously and will respond as follows:

- **Initial Response:** Within 48 hours
- **Confirmation:** Within 7 days (confirm if it's a valid vulnerability)
- **Fix Timeline:** Within 30 days for critical issues, 90 days for moderate issues
- **Public Disclosure:** After fix is released (coordinated disclosure)

### Disclosure Policy

We follow **coordinated disclosure**:

1. **Private Report:** You report the vulnerability privately
2. **Fix Development:** We develop and test a fix
3. **Fix Release:** We release a patched version
4. **Public Disclosure:** We jointly announce the vulnerability and fix

**Please do not publicly disclose the vulnerability until we've released a fix.**

## Security Best Practices

### For Users

- Always download from official sources (GitHub releases)
- Verify you're downloading from the correct repository (GrandDay/lab-win-sec-tools)
- Review the script before running (it's open source for a reason)
- Run in a VM if you're unsure about security
- Keep your system updated with Windows security patches

### For Contributors

- Never commit credentials, API keys, or secrets
- Use HTTPS for all external requests
- Validate and sanitize all user inputs
- Follow principle of least privilege
- Use PowerShell's built-in security features
- Run PSScriptAnalyzer before committing

## Known Security Considerations

### By Design

This installer requires:

- **Administrator Privileges:** Necessary to create directories in C:\ and install tools
- **Execution Policy Bypass:** Used for one-liner installation (temporary, not persistent)
- **File Unblocking:** Removes "downloaded from internet" flag (tools are from official Microsoft sources)

These are intentional design decisions for legitimate functionality.

### Official Sources Only

All tools are downloaded from:

- `download.sysinternals.com` - Microsoft's official Sysinternals CDN
- All downloads use HTTPS (TLS 1.2+)
- No third-party or unofficial sources

### No Telemetry

This installer:

- Does **NOT** collect any user data
- Does **NOT** send analytics or telemetry
- Does **NOT** phone home
- Does **NOT** install any persistent services

## Security Updates

Security patches will be released as:

- **Critical:** Immediate patch release (within 48 hours)
- **High:** Patch within 7 days
- **Moderate:** Patch within 30 days
- **Low:** Included in next scheduled release

## Hall of Fame

We appreciate responsible disclosure. Security researchers who report valid vulnerabilities will be acknowledged here (with permission):

- _No reports yet_

## Contact

For security concerns, contact:

- **GitHub Security:** [Security Advisories](https://github.com/GrandDay/lab-win-sec-tools/security/advisories)
- **Maintainer:** See GitHub profile for contact information

---

**Thank you for helping keep this project secure!**
