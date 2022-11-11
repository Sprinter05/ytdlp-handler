# CURL TIME WOOOOOOOOOOOOO0000OOOO)o0o0o0o0o0
CSHA=$(sha512sum start.sh)
ONLINESHA=$(curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/start.sh.sha512)

if [[ "$CSHA" != "$ONLINESHA" ]]; then
	curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/start.sh -o start.sh
	if [ -f settings.ini ]; then
		curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/settings.ini -o nsettings.ini
		echo "New version of start.sh and settings.ini have been downloaded.\nTo apply the new settings, replace settings.ini with nsettings.ini"
	else
		curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/settings.ini -o settings.ini # Where'd your settings go
	fi
else
	echo "You already have the latest version."
fi
s
