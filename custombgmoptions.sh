#!/bin/bash

infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}RetroPie Background Music Options Script\n\n"
infobox="${infobox}The mpg123 background music script has already been installed on this base image.\n"
infobox="${infobox}\n"
infobox="${infobox}This script will play MP3 files during menu navigation in either Emulation Station or Attract mode.\n"
infobox="${infobox}\n"
infobox="${infobox}A Few special new folders have been created in the /roms directory called \"music\", and subfolders from there\n"
infobox="${infobox}named \"arcade\", \"bttf\", \"st\", & this last one \"custom\" is for placing your MP3 files into.\n"
infobox="${infobox}\n"
infobox="${infobox}Once you place your music files into this folder and enable it, the music will automatically begin playing.\n"
infobox="${infobox}\n"
infobox="${infobox}When you launch a game, however, the music will stop or unless set otherwise by you in this menu.\n"
infobox="${infobox}Otherwise upon exiting out of the game the music will begin playing again.\n"
infobox="${infobox}\n\n"

dialog --backtitle "RetroPie Background Music Options" \
--title "RetroPie Background Music Options" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Enable Arcade background music" \
            2 "Disable Arcade background music" \
            3 "Enable BTTF background music" \
            4 "Disable BTTF background music" \
            5 "Enable Custom background music" \
            6 "Disable Custom background music" \
            7 "Enable Supreme Team background music" \
            8 "Disable Supreme Team background music" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) enable_arcade  ;;
            2) disable_arcade  ;;
            3) enable_bttf  ;;
            4) disable_bttf  ;;
            5) enable_custom  ;;
            6) disable_custom  ;;
            7) enable_st  ;;
            8) disable_st  ;;
            *)  break ;;
        esac
    done
}

function enable_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Confirmed Arcade Music Already Enabled"
elif grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdir/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Arcade Music Enabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from BTTF to Arcade"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from Custom to Arcade"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from ST to Arcade"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

function disable_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdir/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Arcade Music Disabled"
fi
sudo pkill -f BGM.py
sudo pkill -f pngview
sleep 3
}

function enable_bttf() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Confirmed BTTF Music Already Enabled"
elif grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdir/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed BTTF Music Enabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from Arcade to BTTF"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from Custom to BTTF"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from ST to BTTF"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

function disable_bttf() {
if grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdir/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "BTTF Music Disabled"
fi
sudo pkill -f BGM.py
sudo pkill -f pngview
sleep 3
}

function enable_custom() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Confirmed Custom Music Already Enabled"
elif grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdir/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Custom Music Enabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from Arcade to Custom"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from BTTF to Custom"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from ST to Custom"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

function disable_custom() {
if grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdir/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Custom Music Disabled"
fi
sudo pkill -f BGM.py
sudo pkill -f pngview
sleep 3
}
function enable_st() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Confirmed ST Music Already Enabled"
elif grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdir/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed ST Music Enabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from Arcade to ST"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from BTTF to ST"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "Confirmed Music Switch from Custom to ST"
fi
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 3
}

function disable_st() {
if grep -q 'musicdir = musicdir' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdir/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "ST Music Disabled"
fi
sudo pkill -f BGM.py
sudo pkill -f pngview
sleep 3
}

main_menu
