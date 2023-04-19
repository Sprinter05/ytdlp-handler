:::Code by Sprinter05
@echo off
mode con: cols=120 lines=30
:::Load ASCII Art
::::  __     _________            _____  _      _____      _    _          _   _ _____  _      ______ _____  
::::  \ \   / /__   __|          |  __ \| |    |  __ \    | |  | |   /\   | \ | |  __ \| |    |  ____|  __ \ 
::::   \ \_/ /   | |     ______  | |  | | |    | |__) |   | |__| |  /  \  |  \| | |  | | |    | |__  | |__) |
::::    \   /    | |    |______| | |  | | |    |  ___/    |  __  | / /\ \ | . ` | |  | | |    |  __| |  _  / 
::::     | |     | |             | |__| | |____| |        | |  | |/ ____ \| |\  | |__| | |____| |____| | \ \ 
::::     |_|     |_|             |_____/|______|_|        |_|  |_/_/    \_\_| \_|_____/|______|______|_|  \_\
::::                                                                                                         
::::                                                                                                            
for /f "delims=: tokens=*" %%A in ('findstr /b :::: "%~f0"') do @echo(%%A

:::App information
echo CMD file by Sprinter05
echo Using: https://github.com/yt-dlp/yt-dlp and mhttps://github.com/FFmpeg/FFmpeg
echo:

:::Check .ini file and set properties
if not exist settings.ini (
    echo Configuration file settings.ini not found!
    pause
    exit /b
)
for /f "delims== tokens=1,2" %%G in (settings.ini) do set %%G=%%H

if "%LEGACY%"=="1" (
    echo LEGACY MODE IS ENABLED
    echo:
)
set RLCMD=
if "%RATELIMIT%"=="1" (set RLCMD=--limit-rate)
set SPDCMD=
if "%RATELIMIT%"=="1" (set SPDCMD=%SPEED%)
set THMBCMD=
if "%THUMBNAIL%"=="1" (set THMBCMD=--embed-thumbnail)
set SUBTCMD=
if "%SUBTITLES%"=="1" (
    if "%LEGACY%"=="1" (
        set SUBTCMD=--embed-subs --all-subs --sub-lang all
    ) else (
        set SUBTCMD=--embed-subs --sub-langs all
    )
)
set MTDCMD=
if "%METADATA%"=="1" (
    if "%LEGACY%"=="1" (
        set MTDCMD=--add-metadata
    ) else (
        set MTDCMD=--embed-metadata
    )
)
set CHPTCMD=
if "%CHAPTERS%"=="1" (set CHPTCMD=--split-chapters)
set PPCMD=
if "%POSTPROCESSING%"=="1" (set PPCMD=--postprocessor-args)
set PPCMDARGS=
if "%POSTPROCESSING%"=="1" (set PPCMDARGS=%PPARGS%)
set DBGCMD=
if "%DEBUG%"=="1" (set DBGCMD=--verbose)
set RMXCMD=
if "%REMUX%"=="1" (set RMXCMD=--remux-video) else (set RMXCMD=--recode-video)

:::Adapt dirs to \ format for explorer.exe
set MUSICDIR2=%MUSICDIR%
set MUSICDIR2=%MUSICDIR2:/=\%
set VIDEODIR2=%VIDEODIR%
set VIDEODIR2=%VIDEODIR2:/=\%

:::Check if binaries are present
if "%LEGACY%"=="1" (
    if not exist youtube-dl.exe (
        echo The youtube-dl.exe binary was not found!
        pause
        exit /b
    )
) else (
    if not exist yt-dlp.exe (
        echo The yt-dlp.exe binary was not found!
        pause
        exit /b
    )
)
if not exist ffmpeg.exe (
    echo The ffmpeg.exe binary was not found!
    pause
    exit /b
)
if not exist ffprobe.exe (
    echo The ffprobe.exe binary was not found!
    pause
    exit /b
)

:::Check and compare local and online versions through changelog.txt and github API
if "%CHECKUPD%"=="1" (
    if exist changelog.txt (
        goto :CheckUpdate
    ) else (
        echo Missing changelog.txt file! Cannot check for updates.
        echo:
        goto :ActualProgram
    )
) else (
    goto :ActualProgram
)

:CheckUpdate
set "currver="
for /F "skip=3 delims=" %%i in (changelog.txt) do (
    if not defined currver (
        set "currver=%%i"
    )
)
for /F %%i in ('powershell -command "((Invoke-WebRequest -Uri https://api.github.com/repos/Sprinter05/ytdlp-handler/releases/latest).Content | ConvertFrom-Json).tag_name"') do (
    set "onlinever=%%i"
)
echo Local version is %currver:~0,3%. Online version is %onlinever%.
if "%onlinever%"=="%currver:~0,3%" (
    echo The ytdlp-handler program is up to date.
) else (
    echo There is a new ytdlp-handler update available.
)
echo:
goto :ActualProgram

:::User inputs Link and Media format
:ActualProgram
echo # Enter Youtube Link:
set /p LINK="Link: "
echo:
echo # Choose format [1:mp3, 2:wav, 3:ogg, 4:mp4, 5:mkv] (default is mp3):
set /p FORMAT="Format: "
echo:

:::Check format, run yt-dlp and open explorer if needed
if "%FORMAT%"=="" (
    if "%LEGACY%"=="1" (
        youtube-dl --no-playlist %RLCMD% %SPDCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s"
    ) else (
        yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    )
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    if "%REOPEN%"=="1" (
        cls
        call "start_win.cmd"
    )
    exit /b
)
if %FORMAT%==1 (
    if "%LEGACY%"=="1" (
        youtube-dl --no-playlist %RLCMD% %SPDCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s"
    ) else (
        yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    )
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    if "%REOPEN%"=="1" (
        cls
        call "start_win.cmd"
    )
    exit /b
)
if %FORMAT%==2 (
    if "%LEGACY%"=="1" (
        youtube-dl --no-playlist %RLCMD% %SPDCMD% %MTDCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format wav "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s"
    ) else (
        yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format wav "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    )
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    if "%REOPEN%"=="1" (
        cls
        call "start_win.cmd"
    )
    exit /b
)
if %FORMAT%==3 (
    if "%LEGACY%"=="1" (
        youtube-dl --no-playlist %RLCMD% %SPDCMD% %MTDCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format vorbis "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s"
    ) else (
        yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format vorbis "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    )
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    if "%REOPEN%"=="1" (
        cls
        call "start_win.cmd"
    )
    exit /b
)
if %FORMAT%==4 (
    if "%LEGACY%"=="1" (
        youtube-dl --no-playlist %RLCMD% %SPDCMD% %MTDCMD% %SUBTCMD% --console-title -i -f "bestvideo[ext=webm][height<=?%VIDEOQUALITY%]+bestaudio[ext=m4a]" "%LINK%" --recode-video "mp4" %DBGCMD% %PPCMD% %PPCMDARGS% -o "%VIDEODIR%/%%(title)s.%%(ext)s"
    ) else (
        yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% %SUBTCMD% --console-title -i -f "webm/bestvideo[height<=%VIDEOQUALITY%]+m4a/bestaudio" "%LINK%" %RMXCMD% "mp4" %DBGCMD% %PPCMD% %PPCMDARGS% -o "%VIDEODIR%/%%(title)s.%%(ext)s" -o "chapter:%VIDEODIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    )
    pause
    if "%EXPLORER%"=="1" (explorer "%VIDEODIR2%")
    if "%REOPEN%"=="1" (
        cls
        call "start_win.cmd"
    )
    exit /b
)
if %FORMAT%==5 (
    if "%LEGACY%"=="1" (
        youtube-dl --no-playlist %RLCMD% %SPDCMD% %MTDCMD% %SUBTCMD% --console-title -i -f "bestvideo[ext=webm][height<=?%VIDEOQUALITY%]+bestaudio[ext=m4a]" "%LINK%" %DBGCMD% -o "%VIDEODIR%/%%(title)s.%%(ext)s"
    ) else (
        yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %SUBTCMD% --console-title -i -f "webm/bestvideo[height<=%VIDEOQUALITY%]+m4a/bestaudio" "%LINK%" %DBGCMD% -o "%VIDEODIR%/%%(title)s.%%(ext)s" -o "chapter:%VIDEODIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    )
    pause
    if "%EXPLORER%"=="1" (explorer "%VIDEODIR2%")
    if "%REOPEN%"=="1" (
        cls
        call "start_win.cmd"
    )
    exit /b
)
:::Works as a final else statement
if not "%FORMAT%"=="" if not %FORMAT%==1 if not %FORMAT%==2 if not %FORMAT%==3 if not %FORMAT%==4 if not %FORMAT%==5 (
    if "%LEGACY%"=="1" (
        youtube-dl --no-playlist %RLCMD% %SPDCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s"
    ) else (
        yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    )
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    if "%REOPEN%"=="1" (
        cls
        call "start_win.cmd"
    )
    exit /b
)