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

echo.
echo For a full release, run the script twice, once for a 64-built build, once for
echo a 32-bit build. You may need to change the script variable QTBIN to point to
echo your Qt folder (once for 64-bit, once for 32-bit).
echo.
echo You may need to set the PATH that the script can find Git for Windows.
echo.
echo You may need to change the script variable BOOSTDIR to find Boost C++ header.
echo.
echo You may need to change the script variable LIBGIT2 to find git2.dll.
echo.

:: ==============================   PARSE   ==============================

if .%1 == . (
	echo first parameter --release version-- is missing, should be:
	echo    something like 0.8.6b
	exit /B 1
)

if .%2 == . (
	echo second parameter --target architecture-- is missing, should be:
	echo     either "32" for a 32-bit build
	echo         or "64" for a 64-bit build
	exit /B 1
)

if .%3 == . (
	echo third parameter --visual studio version-- is missing, should be:
	echo     "2019", "2022"
	exit /B 1
)

if %2 == 64 (
	if %3 == 2019 (
		set QTBIN=C:\Qt\5.15.2\msvc2019_64\bin
		set VCCRT=Microsoft.VC142.CRT
		set PDLL=msvcp140.dll
		set RDLL=vcruntime140.dll
	) else if %3 == 2022 (
		set QTBIN=C:\Qt\6.4.0\msvc2022_64\bin
		set VCCRT=Microsoft.VC150.CRT
		set PDLL=msvcp150.dll
		set RDLL=vcruntime150.dll
	) else (
		echo third parameter --visual studio version-- is missing, should be:
		echo     "2019", "2022"
		exit /B 1
	)
	set QTARCH=""QMAKE_TARGET.arch=x86_64""
	set DBARCH="machine.*(x64)"
) else if %2 == 32 (
	if %3 == 2019 (
		set QTBIN=C:\Qt\5.15.2\msvc2019\bin
		set VCCRT=Microsoft.VC142.CRT
		set PDLL=msvcp140.dll
		set RDLL=vcruntime140.dll
	) else if %3 == 2022 (
		set QTBIN=C:\Qt\6.4.0\msvc2022\bin
		set VCCRT=Microsoft.VC150.CRT
		set PDLL=msvcp150.dll
		set RDLL=vcruntime150.dll
	) else (
		echo third parameter --visual studio version-- is missing, should be:
		echo     "2019", "2022"
		exit /B 1
	)
	set QTARCH=""QMAKE_TARGET.arch=x86""
	set DBARCH="machine.*(x86)"
) else (
	echo second parameter --target architecture-- should be:
	echo     either "32" for a 32-bit build
	echo         or "64" for a 64-bit build
	exit /B 1
)

set RD=release%2
set BD=build%2
set VD=Release

set PN=fritzing
set PV=%1
set PR=win%2
set RN=%PN%_%PV%-%PR%
echo build %PN%_%PV%-%PR%

if exist "%QTBIN%" set PATH=%PATH%;%QTBIN%
if exist "%QTBIN%" echo found %QTBIN% for %3 and %2 bit
if not exist "%QTBIN%" exit /B 1
echo.

:: ============================== EVALUATE ===============================

call :WHICH qmake
set QMAKE=%RETVAL%
if not exist %QMAKE% echo Qmake not found, check your parameters.
if not exist %QMAKE% exit /B 1
echo found Qmake as %QMAKE%
echo.

:: Microsoft Program Maintenance Utility
:: https://devblogs.microsoft.com/oldnewthing/20190325-00/?p=102359
call :WHICH nmake
set NMAKE=%RETVAL%
if not exist %NMAKE% echo New Make not found, check your PATH.
if not exist %NMAKE% exit /B 1
echo found New Make as %NMAKE%
echo.

call :WHICH dumpbin
set DUMPBIN=%RETVAL%
if not exist %DUMPBIN% echo Dump Binary not found, check your PATH.
if not exist %DUMPBIN% exit /B 1
echo found Dump Binary as %DUMPBIN%
echo.

call :WHICH editbin
set EDITBIN=%RETVAL%
if not exist %EDITBIN% echo Edit Binary not found, check your PATH.
if not exist %EDITBIN% exit /B 1
echo found Edit Binary as %EDITBIN%
echo.

