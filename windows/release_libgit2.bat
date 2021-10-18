@echo off
setlocal

echo.
echo You must start this script from the Visual Studio Command Line Window, find
echo this under the start menu at (depending on your version of Visual Studio):
echo     Start / Visual Studio 2019 / x86 Native Tools Command Prompt for VS 2019
echo for the 64-bit build, use the 64-bit prompt:
echo     Start / Visual Studio 2019 / x64 Native Tools Command Prompt for VS 2019
echo.
echo The script also assumes you have cloned the Fritzing (Packaging) Git repository
echo and are launching this script from within that repository.
echo.

:: ==============================   PARSE   ==============================

if .%1 == . (
	echo first parameter --target architecture-- is missing, should be:
	echo     either "32" for a 32-bit build
	echo         or "64" for a 64-bit build
	exit /B 1
)

if .%2 == . (
	echo second parameter --visual studio version-- is missing, should be:
	echo     "2019", "2022"
	exit /B 1
)

:: https://cmake.org/cmake/help/latest/generator/Visual%20Studio%2016%202019.html
:: https://cmake.org/cmake/help/latest/generator/Visual%20Studio%2017%202022.html
if %2 == 2019 (
	set CMPLAT="Visual Studio 16 2019"
) else if %2 == 2022 (
	set CMPLAT="Visual Studio 17 2022"
) else (
	echo second parameter --visual studio version-- is missing, should be:
	echo     "2019", "2022"
	exit /B 1
)
echo found %CMPLAT% for %2

if %1 == 64 (
	set CMARCH=x64
	set DBARCH="machine.*(x64)"
) else if %1 == 32 (
	set CMARCH=Win32
	set DBARCH="machine.*(x86)"
) else (
	echo first parameter --target architecture-- should be:
	echo     either "32" for a 32-bit build
	echo         or "64" for a 64-bit build
	exit /B 1
)
echo found %CMARCH% for %1 bit

set BD=build%1
set VD=Release

:: ============================== EVALUATE ===============================

call :WHICH cmake
set CMAKE=%RETVAL%
if not exist %CMAKE% echo CMake not found, check your PATH.
if not exist %CMAKE% exit /B 1
echo found CMake as %CMAKE%
echo.

:: https://gitlab.kitware.com/cmake/cmake/-/issues/17043
call :WHICH pkg-config
set PKG_CONFIG=%RETVAL%
if exist %PKG_CONFIG% echo found pkg-config (use work around), check your PATH.
if exist %PKG_CONFIG% echo.

call :WHICH dumpbin
set DUMPBIN=%RETVAL%
if not exist %DUMPBIN% echo Dump Binary not found, check your PATH.
if not exist %DUMPBIN% exit /B 1
echo found Dump Binary as %DUMPBIN%
echo.

call :NORMALIZEPATH %~dp0..
set TOPDIR=%RETVAL%
cd /D %TOPDIR%

call :NORMALIZEPATH %TOPDIR%\libgit2
set LIBGIT2_SRC=%RETVAL%
if not exist %LIBGIT2_SRC% echo Libgit2 source not found, check your workspace.
if not exist %LIBGIT2_SRC% exit /B 1

call :NORMALIZEPATH %LIBGIT2_SRC%\%BD%
set LIBGIT2_BLD=%RETVAL%
if exist %LIBGIT2_BLD% echo Libgit2 build exist, clean by remove.
if exist %LIBGIT2_BLD% rmdir /Q /S %LIBGIT2_BLD%

echo found Libgit2 in %LIBGIT2_SRC%
echo build Libgit2 in %LIBGIT2_BLD%
echo.

:: ==============================   BUILD   ==============================

%CMAKE% -S %LIBGIT2_SRC% -B %LIBGIT2_BLD% -G %CMPLAT% -A %CMARCH% ^
        -DPKG_CONFIG_EXECUTABLE="" ^
        -DBUILD_SHARED_LIBS=ON ^
        -DBUILD_CLAR=OFF ^
    || exit /B 2
%CMAKE% --build %LIBGIT2_BLD% --config %VD% || exit /B 2

:: ============================== VALIDATE ===============================

call :NORMALIZEPATH %LIBGIT2_BLD%\%VD%
set DESTDIR=%RETVAL%
if not exist %DESTDIR% echo Libgit2 destination not found, check your build.
if not exist %DESTDIR% exit /B 2

call :NORMALIZEPATH %DESTDIR%\git2.dll
set LG2DLL=%RETVAL%
if not exist %LG2DLL% echo Libgit2 not found, check your build.
if not exist %LG2DLL% exit /B 2

echo found Libgit2 in %DESTDIR%
echo found     DLL as %LG2DLL%
echo test      DLL is
%DUMPBIN% /HEADERS %LG2DLL% | findstr %DBARCH% ^
    || echo Libgit2 not for %DBARCH%, check your build. && exit /B 2
echo.

:: ============================== FUNCTIONS ==============================
endlocal
exit /B

:NORMALIZEPATH
set RETVAL="%~f1"
exit /B

:WHICH
set RETVAL=""
where /Q %~1 && for /F "tokens=* usebackq" %%f in (`where /F %~1`) do (set "RETVAL=%%f" & goto :which_next)
:which_next
exit /B

:MCOPY
setlocal ENABLEDELAYEDEXPANSION
set "_args=%*"
set "_args=!_args:*%1 =!"
set "_args=!_args:*%2 =!"
if not exist "%~f1" exit /B 1
if not exist "%~f2" exit /B 1
for %%f in (%_args%) do (echo      %%f & copy /Y /V /B "%~f1\%%f" "%~f2\%%f")
exit /B

:MXCOPY
setlocal ENABLEDELAYEDEXPANSION
set "_args=%*"
set "_args=!_args:*%1 =!"
set "_args=!_args:*%2 =!"
if not exist "%~f1" exit /B 1
if not exist "%~f2" exit /B 1
for %%f in (%_args%) do (echo      %%f & xcopy /Q "%~f1\%%f" "%~f2\%%f" /Y /E /I)
exit /B