@echo off

echo Would you like to reset your current settings to their default values? [y/n]
set /p DFSET="> "
if "%DFSET%"=="y" (
set RESETSET=1
) else (
    set RESETSET=0
)
echo:
powershell -command "Expand-Archive -Force '.\test.zip' '.\temp\'"
if exist start.cmd (
    del ".\start.cmd"
)
if exist update_new.bat (
    del ".\update_new.bat"
)
if exist changelog.txt (
    del ".\changelog.txt"
)
ren ".\temp\update.bat" "update_new.bat"
move ".\temp\update_new.bat" ".\"
move ".\temp\start.cmd" ".\"
move ".\temp\changelog.txt" ".\"
if %RESETSET%==1 (
    if exist settings.ini (
        del ".\settings.ini"
    )
    move ".\temp\settings.ini" ".\"
)
RMDIR /s /q ".\temp"
pause
exit \b
:::Code by Sprinter05