#!/usr/bin/bash
# BGM_Install.sh
#
# Updated script by thepitster https://github.com/ALLRiPPED/ 
#############################################
# Install background music + overlay
#############################################
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}RetroPie Background Music Install Script\n\n"
infobox="${infobox}The background music python and control scripts will be installed on this system.\n"
infobox="${infobox}\n"
infobox="${infobox}This script will play MP3 & OGG files during menu navigation in either Emulation Station or Attract mode.\n"
infobox="${infobox}\n"
infobox="${infobox}A Few special new folders have been created in the /home/pi/RetroPie/roms/music directory called \"arcade\"\n"
infobox="${infobox}(Arcade), \"bttf\" (Back To The Future), \"st\" (Supremem Team), \"uvf\" (Ultimate Vs Fighter), \"venom\" (Venom),\n"
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
infobox="${infobox}and separate the song title to a separate new lines.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"

dialog --backtitle "RetroPie Background Music Install Script v1.60" \
--title "RetroPie Background Music Install Script v1.60" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --colors --backtitle "RetroPie Background Music Install Script v1.60" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose An Option Below" 25 85 20 \
            01 "Install Background Music without Custom Music" \
            02 "Install Background Music with Custom Music" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) install_bgm_1  ;;
            02) install_bgm_2  ;;
            *)  break ;;
        esac
    done
}
function install_bgm_1() {
clear
prep_work
gdown https://drive.google.com/uc?id=1hv2nXThZ5S4OkY-oLGKwMtjmfRYy2cFe
unzip -q bgm.zip -d /home/pi/RetroPie
rm -f bgm.zip
setup
rebootq
}
function install_bgm_2() {
clear
prep_work
gdown https://drive.google.com/uc?id=1hv2nXThZ5S4OkY-oLGKwMtjmfRYy2cFe
gdown https://drive.google.com/uc?id=1-BHwb4oT6GiwpRv7l3VLHuJLsRxScGNV
unzip -q bgm.zip -d /home/pi/RetroPie
unzip -q custombgm.zip -d /home/pi/RetroPie
mv -f /home/pi/RetroPie/roms/music/custom/'No Music in Folder.mp3' /home/pi/RetroPie/roms/music/
setup
rebootq
}

