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
            01 "Enable Arcade background music" \
            02 "Disable Arcade background music" \
            03 "Enable BTTF background music" \
            04 "Disable BTTF background music" \
            05 "Enable Custom background music" \
            06 "Disable Custom background music" \
            07 "Enable Supreme Team background music" \
            08 "Disable Supreme Team background music" \
            09 "Enable Ultimate Vs Fighter background music" \
            10 "Disable Ultimate Vs Fighter background music" \
            11 "Enable Venom background music" \
            12 "Disable Venom background music" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) enable_arcade  ;;
            02) disable_arcade  ;;
            03) enable_bttf  ;;
            04) disable_bttf  ;;
            05) enable_custom  ;;
            06) disable_custom  ;;
            07) enable_st  ;;
            08) disable_st  ;;
            09) enable_uvf  ;;
            10) disable_uvf  ;;
            11) enable_venom  ;;
            12) disable_venom  ;;
            *)  break ;;
        esac
    done
}

function enable_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Arcade Music Already Enabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Arcade Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Arcade Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Arcade Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Arcade Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Arcade Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Arcade Music Enabled" 3 24 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 2
fi
}

function disable_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Arcade Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Arcade Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Arcade Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Arcade Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Arcade Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Arcade Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Arcade Music Disabled" 3 25 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
}

function enable_bttf() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "BTTF Music Already Enabled" 3 30 ; sleep 2
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "BTTF Music Enabled" 3 22 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "BTTF Music Enabled" 3 22 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "BTTF Music Enabled" 3 22 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "BTTF Music Enabled" 3 22 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "BTTF Music Enabled" 3 22 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "BTTF Music Enabled" 3 22 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 2
fi
}

function disable_bttf() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "BTTF Music Already Disabled" 3 31 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "BTTF Music Already Disabled" 3 31 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "BTTF Music Already Disabled" 3 31 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "BTTF Music Already Disabled" 3 31 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "BTTF Music Already Disabled" 3 31 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "BTTF Music Already Disabled" 3 31 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "BTTF Music Disabled" 3 23 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
}

function enable_custom() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Custom Music Already Enabled" 3 34 ; sleep 2
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Custom Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Custom Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Custom Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Custom Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Custom Music Enabled" 3 24 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Custom Music Enabled" 3 24 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 2
fi
}

function disable_custom() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Custom Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Custom Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Custom Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Custom Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Custom Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Custom Music Already Disabled" 3 33 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Custom Music Disabled" 3 25 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
}

function enable_st() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "ST Music Already Enabled" 3 28 ; sleep 2
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "ST Music Enabled" 3 20 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "ST Music Enabled" 3 20 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "ST Music Enabled" 3 20 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "ST Music Enabled" 3 20 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "ST Music Enabled" 3 20 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "ST Music Enabled" 3 20 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 2
fi
}

function disable_st() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "ST Music Already Disabled" 3 29 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "ST Music Already Disabled" 3 29 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "ST Music Already Disabled" 3 29 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "ST Music Already Disabled" 3 29 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "ST Music Already Disabled" 3 29 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "ST Music Already Disabled" 3 29 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "ST Music Disabled" 3 21 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
}

function enable_uvf() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "UVF Music Already Enabled" 3 29 ; sleep 2
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "UVF Music Enabled" 3 21 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "UVF Music Enabled" 3 21 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "UVF Music Enabled" 3 21 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "UVF Music Enabled" 3 21 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "UVF Music Enabled" 3 21 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "UVF Music Enabled" 3 21 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 2
fi
}

function disable_uvf() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "UFV Music Already Disabled" 3 30 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "UVF Music Already Disabled" 3 30 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "UVF Music Already Disabled" 3 30 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "UVF Music Already Disabled" 3 30 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "UVF Music Already Disabled" 3 30 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "UVF Music Already Disabled" 3 30 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "UVF Music Disabled" 3 22 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
}

function enable_venom() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Venom Music Already Enabled" 3 31 ; sleep 2
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Venom Music Enabled" 3 23 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Venom Music Enabled" 3 23 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Venom Music Enabled" 3 23 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Venom Music Enabled" 3 23 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Venom Music Enabled" 3 23 ; sleep 2
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Venom Music Enabled" 3 23 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
python /home/pi/RetroPie/roms/music/BGM.py &
sleep 2
fi
}

function disable_venom() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Venom Music Disabled" 3 24 ; sleep 2
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
else
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
}

main_menu
