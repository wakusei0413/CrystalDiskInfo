<#!
.SYNOPSIS
    Packages an existing CrystalDiskInfo build into a portable ZIP archive.

.DESCRIPTION
    Collects the compiled DiskInfo.exe along with the resource folders that the
    application expects at runtime and produces a ready-to-distribute portable
    bundle. The script assumes that the solution has already been built with
    Visual Studio / MSBuild.

.EXAMPLE
    PS> .\scripts\package-portable.ps1 -Configuration Release -Platform x64

    Creates dist\portable\x64\Release containing the portable payload and a
    dist\CrystalDiskInfo-x64-Release-portable.zip archive.

.PARAMETER Configuration
    Build configuration that was compiled (e.g. Release, ReleaseShizuku).

.PARAMETER Platform
    Build platform that was compiled (e.g. x64, Win32).

.PARAMETER OutputRoot
    Optional root directory for generated artifacts. Defaults to <repo>/dist.

.PARAMETER ResourceOverride
    Optional path to an extracted CdiResource folder downloaded from the
    CrystalDiskInfo website. When supplied, its contents are copied into the
    portable package under a CdiResource directory.
#>
[CmdletBinding()]
param(
    [string]$Configuration = "Release",
    [string]$Platform = "x64",
    [string]$OutputRoot,
    [string]$ResourceOverride
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command -Name 'Compress-Archive' -ErrorAction SilentlyContinue)) {
    throw "Compress-Archive cmdlet not available. Please run this script with Windows PowerShell 5.0 or newer (or PowerShell Core)."
}

$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $OutputRoot) {
    $OutputRoot = Join-Path -Path $repoRoot -ChildPath 'dist'
}

$exeName = 'DiskInfo.exe'
$probableOutputs = @(
    [System.IO.Path]::Combine($repoRoot, $Platform, $Configuration, $exeName),
    [System.IO.Path]::Combine($repoRoot, $Configuration, $exeName),
    [System.IO.Path]::Combine($repoRoot, 'Win32', $Configuration, $exeName),
    [System.IO.Path]::Combine($repoRoot, 'x64', $Configuration, $exeName),
    [System.IO.Path]::Combine($repoRoot, 'Bin', $Platform, $Configuration, $exeName),
    [System.IO.Path]::Combine($repoRoot, 'Bin', $Configuration, $exeName),
    [System.IO.Path]::Combine($repoRoot, 'build', $Platform, $Configuration, $exeName),
    [System.IO.Path]::Combine($repoRoot, 'out', $Platform, $Configuration, $exeName)
)

$exePath = $null
foreach ($candidate in $probableOutputs) {
    if (Test-Path $candidate) {
        $exePath = $candidate
        break
    }
}

if (-not $exePath) {
    throw "Unable to locate '$exeName'. Build the solution for configuration '$Configuration' and platform '$Platform' before running this script."
}

$buildDir = Split-Path -Parent $exePath
$portableRoot = Join-Path $OutputRoot "portable/$Platform/$Configuration"

if (Test-Path $portableRoot) {
    Remove-Item -Path $portableRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $portableRoot -Force | Out-Null

Write-Host "Using build output: $buildDir" -ForegroundColor Cyan

# Copy core binaries (skip debug symbols and libs).
Get-ChildItem -Path $buildDir -File |
    Where-Object { $_.Extension -notin @('.pdb', '.lib', '.exp', '.ilk') } |
    ForEach-Object {
        Copy-Item -Path $_.FullName -Destination (Join-Path $portableRoot $_.Name) -Force
    }

$itemsToCopy = @(
    @{ Path = 'Language'; Destination = 'Language'; Type = 'Directory' },
    @{ Path = 'res'; Destination = 'res'; Type = 'Directory' },
    @{ Path = 'resK'; Destination = 'resK'; Type = 'Directory' },
    @{ Path = 'resN'; Destination = 'resN'; Type = 'Directory' },
    @{ Path = 'resS'; Destination = 'resS'; Type = 'Directory' },
    @{ Path = 'Priscilla'; Destination = 'Priscilla'; Type = 'Directory' },
    @{ Path = 'MSG00409.bin'; Destination = 'MSG00409.bin'; Type = 'File' },
    @{ Path = 'LICENSE.txt'; Destination = 'LICENSE.txt'; Type = 'File' },
    @{ Path = 'README.md'; Destination = 'README.md'; Type = 'File' },
    @{ Path = 'README.ja.md'; Destination = 'README.ja.md'; Type = 'File' }
)

foreach ($item in $itemsToCopy) {
    $source = Join-Path $repoRoot $item.Path
    if (-not (Test-Path $source)) {
        Write-Warning "Skipping missing item: $($item.Path)"
        continue
    }

    $destination = Join-Path $portableRoot $item.Destination
    if ($item.Type -eq 'Directory') {
        Copy-Item -Path $source -Destination $destination -Recurse -Force
    }
    else {
        Copy-Item -Path $source -Destination $destination -Force
    }
}

if ($ResourceOverride) {
    if (-not (Test-Path $ResourceOverride)) {
        throw "ResourceOverride path '$ResourceOverride' does not exist."
    }
    $resourceDestination = Join-Path $portableRoot 'CdiResource'
    Copy-Item -Path $ResourceOverride -Destination $resourceDestination -Recurse -Force
}

$zipName = "CrystalDiskInfo-$Platform-$Configuration-portable.zip"
$zipPath = Join-Path $OutputRoot $zipName
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}

Write-Host "Creating archive: $zipPath" -ForegroundColor Cyan
Compress-Archive -Path ([System.IO.Path]::Combine($portableRoot, '*')) -DestinationPath $zipPath -Force

Write-Host "Portable package created at $portableRoot" -ForegroundColor Green
Write-Host "ZIP archive created at $zipPath" -ForegroundColor Green
