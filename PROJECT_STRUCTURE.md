# Project Structure

This document describes the complete file structure of the lab-win-sec-tools repository.

```text
lab-win-sec-tools/
│
├── .github/
│   └── workflows/
│       └── ci.yml                    # GitHub Actions CI/CD pipeline
│
├── docs/
│   ├── GUIDE.md                      # Comprehensive installation and usage guide
│   ├── SECURITY.md                   # Security best practices for malware analysis
│   └── README.md                     # Documentation index
│
├── examples/
│   └── EXAMPLES.md                   # Advanced usage examples and templates
│
├── .gitignore                        # Git ignore rules
├── .markdownlint.json                # Markdown linting configuration
├── CHANGELOG.md                      # Version history and changes
├── CONTRIBUTING.md                   # Contribution guidelines
├── install.ps1                       # Main installation script (THE CORE FILE)
├── LICENSE                           # MIT License
├── README.md                         # Main project documentation
├── RELEASE_CHECKLIST.md              # Release process checklist
└── SECURITY_POLICY.md                # Security reporting and policy

```

## File Descriptions

### Root Files

#### `install.ps1` ⭐ CORE FILE

The main PowerShell installation script that:

- Downloads Process Explorer and Autoruns from Microsoft
- Extracts to `C:\Tools\`
- Handles privilege elevation
- Provides error handling and user feedback

#### `README.md`

Main project documentation including:

- Quick start guide
- Installation methods
- Tool descriptions
- Troubleshooting basics
- Links to detailed documentation

#### `LICENSE`

MIT License - permissive open source license allowing commercial and private use.

#### `CHANGELOG.md`

Version history following [Keep a Changelog](https://keepachangelog.com/) format.

#### `CONTRIBUTING.md`

Guidelines for contributors covering:

- Code of conduct
- Development setup
- Coding standards
- Pull request process
- Testing requirements

#### `RELEASE_CHECKLIST.md`

Comprehensive checklist for maintainers when preparing releases.

#### `SECURITY_POLICY.md`

Security policy including:

- Supported versions
- Vulnerability reporting process
- Disclosure policy
- Security best practices

### Configuration Files

#### `.gitignore`

Excludes from version control:

- Downloaded binaries (*.zip, *.exe)
- Temporary files
- IDE configurations
- OS-generated files

#### `.markdownlint.json`

Configuration for Markdown linting to ensure documentation quality.

### `.github/` Directory

#### `workflows/ci.yml`

GitHub Actions workflow that:

- Lints PowerShell scripts with PSScriptAnalyzer
- Tests script syntax
- Verifies download URLs are accessible
- Lints Markdown documentation

### `docs/` Directory

#### `docs/GUIDE.md`

Comprehensive guide covering:

- System requirements
- All installation methods (one-liner, clone, manual, winget)
- Post-installation setup for Process Explorer and Autoruns
- Detailed tool usage instructions
- Troubleshooting common issues
- FAQ

#### `docs/SECURITY.md`

Security documentation covering:

- Safe installation practices
- Malware analysis safety (VMs, isolation, snapshots)
- Tool security features
- Network security considerations
- Data protection
- Incident response procedures
- Legal and ethical considerations

#### `docs/README.md`

Index of all documentation with quick links.

### `examples/` Directory

#### `examples/EXAMPLES.md`

Advanced examples including:

- Custom installation paths
- Silent installation for automation
- Batch installation across multiple machines
- Verification scripts
- Launch scripts
- Uninstall script
- Update script
- Task Scheduler integration
- Adding additional tools template

## File Dependencies

### Installation Flow

```text
User runs → install.ps1
              │
              ├─→ Downloads from download.sysinternals.com
              ├─→ Extracts to C:\Tools\
              └─→ Unblocks files
```

### Documentation Flow

```text
User reads → README.md (overview)
               │
               ├─→ docs/GUIDE.md (detailed instructions)
               ├─→ docs/SECURITY.md (security practices)
               └─→ examples/EXAMPLES.md (advanced usage)
```

### Development Flow

```text
Developer reads → CONTRIBUTING.md
                    │
                    ├─→ Follows coding standards
                    ├─→ Tests with .github/workflows/ci.yml
                    └─→ Releases with RELEASE_CHECKLIST.md
```

## File Sizes (Approximate)

| File | Size | Lines |
|------|------|-------|
| install.ps1 | 15 KB | ~450 |
| README.md | 8 KB | ~200 |
| docs/GUIDE.md | 20 KB | ~500 |
| docs/SECURITY.md | 18 KB | ~450 |
| CONTRIBUTING.md | 12 KB | ~350 |
| examples/EXAMPLES.md | 8 KB | ~250 |
| Other files | <5 KB each | <150 each |

## Critical Files (Must Review)

When reviewing this repository, prioritize these files:

1. **`install.ps1`** - The actual code that runs
2. **`README.md`** - First impression for users
3. **`docs/SECURITY.md`** - Critical for safe malware analysis
4. **`LICENSE`** - Legal terms

## Maintainability

### Easy to Update

- **Tool URLs:** In `$TOOLS` array in `install.ps1`
- **Installation path:** `$TOOLS_BASE_DIR` variable
- **Documentation:** Markdown files in `docs/`

### Version Information

Update these when releasing:

- `CHANGELOG.md` - Add new version entry
- `install.ps1` - Update header comment version
- `docs/GUIDE.md` - Update "Last Updated" date
- `docs/SECURITY.md` - Update "Last Updated" date

## Repository Stats

- **Total Files:** ~15
- **Total Lines of Code:** ~450 (PowerShell)
- **Total Lines of Docs:** ~2,000+ (Markdown)
- **Languages:** PowerShell, Markdown, YAML

## Design Philosophy

This structure follows:

1. **Simplicity:** One main script, comprehensive documentation
2. **Transparency:** All code is readable and well-commented
3. **Usability:** Clear paths from beginner to advanced usage
4. **Safety:** Security documentation is prominent
5. **Maintainability:** Modular structure, easy to update

---

**Modeled after:** [APT-Cache-Proxy-Configurator](https://github.com/GrandDay/APT-Cache-Proxy-Configurator)

**Last Updated:** October 22, 2025
