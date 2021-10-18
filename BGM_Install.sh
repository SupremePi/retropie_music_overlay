#!/usr/bin/env bash
# BGM_Install.sh
#############################################
# Install background music + overlay
#############################################
##### Install needed packages
sudo apt-get install imagemagick fbi python-pip python3-pip # to generate overlays
sudo pip install gdown
if sudo apt-get --simulate install python-pygame
then 
	sudo apt-get install python-pygame # to control music
else
	echo "

Unable to install python-pygame, please update your system (\"sudo apt-get upgrade && sudo apt-get update\") and then try running this script again!
	
	"
	exit
fi
cd ~
if [ -d "~/retropie_music_overlay" ]; then #delete folder if it is there
	echo "~/retropie_music_overlay Exsists. Now Removing ..."
	sudo rm -r ~/retropie_music_overlay
fi
currentuser=$(whoami) # Check user and then stop the script if root
if [[ $currentuser == "root" ]]; then
	echo "DON'T RUN THIS SCRIPT AS ROOT! USE './BGM_Install.sh' !"
	exit
fi
##### Download the files needed and install the script + utilities
git clone https://github.com/ALLRiPPED/retropie_music_overlay.git
cd ~/retropie_music_overlay
if [[ $currentuser == "pi" ]]; then #Use pngview if using Raspberry Pi
	sudo chmod +x pngview
	sudo cp pngview /usr/local/bin/
elif [[ $currentuser == "pigaming" ]]; then
	sudo apt-get install libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev # Install ODROID stuff
	git clone https://github.com/AreaScout/Gaming-Kit-Tools.git
	cd ~/retropie_music_overlay/Gaming-Kit-Tools
	make
	sudo make install
fi
cd ~/retropie_music_overlay/
sudo chmod +x BGM.py
sudo chmod +x bgmcustomoptions.sh
sudo chown $currentuser:$currentuser BGM.py
sudo chown $currentuser:$currentuser bgmcustomoptions.sh
sudo chmod 0777 BGM.py
sudo chmod 0777 bgmcustomoptions.sh
if [ ! -d  "~/RetroPie/roms/music/" ];
then
	mkdir /home/pi/RetroPie/roms/music/
else
	echo "~/RetroPie/roms/music Exists!"
fi	
if [ -f "~/BGM.py" ]; then #Remove old version if it is there
	rm -f ~/BGM.py
elif [ -f "~/RetroPie/roms/music/BGM.py" ]; then #Remove old version if it is there
	rm -f ~/RetroPie/roms/music/BGM.py
fi
cp BGM.py ~/RetroPie/roms/music/
gdown https://drive.google.com/uc?id=1hv2nXThZ5S4OkY-oLGKwMtjmfRYy2cFe
unzip -q bgm.zip -d ~/RetroPie && rm -f bgm.zip
##### Setting up Splash Screen
sudo sed -i -E "s/.*/\/home\/pi\/RetroPie\/splashscreens\/JarvisSplash.mp4/" /etc/splashscreen.list
##### Add pixel font
sudo mkdir -p /usr/share/fonts/opentype
sudo cp Pixel.otf /usr/share/fonts/opentype/
##### Add menu options for BGM toggles
cp backgroundmusic.png ~/RetroPie/retropiemenu/icons/
if [ -f "~/RetroPie/retropiemenu/bgmcustomoptions.sh" ]; # Remove old version if it is there
then
	sudo rm -f ~/RetroPie/retropiemenu/bgmcustomoptions.sh
fi
cp bgmcustomoptions.sh ~/RetroPie/retropiemenu/
if [ ! -s ~/RetroPie/retropiemenu/gamelist.xml ] # Remove gamelist.xml if file size is 0
then
	sudo rm -f ~/RetroPie/retropiemenu/gamelist.xml
fi
if [ ! -f "~/RetroPie/retropiemenu/gamelist.xml" ]; # If file doesn't exist, copy gamelist.xml to folder
then
	cp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml ~/RetroPie/retropiemenu/gamelist.xml
fi
CONTENT1="<game>\n<path>./bgmcustomoptions.sh</path>\n<name>Background Music Options</name>\n<desc>Toggles background music options such as music ON/OFF and volume control. Set and play MP3/OGG files during menu navigation in both Emulation Station and Attract Mode. A Few special new folders have been created in the /music directory called "arcade", "bttf", "st", "uvf", "venom", and this last one "custom" is for placing your own MP3/OGG files into. Once you place your music files into this folder and enable it, the music will automatically begin playing.</desc>\n<image>./icons/backgroundmusic.png</image>\n</game>"
C1=$(echo $CONTENT1 | sed 's/\//\\\//g')
if grep -q bgmcustomoptions.sh "/home/$currentuser/RetroPie/retropiemenu/gamelist.xml"; then # Check if menu entry is already there or not
	echo "gamelist.xml entry confirmed"
else
	sed "/<\/gameList>/ s/.*/${C1}\n&/" ~/RetroPie/retropiemenu/gamelist.xml > ~/temp
	cat ~/temp > ~/RetroPie/retropiemenu/gamelist.xml
	rm -f ~/temp
fi
cd ~/
sudo rm -r ~/retropie_music_overlay
##### Disable ODROID BGM script if it exists
if [ -a ~/scripts/bgm/start.sc ]; then
	pkill -STOP mpg123
	sudo rm ~/scripts/bgm/start.sc
fi
##### Explain stuff to the user
printf "\n\n\n"
echo "Place your music files in /home/$currentuser/RetroPie/roms/music/custom/"
echo "Edit /home/$currentuser/RetroPie/roms/music/BGM.py for more options!"
echo "You will still have to set up the script to run automatically when the device boots!"
echo "Run \"sudo nano /etc/rc.local\" Near the bottom, on the line above \"exit 0\", put the following code:

"
echo "su $currentuser -c 'python ~/RetroPie/roms/music/BGM.py &'

Press Control+X, Y, and Enter to save changes. Reboot and enjoy!

Example rc.local file: https://pastebin.com/E8NvrJJ1"
