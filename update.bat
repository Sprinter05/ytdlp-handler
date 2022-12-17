@echo off

echo Would you like to reset your current settings to their default values? [y/n]
set /p DFSET="> "
if "%DFSET%"=="y" (
set RESETSET=1
) else (
    set RESETSET=0
)
echo:
curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/ytdlp-handler_win_x86.zip -o ytdlp-handler_win_x86.zip
powershell -command "Expand-Archive -Force '.\ytdlp-handler_win_x86.zip' '.\temp\'"
if exist start.cmd (
    del ".\start.cmd"
)
if exist start_win.cmd (
    del ".\start_win.cmd"
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
move ".\temp\start_win.cmd" ".\"
move ".\temp\changelog.txt" ".\"
if %RESETSET%==1 (
    if exist settings.ini (
        del ".\settings.ini"
    )
    move ".\temp\settings.ini" ".\"
)
RMDIR /s /q ".\temp"
del ".\ytdlp-handler_win_x86.zip"
echo:
echo Rename your update_new.bat file to update.bat!
pause
del ".\update.bat"
exit \b
:::Code by Sprinter05