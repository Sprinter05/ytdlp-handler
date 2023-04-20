# sprinter skill issue

if [ -f /etc/ytdlp-handler.d/dnu ]; then
	echo "ytdlp-handler is being managed by your system package manager and therefore, this updater cannot be used."
	exit 1
fi

# Fix name problems
if [ -f update_new.sh ]; then
	echo "Update completed! Remember to run start.sh to start the program."
	rm "./update.sh"
	mv "./update_new.sh" "update.sh"
	echo "Ensure that FFMPEG and ytdlp are installed and up to date via your package manager"
	exit
fi

# Ask for default user settings reset
echo "Would you like to reset your curmvt settings to their default values? [y/N]"
read DFSET
if [ "$DFSET" == "y" ]; then
	RESETSET=1
else
	RESETSET=0
fi

# Download main program files from a .zip and do all the file manipulation

echo "Downloading main files from https://github.com/Sprinter05/ytdlp-handler/releases/latest..."
curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/ytdlp-handler_linux.zip -o ./ytdlp-handler_linux.zip.zip

if unzip ./ytdlp-handler_linux.zip -d ./temp ; then
	echo "Unzipped to ./temp"
	rm ./ytdlp-handler_linux.zip
else
	echo "Unzip failed. Aborting..."
	exit 65
fi

if [ -f "start.sh" ]; then
	rm "./start.sh"
fi
if [ -f changelog.txt ]; then
	rm "./changelog.txt"
fi
mv "./temp/update.sh" "update_new.sh"
mv "./temp/start.sh" "./"
mv "./temp/changelog.txt" "./"

# License moment
if [ -f "LICENSE" ]; then
	rm "./LICENSE"
fi

curl -L https://raw.githubusercontent.com/Sprinter05/ytdlp-handler/main/LICENSE -o LICENSE

# Reset settings to default if user agreed to do so
if [ $RESETSET == 1 ]; then
	echo Resetting settings to default values...
	if [ -f "settings.ini" ]; then
		rm "./settings.ini"
	fi
	mv "./temp/settings.ini" "./"
fi

rm -r ./temp

bash "update_new.sh"
# Code by Sprinter05
