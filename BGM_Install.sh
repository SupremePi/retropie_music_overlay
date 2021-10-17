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
sudo chown $currentuser:$currentuser BGM.py
sudo chmod 0777 BGM.py
if [ ! -d  "~/RetroPie/roms/music/" ];
then
	mkdir ~/RetroPie/roms/music/
else
	echo "~/RetroPie/retropiemenu/audiotools Exists!"
fi	
if [ -f "~/BGM.py" ]; then #Remove old version if it is there
	rm -f ~/BGM.py
elif [ -f "~/RetroPie/roms/music/BGM.py" ]; then #Remove old version if it is there
	rm -f ~/RetroPie/roms/music/BGM.py
fi
cp BGM.py ~/RetroPie/roms/music/
gdown https://drive.google.com/uc?id=1hv2nXThZ5S4OkY-oLGKwMtjmfRYy2cFe
unzip -q bgm.zip -d ~/retropie_music_overlay && rm -f bgm.zip
mv -f ~/retropie_music_overlay/music/* ~/RetroPie/roms/music

##### Setting up Splash Screen
cp ~/retropie_music_overlay/splashscreens/JarvisSplash.mp4 ~/RetroPie/splashscreens/
sudo mv -f ~/retropie_music_overlay/splashscreens/splashscreen.list /etc/

##### Add pixel font
sudo mkdir -p /usr/share/fonts/opentype
sudo cp Pixel.otf /usr/share/fonts/opentype/

##### Add menu options for BGM toggles
cp backgroundmusic.png ~/RetroPie/retropiemenu/icons/
sudo chmod +x backgroundmusic.sh
sudo chmod +x custombgmoptions.sh
sudo chown $currentuser:$currentuser backgroundmusic.sh
sudo chown $currentuser:$currentuser custombgmoptions.sh
sudo chmod 0777 backgroundmusic.sh
sudo chmod 0777 custombgmoptions.sh
CONTENT1="	<game>\n<path>./audiotools</path>\n<name>Audio Tools</name>\n<desc>Audio Tools and More Options.</desc>\n<image>./icons/audiosettings.png</image>\n</game>"
C1=$(echo $CONTENT1 | sed 's/\//\\\//g')
if [ ! -d  "~/RetroPie/retropiemenu/audiotools/" ];
then
	mkdir ~/RetroPie/retropiemenu/audiotools/
	if grep -q /audiotools "/home/$currentuser/RetroPie/retropiemenu/gamelist.xml"; then # Check if menu entry is already there or not
		echo "gamelist.xml entry confirmed"
	else
		sed "/<\/gameList>/ s/.*/${C1}\n&/" ~/RetroPie/retropiemenu/gamelist.xml > ~/temp
		cat ~/temp > ~/RetroPie/retropiemenu/gamelist.xml
		rm -f ~/temp
fi
else
	echo "~/RetroPie/retropiemenu/audiotools Exists!"
fi

if [ -f "~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh" ]; # Remove old version if it is there
then
	sudo rm -f ~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh
fi
cp backgroundmusic.sh ~/RetroPie/retropiemenu/audiotools/
if [ -f "~/RetroPie/retropiemenu/audiotools/custombgmoptions.sh" ]; # Remove old version if it is there
then
	sudo rm -f ~/RetroPie/retropiemenu/audiotools/custombgmoptions.sh
fi
cp custombgmoptions.sh ~/RetroPie/retropiemenu/audiotools/


if [ ! -s ~/RetroPie/retropiemenu/gamelist.xml ] # Remove gamelist.xml if file size is 0
then
	sudo rm -f ~/RetroPie/retropiemenu/gamelist.xml
fi
if [ ! -f "~/RetroPie/retropiemenu/gamelist.xml" ]; # If file doesn't exist, copy gamelist.xml to folder
then
	cp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml ~/RetroPie/retropiemenu/gamelist.xml
fi

CONTENT2="<game>\n<path>./audiotools/backgroundmusic.sh</path>\n<name>Background Music</name>\n<desc>Toggles background music options such as music ON/OFF and volume control.</desc>\n<image>./icons/backgroundmusic.png</image>\n</game>"
C2=$(echo $CONTENT2 | sed 's/\//\\\//g')
if grep -q backgroundmusic.sh "/home/$currentuser/RetroPie/retropiemenu/gamelist.xml"; then # Check if menu entry is already there or not
	echo "gamelist.xml entry confirmed"
else
	sed "/<\/gameList>/ s/.*/${C2}\n&/" ~/RetroPie/retropiemenu/gamelist.xml > ~/temp
	cat ~/temp > ~/RetroPie/retropiemenu/gamelist.xml
	rm -f ~/temp
fi
CONTENT3="<game>\n<path>./audiotools/custombgmoptions.sh</path>\n<name>Background Music Options</name>\n<desc>A background music script to set and play MP3/OGG files during menu navigation in both Emulation Station and Attract Mode. A Few special new folders have been created in the /roms directory called "music", and subfolders from there named "arcade", "bttf", "st", &amp; this last one "custom" is for placing your MP3 files into. Once you place your music files into this folder and enable it, the music will automatically begin playing.</desc>\n<image>./icons/backgroundmusic.png</image>\n</game>"
C3=$(echo $CONTENT3 | sed 's/\//\\\//g')
if grep -q custombgmoptions.sh "/home/$currentuser/RetroPie/retropiemenu/gamelist.xml"; then # Check if menu entry is already there or not
	echo "gamelist.xml entry confirmed"
else
	sed "/<\/gameList>/ s/.*/${C3}\n&/" ~/RetroPie/retropiemenu/gamelist.xml > ~/temp
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
