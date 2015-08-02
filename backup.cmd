@echo off
set SOURCE=%USERPROFILE%
set DESTINATION=%~d0\backup
set EXCLUDE=%~dp0\excludes.txt


set RUBY=ruby-2.0.0-p0-x64-mingw32
REM set RUBY=ruby-2.0.0-p0-i386-mingw32
set SCRIPT=%~dp0\bin\backup.rbw

%~dp0\%RUBY%\bin\ruby.exe "%SCRIPT%" -s "%SOURCE%" -d "%DESTINATION%" -x "%EXCLUDE%"
echo.
echo Press any key to exit.
pause>nul
