#!/bin/env bash
# BGM_Update.sh
#
# Updated script by thepitster https://github.com/ALLRiPPED/ 
#############################################
# Update background music + overlay
#############################################
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}RetroPie Background Music Overlay Update Script\n\n"
infobox="${infobox}The background music python and control scripts will be Updated on this system.\n"
infobox="${infobox}\n"
infobox="${infobox}This script will play MP3 & OGG files during menu navigation in either Emulation Station or Attract mode.\n"
infobox="${infobox}\n"
infobox="${infobox}A Few special new folders have been created in the /home/pi/RetroPie/roms/music directory called \"arcade\"\n"
infobox="${infobox}(Arcade), \"bttf\" (Back To The Future), \"st\" (Suprememe Team), \"uvf\" (Ultimate Vs Fighter), \"venom\" (Venom),\n"
infobox="${infobox}and this last one \"custom\" (Custom) is for placing your own MP3 files into.\n"
infobox="${infobox}\n"
infobox="${infobox}Also included in this script is the ability to select between the different music folders you can disable them all\n"
infobox="${infobox}or enable them, but only one at a time, the music will then automatically start playing.\n"
infobox="${infobox}\n"
infobox="${infobox}Launch a game, the music will stop. Upon exiting out of the game the music will begin playing again.\n"
infobox="${infobox}\n"
infobox="${infobox}This also lets you turn off certain options for BGM.py such as, Enable/Disable the Overlay, Fadeout effect,\n"
infobox="${infobox}Rounded Corners on Overlays, an option to turn the dashes, or hyphens, with a space on both sides\n"
infobox="${infobox}\" - \"\n"
infobox="${infobox}and separate the song title to a separate newlines.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"

dialog --backtitle "RetroPie Background Music Overlay Update Script v1.63" \
--title "RetroPie Background Music Overlay Update Script v1.63" \
--msgbox "${infobox}" 35 110
clear
##### Install needed packages
sudo apt-get update -y
if sudo apt-get --simulate install python-pygame
then 
	sudo apt-get install -y python-pygame # to control music
else
	echo "

Unable to install python-pygame, please update your system (\"sudo apt-get upgrade && sudo apt-get update\") and then try running this script again!
	
	"
	exit
fi
sudo apt-get install -y imagemagick fbi python-pip python3-pip # to generate overlays
sudo pip install gdown
cd ~
if [ -d "/home/pi/retropie_music_overlay" ]; then #delete folder if it is there
	echo "/home/pi/retropie_music_overlay Exists. Now Removing ..."
	sudo rm -r /home/pi/retropie_music_overlay
fi
currentuser=$(whoami) # Check user and then stop the script if root
if [[ $currentuser == "root" ]]; then
	echo "DON'T RUN THIS SCRIPT AS ROOT! USE './BGM_Install.sh' !"
	exit
fi
git clone https://github.com/ALLRiPPED/retropie_music_overlay.git
cd /home/pi/retropie_music_overlay
if [[ $currentuser == "pi" ]]; then #Use pngview if using Raspberry Pi
	sudo chmod +x pngview
	sudo cp pngview /usr/local/bin/
elif [[ $currentuser == "pigaming" ]]; then
	sudo apt-get install libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev # Install ODROID stuff
	git clone https://github.com/AreaScout/Gaming-Kit-Tools.git
	cd /home/pi/retropie_music_overlay/Gaming-Kit-Tools
	make
	sudo make install
fi
cd /home/pi/retropie_music_overlay/
sudo chmod +x BGM.py
sudo chmod +x bgmcustomoptions.sh
sudo chown $currentuser:$currentuser BGM.py
sudo chown $currentuser:$currentuser bgmcustomoptions.sh
sudo chmod 0777 BGM.py
sudo chmod 0777 bgmcustomoptions.sh
if [ ! -d  "/home/pi/RetroPie/roms/music/" ];
then
	mkdir /home/pi/RetroPie/roms/music/
else
	echo "/home/pi/RetroPie/roms/music Exists!"
fi	
if [ -f "/home/pi/BGM.py" ]; then #Remove old version if it is there
	rm -f /home/pi/BGM.py
elif [ -f "/home/pi/RetroPie/roms/music/BGM.py" ]; then #Remove old version if it is there
	rm -f /home/pi/RetroPie/roms/music/BGM.py
fi
cp BGM.py /home/pi/RetroPie/roms/music/
##### Add pixel font
sudo mkdir -p /usr/share/fonts/opentype
sudo cp Pixel.otf /usr/share/fonts/opentype/
##### Add menu options for BGM toggles
cp backgroundmusic.png /home/pi/RetroPie/retropiemenu/icons/
if [ -f "/home/pi/RetroPie/retropiemenu/bgmcustomoptions.sh" ]; # Remove old version if it is there
then
	sudo rm -f /home/pi/RetroPie/retropiemenu/bgmcustomoptions.sh
fi
cp bgmcustomoptions.sh /home/pi/RetroPie/retropiemenu/
cd /home/pi/
sudo rm -r /home/pi/retropie_music_overlay
##### Explain stuff to the user
printf "\n\n\n"
echo "Place your personal music files in /home/$currentuser/RetroPie/roms/music/custom/"
echo "Run /home/pi/RetroPie/retropiemenu/bgmcustomoptions.sh or navigate to:"
echo "Retropie > Background Music Options, for more options!"
echo "BGM has been set up to run automatically when the device boots!

"
echo "Thanks for trying out my BGM build"
read -r -p "Would You Like To Reboot So The Changes Can Take Effect? [Y/n] " input
case $input in
	[yY][eE][sS]|[yY])
	sleep 3
	clear
	sudo reboot
	;;
    [nN][oO]|[nN])
	exit
	;;
	*)
	echo "Invalid input..."
	;;
esac
