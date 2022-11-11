@echo off
echo Would you like to update ytdlp-handler from the lastest release? [y/n]
set /p ANSWER=": "
echo:
if "%ANSWER%"=="y" (
    curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/start.cmd -o start.cmd
    echo Done!
    echo:
    echo Would you like to overwrite your settings with the default template? [y/n]
    set /p ANSWER2=": "
    echo:
    if "%ANSWER2%"=="y" (
        curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/settings.ini -o settings.ini
        echo Done!
        echo:
        pause
        exit /b
    )
) else (
    pause
    exit /b
)
:::Code by Sprinter05