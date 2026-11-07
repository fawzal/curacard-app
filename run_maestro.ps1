# CuraCard - Maestro Automated Testing Runner (PowerShell)
param(
    [string]$TargetFlow = ""
)

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  CuraCard - Maestro Automated Testing Runner (PS)     " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

# Set environment variables for this session
if (Test-Path "D:\Android Studio\jbr") {
    $env:JAVA_HOME = "D:\Android Studio\jbr"
    $env:PATH = "C:\Users\Acer\.maestro\maestro\bin;D:\Android Studio\jbr\bin;" + $env:PATH
} elseif (Test-Path "C:\Program Files\Java\jdk-23") {
    $env:JAVA_HOME = "C:\Program Files\Java\jdk-23"
    $env:PATH = "C:\Users\Acer\.maestro\maestro\bin;C:\Program Files\Java\jdk-23\bin;" + $env:PATH
} else {
    $env:PATH = "C:\Users\Acer\.maestro\maestro\bin;" + $env:PATH
}

# Verify Maestro
$maestroCmd = Get-Command maestro -ErrorAction SilentlyContinue
if (-not $maestroCmd) {
    Write-Host "[ERROR] Maestro CLI tidak ditemukan di PATH." -ForegroundColor Red
    Write-Host "Pastikan Maestro terpasang di C:\Users\Acer\.maestro\maestro\bin" -ForegroundColor Yellow
    exit 1
}

Write-Host "Maestro Version:" -ForegroundColor Green
& maestro --version
Write-Host ""

# Check ADB Devices
Write-Host "Checking connected Android devices / emulators..." -ForegroundColor Yellow
& adb devices
Write-Host ""

# Execute Test Flow
if ([string]::IsNullOrWhiteSpace($TargetFlow)) {
    Write-Host "Menjalankan seluruh 4 flow Maestro di folder maestro/..." -ForegroundColor Green
    & maestro test maestro/
} else {
    Write-Host "Menjalankan flow: $TargetFlow" -ForegroundColor Green
    & maestro test $TargetFlow
}

# Sync Screenshots
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  Mengumpulkan dan Menyinkronkan Bukti Screenshot...   " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

$destDir = Join-Path $PSScriptRoot "maestro\screenshots"
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}

$testsDir = Join-Path $env:USERPROFILE ".maestro\tests"
if (Test-Path $testsDir) {
    $latestDir = Get-ChildItem -Path $testsDir | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latestDir) {
        Get-ChildItem -Path $latestDir.FullName -Recurse -Filter "*.png" | ForEach-Object {
            Copy-Item $_.FullName $destDir -Force
        }
        Write-Host "[OK] Seluruh screenshot berhasil disalin ke: maestro\screenshots\" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  Pengujian Maestro Selesai.                          " -ForegroundColor Cyan
Write-Host "  Bukti screenshot tersimpan di: maestro\screenshots  " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
