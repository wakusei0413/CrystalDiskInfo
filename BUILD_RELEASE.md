# Building and Releasing CrystalDiskInfo for Windows 10 1803+

This document describes how to build and release portable versions of CrystalDiskInfo that are optimized for Windows 10 Version 1803 (April 2018 Update) and later.

## Automated Build and Release

The project includes a GitHub Actions workflow that automatically builds and releases portable versions of CrystalDiskInfo.

### Triggering a Release

#### Method 1: Using Git Tags (Recommended)

1. Create and push a version tag:
   ```bash
   git tag -a v9.0.0-RC2 -m "Release version 9.0.0 RC2"
   git push origin v9.0.0-RC2
   ```

2. The workflow will automatically:
   - Build Win32 (x86) and x64 versions
   - Package them as portable ZIP files
   - Create a GitHub release with the artifacts

#### Method 2: Manual Workflow Dispatch

1. Go to the GitHub Actions tab in your repository
2. Select "Build and Release Windows Portable" workflow
3. Click "Run workflow"
4. Enter the version number (e.g., `9.0.0-RC2`)
5. Click "Run workflow"

The workflow will build and release the portable versions.

## Build Configurations

The automated build creates portable packages for:

- **Win32 (x86)**: 32-bit Windows
  - Output: `DiskInfo32.exe`
  - Package: `CrystalDiskInfo-Win32-Release-portable.zip`

- **x64**: 64-bit Windows
  - Output: `DiskInfo64.exe`
  - Package: `CrystalDiskInfo-x64-Release-portable.zip`

## Platform Support

### Windows Version Support

The builds are configured to support:
- ✅ Windows 10 Version 1803 (April 2018 Update) and later
- ✅ Windows 11

### Compiler Configuration

- Platform Toolset: v142 (Visual Studio 2019)
- Windows SDK: 10.0
- Runtime Library: Static MFC linkage
- Minimum Subsystem Version: 5.01 (maintains broad compatibility)

## Manual Building

If you need to build manually on a Windows machine:

### Prerequisites

- Visual Studio 2019 or later with:
  - Desktop development with C++
  - Windows 10 SDK
  - MFC and ATL support

### Build Steps

1. Open `DiskInfo.sln` in Visual Studio

2. Select the desired configuration and platform:
   - Configuration: `Release`
   - Platform: `Win32` or `x64`

3. Build the solution:
   - Menu: Build → Build Solution
   - Or press `Ctrl+Shift+B`

4. The executable will be output to `..\Rugenia\`:
   - Win32: `..\Rugenia\DiskInfo32.exe`
   - x64: `..\Rugenia\DiskInfo64.exe`

### Creating Portable Package

After building, run the packaging script:

```powershell
# For x64
.\scripts\package-portable.ps1 -Configuration Release -Platform x64

# For Win32
.\scripts\package-portable.ps1 -Configuration Release -Platform Win32
```

The portable packages will be created in the `dist` directory:
- Extracted files: `dist/portable/<Platform>/<Configuration>/`
- ZIP archive: `dist/CrystalDiskInfo-<Platform>-<Configuration>-portable.zip`

## Portable Package Contents

Each portable package includes:

- Executable file (`DiskInfo32.exe` or `DiskInfo64.exe`)
- Language files (`Language/`)
- Resource folders (`res/`, `resK/`, `resN/`, `resS/`)
- Helper libraries (`Priscilla/`)
- Message catalog (`MSG00409.bin`)
- License and documentation (`LICENSE.txt`, `README.md`, `README.ja.md`)

## Additional Resources

To enable full theme and language support, users should download the CdiResource pack from:
- [CrystalDiskInfo Official Website](https://crystalmark.info/redirect.php?product=CrystalDiskInfo)

Extract the CdiResource folder to the same directory as the executable.

## Troubleshooting

### Build Fails with SDK Errors

Ensure you have Windows 10 SDK installed. The project targets SDK version 10.0.

### Output Directory Not Found

The project outputs to `..\Rugenia\` (one level above the project directory). Ensure this directory exists or the build will create it automatically.

### Packaging Script Can't Find Executable

The packaging script searches several common output locations. If it fails:
1. Check that the build completed successfully
2. Verify the executable exists in `..\Rugenia\`
3. Ensure you're using the correct Platform name (`Win32` or `x64`, case-sensitive)

## Release Checklist

Before creating a release:

- [ ] Update version in `stdafx.h` (`PRODUCT_VERSION`)
- [ ] Update release date in `stdafx.h` (`PRODUCT_RELEASE`)
- [ ] Test build for both Win32 and x64
- [ ] Verify the application runs on Windows 10 1803+
- [ ] Update CHANGELOG or release notes if applicable
- [ ] Create and push version tag
- [ ] Verify GitHub Actions workflow completes successfully
- [ ] Test downloaded release packages

## License

CrystalDiskInfo is released under the MIT License.
See [LICENSE.txt](LICENSE.txt) for details.
