@echo off
echo ========================================
echo RustDesk Debug Fix Test v8
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

echo 测试5: 仅密码测试
echo 运行: rustdesk.exe --password="Abcd$1234"
rustdesk.exe --password="Abcd$1234"
timeout /t 3 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试6: 连接和密码分离测试
echo 运行: rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234"
rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试7: 复杂参数组合测试
echo 运行: rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true --collapse_toolbar=false --desktop_scaling=true
rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true --collapse_toolbar=false --desktop_scaling=true
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试8: 无参数启动测试
echo 运行: rustdesk.exe
rustdesk.exe
timeout /t 3 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试9: 错误参数测试
echo 运行: rustdesk.exe --fullscreen=invalid
rustdesk.exe --fullscreen=invalid
timeout /t 3 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试10: 混合参数测试
echo 运行: rustdesk.exe --fullscreen=true --collapse_toolbar=false --desktop_scaling=true --connect=10.2.10.216
rustdesk.exe --fullscreen=true --collapse_toolbar=false --desktop_scaling=true --connect=10.2.10.216
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试11: 空连接ID测试
echo 运行: rustdesk.exe --connect= --password="Abcd$1234"
rustdesk.exe --connect= --password="Abcd$1234"
timeout /t 3 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试12: 特殊字符测试
echo 运行: rustdesk.exe --connect=10.2.10.216 --password="Abcd\$1234@#%"
rustdesk.exe --connect=10.2.10.216 --password="Abcd\$1234@#%"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试13: 其他连接类型测试
echo 运行: rustdesk.exe --play=10.2.10.216 --password="Abcd$1234"
rustdesk.exe --play=10.2.10.216 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试14: 文件传输测试
echo 运行: rustdesk.exe --file-transfer=10.2.10.216 --password="Abcd$1234"
rustdesk.exe --file-transfer=10.2.10.216 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试15: 摄像头查看测试
echo 运行: rustdesk.exe --view-camera=10.2.10.216 --password="Abcd$1234"
rustdesk.exe --view-camera=10.2.10.216 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试16: 端口转发测试
echo 运行: rustdesk.exe --port-forward=10.2.10.216 --password="Abcd$1234"
rustdesk.exe --port-forward=10.2.10.216 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试17: RDP测试
echo 运行: rustdesk.exe --rdp=10.2.10.216 --password="Abcd$1234"
rustdesk.exe --rdp=10.2.10.216 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试18: 终端连接测试
echo 运行: rustdesk.exe --terminal=10.2.10.216 --password="Abcd$1234"
rustdesk.exe --terminal=10.2.10.216 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试19: 混合连接类型测试
echo 运行: rustdesk.exe --connect=10.2.10.216 --file-transfer=10.2.10.217 --password="Abcd$1234"
rustdesk.exe --connect=10.2.10.216 --file-transfer=10.2.10.217 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo 测试20: 终端和RDP混合测试
echo 运行: rustdesk.exe --terminal=10.2.10.216 --rdp=10.2.10.217 --password="Abcd$1234"
rustdesk.exe --terminal=10.2.10.216 --rdp=10.2.10.217 --password="Abcd$1234"
timeout /t 5 /nobreak >nul
taskkill /f /im rustdesk.exe >nul 2>&1
echo.

echo ========================================
echo 所有测试完成
echo ========================================
pause
