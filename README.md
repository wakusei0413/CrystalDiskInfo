English | [Japanese](./README.ja.md)

# CrystalDiskInfo

## Overview
CrystalDiskInfo is a disk information tool.

CrystalDiskInfo supports:
- PATA drives
- SATA drives

Partially supports:
- USB drives
- RAID controllers (IRST)
- NVMe drives
- RAID controllers (Intel(R) VROC)
- RAID controllers (AMD-RAIDXpert2 *Requires AMD_RC2t7*)
- USB RAID controllers (JMicron JMS56X,JMB39X)

## Notification
This repository does not include resource files, so please download them from below.
- [Download for resource files](https://crystalmark.info/redirect.php?product=CrystalDiskInfo)

## Building

### Quick Start (Windows)

For automated building on Windows:
```batch
scripts\build-local.bat
```

This will build both Win32 and x64 Release versions and create portable packages.

### Manual Build

Open *DiskInfo.sln* and build.

### Portable bundle

After building the desired configuration, you can create a portable ZIP archive by running the helper script:

```powershell
# For x64
powershell -ExecutionPolicy Bypass -File scripts/package-portable.ps1 -Configuration Release -Platform x64

# For Win32
powershell -ExecutionPolicy Bypass -File scripts/package-portable.ps1 -Configuration Release -Platform Win32
```

The script copies the freshly built executable together with the language and resource folders into `dist/portable/<Platform>/<Configuration>` and generates `dist/CrystalDiskInfo-<Platform>-<Configuration>-portable.zip`. Use the optional `-ResourceOverride` parameter to point to the extracted *CdiResource* directory if you want those assets bundled as well.

### Automated Release (CI/CD)

This repository includes a GitHub Actions workflow for automated building and releasing:

- **Automatic**: Push a version tag (e.g., `v9.0.0-RC2`) to trigger a release
- **Manual**: Use GitHub Actions web UI to manually trigger a release
- **CLI**: Run `./scripts/trigger-release.sh <version>` (requires GitHub CLI)

See [BUILD_RELEASE.md](BUILD_RELEASE.md) for detailed instructions.

### Note
Copy *CdiResource* folder in the [Download CdiResource](https://crystalmark.info/redirect.php?product=CrystalDiskInfo) to *../Rugenia* folder created in the build. If the *CdiResource* folder does not exist at runtime, the app displays "*Not Found 'Graph.html'*".

[AMD_RC2t7](https://thilmera.com/project/AMD_RC2t7/) is a library that provides a function to acquire SMART information (SATA/NVMe) of AMD RAID, it developed by [Gakuto Matsumura](https://twitter.com/thilmera7).

## Project Page
- [Crystal Dew World](https://crystalmark.info/)

## License
The MIT License
- [Japanese version](https://crystalmark.info/ja/software/crystaldiskinfo/crystaldiskinfo-license/)
- [English version](https://crystalmark.info/en/software/crystaldiskinfo/crystaldiskinfo-license/)
