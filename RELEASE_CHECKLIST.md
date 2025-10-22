# Release Checklist

Use this checklist when preparing a new release of the Windows Malware Lab Tools Installer.

## Pre-Release

### Code Quality

- [ ] All PSScriptAnalyzer warnings resolved
- [ ] Code follows PowerShell style guide
- [ ] All functions have proper documentation
- [ ] Error handling is comprehensive
- [ ] No hardcoded credentials or sensitive data

### Testing

- [ ] Tested on Windows 10 Home (fresh install)
- [ ] Tested on Windows 10 Pro (fresh install)
- [ ] Tested on Windows 11 Home (fresh install)
- [ ] Tested on Windows 11 Pro (fresh install)
- [ ] Tested upgrade scenario (existing tools present)
- [ ] Tested privilege elevation (run as non-admin)
- [ ] Tested network failure handling
- [ ] Tested firewall blocking scenario
- [ ] Verified downloads from Microsoft CDN
- [ ] Verified file extraction
- [ ] Verified file unblocking
- [ ] Verified tools launch successfully
- [ ] Tested one-liner installation command
- [ ] Tested local installation method

### Documentation

- [ ] README.md is up-to-date
- [ ] GUIDE.md reflects current functionality
- [ ] SECURITY.md includes latest best practices
- [ ] CONTRIBUTING.md is current
- [ ] CHANGELOG.md updated with new version
- [ ] All internal links work
- [ ] All external links work
- [ ] Screenshots are current (if any)
- [ ] Version numbers updated

### Security

- [ ] All downloads use HTTPS
- [ ] TLS 1.2+ enforced
- [ ] Downloads only from official Microsoft sources
- [ ] No new security vulnerabilities introduced
- [ ] Digital signature verification works (manual check)
- [ ] File unblocking works correctly
- [ ] UAC prompts function as expected

## Release Process

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes
- **MINOR** (1.X.0): New features, backward compatible
- **PATCH** (1.0.X): Bug fixes, backward compatible

**Current release version:** `___.___.__`

### Update Version

- [ ] Update version in `install.ps1` header comments
- [ ] Update version in CHANGELOG.md
- [ ] Update "Last Updated" dates in documentation

### Git Operations

```powershell
# Ensure you're on main branch
git checkout main
git pull origin main

# Create release branch
git checkout -b release/v1.0.0

# Commit version updates
git add .
git commit -m "chore: Prepare release v1.0.0"

# Push release branch
git push origin release/v1.0.0
```

- [ ] Commands above executed
- [ ] Release branch created and pushed

### Create Pull Request

- [ ] Create PR from release branch to main
- [ ] PR description includes release notes
- [ ] All checks pass
- [ ] Code review completed
- [ ] PR merged to main

### Tag Release

```powershell
# Pull latest main
git checkout main
git pull origin main

# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0 - Windows Malware Lab Tools Installer"

# Push tag
git push origin v1.0.0
```

- [ ] Tag created
- [ ] Tag pushed to GitHub

### GitHub Release

- [ ] Go to GitHub Releases page
- [ ] Click "Draft a new release"
- [ ] Select the tag (v1.0.0)
- [ ] Release title: `v1.0.0 - Windows Malware Lab Tools Installer`
- [ ] Copy release notes from CHANGELOG.md
- [ ] Attach any additional files (none for this project)
- [ ] Mark as "Latest release"
- [ ] Publish release

## Post-Release

### Verification

- [ ] GitHub release is visible
- [ ] Tag appears in repository
- [ ] One-liner command works with new release
- [ ] Documentation links are correct
- [ ] Social media announcement (if applicable)

### Update Documentation Links

Verify these URLs work:

- [ ] `https://github.com/GrandDay/lab-win-sec-tools`
- [ ] `https://github.com/GrandDay/lab-win-sec-tools/releases/latest`
- [ ] `https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1`

### Communication

- [ ] Update Notion lab guide with new release info (if applicable)
- [ ] Notify users in GitHub Discussions (if applicable)
- [ ] Update any external references to the project

## Rollback Plan

If critical issues are discovered post-release:

### Immediate Actions

```powershell
# Delete tag locally
git tag -d v1.0.0

# Delete tag from remote
git push origin :refs/tags/v1.0.0
```

- [ ] Tag removed from GitHub
- [ ] GitHub Release marked as "Pre-release" or deleted
- [ ] Issue created documenting the problem
- [ ] Notification sent to users (if release was widely announced)

### Fix and Re-release

- [ ] Create hotfix branch
- [ ] Fix critical issue
- [ ] Test thoroughly
- [ ] Release as patch version (e.g., v1.0.1)

## Notes

### Release Schedule

- **Major releases:** As needed (breaking changes)
- **Minor releases:** Monthly (new features)
- **Patch releases:** As needed (bug fixes)

### Support Policy

- **Latest version:** Full support
- **Previous minor version:** Security fixes only
- **Older versions:** No support (recommend upgrade)

### Testing Environment

**Required for release testing:**

- Windows 10 Home VM
- Windows 10 Pro VM
- Windows 11 Home VM
- Windows 11 Pro VM
- Internet connection (for download tests)
- Isolated network (for failure tests)

### Common Issues to Check

- [ ] PowerShell execution policy conflicts
- [ ] Antivirus false positives
- [ ] Corporate proxy issues
- [ ] Firewall blocking downloads
- [ ] UAC prompt not appearing
- [ ] Files remaining blocked after unblock attempt
- [ ] Directory creation failures
- [ ] Extraction errors

---

## Checklist Completed

**Release Manager:** ___________________

**Date:** ___________________

**Version Released:** ___________________

**GitHub Release URL:** ___________________

---

**After completing this checklist, archive it with the release documentation.**
