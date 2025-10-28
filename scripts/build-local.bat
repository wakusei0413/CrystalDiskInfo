@echo off
REM Local build script for CrystalDiskInfo
REM Builds Release configuration for both Win32 and x64 platforms

setlocal enabledelayedexpansion

echo ==========================================
echo CrystalDiskInfo Local Build Script
echo ==========================================
echo.

REM Check for Visual Studio
set VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist %VSWHERE% (
    echo ERROR: Visual Studio installer not found.
    echo Please install Visual Studio 2019 or later with C++ desktop development tools.
    goto :error
)

REM Find MSBuild
for /f "usebackq delims=" %%i in (`%VSWHERE% -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do (
    set MSBUILD=%%i
)

if not exist "!MSBUILD!" (
    echo ERROR: MSBuild not found.
    echo Please install Visual Studio with C++ desktop development tools.
    goto :error
)

echo Found MSBuild: !MSBUILD!
echo.

REM Build Win32 Release
echo ==========================================
echo Building Win32 Release...
echo ==========================================
echo.

"!MSBUILD!" DiskInfo.sln /p:Configuration=Release /p:Platform=Win32 /m /v:minimal
if errorlevel 1 (
    echo ERROR: Win32 build failed.
    goto :error
)

echo.
echo Win32 build completed successfully!
echo.

REM Build x64 Release
echo ==========================================
echo Building x64 Release...
echo ==========================================
echo.

"!MSBUILD!" DiskInfo.sln /p:Configuration=Release /p:Platform=x64 /m /v:minimal
if errorlevel 1 (
    echo ERROR: x64 build failed.
    goto :error
)

echo.
echo x64 build completed successfully!
echo.

REM Package portable versions
echo ==========================================
echo Packaging portable versions...
echo ==========================================
echo.

echo Packaging Win32...
powershell -ExecutionPolicy Bypass -File scripts\package-portable.ps1 -Configuration Release -Platform Win32
if errorlevel 1 (
    echo WARNING: Win32 packaging failed.
) else (
    echo Win32 portable package created successfully!
)

echo.
echo Packaging x64...
powershell -ExecutionPolicy Bypass -File scripts\package-portable.ps1 -Configuration Release -Platform x64
if errorlevel 1 (
    echo WARNING: x64 packaging failed.
) else (
    echo x64 portable package created successfully!
)

echo.
echo ==========================================
echo Build Complete!
echo ==========================================
echo.
echo Output files:
echo   Win32: ..\Rugenia\DiskInfo32.exe
echo   x64:   ..\Rugenia\DiskInfo64.exe
echo.
echo Portable packages:
echo   dist\CrystalDiskInfo-Win32-Release-portable.zip
echo   dist\CrystalDiskInfo-x64-Release-portable.zip
echo.

goto :end

:error
echo.
echo Build failed with errors.
exit /b 1

:end
endlocal
