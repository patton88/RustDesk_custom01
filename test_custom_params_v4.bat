@echo off
echo ========================================
echo RustDesk Custom Parameters Test v4 (Final)
echo ========================================
echo.
echo This script tests all the fixes for deadlock and parameter issues.
echo.

echo Test 1: Basic fullscreen mode (should work without deadlock)
echo Running: rustdesk.exe --fullscreen=true
echo Expected: App starts in fullscreen mode, no deadlock
rustdesk.exe --fullscreen=true
timeout /t 3 /nobreak >nul
echo.

echo Test 2: Basic collapse toolbar (should work without deadlock)
echo Running: rustdesk.exe --collapse_toolbar=true
echo Expected: App starts with collapsed toolbar, no deadlock
rustdesk.exe --collapse_toolbar=true
timeout /t 3 /nobreak >nul
echo.

echo Test 3: Basic desktop scaling (should work without deadlock)
echo Running: rustdesk.exe --desktop_scaling=true
echo Expected: App starts with desktop scaling enabled, no deadlock
rustdesk.exe --desktop_scaling=true
timeout /t 3 /nobreak >nul
echo.

echo Test 4: Connection with custom params (CRITICAL TEST - should not deadlock)
echo Running: rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
echo Expected: App starts, shows connection dialog, NO DEADLOCK
rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
timeout /t 5 /nobreak >nul
echo.

echo Test 5: Multiple custom params (should work without deadlock)
echo Running: rustdesk.exe --fullscreen=true --collapse_toolbar=true --desktop_scaling=true
echo Expected: App starts with all custom settings applied, no deadlock
rustdesk.exe --fullscreen=true --collapse_toolbar=true --desktop_scaling=true
timeout /t 3 /nobreak >nul
echo.

echo Test 6: Connection only (should work without deadlock)
echo Running: rustdesk.exe --connect=10.2.10.216
echo Expected: App starts, shows connection dialog, NO DEADLOCK
rustdesk.exe --connect=10.2.10.216
timeout /t 3 /nobreak >nul
echo.

echo Test 7: Password only (should work without deadlock)
echo Running: rustdesk.exe --password="Abcd$1234"
echo Expected: App starts normally, no deadlock
rustdesk.exe --password="Abcd$1234"
timeout /t 3 /nobreak >nul
echo.

echo ========================================
echo All tests completed.
echo.
echo IMPORTANT: Check if any instances are still running.
echo If any test caused a deadlock, you'll need to force-close rustdesk.exe
echo ========================================
pause
