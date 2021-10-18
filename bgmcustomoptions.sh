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
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            01 "Disable background music $bgmsd" \
            02 "Enable background music $bgmse" \
            03 "Volume background music: 100% $v100" \
            04 "Volume background music: 75% $v75" \
            05 "Volume background music: 50% $v50" \
            06 "Volume background music: 25% $v25" \
            07 "Enable/Disable Overlay $ovs" \
            08 "Enable/Disable Overlay Fadeout $ovf" \
            09 "Enable/Disable Overlay Rounded Corners $ocr" \
            10 "Enable/Disable Overlay Line Separator $ons" \
            11 "Music Selection $ms" \
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
            11) music_select  ;;
            *)  break ;;
        esac
    done
}
function disable_music() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
echo "Background Music Already Disabled!"
else
touch /home/pi/RetroPie/roms/music/DisableMusic
sudo pkill -f BGM.py
sudo pkill -f pngview
fi
sleep 2
stats_check
}
function enable_music() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
sudo rm -f /home/pi/RetroPie/roms/music/DisableMusic
if grep -q 'maxvolume = 0.50' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.50/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
elif grep -q 'maxvolume = 0.75' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.75/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
elif grep -q 'maxvolume = 1.00' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 1.00/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
elif grep -q 'maxvolume = 0.25' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/maxvolume = 0.25/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
else
echo "Background Music Already Enabled!"
fi
sleep 2
stats_check
}
function volume100() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function volume75() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function volume50() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function volume25() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function overlay_enable() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function overlay_fade_out() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function overlay_rounded_corners() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function overlay_replace_newline() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function music_select() {
local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Back \
            --menu "What action would you like to perform?" 25 75 20 \
            01 "Enable Arcade music" \
            02 "Disable Arcade music" \
            03 "Enable BTTF music" \
            04 "Disable BTTF music" \
            05 "Enable Custom music" \
            06 "Disable Custom music" \
            07 "Enable Supreme Team music" \
            08 "Disable Supreme Team music" \
            09 "Enable Ultimate Vs Fighter music" \
            10 "Disable Ultimate Vs Fighter music" \
            11 "Enable Venom music" \
            12 "Disable Venom music" \
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
stats_check
}
function enable_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Enabled"
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
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
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function disable_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Arcade Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!" 3 30 ; sleep 2
else
	sudo pkill -f BGM.py
	udo pkill -f pngview
fi
sleep 2
stats_check
}
function enable_bttf() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Enabled"
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
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
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function disable_bttf() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "BTTF Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
	echo "BTTF Music Disabled"
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
fi
sleep 2
stats_check
}
function enable_custom() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Enabled" 3 34 ; sleep 2
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
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
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function disable_custom() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Custom Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
fi
sleep 2
stats_check
}
function enable_st() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Enabled"
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
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
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function disable_st() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "ST Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
fi
sleep 2
stats_check
}
function enable_uvf() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "UVF Music Already Enabled"
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
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
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function disable_uvf() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "UFV Music Already Disabled"
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "UVF Music Already Disabled"
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "UVF Music Already Disabled"
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "UVF Music Already Disabled"
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "UVF Music Already Disabled"
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "UVF Music Already Disabled"
elif grep -q 'musicdir = musicdiruvf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
fi
sleep 2
stats_check
}
function enable_venom() {
dialog --infobox "...processing..." 3 20 ; sleep 2
if grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Venom Music Already Enabled"
elif grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
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
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
	python /home/pi/RetroPie/roms/music/BGM.py &
fi
sleep 2
stats_check
}
function disable_venom() {
if grep -q 'musicdir = musicdiroff' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirac' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirbttf' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdircustom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirst' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	echo "Venom Music Already Disabled" 3 32 ; sleep 2
elif grep -q 'musicdir = musicdirvenom' "/home/pi/RetroPie/roms/music/BGM.py"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiroff/g' /home/pi/RetroPie/roms/music/BGM.py
fi
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	sudo pkill -f BGM.py
	sudo pkill -f pngview
fi
sleep 2
stats_check
}
function stats_check() {
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]; then
	bgmsd="(Disabled)"
	bgmse=""
else
	bgmsd=""
	bgmse="(Enabled)"
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
