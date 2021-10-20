#!/bin/bash

infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}RetroPie Background Music Control Script\n\n"
infobox="${infobox}The background music python script has been installed on this system.\n"
infobox="${infobox}\n"
infobox="${infobox}This script will play MP3 & OGG files during menu navigation in either Emulation Station or Attract mode.\n"
infobox="${infobox}\n"
infobox="${infobox}A Few special new folders have been created in the /home/pi/RetroPie/roms/music directory called \"arcade\",\n"
infobox="${infobox}\"bttf\", \"st\", \"uvf\", \"venom\", and this last one \"custom\" is for placing your own MP3 files into.\n"
infobox="${infobox}\n"
infobox="${infobox}Also included in this script is the ability to select between the different music folders you can disable\n"
infobox="${infobox}and enable them, the music will then automatically start playing.\n"
infobox="${infobox}\n"
infobox="${infobox}Launch a game, the music will stop. Upon exiting out of the game the music will begin playing again.\n"
infobox="${infobox}\n"
infobox="${infobox}This also lets you turn off certain options for BGM.py such as, Enable/Disable the Overlay, Fadeout effect,\n"
infobox="${infobox}Rounded Corners on Overlays, an option to turn the dashes, or hyphens, with a space on both sides\n"
infobox="${infobox}\" - \"\n"
infobox="${infobox}and separate the song title to a separate newlines.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"

dialog --backtitle "RetroPie Background Music Control" \
--title "RetroPie Background Music Control" \
--msgbox "${infobox}" 35 110

function main_menu() {
stats_check
    local choice

    while true; do
        choice=$(dialog --backtitle "RetroPie Background Music Control		BGM On Boot $bgmos		BGM Playing $bgms" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose An Option Below" 25 85 20 \
            01 "Enable/Disable Background Music $bgms" \
            02 "Enable/Disable BGM On-Boot $bgmos" \
            03 "Volume Background Music: 100% $v100" \
            04 "Volume Background Music: 75% $v75" \
            05 "Volume Background Music: 50% $v50" \
            06 "Volume Background Music: 25% $v25" \
            07 "Enable/Disable Overlay $ovs" \
            08 "Enable/Disable Overlay Fadeout $ovf" \
            09 "Enable/Disable Overlay Rounded Corners $ocr" \
            10 "Enable/Disable Overlay Line Separator $ons" \
            11 "Music Selection $ms" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) enable_music  ;;
            02) enable_musicos  ;;
            03) volume100  ;;
            04) volume75  ;;
            05) volume50  ;;
            06) volume25  ;;
            07) overlay_enable  ;;
            08) overlay_fade_out  ;;
            09) overlay_rounded_corners  ;;
            10) overlay_replace_newline  ;;
            11) music_select  ;;
            *)  break ;;
        esac
    done
}
function enable_music() {
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
sudo rm -f /home/pi/RetroPie/roms/music/DisableMusic
if grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
else
touch /home/pi/RetroPie/roms/music/DisableMusic
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
sleep 2
stats_check
}

function enable_musicos() {
if grep -q '#(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &' "/opt/retropie/configs/all/autostart.sh"; then
	#bgmos="(Enabled)"
	sudo sed -i 's/\#(python/(python/g' /opt/retropie/configs/all/autostart.sh
elif grep -q '(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &' "/opt/retropie/configs/all/autostart.sh"; then
	#bgmos="(Disabled)"
	sudo sed -i 's/(python/\#(python/g' /opt/retropie/configs/all/autostart.sh
fi
sleep 2
stats_check
}

function volume100() {
if grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 100%" 3 23
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function volume75() {
if grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 75%"
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.75/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function volume50() {
if grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 50%"
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function volume25() {
sudo pkill -f BGM.py
sudo pkill -f pngview
if grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Volume Already 25%"
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.25/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function overlay_enable() {
if grep -q 'overlay_enable = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_enable = True/overlay_enable = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_enable = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_enable = False/overlay_enable = True/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function overlay_fade_out() {
if grep -q 'overlay_fade_out = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_fade_out = True/overlay_fade_out = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_fade_out = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_fade_out = False/overlay_fade_out = True/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function overlay_rounded_corners() {
if grep -q 'overlay_rounded_corners = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_rounded_corners = True/overlay_rounded_corners = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_rounded_corners = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_rounded_corners = False/overlay_rounded_corners = True/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function overlay_replace_newline() {
if grep -q 'overlay_replace_newline = True' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_replace_newline = True/overlay_replace_newline = False/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'overlay_replace_newline = False' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/overlay_replace_newline = False/overlay_replace_newline = True/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function music_select() {
stats_check
local choice

    while true; do
        choice=$(dialog --backtitle "Select Your Music Choice Below		BGM On Boot $bgmos		BGM Playing $bgms" --title " MAIN MENU " \
            --ok-label OK --cancel-label Back \
            --menu "What action would you like to perform? Background Music $bgms" 25 85 20 \
            01 "Enable/Disable Arcade Music $msa" \
            02 "Enable/Disable BTTF Music $msb" \
            03 "Enable/Disable Custom Music $msc" \
            04 "Enable/Disable Supreme Team Music $mss" \
            05 "Enable/Disable Ultimate Vs Fighter Music $msu" \
            06 "Enable/Disable Venom Music $msv" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) enable_arcade  ;;
            02) enable_bttf  ;;
            03) enable_custom  ;;
            04) enable_st  ;;
            05) enable_uvf  ;;
            06) enable_venom  ;;
            *)  break ;;
        esac
    done
}
function enable_arcade() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirac/g' /home/pi/RetroPie/roms/music/BGM.py
else
if grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}

