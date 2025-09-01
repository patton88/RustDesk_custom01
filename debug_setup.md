# RustDesk调试环境设置指南

## 🛠️ 开发环境搭建

### 1. VS Code + 扩展安装

#### 必需扩展
- `rust-analyzer` - Rust语言支持和智能提示
- `CodeLLDB` - Rust调试器（支持断点调试）
- `Flutter` - Flutter开发支持
- `Dart` - Dart语言支持

#### 推荐扩展  
- `Error Lens` - 行内错误提示
- `GitLens` - Git增强功能
- `Better TOML` - TOML文件支持
- `Thunder Client` - API测试工具

### 2. 系统环境配置

#### Windows环境变量
```powershell
# 设置Rust环境变量
setx RUST_BACKTRACE 1
setx RUST_LOG "debug,rustdesk=trace"
setx RUSTFLAGS "-C debuginfo=2"

# 设置Flutter环境变量
setx FLUTTER_ROOT "C:\flutter"  # 根据实际路径调整
```

#### 开发工具版本
- Rust: 1.75+
- Flutter: 3.24.5
- LLDB: 最新版本
- Git: 2.40+

## 🔧 调试配置说明

### Rust调试配置
已配置的调试模式：
1. **Debug RustDesk (Rust)** - 基础调试模式
2. **Debug RustDesk with Connection** - 连接参数调试
3. **Debug RustDesk (Release)** - 发布版本调试
4. **Attach to RustDesk Process** - 附加到现有进程

### Flutter调试配置
- **Debug Flutter (Windows)** - Flutter桌面应用调试

## 🎯 调试技巧

### 1. 设置断点
- 在代码行号左侧点击设置断点
- 条件断点：右键断点设置条件
- 日志断点：不暂停执行，仅输出日志

### 2. 变量监视
- 在调试面板添加监视表达式
- 悬停变量查看值
- 在调试控制台输入表达式

### 3. 调用栈分析
- 查看函数调用链
- 跟踪程序执行路径
- 分析死锁位置

### 4. 内存调试
```rust
// 在代码中添加调试日志
log::debug!("参数值: {:?}", args);
log::trace!("进入函数: {}", function_name);
println!("调试信息: {}", value);
```

## 🚀 常用调试命令

### VS Code快捷键
- `F5` - 开始调试
- `F10` - 单步跳过
- `F11` - 单步进入
- `Shift+F11` - 单步跳出
- `Ctrl+Shift+F5` - 重启调试
- `Shift+F5` - 停止调试

### 终端调试命令
```bash
# 编译调试版本
cargo build --features flutter

# 运行带日志的调试版本
RUST_LOG=debug RUST_BACKTRACE=1 ./target/debug/rustdesk.exe --fullscreen=true

# 使用GDB调试
gdb ./target/debug/rustdesk.exe
(gdb) run --connect=10.2.10.216 --password="Abcd$1234"
(gdb) bt  # 查看调用栈
(gdb) info threads  # 查看线程信息

# 使用LLDB调试
lldb ./target/debug/rustdesk.exe
(lldb) run --connect=10.2.10.216 --password="Abcd$1234"
(lldb) bt  # 查看调用栈
(lldb) thread list  # 查看线程信息
```

## 📊 性能分析工具

### 1. Rust性能分析
```bash
# 使用perf分析（Linux）
perf record --call-graph=dwarf ./target/release/rustdesk
perf report

# 使用cargo-flamegraph
cargo install flamegraph
cargo flamegraph --bin rustdesk -- --fullscreen=true
```

### 2. 内存泄漏检测
```bash
# 使用valgrind（Linux）
valgrind --tool=memcheck --leak-check=full ./target/debug/rustdesk

# 使用AddressSanitizer
RUSTFLAGS="-Z sanitizer=address" cargo build --target x86_64-pc-windows-msvc
```

## 🐛 常见问题调试

### 1. 死锁调试
```rust
// 在可能死锁的位置添加
use std::sync::atomic::{AtomicU32, Ordering};
static DEADLOCK_COUNTER: AtomicU32 = AtomicU32::new(0);

fn potential_deadlock_function() {
    let counter = DEADLOCK_COUNTER.fetch_add(1, Ordering::SeqCst);
    log::warn!("进入潜在死锁函数，计数: {}", counter);
    
    // 原有代码
    
    log::warn!("退出潜在死锁函数，计数: {}", counter);
}
```

### 2. 参数传递调试
```rust
// 在参数处理函数中添加详细日志
fn process_args(args: Vec<String>) {
    log::debug!("收到参数: {:?}", args);
    for (i, arg) in args.iter().enumerate() {
        log::debug!("参数[{}]: {}", i, arg);
        if arg.starts_with("--connect=") {
            log::info!("检测到连接参数: {}", arg);
        }
    }
}
```

### 3. Flutter端调试
```dart
// 在Flutter代码中添加调试信息
void _handleCommandLineArgs() {
  debugPrint('处理命令行参数开始');
  for (int i = 0; i < kBootArgs.length; i++) {
    debugPrint('Flutter参数[$i]: ${kBootArgs[i]}');
  }
  debugPrint('处理命令行参数结束');
}
```

## 🔍 日志分析

### 日志级别设置
```bash
# 详细日志
RUST_LOG=trace

# 模块特定日志
RUST_LOG=rustdesk=debug,flutter=trace

# 仅错误日志
RUST_LOG=error
```

### 日志文件配置
```rust
// 在main函数中添加文件日志
use log4rs;

fn setup_logging() {
    log4rs::init_file("log4rs.yaml", Default::default()).unwrap();
}
```

## 🧪 自动化测试

### 单元测试
```bash
# 运行所有测试
cargo test --features flutter

# 运行特定测试
cargo test connection_args_test --features flutter

# 带详细输出运行测试
cargo test --features flutter -- --nocapture
```

### 集成测试
```bash
# 创建集成测试脚本
./test_custom_params_v5.bat

# 自动化参数测试
powershell -File test_automation.ps1
```
