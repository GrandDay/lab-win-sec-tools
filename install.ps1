#Requires -Version 5.1

<#
.SYNOPSIS
    Windows Malware Lab Tools Installer
    
.DESCRIPTION
    Automates the download and installation of Microsoft Sysinternals tools
    (Process Explorer and Autoruns) required for Windows malware analysis labs.
    
    This script:
    - Checks for Windows 10/11 compatibility
    - Elevates to Administrator if needed
    - Creates required directories under C:\Tools\
    - Downloads tools from official Microsoft sources
    - Extracts and prepares tools for immediate use
    
.NOTES
    Author: GrandDay
    License: MIT
    Repository: https://github.com/GrandDay/lab-win-sec-tools
    
.EXAMPLE
    .\install.ps1
    Run the installer locally
    
.EXAMPLE
    powershell -ExecutionPolicy Bypass -NoProfile -Command "Invoke-Expression (Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/GrandDay/lab-win-sec-tools/main/install.ps1').Content"
    Run the installer from the web (one-liner)
#>

[CmdletBinding()]
param()

# Script configuration
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"  # Faster downloads

# Tool definitions
$TOOLS_BASE_DIR = "C:\Tools"
$TOOLS = @(
    @{
        Name = "Process Explorer"
        Url = "https://download.sysinternals.com/files/ProcessExplorer.zip"
        DestDir = "$TOOLS_BASE_DIR\ProcessExplorer"
        ZipFile = "$env:TEMP\ProcessExplorer.zip"
        Executable = "procexp64.exe"
    },
    @{
        Name = "Autoruns"
        Url = "https://download.sysinternals.com/files/Autoruns.zip"
        DestDir = "$TOOLS_BASE_DIR\Autoruns"
        ZipFile = "$env:TEMP\Autoruns.zip"
        Executable = "Autoruns64.exe"
    }
)

#region Helper Functions

function Write-ColorOutput {
    <#
    .SYNOPSIS
        Write colored output to console
    #>
    param(
        [string]$Message,
        [string]$ForegroundColor = "White"
    )
    
    Write-Host $Message -ForegroundColor $ForegroundColor
}

function Write-Step {
    <#
    .SYNOPSIS
        Write a step message with formatting
    #>
    param([string]$Message)
    Write-ColorOutput "`n[*] $Message" -ForegroundColor Cyan
}

function Write-Success {
    <#
    .SYNOPSIS
        Write a success message
    #>
    param([string]$Message)
    Write-ColorOutput "[✓] $Message" -ForegroundColor Green
}

function Write-ErrorMessage {
    <#
    .SYNOPSIS
        Write an error message
    #>
    param([string]$Message)
    Write-ColorOutput "[✗] $Message" -ForegroundColor Red
}

function Write-Warning {
    <#
    .SYNOPSIS
        Write a warning message
    #>
    param([string]$Message)
    Write-ColorOutput "[!] $Message" -ForegroundColor Yellow
}

function Test-Administrator {
    <#
    .SYNOPSIS
        Check if running with administrator privileges
    #>
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Invoke-ElevatedProcess {
    <#
    .SYNOPSIS
        Re-launch the script with elevated privileges
    #>
    Write-Warning "Administrator privileges required. Requesting elevation..."
    
    try {
        $scriptPath = $MyInvocation.PSCommandPath
        if (-not $scriptPath) {
            # Running from web - save to temp and re-execute
            $scriptPath = "$env:TEMP\lab-win-sec-tools-install.ps1"
            $MyInvocation.MyCommand.ScriptBlock.ToString() | Out-File -FilePath $scriptPath -Force
        }
        
        $arguments = "-ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`""
        Start-Process powershell -Verb RunAs -ArgumentList $arguments -Wait
        exit 0
    }
    catch {
        Write-ErrorMessage "Failed to elevate privileges: $_"
        Write-Host "`nPlease run this script as Administrator manually."
        exit 1
    }
}

function Test-WindowsVersion {
    <#
    .SYNOPSIS
        Verify Windows version compatibility
    #>
    Write-Step "Checking Windows version..."
    
    $os = Get-CimInstance Win32_OperatingSystem
    $osVersion = [System.Environment]::OSVersion.Version
    
    # Check for Windows 10 or 11
    if ($osVersion.Major -lt 10) {
        Write-ErrorMessage "This script requires Windows 10 or Windows 11"
        Write-Host "Detected: $($os.Caption) (Version $($osVersion.ToString()))"
        return $false
    }
    
    Write-Success "Windows version compatible: $($os.Caption)"
    return $true
}

function Test-PowerShellVersion {
    <#
    .SYNOPSIS
        Verify PowerShell version
    #>
    Write-Step "Checking PowerShell version..."
    
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-ErrorMessage "PowerShell 5.1 or higher required"
        Write-Host "Detected: PowerShell $($PSVersionTable.PSVersion.ToString())"
        return $false
    }
    
    Write-Success "PowerShell version: $($PSVersionTable.PSVersion.ToString())"
    return $true
}