function enable_bttf() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirbttf/g' /home/pi/RetroPie/roms/music/BGM.py
else
if grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function enable_custom() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdircustom/g' /home/pi/RetroPie/roms/music/BGM.py
else
if grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function enable_st() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirst/g' /home/pi/RetroPie/roms/music/BGM.py

else
if grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function enable_uvf() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiruvf/g' /home/pi/RetroPie/roms/music/BGM.py
else
if grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function enable_venom() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirvenom/g' /home/pi/RetroPie/roms/music/BGM.py
else
if grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function stats_check() {
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]; then
	bgms="(Disabled)"
else
	bgms="(Enabled)"
fi
if grep -q  '#(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &' "/opt/retropie/configs/all/autostart.sh"; then
	bgmos="(Disabled)"
elif grep -q  '(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &' "/opt/retropie/configs/all/autostart.sh"; then
	bgmos="(Enabled)"
else
	bgmos="(Disabled)"
fi
if grep -q "overlay_enable = True" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ovs="(Enabled)"
else
	ovs="(Disabled)"
fi
if grep -q "overlay_fade_out = True" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ovf="(Enabled)"
else
	ovf="(Disabled)"
fi
if grep -q "overlay_rounded_corners = True" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ocr="(Enabled)"
else
	ocr="(Disabled)"
fi
if grep -q "overlay_replace_newline = True" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ons="(Enabled)"
else
	ons="(Disabled)"
fi
if grep -q "musicdir = musicdiroff" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ms="(Disabled)"
elif grep -q "musicdir = musicdirac" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ms="(Arcade)"
elif grep -q "musicdir = musicdirbttf" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ms="(BTTF)"
elif grep -q "musicdir = musicdircustom" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ms="(Custom)"
elif grep -q "musicdir = musicdirst" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ms="(Supreme Team)"
elif grep -q "musicdir = musicdiruvf" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ms="(Ultimate Vs Fighter)"
elif grep -q "musicdir = musicdirvenom" "/home/pi/RetroPie/roms/music/BGM.py"; then
	ms="(Venom)"
fi
if grep -q "musicdir = musicdirac" "/home/pi/RetroPie/roms/music/BGM.py"; then
	msa="(Enabled)"
	msb="(Disabled)"
	msc="(Disabled)"
	mss="(Disabled)"
	msu="(Disabled)"
	msv="(Disabled)"
elif grep -q "musicdir = musicdirbttf" "/home/pi/RetroPie/roms/music/BGM.py"; then
	msa="(Disabled)"
	msb="(Enabled)"
	msc="(Disabled)"
	mss="(Disabled)"
	msu="(Disabled)"
	msv="(Disabled)"
elif grep -q "musicdir = musicdircustom" "/home/pi/RetroPie/roms/music/BGM.py"; then
	msa="(Disabled)"
	msb="(Disabled)"
	msc="(Enabled)"
	mss="(Disabled)"
	msu="(Disabled)"
	msv="(Disabled)"
elif grep -q "musicdir = musicdirst" "/home/pi/RetroPie/roms/music/BGM.py"; then
	msa="(Disabled)"
	msb="(Disabled)"
	msc="(Disabled)"
	mss="(Enabled)"
	msu="(Disabled)"
	msv="(Disabled)"
elif grep -q "musicdir = musicdiruvf" "/home/pi/RetroPie/roms/music/BGM.py"; then
	msa="(Disabled)"
	msb="(Disabled)"
	msc="(Disabled)"
	mss="(Disabled)"
	msu="(Enabled)"
	msv="(Disabled)"
elif grep -q "musicdir = musicdirvenom" "/home/pi/RetroPie/roms/music/BGM.py"; then
	msa="(Disabled)"
	msb="(Disabled)"
	msc="(Disabled)"
	mss="(Disabled)"
	msu="(Disabled)"
	msv="(Enabled)"
elif grep -q "musicdir = musicdiroff" "/home/pi/RetroPie/roms/music/BGM.py"; then
	msa="(Disabled)"
	msb="(Disabled)"
	msc="(Disabled)"
	mss="(Disabled)"
	msu="(Disabled)"
	msv="(Disabled)"
fi
if grep -q "maxvolume = 1.00" "/home/pi/RetroPie/roms/music/BGM.py"; then
	v100="(Enabled)"
	v75=""
	v50=""
	v25=""
elif grep -q "maxvolume = 0.75" "/home/pi/RetroPie/roms/music/BGM.py"; then
	v100=""
	v75="(Enabled)"
	v50=""
	v25=""
elif grep -q "maxvolume = 0.50" "/home/pi/RetroPie/roms/music/BGM.py"; then
	v100=""
	v75=""
	v50="(Enabled)"
	v25=""
elif grep -q "maxvolume = 0.25" "/home/pi/RetroPie/roms/music/BGM.py"; then
	v100=""
	v75=""
	v50=""
	v25="(Enabled)"
fi
}

main_menu
