@echo off
echo PLEASE READ CAREFULLY BEFORE CHOOSING

::Ask user for parameters
echo:
echo Would you like the standalone yt-dlp binary [1] or the x86 binary [2]? (Use the x86 binary ONLY if you have issues with the standalone one) [1/2]
set /p DFSET="> "
if "%DFSET%"=="1" (
set STDBINARY=1
) else (
    set STDBINARY=0
)
echo:
echo Are you using Windows 10/11 [1] or an older version [2]? [1/2]
set /p WINV="> "
if "%WINV%"=="1" (
set STARTFILE=1
) else (
    set STARTFILE=0
)

::Download yt-dlp win binary
echo:
echo Downloading yt-dlp.exe from [4mhttps://github.com/yt-dlp/yt-dlp[0m...
MKDIR "./ytdlp-handler"
if %STDBINARY%==1 (
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -o ./ytdlp-handler/yt-dlp.exe
) else (
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_x86.exe -o ./ytdlp-handler/yt-dlp.exe
)

::Download ffmpeg binaries
echo:
echo Downloading ffmpeg.exe and ffprobe.exe from [4mhttps://github.com/BtbN/FFmpeg-Builds/releases[0m...
curl -L https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-win64-gpl.zip -o ./ytdlp-handler/ffmpeg.zip
powershell -command "Expand-Archive -Force '.\ytdlp-handler\ffmpeg.zip' '.\ytdlp-handler\ffmpeg\'"
move ".\ytdlp-handler\ffmpeg\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe" ".\ytdlp-handler\"
move ".\ytdlp-handler\ffmpeg\ffmpeg-master-latest-win64-gpl\bin\ffprobe.exe" ".\ytdlp-handler\"
RMDIR /s /q ".\ytdlp-handler\ffmpeg"
del ".\ytdlp-handler\ffmpeg.zip"

::FFMPEG Licenses stuff
echo:
echo Downloading ffmpeg licenses from [4mhttps://github.com/FFmpeg/FFmpeg[0m...
mkdir ".\ytdlp-handler\ffmpeg_licenses"
curl -L https://raw.githubusercontent.com/FFmpeg/FFmpeg/master/COPYING.GPLv2 -o .\ytdlp-handler\ffmpeg_licenses\COPYING.GPLv2
curl -L https://raw.githubusercontent.com/FFmpeg/FFmpeg/master/COPYING.GPLv3 -o .\ytdlp-handler\ffmpeg_licenses\COPYING.GPLv3
curl -L https://raw.githubusercontent.com/FFmpeg/FFmpeg/master/COPYING.LGPLv2.1 -o .\ytdlp-handler\ffmpeg_licenses\COPYING.LGPLv2.1
curl -L https://raw.githubusercontent.com/FFmpeg/FFmpeg/master/COPYING.LGPLv3 -o .\ytdlp-handler\ffmpeg_licenses\COPYING.LGPLv3

::Download main files from project repo
echo:
echo Downloading main files from [4mttps://github.com/Sprinter05/ytdlp-handler/releases/latest[0m...
curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/ytdlp-handler_win_x86.zip -o ./ytdlp-handler/ytdlp-handler_win_x86.zip
powershell -command "Expand-Archive -Force '.\ytdlp-handler\ytdlp-handler_win_x86.zip' '.\ytdlp-handler\temp\'"
move ".\ytdlp-handler\temp\update.bat" ".\ytdlp-handler\"
move ".\ytdlp-handler\temp\settings.ini" ".\ytdlp-handler\"
move ".\ytdlp-handler\temp\changelog.txt" ".\ytdlp-handler\"
if %STARTFILE%==1 (
    move ".\ytdlp-handler\temp\start.cmd" ".\ytdlp-handler\"
) else (
    move ".\ytdlp-handler\temp\start_win.cmd" ".\ytdlp-handler\"
    ren ".\ytdlp-handler\start_win.cmd" "start.cmd"
)
RMDIR /s /q ".\ytdlp-handler\temp"
del ".\ytdlp-handler\ytdlp-handler_win_x86.zip"

::License moment
curl -L https://raw.githubusercontent.com/Sprinter05/ytdlp-handler/main/LICENSE -o .\ytdlp-handler\LICENSE

::Kill program
echo:
echo Open the start.cmd file inside the ytdlp-handler folder to run the program!
pause
del ".\setup.bat"
exit \b
:::Code by Sprinter05