function prep_work() {
##### Install needed packages
sudo apt-get update -y
sudo apt-get install -y imagemagick fbi python-pip python3-pip # to generate overlays
sudo pip install gdown
if sudo apt-get --simulate install python-pygame
then 
	sudo apt-get install -y python-pygame # to control music
else
	echo "

Unable to install python-pygame, please update your system (\"sudo apt-get upgrade && sudo apt-get update\") and then try running this script again!
	
	"
	exit
fi
cd ~
if [ -d "/home/pi/retropie_music_overlay" ]; then #delete folder if it is there
	echo "/home/pi/retropie_music_overlay Exsists. Now Removing ..."
	sudo rm -r /home/pi/retropie_music_overlay
fi
currentuser=$(whoami) # Check user and then stop the script if root
if [[ $currentuser == "root" ]]; then
	echo "DON'T RUN THIS SCRIPT AS ROOT! USE './BGM_Install.sh' !"
	exit
fi
##### Download the files needed and install the script + utilities
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
sudo chmod +x exit-splash
sudo chown $currentuser:$currentuser BGM.py
sudo chown $currentuser:$currentuser bgmcustomoptions.sh
sudo chown $currentuser:$currentuser exit-splash
sudo chmod 0777 BGM.py
sudo chmod 0777 bgmcustomoptions.sh
sudo chmod 0777 exit-splash
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
}

function setup() {
##### Setting up Splash & Exit Screens
sudo sed -i -E "s/.*/\/home\/pi\/RetroPie\/splashscreens\/JarvisSplash.mp4/" /etc/splashscreen.list
mkdir /home/pi/.emulationstation/scripts/reboot
mkdir /home/pi/.emulationstation/scripts/shutdown
cp exit-splash /home/pi/.emulationstation/scripts/reboot/
cp exit-splash /home/pi/.emulationstation/scripts/shutdown/
if ! grep -q '/home/pi/.emulationstation/scripts/shutdown/exit-splash' "/opt/retropie/configs/all/autostart.sh"; then
	sed -i -E '$a\/home/pi/.emulationstation/scripts/shutdown/exit-splash' /opt/retropie/configs/all/autostart.sh
else
	echo "Exit Splash Already Set!"
fi
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
if [ ! -s /home/pi/RetroPie/retropiemenu/gamelist.xml ] # Remove gamelist.xml if file size is 0
then
	sudo rm -f /home/pi/RetroPie/retropiemenu/gamelist.xml
fi
if [ ! -f "/home/pi/RetroPie/retropiemenu/gamelist.xml" ]; # If file doesn't exist, copy gamelist.xml to folder
then
	cp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml /home/pi/RetroPie/retropiemenu/gamelist.xml
fi
CONTENT1="<game>\n<path>./bgmcustomoptions.sh</path>\n<name>Background Music Options</name>\n<desc>Toggles background music options such as music ON/OFF and volume control. Set and play MP3/OGG files during menu navigation in both Emulation Station and Attract Mode. A Few special new folders have been created in the /music directory called "arcade", "bttf", "st", "uvf", "venom", and this last one "custom" is for placing your own MP3/OGG files into. Once you place your music files into this folder and enable it, the music will automatically begin playing.</desc>\n<image>./icons/backgroundmusic.png</image>\n</game>"
C1=$(echo $CONTENT1 | sed 's/\//\\\//g')
if grep -q bgmcustomoptions.sh "/home/$currentuser/RetroPie/retropiemenu/gamelist.xml"; then # Check if menu entry is already there or not
	echo "gamelist.xml entry confirmed"
else
	sed "/<\/gameList>/ s/.*/${C1}\n&/" /home/pi/RetroPie/retropiemenu/gamelist.xml > /home/pi/temp
	cat /home/pi/temp > /home/pi/RetroPie/retropiemenu/gamelist.xml
	rm -f /home/pi/temp
fi
if ! grep -q '#(python /home/pi/RetroPie/roms/music/BGM.py & > /dev/null 2>&1)' "/opt/retropie/configs/all/autostart.sh"; then
	sed -i 's/\#(python/(python/g' /opt/retropie/configs/all/autostart.sh
fi
if ! grep -q '(python /home/pi/RetroPie/roms/music/BGM.py > /dev/null 2>&1) &' "/opt/retropie/configs/all/autostart.sh"; then
	sed -i -E '$ i\(python /home/pi/RetroPie/roms/music/BGM.py > /dev/null 2>&1) &' /opt/retropie/configs/all/autostart.sh
else
	echo "BGM already running at boot!"
fi

cd /home/pi/
sudo rm -r /home/pi/retropie_music_overlay
##### Disable ODROID BGM script if it exists
if [ -a /home/pi/scripts/bgm/start.sc ]; then
	pkill -STOP mpg123
	sudo rm /home/pi/scripts/bgm/start.sc
fi
##### Explain stuff to the user
printf "\n\n\n"
echo "Place your personal music files in /home/$currentuser/RetroPie/roms/music/custom/"
echo "Run /home/pi/RetroPie/retropiemenu/bgmcustomoptions.sh or navigate to:"
echo "Retropie > Background Music Options, for more options!"
echo "BGM has been set up to run automatically when the device boots!

"
echo "Thanks for trying out my BGM build"
}
function rebootq() {
read -r -p "Would You Like To Reboot So The Changes Can Take Effect? [Y/n] " input
case $input in
	[yY][eE][sS]|[yY])
	sleep 3
	sudo reboot
	;;
    [nN][oO]|[nN])
	exit
	;;
	*)
	echo "Invalid input..."
	;;
esac
}

main_menu
