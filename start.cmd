:::Code by Sprinter05
@echo off
:::Load ASCII Art
::::  __     _________            _____  _      _____      _    _          _   _ _____  _      ______ _____  
::::  \ \   / /__   __|          |  __ \| |    |  __ \    | |  | |   /\   | \ | |  __ \| |    |  ____|  __ \ 
::::   \ \_/ /   | |     ______  | |  | | |    | |__) |   | |__| |  /  \  |  \| | |  | | |    | |__  | |__) |
::::    \   /    | |    |______| | |  | | |    |  ___/    |  __  | / /\ \ | . ` | |  | | |    |  __| |  _  / 
::::     | |     | |             | |__| | |____| |        | |  | |/ ____ \| |\  | |__| | |____| |____| | \ \ 
::::     |_|     |_|             |_____/|______|_|        |_|  |_/_/    \_\_| \_|_____/|______|______|_|  \_\
::::                                                                                                         
::::                                                                                                            
for /f "delims=: tokens=*" %%A in ('findstr /b :::: "%~f0"') do @echo([1;31m%%A[0m

:::App information
echo [7mCMD file by Sprinter05[0m
echo Using: [4mhttps://github.com/yt-dlp/yt-dlp[0m and [4mhttps://github.com/FFmpeg/FFmpeg[0m
echo [0m

:::Check .ini file and set properties
for /f "delims== tokens=1,2" %%G in (settings.ini) do set %%G=%%H
set RLCMD=
if "%RATELIMIT%"=="1" (set RLCMD=--limit-rate)
set SPDCMD=
if "%RATELIMIT%"=="1" (set SPDCMD=%SPEED%)
set THMBCMD=
if "%THUMBNAIL%"=="1" (set THMBCMD=--embed-thumbnail)
set SUBTCMD=
if "%SUBTITLES%"=="1" (set SUBTCMD=--embed-subs --sub-langs all)
set MTDCMD=
if "%METADATA%"=="1" (set MTDCMD=--embed-metadata)
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

:::User inputs Link and Media format
echo [1;4m# Enter Youtube Link:[0m
set /p LINK="Link: "
echo [0m
echo [1;4m# Choose format [1:mp3, 2:wav, 3:ogg, 4:mp4, 5:mkv] (default is mp3):[0m
set /p FORMAT="Format: "
echo [0m

::Check format, run yt-dlp and open explorer if needed
if "%FORMAT%"=="" (
    yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    exit /b
)
if %FORMAT%==1 (
    yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    exit /b
)
if %FORMAT%==2 (
    yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format wav "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    exit /b
)
if %FORMAT%==3 (
    yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format vorbis "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    exit /b
)
if %FORMAT%==4 (
    yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% %SUBTCMD% --console-title -i -f "webm/bestvideo[height<=%VIDEOQUALITY%]+m4a/bestaudio" "%LINK%" %RMXCMD% "mp4" %DBGCMD% %PPCMD% %PPCMDARGS% -o "%VIDEODIR%/%%(title)s.%%(ext)s" -o "chapter:%VIDEODIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    pause
    if "%EXPLORER%"=="1" (explorer "%VIDEODIR2%")
    exit /b
)
if %FORMAT%==5 (
    yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %SUBTCMD% --console-title -i -f "webm/bestvideo[height<=%VIDEOQUALITY%]+m4a/bestaudio" "%LINK%" %DBGCMD% -o "%VIDEODIR%/%%(title)s.%%(ext)s" -o "chapter:%VIDEODIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    pause
    if "%EXPLORER%"=="1" (explorer "%VIDEODIR2%")
    exit /b
)
:::Works as a final else statement
if not "%FORMAT%"=="" if not %FORMAT%==1 if not %FORMAT%==2 if not %FORMAT%==3 if not %FORMAT%==4 if not %FORMAT%==5 (
    yt-dlp --no-playlist %RLCMD% %SPDCMD% %CHPTCMD% %MTDCMD% %THMBCMD% --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "%LINK%" --audio-quality %AUDIOQUALITY% %DBGCMD% -o "%MUSICDIR%/%%(title)s.%%(ext)s" -o "chapter:%MUSICDIR%/%%(section_title)s - %%(title)s.%%(ext)s"
    pause
    if "%EXPLORER%"=="1" (explorer "%MUSICDIR2%")
    exit /b
)