call :WHICH windeployqt
set QTWDT=%RETVAL%
if not exist %QTWDT% echo Windows Deployment Tool not found, check your PATH.
if not exist %QTWDT% exit /B 1
echo found Windows Deployment Tool as %QTWDT%
echo.

call :WHICH git
set GIT=%RETVAL%
if not exist %GIT% echo Git not found, check your PATH.
if not exist %GIT% exit /B 1
echo found Git as %GIT%
echo.

call :WHICH 7z
set CLI7Z=%RETVAL%
if not exist %CLI7Z% echo 7z not found, check your PATH.
if not exist %CLI7Z% exit /B 1
echo found 7z as %CLI7Z%
echo.

call :NORMALIZEPATH %~dp0..
set TOPDIR=%RETVAL%
cd /D %TOPDIR%

call :NORMALIZEPATH %TOPDIR%\boost
set BOOSTDIR=%RETVAL%
if not exist %BOOSTDIR% echo Boost directory not found, check your workspace.
if not exist %BOOSTDIR% exit /B 1

call :NORMALIZEPATH %BOOSTDIR%\boost\config.hpp
set BOOSTCFG=%RETVAL%
if not exist %BOOSTCFG% echo Boost header not found, check your workspace.
if not exist %BOOSTCFG% exit /B 1

echo found Boost in %BOOSTDIR%
echo found   CFG as %BOOSTCFG%
echo.

call :NORMALIZEPATH %TOPDIR%\libgit2\%BD%
set LIBGIT2=%RETVAL%
if not exist %LIBGIT2% echo Libgit2 build not found, check your workspace.
if not exist %LIBGIT2% exit /B 1

call :NORMALIZEPATH %LIBGIT2%\%VD%\git2.dll
set GIT2DLL=%RETVAL%
if not exist %GIT2DLL% echo Libgit2 DLL not found, check your workspace.
if not exist %GIT2DLL% exit /B 1

echo found Libgit2 in %LIBGIT2%
echo found     DLL as %GIT2DLL%
echo.

call :NORMALIZEPATH %TOPDIR%\fritzing-app
set FZADIR=%RETVAL%
if not exist %FZADIR% echo Fritzing App source not found, check your workspace.
if not exist %FZADIR% exit /B 1

call :NORMALIZEPATH %FZADIR%\phoenix.pro
set QMPRO=%RETVAL%
if not exist %QMPRO% echo Qmake project not found, check your workspace.
if not exist %QMPRO% exit /B 1

echo found Fritzing App in %FZADIR%
echo found    Qmake PRO as %QMPRO%
echo.

call :NORMALIZEPATH %TOPDIR%\fritzing-parts
set FZPDIR=%RETVAL%
if not exist %FZPDIR% echo Fritzing Parts Library not found, check your workspace.
if not exist %FZPDIR% exit /B 1

call :NORMALIZEPATH %FZPDIR%\bins\core.fzb
set FZBCORE=%RETVAL%
if not exist %FZBCORE% echo Fritzing Core Bin not found, check your workspace.
if not exist %FZBCORE% exit /B 1

echo found Fritzing Parts in %FZPDIR%
echo found   Core Bin FZB as %FZBCORE%
echo.

:: ==============================   BUILD   ==============================

:: set environment variable for Qmake project (phoenix.pro) and/or pri files
set RELEASE_SCRIPT="release_script"
set QMDEF=""boost_root=%BOOSTDIR:"=%""

pushd %FZADIR%
%QMAKE% -makefile -o Makefile %QMPRO% %QMDEF% %QTARCH% || exit /B 2
%NMAKE% %VD% || exit /B 2
popd

:: ============================== VALIDATE ===============================

call :NORMALIZEPATH %TOPDIR%\%RD%
set DESTDIR=%RETVAL%
if not exist %DESTDIR% echo Fritzing destination not found, check your build.
if not exist %DESTDIR% exit /B 2

call :NORMALIZEPATH %DESTDIR%\fritzing.exe
set FZAEXE=%RETVAL%
if not exist %FZAEXE% echo Fritzing not found, check your build.
if not exist %FZAEXE% exit /B 2

echo found Fritzing in %DESTDIR%
echo found      EXE as %FZAEXE%
echo test       EXE is
%DUMPBIN% /HEADERS %FZAEXE% | findstr %DBARCH% ^
    || echo Fritzing not for %DBARCH%, check your build. && exit /B 2
