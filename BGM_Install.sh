#!/bin/bash
# BGM_Install.sh
# Updated script by thepitster https://github.com/ALLRiPPED/ 
#############################################
# Install background music + overlay
#############################################
SCRIPT_LOC="$HOME/.rpbgmo/BGM.py"
INSTALL_DIR=$(dirname "${SCRIPT_LOC}")
MUSIC_DIR="$HOME/RetroPie/roms/music"
MUSIC_DIR="${MUSIC_DIR/#~/$HOME}"
MENU_DIR="$HOME/RetroPie/retropiemenu"
AUTOSTART="/opt/retropie/configs/all/autostart.sh"
PYGAME_PKG="python3-pygame"
PSUTIL_PKG="python3-psutil"
cd $HOME

infobox=""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}RetroPie Background Music Overlay Install Script\n\n"
infobox="${infobox}The background music python and control scripts will be installed on this system.\n"
infobox="${infobox}This script will play MP3 & OGG files during menu navigation in either Emulation Station or Attract mode.\n"
infobox="${infobox}A Few special new folders have been created in the /home/pi/RetroPie/roms/music directory called \"arcade\"\n"
infobox="${infobox}(Arcade), \"bttf\" (Back To The Future), \"st\" (Suprememe Team), \"uvf\" (Ultimate Vs Fighter), \"venom\" (Venom),\n"
infobox="${infobox}and this last one \"custom\" (Custom) is for placing your own MP3 files into.\n"
infobox="${infobox}Also included in this script is the ability to select between the different music folders you can disable them all\n"
infobox="${infobox}or enable them, but only one at a time, the music will then automatically start playing.\n"
infobox="${infobox}Launch a game, the music will stop. Upon exiting out of the game the music will begin playing again.\n"
infobox="${infobox}This also lets you turn off certain options for BGM.py such as, Enable/Disable the Overlay, Fadeout effect,\n"
infobox="${infobox}Rounded Corners on Overlays, an option to turn the dashes, or hyphens, with a space on both sides\n"
infobox="${infobox}\" - \"\n"
infobox="${infobox}and separate the song title to a separate new lines.\n"
infobox="${infobox}\n\n"
dialog --backtitle "RetroPie Background Music Overlay Install Script v2.00" \
--title "RetroPie Background Music Overlay Install Script v2.00" \
--msgbox "${infobox}" 35 110
main_menu() {
    local choice
    while true; do
        choice=$(dialog --colors --backtitle "RetroPie Background Music Overlay Install Script v2.00" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose An Option Below" 25 85 20 \
            01 "Minimal Install RPBGM Overlay No Music" \
            02 "Install RPBGM Overlay without Custom Music" \
            03 "Full Install RPBGM Overlay All Music" \
            2>&1 > /dev/tty)
        case "$choice" in
            01) install_bgm  ;;
            02) install_bgm_1  ;;
            03) install_bgm_2  ;;
            *)  break ;;
        esac
    done
}
install_bgm() {
minimum=1
clear
prep_work
setup
rebootq
exit
}
install_bgm_1() {
minimum=0
clear
prep_work
gdown https://drive.google.com/uc?id=1hv2nXThZ5S4OkY-oLGKwMtjmfRYy2cFe -O $HOME/retropie_music_overlay/bgm.zip
unzip -q $HOME/retropie_music_overlay/bgm.zip -d $HOME/RetroPie
setup
rebootq
exit
}
install_bgm_2() {
minimum=0
clear
prep_work
gdown https://drive.google.com/uc?id=1hv2nXThZ5S4OkY-oLGKwMtjmfRYy2cFe -O $HOME/retropie_music_overlay/bgm.zip
gdown https://drive.google.com/uc?id=1-BHwb4oT6GiwpRv7l3VLHuJLsRxScGNV -O $HOME/retropie_music_overlay/custombgm.zip
unzip -q $HOME/retropie_music_overlay/bgm.zip -d $HOME/RetroPie
unzip -q $HOME/retropie_music_overlay/custombgm.zip -d $HOME/RetroPie
mv -f $MUSIC_DIR/custom/'No Music in Folder.mp3' $MUSIC_DIR
setup
rebootq
exit
}
prep_work() {
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
sudo apt-get install -y omxplayer python-pygame mpg123 imagemagick python-urllib3 libpng12-0 fbi python-pip python3-pip # to generate overlays
sudo pip install requests gdown
cd ~
##### Disable ODROID BGM script if it exists
if [ -a $HOME/scripts/bgm/start.sc ]; then
	pkill -STOP mpg123
	sudo rm $HOME/scripts/bgm/start.sc
fi
if [ -d "$HOME/retropie_music_overlay" ]; then #delete folder if it is there
	echo "$HOME/retropie_music_overlay Exists. Now Removing ..."
	sudo rm -r $HOME/retropie_music_overlay
fi
currentuser=$(whoami) # Check user and then stop the script if root
if [[ $currentuser == "root" ]]; then
	echo "DON'T RUN THIS SCRIPT AS ROOT! USE './BGM_Install.sh' !"
	exit
fi
##### Download the files needed and install the script + utilities
git clone https://github.com/ALLRiPPED/retropie_music_overlay.git
cd $HOME/retropie_music_overlay
if [[ $currentuser == "pi" ]]; then #Use pngview if using Raspberry Pi
	sudo chmod +x pngview
	sudo cp pngview /usr/local/bin/
elif [[ $currentuser == "pigaming" ]]; then
	sudo apt-get install libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev # Install ODROID stuff
	git clone https://github.com/AreaScout/Gaming-Kit-Tools.git
	cd $HOME/retropie_music_overlay/Gaming-Kit-Tools
	make
	sudo make install
fi
cd $HOME/retropie_music_overlay/
sudo chmod +x $HOME/retropie_music_overlay/BGM.py
sudo chmod +x $HOME/retropie_music_overlay/exit-splash
sudo chown $currentuser:$currentuser $HOME/retropie_music_overlay/BGM.py
sudo chown $currentuser:$currentuser $HOME/retropie_music_overlay/exit-splash
sudo chmod 0777 $HOME/retropie_music_overlay/BGM.py
sudo chmod 0777 $HOME/retropie_music_overlay/exit-splash
if [ ! -d  "$MUSIC_DIR" ];
then
	mkdir $MUSIC_DIR
else
	echo "$MUSIC_DIR Exists!"
fi	
if [ -f "$HOME/BGM.py" ]; then #Remove old version if it is there
	rm -f $HOME/BGM.py
elif [ -f "$MUSIC_DIR/BGM.py" ]; then #Remove old version if it is there
	rm -f $MUSIC_DIR/BGM.py
elif [ -f "$INSTALL_DIR/BGM.py" ] ; then #Remove old version if it is there
	rm -f $INSTALL_DIR/BGM.py
fi
if [ $INSTALL_DIR ]; then mkdir $INSTALL_DIR; fi
cp BGM.py $INSTALL_DIR
}
setup() {
##### Add fonts
sudo mkdir -p /usr/share/fonts/opentype
sudo cp $HOME/retropie_music_overlay/Pixel.otf /usr/share/fonts/opentype/
sudo cp $HOME/retropie_music_overlay/GROBOLD.ttf /usr/share/fonts/truetype/
##### Add menu options for BGM Overlay Controls
cp $HOME/retropie_music_overlay/backgroundmusic.png $MENU_DIR/icons/
if [ -f "$MENU_DIR/bgmcustomoptions.sh" ]; then # Remove old version if it is there
	sudo rm -f $MENU_DIR/bgmcustomoptions.sh
fi
if [ "$minimum" = "1" ]; then
	sudo chmod +x $HOME/retropie_music_overlay/bgmcustomoptions-minimum.sh
	sudo chown $currentuser:$currentuser $HOME/retropie_music_overlay/bgmcustomoptions-minimum.sh
	sudo chmod 0777 $HOME/retropie_music_overlay/bgmcustomoptions-minimum.sh
	cp bgmcustomoptions-minimum.sh $MENU_DIR/bgmcustomoptions.sh
else
	sudo chmod +x $HOME/retropie_music_overlay/bgmcustomoptions.sh
	sudo chown $currentuser:$currentuser $HOME/retropie_music_overlay/bgmcustomoptions.sh
	sudo chmod 0777 $HOME/retropie_music_overlay/bgmcustomoptions.sh
	cp bgmcustomoptions.sh $MENU_DIR
fi
if [ ! -s $MENU_DIR/gamelist.xml ] # Remove gamelist.xml if file size is 0
then
	sudo rm -f $MENU_DIR/gamelist.xml
fi
if [ ! -f "$MENU_DIR/gamelist.xml" ]; # If file doesn't exist, copy gamelist.xml to folder
then
	cp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml $MENU_DIR/gamelist.xml
fi
CONTENT1="<game>\n<path>./bgmcustomoptions.sh</path>\n<name>BGM Overlay Options</name>\n<desc>Toggles background music options such as music ON/OFF and volume control. Set and play MP3/OGG files during menu navigation in both Emulation Station and Attract Mode. A Few special new folders have been created in the /music directory called "arcade", "bttf", "st", "uvf", "venom", and this last one "custom" is for placing your own MP3/OGG files into. Once you place your music files into this folder and enable it, the music will automatically begin playing.</desc>\n<image>./icons/backgroundmusic.png</image>\n<releasedate>20211110T000251</releasedate>\n<developer>Livewire, madmodder123, thepitster</developer>\n<publisher>Livewire, madmodder123, thepitster</publisher>\n<genre>BGM Control Script</genre>\n</game>"
C1=$(echo $CONTENT1 | sed 's/\//\\\//g')
if grep -q bgmcustomoptions.sh "$MENU_DIR/gamelist.xml"; then # Check if menu entry is already there or not
	echo "gamelist.xml entry confirmed"
else
	sed "/<\/gameList>/ s/.*/${C1}\n&/" $MENU_DIR/gamelist.xml > $HOME/temp
	cat $HOME/temp > $MENU_DIR/gamelist.xml
	rm -f $HOME/temp
fi
if ! grep -q '#(nohup python /home/pi/.rpbgmo/BGM.py & > /dev/null 2>&1)' "$AUTOSTART"; then
	sed -i 's/\#(nohup python/(nohup python/g' $AUTOSTART
fi
if ! grep -q '(nohup python /home/pi/.rpbgmo/BGM.py > /dev/null 2>&1) &' "$AUTOSTART"; then
	sed -i -E '$ i\(nohup python /home/pi/.rpbgmo/BGM.py > /dev/null 2>&1) &' $AUTOSTART
else
	echo "BGM already running at boot!"
fi
##### Setting up Splash & Exit Screens
cp $HOME/retropie_music_overlay/splashscreens/JarvisSplash.mp4 $HOME/RetroPie/splashscreens/
cp $HOME/retropie_music_overlay/splashscreens/JarvisExit.mp4 $HOME/RetroPie/splashscreens/
sudo sed -i -E "s/.*/\/home\/pi\/RetroPie\/splashscreens\/JarvisSplash.mp4/" /etc/splashscreen.list
mkdir -p /opt/retropie/configs/all/emulationstation/scripts/reboot
mkdir -p /opt/retropie/configs/all/emulationstation/scripts/shutdown
cp $HOME/retropie_music_overlay/exit-splash /opt/retropie/configs/all/emulationstation/scripts/reboot/
cp $HOME/retropie_music_overlay/exit-splash /opt/retropie/configs/all/emulationstation/scripts/shutdown/
if ! grep -q '/opt/retropie/configs/all/emulationstation/scripts/shutdown/exit-splash' "$AUTOSTART"; then
	sed -i -E '$a\/opt/retropie/configs/all/emulationstation/scripts/shutdown/exit-splash' $AUTOSTART
else
	echo "Exit Splash Already Set!"
fi
cd $HOME
##### Explain stuff to the user
printf "\n\n\n"
echo "Place your personal music files in $MUSIC_DIR/custom/"
echo "Run $MENU_DIR/bgmcustomoptions.sh or navigate to:"
echo "Retropie > Background Music Options, for more options!"
echo "BGM has been set up to run automatically when the device boots!

"
echo "Thanks for trying out my BGM build"
}
rebootq() {
    local choice

    while true; do
        choice=$(dialog --colors --backtitle "Would You Like To Reboot So The Changes Can Take Effect? [Y/n]" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose An Option Below" 25 85 20 \
            01 "Reboot Later" \
            02 "Reboot Now" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) rebootl  ;;
            02) rebootn  ;;
            *)  break ;;
        esac
    done
}
rebootl() {
	sudo rm -r /home/pi/retropie_music_overlay
	sleep 3
	exit
}
rebootn() {
sudo rm -r /home/pi/retropie_music_overlay
sleep 3
sudo reboot
}
main_menu
