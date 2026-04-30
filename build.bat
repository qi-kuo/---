@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo [1/5] Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Python not found in PATH.
  pause
  exit /b 1
)

echo [2/5] Installing/Updating PyInstaller...
python -m pip install --upgrade pyinstaller
if errorlevel 1 (
  echo [ERROR] Failed to install PyInstaller.
  pause
  exit /b 1
)

echo [3/5] Building executable...
python -m PyInstaller --noconfirm --clean --windowed --name RocoKingdomTool auto2.py
if errorlevel 1 (
  echo [ERROR] Build failed.
  pause
  exit /b 1
)

echo [4/5] Preparing map tracker files...
if not exist "Game-Map-Tracker-main\main_sift.py" (
  if exist "Game-Map-Tracker-main.zip" (
    echo Extracting Game-Map-Tracker-main.zip...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath 'Game-Map-Tracker-main.zip' -DestinationPath '.' -Force"
  ) else (
    echo [ERROR] Missing both Game-Map-Tracker-main folder and Game-Map-Tracker-main.zip.
    pause
    exit /b 1
  )
)

if not exist "dist\RocoKingdomTool" (
  echo [ERROR] Build output folder dist\RocoKingdomTool not found.
  pause
  exit /b 1
)

if not exist "Game-Map-Tracker-main\main_sift.py" (
  echo [ERROR] Failed to prepare Game-Map-Tracker-main source folder.
  pause
  exit /b 1
)

xcopy /E /I /Y "Game-Map-Tracker-main" "dist\RocoKingdomTool\Game-Map-Tracker-main" >nul
if errorlevel 1 (
  echo [ERROR] Failed to copy Game-Map-Tracker-main folder.
  pause
  exit /b 1
)

echo [5/5] Done.
echo Output: dist\RocoKingdomTool\RocoKingdomTool.exe
pause
exit /b 0
