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
            01 "Disable background music" \
            02 "Enable background music (Volume default 50%)" \
            03 "Volume background music: 100%" \
            04 "Volume background music: 75%" \
            05 "Volume background music: 50%" \
            06 "Volume background music: 25%" \
            07 "Enable/Disable Overlay" \
            08 "Enable/Disable Overlay Fadeout" \
			09 "Enable/Disable Overlay Rounded Corners" \
			10 "Enable/Disable Overlay Newline Separator" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) disable_music  ;;
            02) enable_music  ;;
            03) volume100  ;;
            04) volume75  ;;
            05) volume50  ;;
            06) volume25  ;;
            07) overlay_enable  ;;
            08) overlay_fade_out  ;;
			09) overlay_rounded_corners  ;;
			10) overlay_replace_newline  ;;
            *)  break ;;
        esac
    done
}
function disable_music() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
dialog --infobox "Background Music Already Disabled!" 3 38 ; sleep 2
else
touch /home/pi/RetroPie/roms/music/DisableMusic
sudo pkill -f BGM.py
sudo pkill -f pngview
dialog --infobox "Background Music Disabled!" 3 30 ; sleep 2
fi
}
function enable_music() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
sudo rm -f /home/pi/RetroPie/roms/music/DisableMusic
if grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
	dialog --infobox "Background Music Enabled!" 3 29 ; sleep 2
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
	dialog --infobox "Background Music Enabled!" 3 29 ; sleep 2
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
	dialog --infobox "Background Music Enabled!" 3 29 ; sleep 2
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
	dialog --infobox "Background Music Enabled!" 3 29 ; sleep 2
fi
else
dialog --infobox "Background Music Already Enabled!" 3 37 ; sleep 2
fi
}
function volume100() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Volume Already 100%" 3 23 ; sleep 2
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 100%" 3 22 ; sleep 2
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 100%" 3 22 ; sleep 2
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 100%" 3 22 ; sleep 2
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
function volume75() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Volume Already 75%" 3 22 ; sleep 2
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 75%" 3 21 ; sleep 2
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 75%" 3 21 ; sleep 2
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 75%" 3 21 ; sleep 2
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
function volume50() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Volume Already 50%" 3 22 ; sleep 2
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 50%" 3 21 ; sleep 2
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 50%" 3 21 ; sleep 2
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 50%" 3 21 ; sleep 2
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
function volume25() {
dialog --infobox "...processing..." 3 20 ; sleep 2
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Volume Already 25%" 3 22 ; sleep 2
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 25%" 3 21 ; sleep 2
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 25%" 3 21 ; sleep 2
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Volume Set to 25%" 3 21 ; sleep 2
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
function overlay_enable() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'overlay_enable = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Overlay Disabled" 3 21 ; sleep 2
	sed -i -E 's/overlay_enable = True/overlay_enable = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_enable = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_enable = False/overlay_enable = True/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Overlay Enabled" 3 20 ; sleep 2
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
function overlay_fade_out() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'overlay_fade_out = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Overlay Fadeout Disabled" 3 29 ; sleep 2
	sed -i -E 's/overlay_fade_out = True/overlay_fade_out = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_fade_out = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_fade_out = False/overlay_fade_out = True/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Overlay Fadeout Enabled" 3 28 ; sleep 2
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
function overlay_rounded_corners() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'overlay_rounded_corners = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Overlay Rounded Corners Disabled" 3 37 ; sleep 2
	sed -i -E 's/overlay_rounded_corners = True/overlay_rounded_corners = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_rounded_corners = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_rounded_corners = False/overlay_rounded_corners = True/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Overlay Rounded Corners Enabled" 3 36 ; sleep 2
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
function overlay_replace_newline() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'overlay_replace_newline = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	dialog --infobox "Overlay Separator Disabled" 3 31 ; sleep 2
	sed -i -E 's/overlay_replace_newline = True/overlay_replace_newline = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_replace_newline = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_replace_newline = False/overlay_replace_newline = True/g' /home/pi/RetroPie/roms/music/BGM.py
	dialog --infobox "Overlay Separator Enabled" 3 30 ; sleep 2
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



main_menu
