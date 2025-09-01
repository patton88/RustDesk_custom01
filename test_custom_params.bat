@echo off
echo Testing RustDesk Custom Parameters...
echo.

echo Test 1: Fullscreen mode
echo Running: rustdesk.exe --fullscreen=true
rustdesk.exe --fullscreen=true
timeout /t 5 /nobreak >nul

echo.
echo Test 2: Collapse toolbar
echo Running: rustdesk.exe --collapse_toolbar=true
rustdesk.exe --collapse_toolbar=true
timeout /t 5 /nobreak >nul

echo.
echo Test 3: Desktop scaling
echo Running: rustdesk.exe --desktop_scaling=true
rustdesk.exe --desktop_scaling=true
timeout /t 5 /nobreak >nul

echo.
echo Test 4: Connection with custom params
echo Running: rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
rustdesk.exe --connect=10.2.10.216 --password="Abcd$1234" --fullscreen=true
timeout /t 5 /nobreak >nul

echo.
echo All tests completed.
pause
