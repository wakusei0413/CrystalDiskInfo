# 快速发布指南 / Quick Release Guide

[English](#english) | [中文](#chinese)

---

## <a id="chinese"></a>中文

### 如何发布便携版本到 GitHub Release

#### 方法 1: 使用 Git 标签（推荐）

这是最简单的方法，只需创建并推送一个版本标签：

```bash
# 创建版本标签
git tag -a v9.0.0-RC2 -m "Release version 9.0.0 RC2"

# 推送标签到 GitHub
git push origin v9.0.0-RC2
```

GitHub Actions 将自动：
1. ✅ 编译 Win32 (32位) 版本
2. ✅ 编译 x64 (64位) 版本  
3. ✅ 打包成便携 ZIP 文件
4. ✅ 创建 GitHub Release 并上传文件

#### 方法 2: 手动触发工作流

1. 访问 GitHub 仓库的 **Actions** 标签页
2. 选择 **"Build and Release Windows Portable"** 工作流
3. 点击 **"Run workflow"** 按钮
4. 输入版本号（例如：`9.0.0-RC2`）
5. 点击绿色的 **"Run workflow"** 按钮

#### 方法 3: 使用命令行工具

如果安装了 GitHub CLI (`gh`)：

```bash
./scripts/trigger-release.sh 9.0.0-RC2
```

### 发布的内容

每次发布都会创建两个便携版本：

- 📦 **CrystalDiskInfo-Win32-Release-portable.zip**
  - 适用于 32位 Windows 系统
  - 包含 `DiskInfo32.exe`

- 📦 **CrystalDiskInfo-x64-Release-portable.zip**
  - 适用于 64位 Windows 系统  
  - 包含 `DiskInfo64.exe`

### 系统要求

✅ Windows 10 版本 1803（2018年4月更新）及更高版本  
✅ Windows 11

### 查看发布进度

```bash
# 查看工作流运行列表
gh run list --workflow=build-release.yml

# 实时监控当前运行
gh run watch

# 在浏览器中查看
gh workflow view build-release.yml --web
```

### 常见问题

**Q: 发布需要多长时间？**  
A: 通常 5-10 分钟，包括编译和打包两个平台。

**Q: 如何删除错误的发布？**  
A: 在 GitHub 网页上进入 Releases 页面，找到对应版本并删除。

**Q: 可以修改发布说明吗？**  
A: 可以！在 GitHub Releases 页面点击 "Edit" 按钮。

---

## <a id="english"></a>English

### How to Release Portable Versions to GitHub Release

#### Method 1: Using Git Tags (Recommended)

This is the simplest method - just create and push a version tag:

```bash
# Create version tag
git tag -a v9.0.0-RC2 -m "Release version 9.0.0 RC2"

# Push tag to GitHub
git push origin v9.0.0-RC2
```

GitHub Actions will automatically:
1. ✅ Build Win32 (32-bit) version
2. ✅ Build x64 (64-bit) version
3. ✅ Package as portable ZIP files
4. ✅ Create GitHub Release and upload files

#### Method 2: Manual Workflow Trigger

1. Go to the **Actions** tab in your GitHub repository
2. Select **"Build and Release Windows Portable"** workflow
3. Click **"Run workflow"** button
4. Enter the version number (e.g., `9.0.0-RC2`)
5. Click the green **"Run workflow"** button

#### Method 3: Using Command Line Tool

If you have GitHub CLI (`gh`) installed:

```bash
./scripts/trigger-release.sh 9.0.0-RC2
```

### What Gets Released

Each release creates two portable versions:

- 📦 **CrystalDiskInfo-Win32-Release-portable.zip**
  - For 32-bit Windows systems
  - Contains `DiskInfo32.exe`

- 📦 **CrystalDiskInfo-x64-Release-portable.zip**
  - For 64-bit Windows systems
  - Contains `DiskInfo64.exe`

### System Requirements

✅ Windows 10 Version 1803 (April 2018 Update) and later  
✅ Windows 11

### Check Release Progress

```bash
# View workflow run list
gh run list --workflow=build-release.yml

# Watch current run in real-time
gh run watch

# View in browser
gh workflow view build-release.yml --web
```

### FAQ

**Q: How long does a release take?**  
A: Usually 5-10 minutes, including building and packaging both platforms.

**Q: How to delete a wrong release?**  
A: Go to the Releases page on GitHub, find the version and delete it.

**Q: Can I edit the release notes?**  
A: Yes! Click the "Edit" button on the GitHub Releases page.

---

## More Information

For detailed build instructions and troubleshooting, see:
- [BUILD_RELEASE.md](BUILD_RELEASE.md) - Complete build documentation
- [README.md](README.md) - Project overview and build instructions

## License

CrystalDiskInfo is released under the MIT License.