function New-ToolDirectory {
    <#
    .SYNOPSIS
        Create tool directories if they don't exist
    #>
    param([string]$Path)
    
    if (Test-Path $Path) {
        Write-Success "Directory already exists: $Path"
    }
    else {
        try {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
            Write-Success "Created directory: $Path"
        }
        catch {
            Write-ErrorMessage "Failed to create directory: $Path"
            throw $_
        }
    }
}

function Get-Tool {
    <#
    .SYNOPSIS
        Download a tool from the specified URL
    #>
    param(
        [string]$Url,
        [string]$Destination,
        [string]$ToolName
    )
    
    Write-Step "Downloading $ToolName..."
    Write-Host "    Source: $Url"
    Write-Host "    Destination: $Destination"
    
    try {
        # Use TLS 1.2 or higher
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $Destination)
        
        Write-Success "Downloaded $ToolName successfully"
    }
    catch {
        Write-ErrorMessage "Failed to download $ToolName"
        Write-Host "    Error: $_"
        throw $_
    }
}

function Expand-ToolArchive {
    <#
    .SYNOPSIS
        Extract tool archive to destination directory
    #>
    param(
        [string]$ZipPath,
        [string]$DestinationPath,
        [string]$ToolName
    )
    
    Write-Step "Extracting $ToolName..."
    
    try {
        # Remove existing files if present
        if (Test-Path $DestinationPath) {
            Remove-Item "$DestinationPath\*" -Force -Recurse -ErrorAction SilentlyContinue
        }
        
        Expand-Archive -Path $ZipPath -DestinationPath $DestinationPath -Force
        Write-Success "Extracted $ToolName to $DestinationPath"
    }
    catch {
        Write-ErrorMessage "Failed to extract $ToolName"
        Write-Host "    Error: $_"
        throw $_
    }
}

function Unblock-ToolFile {
    <#
    .SYNOPSIS
        Unblock downloaded files to prevent security warnings
    #>
    param(
        [string]$Path,
        [string]$ToolName
    )
    
    Write-Step "Unblocking $ToolName files..."
    
    try {
        Get-ChildItem -Path $Path -Recurse | Unblock-File
        Write-Success "Unblocked $ToolName files"
    }
    catch {
        Write-Warning "Could not unblock all files (non-critical): $_"
    }
}

function Test-ToolInstallation {
    <#
    .SYNOPSIS
        Verify tool installation
    #>
    param(
        [string]$Path,
        [string]$ExecutableName,
        [string]$ToolName
    )
    
    $exePath = Join-Path $Path $ExecutableName
    
    if (Test-Path $exePath) {
        Write-Success "$ToolName installed successfully: $exePath"
        return $true
    }
    else {
        Write-ErrorMessage "$ToolName installation verification failed"
        return $false
    }
}

function Remove-TempFile {
    <#
    .SYNOPSIS
        Clean up temporary download files
    #>
    Write-Step "Cleaning up temporary files..."
    
    foreach ($tool in $TOOLS) {
        if (Test-Path $tool.ZipFile) {
            Remove-Item $tool.ZipFile -Force -ErrorAction SilentlyContinue
        }
    }
    
    Write-Success "Cleanup complete"
}

