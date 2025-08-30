# RustDesk Custom Build Instructions

## 概述

这个项目是RustDesk的自定义版本，添加了额外的命令行参数支持，用于控制远程桌面的显示行为。

## 新增功能

### 命令行参数

1. **`--fullscreen`**: 控制全屏模式
   - `--fullscreen=true`: 设置为全屏模式
   - `--fullscreen=false`: 设置为窗口模式
   - 无参数时：保持默认行为

2. **`--collapse_toolbar`**: 控制工具栏显示
   - `--collapse_toolbar=true`: 远程会话工具栏默认隐藏
   - `--collapse_toolbar=false`: 远程会话工具栏展开
   - 无参数时：保持默认行为

3. **`--desktop_scaling`**: 控制桌面缩放
   - `--desktop_scaling=true`: 远程桌面适应窗口
   - `--desktop_scaling=false`: 远程桌面保持原始尺寸
   - 无参数时：保持默认行为

## 使用示例

```bash
# 全屏模式启动，工具栏隐藏
rustdesk.exe --fullscreen=true --collapse_toolbar=true

# 窗口模式启动，桌面适应窗口
rustdesk.exe --fullscreen=false --desktop_scaling=true

# 全屏模式启动，保持原始桌面尺寸
rustdesk.exe --fullscreen=true --desktop_scaling=false
```

## GitHub Actions 自动构建

### 触发构建

1. **自动触发**: 当代码推送到 `master` 或 `main` 分支时，GitHub Actions会自动开始构建
2. **手动触发**: 在GitHub仓库页面，进入 "Actions" 标签页，选择 "Build Windows x64 RustDesk" 工作流，点击 "Run workflow"

### 构建过程

构建过程包含以下步骤：

1. **生成桥接文件** (Ubuntu环境)
   - 安装Flutter
   - 生成必要的桥接文件

2. **编译Windows版本** (Windows 2022环境)
   - 安装LLVM和Clang
   - 安装Flutter和自定义引擎
   - 安装Rust工具链
   - 设置vcpkg依赖
   - 编译RustDesk
   - 打包生成文件

### 获取构建结果

构建完成后，您可以通过以下方式获取结果：

1. **下载Artifacts**:
   - 在GitHub Actions页面找到成功的构建
   - 点击构建记录
   - 在页面底部找到 "Artifacts" 部分
   - 下载 `RustDesk-Windows-x64` (单个exe文件) 或 `RustDesk-Windows-x64-Package` (完整包)

2. **Release版本**:
   - 如果构建成功且推送到master分支，会自动创建GitHub Release
   - 在仓库的 "Releases" 页面可以找到发布的版本

## 本地构建

如果您想在本地构建，请参考以下步骤：

### 环境要求

- Windows 10/11
- Visual Studio 2019/2022 with C++ workload
- Python 3.8+
- Rust 1.75
- Flutter 3.24.5
- vcpkg

### 构建步骤

1. **克隆仓库**:
   ```bash
   git clone https://github.com/patton88/RustDesk_custom01.git
   cd RustDesk_custom01
   ```

2. **安装依赖**:
   ```bash
   # 安装Rust
   rustup install 1.75
   rustup default 1.75
   
   # 安装Flutter
   flutter install 3.24.5
   flutter doctor
   
   # 设置vcpkg
   git clone https://github.com/Microsoft/vcpkg.git
   cd vcpkg
   ./bootstrap-vcpkg.bat
   ./vcpkg install --triplet=x64-windows-static
   ```

3. **生成桥接文件**:
   ```bash
   cd flutter
   flutter pub get
   dart run build_runner build
   ```

4. **编译**:
   ```bash
   python3 build.py --portable --hwcodec --flutter --vram --skip-portable-pack
   ```

## 修改说明

### 修改的文件

1. `flutter/lib/web/bridge.dart` - 添加命令行参数处理
2. `flutter/lib/desktop/pages/remote_page.dart` - 实现UI控制逻辑
3. `src/core_main.rs` - 解析命令行参数
4. `src/ipc.rs` - 处理参数传递
5. `src/ui_interface.rs` - 定义UI接口

### 技术细节

- 使用Flutter的FFI机制与Rust代码交互
- 通过IPC机制在进程间传递参数
- 支持动态UI状态切换
- 保持向后兼容性

## 故障排除

### 常见问题

1. **构建失败**: 检查GitHub Actions日志，确保所有依赖都正确安装
2. **参数不生效**: 确保使用正确的参数格式，布尔值必须为 `true` 或 `false`
3. **UI显示异常**: 检查Flutter版本兼容性

### 获取帮助

如果遇到问题，请：
1. 查看GitHub Actions构建日志
2. 检查Issues页面是否有类似问题
3. 创建新的Issue描述问题

## 许可证

本项目基于RustDesk的许可证，请参考原始项目的LICENSE文件。
