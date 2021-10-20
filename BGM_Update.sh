#!/usr/bin/env bash
# BGM_Update.sh
#
# Updated script by thepitster https://github.com/ALLRiPPED/ 
#############################################
# Update background music + overlay
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
cd ~/
sudo rm -r ~/retropie_music_overlay
##### Disable ODROID BGM script if it exists
if [ -a ~/scripts/bgm/start.sc ]; then
	pkill -STOP mpg123
	sudo rm ~/scripts/bgm/start.sc
fi
##### Explain stuff to the user
printf "\n\n\n"
echo "Place your personal music files in /home/$currentuser/RetroPie/roms/music/custom/"
echo "Run ~/RetroPie/retropiemenu/bgmcustomoptions.sh or navigate to:"
echo "Retropie > Background Music Options, for more options!"
echo "BGM has been set up to run automatically when the device boots!

"
echo "Thanks for trying out my BGM build"