echo.

:: ==============================  DEPLOY  ===============================

call :NORMALIZEPATH %DESTDIR%\deploy
set DEPLOY=%RETVAL%

call :NORMALIZEPATH %DESTDIR%\forzip
set FORZIP=%RETVAL%

call :NORMALIZEPATH %FORZIP:"=%\%RN:"=%
set RELEASE_BASE=%RETVAL%

call :NORMALIZEPATH %RELEASE_BASE:"=%.zip
set RELEASE_ZIP=%RETVAL%

echo Setting up deploy folder. Ignore any "The system cannot find ..." messages.
if exist %RELEASE_ZIP% del /Q %RELEASE_ZIP%
rmdir /Q /S %FORZIP%
rmdir /Q /S %DEPLOY%

mkdir %FORZIP%
mkdir %DEPLOY%
echo.
echo Deploy folder ready. ANY FURTHER "The system cannot find ..." MESSAGES
echo REPRESENT   SIGNIFICANT   PROBLEMS   WITH THE SCRIPT. (!)
echo.

echo copy Qt dependencies... (libraries, plugins, and translations)
%QTWDT% --verbose 1 --release --compiler-runtime ^
        --dir %DEPLOY% %FZAEXE% || exit /B 3
echo.

echo copy Libgit2 library...
call :MCOPY %LIBGIT2%\%VD% %DEPLOY% git2.dll || exit /B 3
echo.

echo copy Fritzing application...
call :MCOPY  %DESTDIR% %DEPLOY% Fritzing.exe || exit /B 3
echo.

if %VSCMD_ARG_TGT_ARCH% == x86 (
	echo make Fritzing application compatible with Windows XP
	%EDITBIN% /NOLOGO /SUBSYSTEM:WINDOWS,5.01 /OSVERSION:5.1 ^
	          %DEPLOY%\Fritzing.exe || exit /B 3
	echo.
)

call :NORMALIZEPATH "%VCTOOLSREDISTDIR%\%VSCMD_ARG_TGT_ARCH%\%VCCRT%"
set VCCRTDIR=%RETVAL%

echo copy VC Redistributable libraries...
call :MCOPY %VCCRTDIR% %DEPLOY% %PDLL% %RDLL% || exit /B 3
echo.

echo copy sketches, translations, help, README, LICENSE...
call :MXCOPY %FZADIR% %DEPLOY% translations sketches help || exit /B 3
call :MCOPY %FZADIR% %DEPLOY% ^
            README.md ^
            INSTALL.txt ^
            LICENSE.GPL2 ^
            LICENSE.GPL3 ^
            LICENSE.CC-BY-SA || exit /B 3
echo.

echo removing empty translation files...
pushd %DEPLOY%\translations
for /F "usebackq delims=;" %%A in (`dir /B *.qm`) do If %%~zA LSS 1024 del /Q "%%A"
del /Q *.ts
popd
echo.

echo export Fritzing parts library...
pushd %DEPLOY%
:: %GIT% clone --origin upstream --branch main --single-branch ^
::       "https://github.com/fritzing/fritzing-parts.git" || exit /B 3
%GIT% clone --origin upstream --single-branch ^
      %FZPDIR% parts || exit /B 3
%GIT% -C parts remote set-url upstream ^
      "https://github.com/fritzing/fritzing-parts.git" || exit /B 3
popd
echo.

:: echo removing placeholder...
:: pushd %DEPLOY%
:: del /Q /S placeholder.txt
:: popd
:: echo.

:: ============================= PACKAGING ===============================

:: https://github.com/fritzing/fritzing-app/wiki/3.-Command-Line-Options
echo run Fritzing to create parts database...
%DEPLOY%\Fritzing.exe -pp %DEPLOY%\parts ^
                      -db %DEPLOY%\parts\parts.db || exit /b 4
echo.

echo move deployments to %RELEASE_BASE%
move /Y %DEPLOY% %RELEASE_BASE%
echo.

echo move deployments to %RELEASE_ZIP%
%CLI7Z% a -y -r -tzip -sdel %RELEASE_ZIP% %RELEASE_BASE%
echo.

echo move deployments to %TOPDIR%
move /Y %RELEASE_ZIP% %TOPDIR%

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
