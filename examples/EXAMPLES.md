# Examples and Templates

This directory contains example configurations and usage templates for advanced users.

## Custom Installation Path

If you want to install to a different location than `C:\Tools\`, you can modify the script:

### Example: Install to D:\SecurityTools\

```powershell
# Create a copy of install.ps1
Copy-Item install.ps1 install-custom.ps1

# Edit install-custom.ps1 and change this line:
# $TOOLS_BASE_DIR = "C:\Tools"
# to:
# $TOOLS_BASE_DIR = "D:\SecurityTools"

# Run the custom installer
.\install-custom.ps1
```

## Silent Installation (Unattended)

For automated deployments or lab setup scripts:

```powershell
# Create a wrapper script: install-silent.ps1
[CmdletBinding()]
param()

# Suppress interactive output
$ProgressPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'

# Run installer
& .\install.ps1 2>&1 | Out-Null

# Check exit code
if ($LASTEXITCODE -eq 0) {
    Write-Output "SUCCESS: Tools installed"
    exit 0
} else {
    Write-Output "ERROR: Installation failed"
    exit 1
}
```

## Batch Installation Script

To install on multiple machines:

```powershell
# install-multiple.ps1
$computers = @(
    "LAB-PC-01",
    "LAB-PC-02",
    "LAB-PC-03"
)

$credential = Get-Credential -Message "Enter admin credentials"

foreach ($computer in $computers) {
    Write-Host "Installing on $computer..."
    
    Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {
        # Download and run installer
        $script = Invoke-WebRequest -UseBasicParsing `
            'https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1'
        Invoke-Expression $script.Content
    }
}
```

## Verify Installation

```powershell
# verify-install.ps1
$tools = @(
    @{
        Name = "Process Explorer"
        Path = "C:\Tools\ProcessExplorer\procexp64.exe"
    },
    @{
        Name = "Autoruns"
        Path = "C:\Tools\Autoruns\Autoruns64.exe"
    }
)

$allPresent = $true

foreach ($tool in $tools) {
    if (Test-Path $tool.Path) {
        Write-Host "[OK] $($tool.Name) found at $($tool.Path)" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] $($tool.Name) not found at $($tool.Path)" -ForegroundColor Red
        $allPresent = $false
    }
}

if ($allPresent) {
    Write-Host "`nAll tools installed successfully!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`nSome tools are missing. Please re-run the installer." -ForegroundColor Red
    exit 1
}
```

## Launch Tools Script

Quick launcher for both tools:

```powershell
# launch-tools.ps1
param(
    [Parameter()]
    [ValidateSet('ProcessExplorer', 'Autoruns', 'Both')]
    [string]$Tool = 'Both'
)

$procExp = "C:\Tools\ProcessExplorer\procexp64.exe"
$autoruns = "C:\Tools\Autoruns\Autoruns64.exe"

switch ($Tool) {
    'ProcessExplorer' {
        Start-Process $procExp -Verb RunAs
    }
    'Autoruns' {
        Start-Process $autoruns -Verb RunAs
    }
    'Both' {
        Start-Process $procExp -Verb RunAs
        Start-Sleep -Seconds 2
        Start-Process $autoruns -Verb RunAs
    }
}
```

### Usage

```powershell
# Launch Process Explorer only
.\launch-tools.ps1 -Tool ProcessExplorer

# Launch Autoruns only
.\launch-tools.ps1 -Tool Autoruns

# Launch both (default)
.\launch-tools.ps1
```

## Uninstall Script

```powershell
# uninstall.ps1
[CmdletBinding()]
param(
    [switch]$Force
)

$toolsDir = "C:\Tools"

Write-Host "Windows Malware Lab Tools Uninstaller" -ForegroundColor Cyan
Write-Host "======================================`n"

# Check if tools directory exists
if (-not (Test-Path $toolsDir)) {
    Write-Host "Tools directory not found: $toolsDir" -ForegroundColor Yellow
    Write-Host "Nothing to uninstall."
    exit 0
}

# Confirm unless -Force
if (-not $Force) {
    $confirm = Read-Host "Remove all tools from $toolsDir? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "Uninstall cancelled."
        exit 0
    }
}

# Remove tools
try {
    Write-Host "Removing Process Explorer..." -ForegroundColor Yellow
    Remove-Item "$toolsDir\ProcessExplorer" -Recurse -Force -ErrorAction Stop
    Write-Host "[OK] Process Explorer removed" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to remove Process Explorer: $_" -ForegroundColor Red
}

try {
    Write-Host "Removing Autoruns..." -ForegroundColor Yellow
    Remove-Item "$toolsDir\Autoruns" -Recurse -Force -ErrorAction Stop
    Write-Host "[OK] Autoruns removed" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to remove Autoruns: $_" -ForegroundColor Red
}

# Remove parent directory if empty
if ((Get-ChildItem $toolsDir).Count -eq 0) {
    Write-Host "Removing empty tools directory..." -ForegroundColor Yellow
    Remove-Item $toolsDir -Force
    Write-Host "[OK] Tools directory removed" -ForegroundColor Green
}

Write-Host "`nUninstall complete!" -ForegroundColor Green
```

### Usage

```powershell
# Uninstall with confirmation
.\uninstall.ps1

# Uninstall without confirmation
.\uninstall.ps1 -Force
```

## Update Script

Check for and install newer versions:

```powershell
# update-tools.ps1
Write-Host "Checking for updates..." -ForegroundColor Cyan

# Just re-run the installer (it downloads latest versions)
$script = Invoke-WebRequest -UseBasicParsing `
    'https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1'

Write-Host "Updating to latest versions..." -ForegroundColor Yellow
Invoke-Expression $script.Content
```

## Integration with Task Scheduler

Schedule automatic updates (use with caution in lab environments):

```powershell
# schedule-update.ps1
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -File C:\Scripts\update-tools.ps1"

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 3am

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

Register-ScheduledTask -TaskName "Update Malware Lab Tools" `
    -Action $action -Trigger $trigger -Principal $principal `
    -Description "Weekly update of security analysis tools"
```

## Adding Additional Tools

Template for adding more Sysinternals tools:

```powershell
# In install.ps1, add to $TOOLS array:
@{
    Name = "TCPView"
    Url = "https://download.sysinternals.com/files/TCPView.zip"
    DestDir = "$TOOLS_BASE_DIR\TCPView"
    ZipFile = "$env:TEMP\TCPView.zip"
    Executable = "Tcpview.exe"
}
```

---

**Note:** These are examples only. Test thoroughly in a lab environment before using in production.
