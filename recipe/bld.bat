@echo off
setlocal enabledelayedexpansion

if "%ARCH%"=="32" (
    set "EPICS_HOST_ARCH=win32-x86"
) else (
    set "EPICS_HOST_ARCH=windows-x64"
)

echo EPICS_BASE=%EPICS_BASE%> configure\RELEASE.local
echo PVXS=%PREFIX%>> configure\RELEASE.local
echo USR_LDFLAGS+=/LIBPATH:%PREFIX%\lib>> configure\CONFIG_SITE.local
echo USR_LDFLAGS+=/LIBPATH:%PREFIX%\libs>> configure\CONFIG_SITE.local

set "SCRIPTS=" & :: avoid python-scripts masking make
set "PATH=%PATH%;%BUILD_PREFIX%\Library\bin;%BUILD_PREFIX%\Library\usr\bin"

make -j %CPU_COUNT%
if errorlevel 1 (
    echo MAKE FAILED
    exit /b 1
)

for /d %%P in ("%SRC_DIR%\python*") do (
  robocopy "%%~fP\%EPICS_HOST_ARCH%\p4p" "%SP_DIR%\p4p" /E
  if errorlevel 8 exit /b 1
)

copy "%SRC_DIR%\bin\%EPICS_HOST_ARCH%\*.dll" "%SP_DIR%\p4p\" >nul

mkdir "%PREFIX%\Library\bin"
copy "%SRC_DIR%\bin\%EPICS_HOST_ARCH%\pvagw.exe" "%PREFIX%\Library\bin\" >nul

endlocal
