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

echo [4/5] Copying Game-Map-Tracker-main.zip...
if not exist "Game-Map-Tracker-main.zip" (
  echo [ERROR] Missing Game-Map-Tracker-main.zip in project root.
  pause
  exit /b 1
)

if not exist "dist\RocoKingdomTool" (
  echo [ERROR] Build output folder dist\RocoKingdomTool not found.
  pause
  exit /b 1
)

copy /Y "Game-Map-Tracker-main.zip" "dist\RocoKingdomTool\Game-Map-Tracker-main.zip" >nul
if errorlevel 1 (
  echo [ERROR] Failed to copy zip file.
  pause
  exit /b 1
)

echo [5/5] Done.
echo Output: dist\RocoKingdomTool\RocoKingdomTool.exe
pause
exit /b 0
