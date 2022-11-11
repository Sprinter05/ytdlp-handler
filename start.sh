echo -e "\e[1;31m  __     _________            _____  _      _____      _    _          _   _ _____  _      ______ _____   \e[0m"
echo -e "\e[1;31m  \ \   / /__   __|          |  __ \| |    |  __ \    | |  | |   /\   | \ | |  __ \| |    |  ____|  __ \  \e[0m"
echo -e "\e[1;31m   \ \_/ /   | |     ______  | |  | | |    | |__) |   | |__| |  /  \  |  \| | |  | | |    | |__  | |__) | \e[0m"
echo -e "\e[1;31m    \   /    | |    |______| | |  | | |    |  ___/    |  __  | / /\ \ | . \` | |  | | |    |  __| |  _  /  \e[0m"
echo -e "\e[1;31m     | |     | |             | |__| | |____| |        | |  | |/ ____ \| |\  | |__| | |____| |____| | \ \  \e[0m"
echo -e "\e[1;31m     |_|     |_|             |_____/|______|_|        |_|  |_/_/    \_\_| \_|_____/|______|______|_|  \_\ \e[0m"
echo -e "\e[1;31m                                                                                                          \e[0m"
echo -e "Using: \e[4mhttps://github.com/yt-dlp/yt-dlp\e[0m and \e[4mhttps://github.com/FFmpeg/FFmpeg\e[0m"
echo -e "\e[0m"

# PROGRAM SETTINGS
eval $(grep VIDEODIR settings.ini)
eval $(grep MUSICDIR settings.ini)
eval $(grep EXPLORER settings.ini)

# YOUTUBE DOWNLOAD
eval $(grep RATELIMIT settings.ini)
eval $(grep SPEED settings.ini)
eval $(grep VIDEOQUALITY settings.ini)
eval $(grep THUMBNAIL settings.ini)
eval $(grep SUBTITLES settings.ini)
eval $(grep METADATA settings.ini)
eval $(grep CHAPTERS settings.ini)

# VIDEO PROCESSING
eval $(grep REMUX settings.ini)
eval $(grep POSTPROCESSING settings.ini)
eval $(grep PPARGS settings.ini)
eval $(grep DEBUG settings.ini)

# AUDIO PROCESSING
eval $(grep AUDIOQUALITY settings.ini)

RLCMD=""
SPDCMD=""
if [ $RATELIMIT == 1 ]; then
	RLCMD="--limit-rate"
	SPDCMD=$SPEED
fi

THMBCMD=""
if [ $THUMBNAIL == 1 ]; then
	THMBCMD="--embed-thumbnail"
fi
SUBTCMD=""
if [ $SUBTITLES == 1 ]; then
	SUBTCMD="--embed-subs"
fi
MTDCMD=""
if [ $METADATA == 1 ]; then
	MTDCMD="--embed-metadata"
fi
CHPTCMD=""
if [ $CHAPTERS == 1 ]; then
	CHPTCMD="--split-chapters"
fi

PPCMD=""
PPCMDARGS=""
if [ $POSTPROCESSING == 1 ]; then
	PPCMD="--postprocessor-args"
	PPCMDARGS=$PPARGS
fi

DBGCMD=""
if [ $DEBUG == 1 ]; then
	DBGCMD="--verbose"
fi

RMXCMD=""
if [ $REMUX == 1 ]; then
	RMXCMD="--remux-video"
else
	RMXCMD="--recode-video"
fi

echo -e "\e[1;4m# Enter Youtube Link:\e[0m"
read -p "Link: " LINK
echo -e "\e[0m"
echo -e "\e[1;4m# Choose format [1:mp3, 2:wav, 3:ogg, 4:mp4, 5:mkv] (default is mp3):\e[0m"
read -p "Format: " FORMAT
echo -e "\e[0m"

ALWAYSINCCMD="$RLCMD $SPDCMD $CHPTCMD $MTDCMD"

EXPLORERDIR=$MUSICDIR

if [ "$FORMAT" == "" ]; then
	yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
elif [ $FORMAT -eq 1 ]; then
	yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
elif [ $FORMAT -eq 2 ]; then
	yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD --console-title -i -f "m4a/bestaudio" -x --audio-format wav "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
elif [ $FORMAT -eq 3 ]; then
	 yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format vorbis "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
elif [ $FORMAT -eq 4 ]; then
	 yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD $SUBTCMD --console-title -i -f "webm/bestvideo[height<=$VIDEOQUALITY]+m4a/bestaudio" "$LINK" $RMXCMD "mp4" $DBGCMD $PPCMD $PPCMDARGS -o "$VIDEODIR/%(title)s.%(ext)s" -o "chapter:$VIDEODIR/%(section_title)s - %(title)s.%(ext)s"
	 EXPLORERDIR=$VIDEODIR
elif [ $FORMAT -eq 5 ]; then
	yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $SUBTCMD --console-title -i -f "webm/bestvideo[height<=$VIDEOQUALITY]+m4a/bestaudio" "$LINK" $DBGCMD -o "$VIDEODIR/%(title)s.%(ext)s" -o "chapter:$VIDEODIR/%(section_title)s - %(title)s.%(ext)s"
	 EXPLORERDIR=$VIDEODIR
else
	yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
fi

if [ $EXPLORER -eq 1 ]; then
	if [ -f "/usr/bin/xdg-open" ]; then
		read -p "Opening file browser... "
		xdg-open $EXPLORERDIR
	else
		cd $EXPLORERDIR
	fi
fi
# Initial code by Sprinter05, SH port by Tulip
