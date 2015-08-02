@echo off
set SOURCE=%USERPROFILE%
set DESTINATION=%~d0\backup
set EXCLUDE=%~dp0\excludes.txt


set RUBY=jruby-9.0.0.0
set SCRIPT=%~dp0\bin\backup.rbw

%~dp0\%RUBY%\bin\jruby.exe "%SCRIPT%" -s "%SOURCE%" -d "%DESTINATION%" -x "%EXCLUDE%"
echo.
echo Press any key to exit.
pause>nul
