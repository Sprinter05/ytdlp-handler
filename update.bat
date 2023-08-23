@echo off

::Check and save Windows version
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

::Fix name problems
if exist update_new.bat (
    echo Update completed! Remember to run start.cmd to start the program.
    del ".\update.bat"
    pause
    ren ".\update_new.bat" "update.bat"
    exit /b
)

::Important Warn Message
echo:
echo PLEASE READ CAREFULLY BEFORE CHOOSING
echo:

::Ask for yt-dlp binary version
echo Would you like the standalone yt-dlp binary [1] or the x86 binary [2] or would you prefer not to update the yt-dlp binary [3]? (Use the x86 binary ONLY if you have issues with the standalone one) [1/2/3] (default is 1)
set /p DFSET="> "
if "%DFSET%"=="2" (
    set STDBINARY=0
) else (
    set STDBINARY=1
)
if "%DFSET%"=="3" (
    set UPDBINYT=0
) else (
    set UPDBINYT=1
)

::Download new yt-dlp binary through curl if needed
if %UPDBINYT%==1 (
    echo:
    echo Downloading yt-dlp.exe from https://github.com/yt-dlp/yt-dlp...
    if exist yt-dlp.exe (
        del "yt-dlp.exe"
    )
    if %STDBINARY%==1 (
        curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -o yt-dlp.exe
    ) else (
        curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_x86.exe -o yt-dlp.exe
    )
)

::Ask for default user settings reset
echo:
echo Would you like to reset your current settings to their default values? [y/n] (default is n)
set /p DFSET="> "
if "%DFSET%"=="y" (
set RESETSET=1
) else (
    set RESETSET=0
)

::Download main program files from a .zip and do all the file manipulation
echo:
echo Downloading main files from https://github.com/Sprinter05/ytdlp-handler/releases/latest...
curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/ytdlp-handler_win_x86.zip -o ytdlp-handler_win_x86.zip
powershell -command "Expand-Archive -Force '.\ytdlp-handler_win_x86.zip' '.\temp\'"
if exist start.cmd (
    del ".\start.cmd"
)
if exist start_win.cmd (
    del ".\start_win.cmd"
)
if exist changelog.txt (
    del ".\changelog.txt"
)
ren ".\temp\update.bat" "update_new.bat"
move ".\temp\update_new.bat" ".\"
if "%version%" == "10.0" (
    move ".\temp\start.cmd" ".\"
) else (
    move ".\temp\start_win.cmd" ".\"
    ren ".\start_win.cmd" "start.cmd"
)
move ".\temp\changelog.txt" ".\"

::License moment
if not exist LICENSE (
    del ".\LICENSE"
)
curl -L https://raw.githubusercontent.com/Sprinter05/ytdlp-handler/main/LICENSE -o LICENSE

::Reset settings to default if user agreed to do so
echo:
echo Resetting settings to default values...
if %RESETSET%==1 (
    if exist settings.ini (
        del ".\settings.ini"
    )
    move ".\temp\settings.ini" ".\"
)
RMDIR /s /q ".\temp"
del ".\ytdlp-handler_win_x86.zip"
echo Done

:Normal
cls
call "update_new.bat"
exit \b
:::Code by Sprinter05