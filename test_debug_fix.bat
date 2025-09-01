@echo off
echo ========================================
echo RustDesk Debug Fix Test
echo ========================================
echo.

echo 测试1: 基础参数测试
echo 运行: rustdesk.exe --fullscreen=true
rustdesk.exe --fullscreen=true
timeout /t 3 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试2: 连接参数测试
echo 运行: rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试3: 多参数组合测试
echo 运行: rustdesk.exe --fullscreen=true --collapse_toolbar=true --desktop_scaling=false
rustdesk.exe --fullscreen=true --collapse_toolbar=true --desktop_scaling=false
timeout /t 3 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试4: 仅连接测试
echo 运行: rustdesk.exe --connect=10.2.10.216
rustdesk.exe --connect=10.2.10.216
timeout /t 3 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo ========================================
echo 所有测试完成
echo ========================================
pause
