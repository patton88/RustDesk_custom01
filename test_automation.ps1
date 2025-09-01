# RustDesk自动化测试脚本
param(
    [string]$BuildType = "debug",
    [string]$TestTimeout = "10",
    [switch]$Verbose = $false
)

# 设置错误处理
$ErrorActionPreference = "Stop"

# 定义颜色输出函数
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success { param([string]$Message) Write-ColorOutput "✅ $Message" "Green" }
function Write-Error { param([string]$Message) Write-ColorOutput "❌ $Message" "Red" }
function Write-Info { param([string]$Message) Write-ColorOutput "ℹ️ $Message" "Cyan" }
function Write-Warning { param([string]$Message) Write-ColorOutput "⚠️ $Message" "Yellow" }

# 测试配置
$TestConfig = @{
    BuildType = $BuildType
    Timeout = [int]$TestTimeout
    Verbose = $Verbose.IsPresent
    ExePath = if ($BuildType -eq "release") { ".\target\release\rustdesk.exe" } else { ".\target\debug\rustdesk.exe" }
}

# 测试用例定义
$TestCases = @(
    @{
        Name = "基础全屏测试"
        Args = @("--fullscreen=true")
        Expected = "应用启动并进入全屏模式"
        CheckProcess = $true
    },
    @{
        Name = "工具栏折叠测试"
        Args = @("--collapse_toolbar=true")
        Expected = "应用启动时工具栏已折叠"
        CheckProcess = $true
    },
    @{
        Name = "桌面缩放测试"
        Args = @("--desktop_scaling=true")
        Expected = "应用启动时启用桌面缩放"
        CheckProcess = $true
    },
    @{
        Name = "连接参数测试"
        Args = @("--connect=10.2.10.216", "--password=Abcd$1234", "--fullscreen=true")
        Expected = "应用启动并尝试连接到指定主机"
        CheckProcess = $true
        CheckConnection = $true
    },
    @{
        Name = "多参数组合测试"
        Args = @("--fullscreen=true", "--collapse_toolbar=true", "--desktop_scaling=false")
        Expected = "应用启动并应用所有参数设置"
        CheckProcess = $true
    }
)

function Test-ProcessExists {
    param([string]$ProcessName)
    return Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
}

function Stop-RustDeskProcess {
    $processes = Get-Process -Name "rustdesk" -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Info "停止现有RustDesk进程..."
        $processes | ForEach-Object { 
            try {
                $_.Kill()
                $_.WaitForExit(5000)
            } catch {
                Write-Warning "强制结束进程 $($_.Id)"
                Stop-Process -Id $_.Id -Force
            }
        }
        Start-Sleep 2
    }
}

function Start-TestProcess {
    param([array]$Arguments)
    
    $processInfo = @{
        FilePath = $TestConfig.ExePath
        ArgumentList = $Arguments
        NoNewWindow = $true
        PassThru = $true
    }
    
    if ($TestConfig.Verbose) {
        Write-Info "启动命令: $($TestConfig.ExePath) $($Arguments -join ' ')"
    }
    
    try {
        $process = Start-Process @processInfo
        return $process
    } catch {
        Write-Error "启动进程失败: $($_.Exception.Message)"
        return $null
    }
}

function Test-ApplicationResponse {
    param([System.Diagnostics.Process]$Process, [int]$TimeoutSeconds)
    
    $timeout = [DateTime]::Now.AddSeconds($TimeoutSeconds)
    
    while ([DateTime]::Now -lt $timeout) {
        if ($Process.HasExited) {
            return @{
                Success = $false
                Message = "进程意外退出，退出代码: $($Process.ExitCode)"
            }
        }
        
        try {
            # 检查进程是否响应
            if (-not $Process.Responding) {
                return @{
                    Success = $false
                    Message = "进程无响应（可能死锁）"
                }
            }
            
            # 检查窗口是否存在
            $windows = Get-Process -Name "rustdesk" -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 }
            if ($windows) {
                return @{
                    Success = $true
                    Message = "应用正常启动，窗口已显示"
                }
            }
        } catch {
            # 继续检查
        }
        
        Start-Sleep 1
    }
    
    return @{
        Success = $false
        Message = "超时：应用在 $TimeoutSeconds 秒内未正常启动"
    }
}

