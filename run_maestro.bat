@echo off
setlocal

echo =======================================================
echo   CuraCard - Maestro Automated Testing Runner
echo =======================================================

rem Set JAVA_HOME if not already set or if old java 8 is detected
if exist "D:\Android Studio\jbr" (
    set "JAVA_HOME=D:\Android Studio\jbr"
    set "PATH=D:\Android Studio\jbr\bin;%PATH%"
) else if exist "C:\Program Files\Java\jdk-23" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-23"
    set "PATH=C:\Program Files\Java\jdk-23\bin;%PATH%"
)

rem Add Maestro bin to PATH
if exist "%USERPROFILE%\.maestro\bin" (
    set "PATH=%USERPROFILE%\.maestro\bin;%PATH%"
)
if exist "%USERPROFILE%\.maestro\maestro\bin" (
    set "PATH=%USERPROFILE%\.maestro\maestro\bin;%PATH%"
)

echo Checking Maestro version...
where maestro >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Maestro executable not found in PATH or %USERPROFILE%\.maestro\bin.
    echo Please ensure Maestro is installed as documented in maestro\README.md.
    pause
    exit /b 1
)

call maestro --version
echo.

rem Check adb devices
echo Checking connected Android devices / emulators...
adb devices
echo.

set TARGET_FLOW=%~1
if "%TARGET_FLOW%"=="" (
    echo Menjalankan semua 4 flow Maestro di folder maestro/...
    call maestro test maestro/
) else (
    echo Menjalankan flow: %TARGET_FLOW%
    call maestro test %TARGET_FLOW%
)

echo.
echo =======================================================
echo   Mengumpulkan dan Menyinkronkan Bukti Screenshot...
echo =======================================================

if not exist "maestro\screenshots" mkdir "maestro\screenshots"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$testsDir = Join-Path $env:USERPROFILE '.maestro\tests';" ^
    "if (Test-Path $testsDir) {" ^
    "    $latestDir = (Get-ChildItem -Path $testsDir | Sort-Object LastWriteTime -Descending | Select-Object -First 1);" ^
    "    if ($latestDir) {" ^
    "        Get-ChildItem -Path $latestDir.FullName -Recurse -Filter '*.png' | ForEach-Object { Copy-Item $_.FullName 'maestro\screenshots\' -Force };" ^
    "        Write-Host '[OK] Seluruh screenshot berhasil disalin ke: maestro\screenshots\';" ^
    "    }" ^
    "}"

echo.
echo =======================================================
echo   Pengujian Maestro Selesai.
echo   Seluruh screenshot dapat dilihat di: maestro\screenshots
echo =======================================================
