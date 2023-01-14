#s printer skill issue
if [ -f update_new.sh ]; then
	echo Rename this file to update.sh!
	read -p "Press enter to continue... "
	exit
fi

echo "Would you like to reset your current settings to their default values? [y/n]"
read -p "> " DFSET
if [ "$DFSET" == "y" ]; then
	RESETSET=1
else
	RESETSET=0
fi
echo ""

curl -L https://github.com/Sprinter05/ytdlp-handler/releases/latest/download/ytdlp-handler_linux.zip -o ytdlp-handler_linux.zip
mkdir temp
unzip ytdlp-handler_linux.zip -d ./temp/
if [ -f "start.sh" ]; then
	rm "./start.sh"
fi
if [ -f "changelog.txt" ]; then
	rm "./changelog.txt"
fi
mv "./temp/update.sh" "update_new.sh"
mv "./temp/start.sh" "./"
mv "./temp/changelog.txt" "./"
if [ $RESETSET == 1 ]; then
	if [ -f settings.ini ]; then
		rm "./settings.ini"
	fi
	mv "./temp/settings.ini" "./"
fi
rm -r "./temp"
rm "./ytdlp-handler_linux.zip"
echo
read -p "Rename your update_new.sh file to update.sh! "
rm "./update.sh"
# Code by Sprinter05
