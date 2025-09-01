@echo off
echo ========================================
echo RustDesk Custom Parameters Test v2
echo ========================================
echo.

echo Test 1: Basic fullscreen mode
echo Running: rustdesk.exe --fullscreen=true
echo Expected: App starts in fullscreen mode
rustdesk.exe --fullscreen=true
timeout /t 3 /nobreak >nul
echo.

echo Test 2: Basic collapse toolbar
echo Running: rustdesk.exe --collapse_toolbar=true
echo Expected: App starts with collapsed toolbar
rustdesk.exe --collapse_toolbar=true
timeout /t 3 /nobreak >nul
echo.

echo Test 3: Basic desktop scaling
echo Running: rustdesk.exe --desktop_scaling=true
echo Expected: App starts with desktop scaling enabled
rustdesk.exe --desktop_scaling=true
timeout /t 3 /nobreak >nul
echo.

echo Test 4: Connection with custom params (should not deadlock)
echo Running: rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
echo Expected: App starts, shows connection dialog, no deadlock
rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
timeout /t 5 /nobreak >nul
echo.

echo Test 5: Multiple custom params
echo Running: rustdesk.exe --fullscreen=true --collapse_toolbar=true --desktop_scaling=true
echo Expected: App starts with all custom settings applied
rustdesk.exe --fullscreen=true --collapse_toolbar=true --desktop_scaling=true
timeout /t 3 /nobreak >nul
echo.

echo ========================================
echo All tests completed.
echo Check if any instances are still running.
echo ========================================
pause
