# do the art thing
echo -e "\e[1;31m  __     _________            _____  _      _____      _    _          _   _ _____  _      ______ _____   \e[0m"
echo -e "\e[1;31m  \ \   / /__   __|          |  __ \| |    |  __ \    | |  | |   /\   | \ | |  __ \| |    |  ____|  __ \  \e[0m"
echo -e "\e[1;31m   \ \_/ /   | |     ______  | |  | | |    | |__) |   | |__| |  /  \  |  \| | |  | | |    | |__  | |__) | \e[0m"
echo -e "\e[1;31m    \   /    | |    |______| | |  | | |    |  ___/    |  __  | / /\ \ | . \` | |  | | |    |  __| |  _  /  \e[0m"
echo -e "\e[1;31m     | |     | |             | |__| | |____| |        | |  | |/ ____ \| |\  | |__| | |____| |____| | \ \  \e[0m"
echo -e "\e[1;31m     |_|     |_|             |_____/|______|_|        |_|  |_/_/    \_\_| \_|_____/|______|______|_|  \_\ \e[0m"
echo -e "\e[1;31m                                                                                                          \e[0m"
echo -e "\e[7mSH file by Tulip\e[0m"
echo -e "Using: \e[4mhttps://github.com/yt-dlp/yt-dlp\e[0m and \e[4mhttps://github.com/FFmpeg/FFmpeg\e[0m"
echo -e "\e[0m"

# Get values from settings..
## PROGRAM SETTINGS
eval $(grep LEGACY settings.ini)
eval $(grep VIDEODIR settings.ini)
eval $(grep MUSICDIR settings.ini)
eval $(grep EXPLORER settings.ini)

## YOUTUBE DOWNLOAD
eval $(grep RATELIMIT settings.ini)
eval $(grep SPEED settings.ini)
eval $(grep VIDEOQUALITY settings.ini)
eval $(grep THUMBNAIL settings.ini)
eval $(grep SUBTITLES settings.ini)
eval $(grep METADATA settings.ini)
eval $(grep CHAPTERS settings.ini)

## VIDEO PROCESSING
eval $(grep REMUX settings.ini)
eval $(grep POSTPROCESSING settings.ini)
eval $(grep PPARGS settings.ini)
eval $(grep DEBUG settings.ini)

## AUDIO PROCESSING
eval $(grep AUDIOQUALITY settings.ini)

# Check if settings.ini exists
if ! [ -f "settings.ini" ]; then
	echo -e "Configuration file settings.ini not found!"
	pause
	exit
fi

#Check if LEGACY is enabled
if [ $LEGACY == 1 ]; then
	echo -e "\e[7mLEGACY MODE IS ENABLED\e[0m"
	echo -e "\e[0m"
fi

# Setup CMDs
RLCMD=""
SPDCMD=""
if [ $RATELIMIT == 1 ]; then
	RLCMD="--limit-rate" # Download speed limit
	SPDCMD=$SPEED
fi

THMBCMD=""
if [ $THUMBNAIL == 1 ]; then
	THMBCMD="--embed-thumbnail" # Thumbnails lets GOOOOOOO
fi
SUBTCMD=""
if [ $SUBTITLES == 1 ]; then # Subtitles
	if [ $LEGACY == 1 ]; then
		SUBTCMD="--embed-subs --all-subs --sub-lang all"
	else
		SUBTCMD="--embed-subs"
	fi
fi
MTDCMD=""
if [ $METADATA == 1 ]; then  # This goofs up on .ogg. I do love me 8 digit year
	if [ $LEGACY == 1 ]; then
		MTDCMD="--add-metadata"
	else
		MTDCMD="--embed-metadata"
	fi
fi
CHPTCMD=""
if [ $CHAPTERS == 1 ]; then
	CHPTCMD="--split-chapters" # Chapters. Who even wants this?
fi

PPCMD=""
PPCMDARGS=""
if [ $POSTPROCESSING == 1 ]; then
	PPCMD="--postprocessor-args" # pleasedontsayit pleasedontsayit pleasedontsayit pleasedontsayit pleasedontsayit
	PPCMDARGS=$PPARGS
fi

DBGCMD=""
if [ $DEBUG == 1 ]; then
	DBGCMD="--verbose" # Make errors be helpful
fi

RMXCMD=""
if [ $REMUX == 1 ]; then
	RMXCMD="--remux-video" # Speedy
else
	RMXCMD="--recode-video" # Not speedy
fi

# Check if dependencies are installed
if [ $LEGACY == 1 ]: then
	echo -n "Checking dependencies... "
	for name in youtube-dl ffmpeg
	do
  	[[ $(which $name 2>/dev/null) ]] || { echo -en "\n$name needs to be installed. Use 'sudo apt-get install $name'";deps=1; }
	done
	[[ $deps -ne 1 ]] && echo "OK" || { echo -en "\nInstall the above and rerun this script\n";exit 1; }
