# 🚀 CrystalDiskInfo 发布系统 / Release System

## 一键发布 / One-Click Release

```bash
./scripts/create-release-tag.sh 9.0.0-RC2
```

就这么简单！GitHub Actions 会自动构建并发布 Win32 和 x64 便携版本。

---

## 📖 文档索引 / Documentation Index

| 文档 / Document | 说明 / Description |
|----------------|-------------------|
| [HOW_TO_RELEASE.md](HOW_TO_RELEASE.md) | **完整发布指南** - 从准备到发布的详细步骤 |
| [QUICK_RELEASE.md](QUICK_RELEASE.md) | **快速参考** - 中英双语快速发布指南 |
| [BUILD_RELEASE.md](BUILD_RELEASE.md) | **构建文档** - 技术细节和本地构建说明 |
| [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) | **实现总结** - 系统架构和技术说明 |

---

## 🎯 三种发布方式 / Three Release Methods

### 1️⃣ 使用脚本（最简单）/ Using Script (Easiest)

```bash
# 正式发布
./scripts/create-release-tag.sh 9.0.0-RC2

# 测试发布
./scripts/create-release-tag.sh 9.0.0-test --test
```

### 2️⃣ 手动标签 / Manual Tag

```bash
git tag -a v9.0.0-RC2 -m "Release version 9.0.0 RC2"
git push origin v9.0.0-RC2
```

### 3️⃣ GitHub 网页 / GitHub Web UI

1. 访问 **Actions** 页面
2. 运行 **"Build and Release Windows Portable"** 工作流
3. 输入版本号

---

## 📦 发布产物 / Release Artifacts

每次发布都包含：

- ✅ `CrystalDiskInfo-Win32-Release-portable.zip` (32位版本)
- ✅ `CrystalDiskInfo-x64-Release-portable.zip` (64位版本)

支持系统 / Supported Systems:
- Windows 10 Version 1803+
- Windows 11

---

## 🛠️ 本地构建 / Local Build

如果需要在 Windows 机器上本地构建：

```batch
# 一键构建和打包
scripts\build-local.bat
```

或手动打包：

```powershell
# Win32
.\scripts\package-portable.ps1 -Configuration Release -Platform Win32

# x64
.\scripts\package-portable.ps1 -Configuration Release -Platform x64
```

---

## 🔧 工具脚本 / Utility Scripts

| 脚本 / Script | 用途 / Purpose |
|--------------|---------------|
| `scripts/create-release-tag.sh` | 创建和推送发布标签 |
| `scripts/trigger-release.sh` | 使用 GitHub CLI 触发工作流 |
| `scripts/build-local.bat` | Windows 本地构建 |
| `scripts/package-portable.ps1` | 打包便携版本 |

---

## 📋 快速检查清单 / Quick Checklist

发布前确认：

- [ ] 更新版本号 (`stdafx.h` 中的 `PRODUCT_VERSION`)
- [ ] 更新发布日期 (`stdafx.h` 中的 `PRODUCT_RELEASE`)
- [ ] 提交所有代码更改
- [ ] 运行发布脚本或推送标签
- [ ] 等待 GitHub Actions 完成（5-10分钟）
- [ ] 验证 Releases 页面的发布内容

---

## 💡 提示 / Tips

### 测试发布

在正式发布前，建议先测试：

```bash
./scripts/create-release-tag.sh 9.0.0-test --test
```

测试完成后删除：

```bash
# 删除本地标签
git tag -d v9.0.0-test

# 删除远程标签
git push origin :refs/tags/v9.0.0-test
```

### 查看构建进度

```bash
# 使用 GitHub CLI
gh run watch

# 或在浏览器中查看
open https://github.com/wakusei0413/CrystalDiskInfo/actions
```

---

## ❓ 遇到问题？ / Need Help?

1. 查看 [HOW_TO_RELEASE.md](HOW_TO_RELEASE.md) 中的故障排除部分
2. 查看 [FAQ](HOW_TO_RELEASE.md#-常见问题--faq)
3. 查看 GitHub Actions 运行日志
4. 创建 Issue

---

## 🎉 就是这么简单！ / That's It!

现在您可以轻松地发布 CrystalDiskInfo 的便携版本到 GitHub Releases。

**祝发布顺利！🚀**

---

## 📚 更多资源 / More Resources

- [GitHub Actions 文档](https://docs.github.com/actions)
- [CrystalDiskInfo 官网](https://crystalmark.info/)
- [项目 LICENSE](LICENSE.txt)
