@echo off
setlocal enabledelayedexpansion

if "%ARCH%"=="32" (
    set "EPICS_HOST_ARCH=win32-x86"
) else (
    set "EPICS_HOST_ARCH=windows-x64"
)

echo EPICS_BASE=%EPICS_BASE%> configure\RELEASE.local

set "SCRIPTS=" & :: avoid python-scripts masking make
set "PATH=%BUILD_PREFIX%\Library\bin;%BUILD_PREFIX%\Library\usr\bin;%PATH%"

make -j %CPU_COUNT%
if errorlevel 1 (
    echo MAKE FAILED
    exit /b 1
)

for /d %%P in ("%SRC_DIR%\python*") do (
  robocopy "%%~fP\%EPICS_HOST_ARCH%\p4p" "%SP_DIR%\p4p" /E
  if errorlevel 8 exit /b 1
)

mkdir "%PREFIX%\Library\bin"
copy "%SRC_DIR%\bin\%EPICS_HOST_ARCH%\pvagw.exe" "%PREFIX%\Library\bin\" >nul

endlocal