else
	echo -n "Checking dependencies... "
	for name in yt-dlp ffmpeg
	do
  	[[ $(which $name 2>/dev/null) ]] || { echo -en "\n$name needs to be installed. Use 'sudo apt-get install $name'";deps=1; }
	done
	[[ $deps -ne 1 ]] && echo "OK" || { echo -en "\nInstall the above and rerun this script\n";exit 1; }
fi

# Get the link and format
echo -e "\e[1;4m# Enter Youtube Link:\e[0m"
read -p "Link: " LINK
echo -e "\e[0m"
echo -e "\e[1;4m# Choose format [1:mp3, 2:wav, 3:ogg, 4:mp4, 5:mkv] (default is mp3):\e[0m"
read -p "Format: " FORMAT
echo -e "\e[0m"

# Convenience :sparkles:
ALWAYSINCCMD="$RLCMD $SPDCMD $CHPTCMD $MTDCMD"

EXPLORERDIR=$MUSICDIR

# Ugly if elif else block
if [ "$FORMAT" == "" ]; then
	if [ $LEGACY == 1 ]; then
		youtube-dl --no-playlist $RLCMD $SPDCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s"
	else
		yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
	fi
elif [ $FORMAT -eq 1 ]; then
	if [ $LEGACY == 1 ]; then
		youtube-dl --no-playlist $RLCMD $SPDCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s"
	else
		yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
	fi
elif [ $FORMAT -eq 2 ]; then
	if [ $LEGACY == 1 ]; then
		youtube-dl --no-playlist $RLCMD $SPDCMD $MTDCMD --console-title -i -f "m4a/bestaudio" -x --audio-format wav "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s"
	else
		yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD --console-title -i -f "m4a/bestaudio" -x --audio-format wav "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
	fi
elif [ $FORMAT -eq 3 ]; then
	if [ $LEGACY == 1 ]; then
		youtube-dl --no-playlist $RLCMD $SPDCMD $MTDCMD --console-title -i -f "m4a/bestaudio" -x --audio-format vorbis "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s"
	else
		yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format vorbis "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
	fi
elif [ $FORMAT -eq 4 ]; then
	if [ $LEGACY == 1 ]; then
		youtube-dl --no-playlist $RLCMD $SPDCMD $MTDCMD $SUBTCMD --console-title -i -f "webm/bestvideo[height<=$VIDEOQUALITY]+m4a/bestaudio" "$LINK" $RMXCMD "mp4" $DBGCMD $PPCMD $PPCMDARGS -o "$VIDEODIR/%(title)s.%(ext)s"
	else
		yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD $SUBTCMD --console-title -i -f "webm/bestvideo[height<=$VIDEOQUALITY]+m4a/bestaudio" "$LINK" $RMXCMD "mp4" $DBGCMD $PPCMD $PPCMDARGS -o "$VIDEODIR/%(title)s.%(ext)s" -o "chapter:$VIDEODIR/%(section_title)s - %(title)s.%(ext)s"
	fi
	EXPLORERDIR=$VIDEODIR
elif [ $FORMAT -eq 5 ]; then	
	if [ $LEGACY == 1 ]; then
		youtube-dl --no-playlist $RLCMD $SPDCMD $MTDCMD $SUBTCMD --console-title -i -f "webm/bestvideo[height<=$VIDEOQUALITY]+m4a/bestaudio" "$LINK" $DBGCMD -o "$VIDEODIR/%(title)s.%(ext)s"
	else
		# Rip anyone who uses a 6 month old version of yt-dlp
		yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $SUBTCMD --console-title -i -f "webm/bestvideo[height<=$VIDEOQUALITY]+m4a/bestaudio" "$LINK" $DBGCMD -o "$VIDEODIR/%(title)s.%(ext)s" -o "chapter:$VIDEODIR/%(section_title)s - %(title)s.%(ext)s"
	fi
	EXPLORERDIR=$VIDEODIR
else
	if [ $LEGACY == 1 ]; then
		youtube-dl --no-playlist $RLCMD $SPDCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s"
	else
		yt-dlp --no-playlist $RLCMD $SPDCMD $CHPTCMD $MTDCMD $THMBCMD --console-title -i -f "m4a/bestaudio" -x --audio-format mp3 "$LINK" --audio-quality $AUDIOQUALITY $DBGCMD -o "$MUSICDIR/%(title)s.%(ext)s" -o "chapter:$MUSICDIR/%(section_title)s - %(title)s.%(ext)s"
	fi
fi

if [ $EXPLORER -eq 1 ]; then
	# If no xdg-utils, experience pain by the power of cd-skull
	if [ -f "/usr/bin/xdg-open" ]; then
		read -p "Opening file browser... "
		xdg-open $EXPLORERDIR
	else
		cd $EXPLORERDIR
	fi
fi
# Initial code by Sprinter05, SH port by Tulip
