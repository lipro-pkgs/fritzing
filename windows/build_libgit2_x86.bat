@echo off
setlocal

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -host_arch=x86 -arch=x86
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -test

cd /D %~dp0
cd ..

call windows\release_libgit2.bat 32 2019

endlocal
exit /B