#!/bin/bash

infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}RetroPie Background Music Script\n\n"
infobox="${infobox}The mpg123 background music script has already been installed on this base image.\n"
infobox="${infobox}\n"
infobox="${infobox}This script will play MP3 files during menu navigation in either Emulation Station or Attract mode.\n"
infobox="${infobox}\n"
infobox="${infobox}A special new folder has been created in the /roms directory called \"music\" for placing your MP3 files into.\n"
infobox="${infobox}\n"
infobox="${infobox}Once you place your music files into this folder and enable it, the music will automatically begin playing.\n"
infobox="${infobox}\n"
infobox="${infobox}When you launch a game, however, the music will stop.  Upon exiting out of the game the music will begin playing again.\n"
infobox="${infobox}\n\n"

dialog --backtitle "RetroPie Background Music" \
--title "RetroPie Background Music" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Disable background music" \
            2 "Enable background music (Volume default 50%)" \
            3 "Volume background music: 100%" \
            4 "Volume background music: 75%" \
            5 "Volume background music: 50%" \
            6 "Volume background music: 25%" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) disable_music  ;;
            2) enable_music  ;;
            3) volume100  ;;
            4) volume75  ;;
            5) volume50  ;;
            6) volume25  ;;
            *)  break ;;
        esac
    done
}

function disable_music() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
echo -e "\n\n\n                               Background Music Already Disabled!\n\n\n"
else
touch /home/pi/RetroPie/roms/music/DisableMusic
sudo pkill -f BGM.py
sudo pkill -f pngview
echo -e "\n\n\n                               Background Music Disabled!\n\n\n"
sleep 3
}

function enable_music() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
sudo rm /home/pi/RetroPie/roms/music/DisableMusic
else
echo -e "\n\n\n                               Background Music Already Enabled!\n\n\n"
fi
if grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo ""
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
fi
python /home/pi/RetroPie/roms/music/BGM.py &
echo -e "\n\n\n                               Background Music Enabled!\n\n\n"
sleep 3
}

function volume100() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 100% Confirmed"
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 100% Confirmed"
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 100% Confirmed"
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 100% Confirmed"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

function volume75() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 75% Confirmed"
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 75% Confirmed"
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 75% Confirmed"
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 75% Confirmed"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

function volume50() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 50% Confirmed"
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 50% Confirmed"
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 50% Confirmed"
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 50% Confirmed"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

function volume25() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 25% Confirmed"
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 25% Confirmed"
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 25% Confirmed"
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Volume Set to 25% Confirmed"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

main_menu
