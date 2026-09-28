@echo off
setlocal enableextensions
cd /d "%~dp0"

rem If we were relaunched (elevated) with the INSTALL flag, just do the setup.
if /i "%~1"=="INSTALL" goto :install

set "GAME=%~dp0Drag'n Wash\DragNWash.exe"
set "MARKER=%~dp0.setup_done"
set "SELF=%~f0"

if not exist "%GAME%" (
  echo.
  echo   Could not find the game next to this launcher.
  echo   Make sure you unzipped the WHOLE folder before running it.
  echo.
  pause
  exit /b 1
)

if not exist "%MARKER%" (
  echo ==============================================================
  echo   First-time setup for Drag'n Wash
  echo   Installing the bits Windows needs to run the game.
  echo   If a permission prompt appears, please click YES.
  echo ==============================================================
  echo.
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath $env:SELF -ArgumentList 'INSTALL' -Verb RunAs -Wait"
  echo.
)

echo   Starting Drag'n Wash...
start "" "%GAME%"
exit /b 0

:install
rem ---- runs elevated; installs prerequisites silently, then writes the marker ----
set "R=%~dp0_Redist"
echo   Installing Visual C++ runtimes...
if exist "%R%\vcredist_2015-2019_x64.exe" start /wait "" "%R%\vcredist_2015-2019_x64.exe" /install /quiet /norestart
if exist "%R%\vcredist_2015-2019_x86.exe" start /wait "" "%R%\vcredist_2015-2019_x86.exe" /install /quiet /norestart
if exist "%R%\vcredist_x64.exe" start /wait "" "%R%\vcredist_x64.exe" /install /quiet /norestart
if exist "%R%\vcredist_x86.exe" start /wait "" "%R%\vcredist_x86.exe" /install /quiet /norestart
echo   Installing .NET Framework 4...
if exist "%R%\dotNetFx40_Full_setup.exe" start /wait "" "%R%\dotNetFx40_Full_setup.exe" /q /norestart
echo   Installing OpenAL (audio)...
if exist "%R%\oalinst.exe" start /wait "" "%R%\oalinst.exe" /s
echo   Installing XNA runtime...
if exist "%R%\xnafx40_redist.msi" start /wait "" msiexec /i "%R%\xnafx40_redist.msi" /quiet /norestart
echo   Updating DirectX (needs internet; skipped if offline)...
if exist "%R%\dxwebsetup.exe" start /wait "" "%R%\dxwebsetup.exe" /q
type nul > "%~dp0.setup_done"
exit /b 0