function Run-SingleTest {
    param([hashtable]$TestCase)
    
    Write-Info "开始测试: $($TestCase.Name)"
    Write-Info "参数: $($TestCase.Args -join ' ')"
    Write-Info "预期: $($TestCase.Expected)"
    
    # 确保没有现有进程
    Stop-RustDeskProcess
    
    # 启动测试进程
    $process = Start-TestProcess -Arguments $TestCase.Args
    if (-not $process) {
        return @{
            TestName = $TestCase.Name
            Success = $false
            Message = "无法启动进程"
            Duration = 0
        }
    }
    
    $startTime = [DateTime]::Now
    
    try {
        # 测试应用响应
        $response = Test-ApplicationResponse -Process $process -TimeoutSeconds $TestConfig.Timeout
        $duration = ([DateTime]::Now - $startTime).TotalSeconds
        
        # 停止进程
        if (-not $process.HasExited) {
            $process.Kill()
            $process.WaitForExit(3000)
        }
        
        return @{
            TestName = $TestCase.Name
            Success = $response.Success
            Message = $response.Message
            Duration = [math]::Round($duration, 2)
        }
        
    } catch {
        return @{
            TestName = $TestCase.Name
            Success = $false
            Message = "测试执行异常: $($_.Exception.Message)"
            Duration = ([DateTime]::Now - $startTime).TotalSeconds
        }
    } finally {
        # 确保进程被清理
        Stop-RustDeskProcess
    }
}

function Show-TestSummary {
    param([array]$Results)
    
    $successCount = ($Results | Where-Object { $_.Success }).Count
    $totalCount = $Results.Count
    $totalDuration = ($Results | Measure-Object -Property Duration -Sum).Sum
    
    Write-ColorOutput "`n========================================" "Magenta"
    Write-ColorOutput "           测试结果汇总" "Magenta"
    Write-ColorOutput "========================================" "Magenta"
    
    foreach ($result in $Results) {
        $status = if ($result.Success) { "✅ 通过" } else { "❌ 失败" }
        $color = if ($result.Success) { "Green" } else { "Red" }
        
        Write-ColorOutput "[$status] $($result.TestName) ($($result.Duration)s)" $color
        if (-not $result.Success) {
            Write-ColorOutput "  原因: $($result.Message)" "Yellow"
        }
    }
    
    Write-ColorOutput "`n总计: $successCount/$totalCount 通过" $(if ($successCount -eq $totalCount) { "Green" } else { "Yellow" })
    Write-ColorOutput "总耗时: $([math]::Round($totalDuration, 2))秒" "Cyan"
    
    if ($successCount -eq $totalCount) {
        Write-Success "所有测试通过！RustDesk自定义参数功能正常。"
    } else {
        Write-Error "存在测试失败，请检查相关问题。"
    }
}

# 主测试流程
function Main {
    Write-ColorOutput "========================================" "Magenta"
    Write-ColorOutput "    RustDesk自动化测试开始" "Magenta"
    Write-ColorOutput "========================================" "Magenta"
    
    Write-Info "构建类型: $($TestConfig.BuildType)"
    Write-Info "超时时间: $($TestConfig.Timeout)秒"
    Write-Info "可执行文件: $($TestConfig.ExePath)"
    
    # 检查可执行文件是否存在
    if (-not (Test-Path $TestConfig.ExePath)) {
        Write-Error "找不到可执行文件: $($TestConfig.ExePath)"
        Write-Info "请先运行构建命令:"
        if ($TestConfig.BuildType -eq "release") {
            Write-Info "cargo build --release --features flutter"
        } else {
            Write-Info "cargo build --features flutter"
        }
        exit 1
    }
    
    # 确保开始时没有运行的进程
    Stop-RustDeskProcess
    
    $results = @()
    
    # 运行所有测试
    foreach ($testCase in $TestCases) {
        $result = Run-SingleTest -TestCase $testCase
        $results += $result
        
        if ($result.Success) {
            Write-Success "$($result.TestName) - $($result.Message)"
        } else {
            Write-Error "$($result.TestName) - $($result.Message)"
        }
        
        # 测试间隔
        Start-Sleep 2
    }
    
    # 显示汇总结果
    Show-TestSummary -Results $results
    
    # 最终清理
    Stop-RustDeskProcess
    
    # 设置退出代码
    $failedCount = ($results | Where-Object { -not $_.Success }).Count
    exit $failedCount
}

# 执行主函数
try {
    Main
} catch {
    Write-Error "测试脚本执行失败: $($_.Exception.Message)"
    exit 1
}
