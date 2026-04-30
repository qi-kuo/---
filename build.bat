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

echo [3/5] Building executable into existing dist folder...
if not exist "dist" mkdir dist
python -m PyInstaller --noconfirm --clean --windowed --onefile --distpath dist --workpath build\pyinstaller --specpath build\pyinstaller --name RocoKingdomTool auto2.py
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

if not exist "dist" (
  echo [ERROR] Build output folder dist not found.
  pause
  exit /b 1
)

if not exist "Game-Map-Tracker-main\main_sift.py" (
  echo [ERROR] Failed to prepare Game-Map-Tracker-main source folder.
  pause
  exit /b 1
)

rmdir /S /Q "dist\Game-Map-Tracker-main" >nul 2>nul
xcopy /E /I /Y "Game-Map-Tracker-main" "dist\Game-Map-Tracker-main" >nul
if errorlevel 1 (
  echo [ERROR] Failed to copy Game-Map-Tracker-main folder.
  pause
  exit /b 1
)

echo [5/5] Done.
echo Output: dist\RocoKingdomTool.exe
echo Tracker: dist\Game-Map-Tracker-main
pause
exit /b 0