function Show-CompletionMessage {
    <#
    .SYNOPSIS
        Display installation completion message
    #>
    Write-ColorOutput "`n========================================" -ForegroundColor Green
    Write-ColorOutput "  Installation Complete!" -ForegroundColor Green
    Write-ColorOutput "========================================`n" -ForegroundColor Green
    
    Write-Host "Installed tools:"
    foreach ($tool in $TOOLS) {
        $exePath = Join-Path $tool.DestDir $tool.Executable
        Write-Host "  • $($tool.Name): $exePath"
    }
    
    Write-ColorOutput "`nNext Steps:" -ForegroundColor Cyan
    Write-Host "1. Launch Process Explorer as Administrator:"
    Write-Host "   Start-Process 'C:\Tools\ProcessExplorer\procexp64.exe' -Verb RunAs`n"
    Write-Host "2. Enable VirusTotal integration in Process Explorer:"
    Write-Host "   Options → VirusTotal.com → Check 'Check VirusTotal.com'`n"
    Write-Host "3. Launch Autoruns as Administrator:"
    Write-Host "   Start-Process 'C:\Tools\Autoruns\Autoruns64.exe' -Verb RunAs`n"
    
    Write-ColorOutput "You're ready to start the lab!" -ForegroundColor Green
}

#endregion

#region Main Installation Logic

function Invoke-Installation {
    <#
    .SYNOPSIS
        Main installation workflow
    #>
    
    Write-ColorOutput "`n========================================" -ForegroundColor Cyan
    Write-ColorOutput "  Windows Malware Lab Tools Installer" -ForegroundColor Cyan
    Write-ColorOutput "========================================`n" -ForegroundColor Cyan
    
    # Pre-flight checks
    if (-not (Test-PowerShellVersion)) {
        exit 1
    }
    
    if (-not (Test-WindowsVersion)) {
        exit 1
    }
    
    # Check administrator privileges
    if (-not (Test-Administrator)) {
        Invoke-ElevatedProcess
        return
    }
    
    Write-Success "Running with Administrator privileges`n"
    
    # Install each tool
    $installSuccess = $true
    
    foreach ($tool in $TOOLS) {
        try {
            Write-ColorOutput "`n--- Installing $($tool.Name) ---" -ForegroundColor Yellow
            
            # Create directory
            New-ToolDirectory -Path $tool.DestDir
            
            # Download
            Get-Tool -Url $tool.Url -Destination $tool.ZipFile -ToolName $tool.Name
            
            # Extract
            Expand-ToolArchive -ZipPath $tool.ZipFile -DestinationPath $tool.DestDir -ToolName $tool.Name
            
            # Unblock files
            Unblock-ToolFile -Path $tool.DestDir -ToolName $tool.Name
            
            # Verify installation
            if (-not (Test-ToolInstallation -Path $tool.DestDir -ExecutableName $tool.Executable -ToolName $tool.Name)) {
                $installSuccess = $false
            }
        }
        catch {
            Write-ErrorMessage "Failed to install $($tool.Name): $_"
            $installSuccess = $false
        }
    }
    
    # Cleanup
    Remove-TempFile
    
    # Final status
    if ($installSuccess) {
        Show-CompletionMessage
    }
    else {
        Write-ColorOutput "`n========================================" -ForegroundColor Red
        Write-ColorOutput "  Installation completed with errors" -ForegroundColor Red
        Write-ColorOutput "========================================`n" -ForegroundColor Red
        Write-Host "Please check the error messages above and try again."
        Write-Host "For help, visit: https://github.com/GrandDay/lab-win-sec-tools/issues`n"
        exit 1
    }
}

#endregion

# Run installation
try {
    Invoke-Installation
}
catch {
    Write-ErrorMessage "Installation failed: $_"
    Write-Host "`nFor troubleshooting help, visit:"
    Write-Host "https://github.com/GrandDay/lab-win-sec-tools/blob/main/docs/GUIDE.md`n"
    exit 1
}
