@echo off
setlocal

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -host_arch=x86 -arch=x86
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -test

cd /D %~dp0
cd ..

if exist boost pushd boost
if exist bootstrap.bat call bootstrap.bat
if exist b2.exe .\b2 headers
popd

endlocal
exit /B