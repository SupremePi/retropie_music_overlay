#!/bin/bash
#RetroPie Background Music Control Script Version 1.60
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}RetroPie Background Music Control Script\n\n"
infobox="${infobox}The background music python script has been installed on this system.\n"
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
infobox="${infobox}and separate the song title to a separate newlines.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"

dialog --backtitle "RetroPie Background Music Control Script v1.60" \
--title "RetroPie Background Music Control Script v1.60" \
--msgbox "${infobox}" 35 110

function main_menu() {
stats_check
    local choice

    while true; do
        choice=$(dialog --backtitle "RetroPie Background Music Control Script v1.60		BGM On-Boot $bgmos		BGM Status $bgms		Volume: $volume		Now Playing: $ms" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose An Option Below" 25 85 20 \
            01 "Enable/Disable Background Music $bgms" \
            02 "Enable/Disable BGM On-Boot $bgmos" \
            03 "Enable/Disable Overlay $ovs" \
            04 "Enable/Disable Overlay Fadeout $ovf" \
            05 "Enable/Disable Overlay Rounded Corners $ocr" \
            06 "Enable/Disable Overlay Line Separator $ons" \
            07 "Music Selection $ms" \
            08 "Background Music Volume Control" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) enable_music  ;;
            02) enable_musicos  ;;
            03) overlay_enable  ;;
            04) overlay_fade_out  ;;
            05) overlay_rounded_corners  ;;
            06) overlay_replace_newline  ;;
            07) music_select  ;;
            08) vol_menu  ;;
            *)  break ;;
        esac
    done
}
function enable_music() {
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
sudo rm -f /home/pi/RetroPie/roms/music/DisableMusic
        CUR_VAL=`grep "maxCUR_VAL =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxCUR_VAL = $ENV{CUR_VAL}/maxCUR_VAL = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
        (python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
else
touch /home/pi/RetroPie/roms/music/DisableMusic
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
function vol_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "RetroPie Background Music Volume Control		BGM On-Boot $bgmos		BGM Status $bgms		Volume: $volume		Now Playing: $ms" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "You can choose the volume level one after another until you are happy with your settings." 25 75 20 \
            01 "Set Background Music Volume to 100%" \
            02 "Set Background Music Volume to 90%" \
            03 "Set Background Music Volume to 80%" \
            04 "Set Background Music Volume to 70%" \
            05 "Set Background Music Volume to 60%" \
            06 "Set Background Music Volume to 50%" \
            07 "Set Background Music Volume to 40%" \
            08 "Set Background Music Volume to 30%" \
            09 "Set Background Music Volume to 20%" \
            10 "Set Background Music Volume to 10%" \
            2>&1 > /dev/tty)

        case "$choice" in
            01) 100_v  ;;
            02) 90_v  ;;
            03) 80_v  ;;
            04) 70_v  ;;
            05) 60_v  ;;
            06) 50_v  ;;
            07) 40_v  ;;
            08) 30_v  ;;
            09) 20_v  ;;
            10) 10_v  ;;
            *)  break ;;
        esac
    done
}
function 100_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 1.00/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 90_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.90/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 80_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.80/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 70_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.70/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 60_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.60/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 50_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.50/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 40_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.40/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 30_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.30/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 20_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.20/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
	(python /home/pi/RetroPie/roms/music/BGM.py >/dev/null 2>&1) &
fi
sleep 2
stats_check
}
function 10_v() {
	CUR_VAL=`grep "maxvolume =" /home/pi/RetroPie/roms/music/BGM.py|awk '{print $3}'`
	export CUR_VAL
	perl -p -i -e 's/maxvolume = $ENV{maxvolume}/maxvolume = 0.10/g' /home/pi/RetroPie/roms/music/BGM.py
if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	pgrep -f "python /home/pi/RetroPie/roms/music/BGM.py"|xargs sudo kill -9 > /dev/null 2>&1
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1
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
	ms="(Back To The Future)"
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
	volume="100%"
elif grep -q "maxvolume = 0.90" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="90%"
elif grep -q "maxvolume = 0.80" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="80%"
elif grep -q "maxvolume = 0.70" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="70%"
elif grep -q "maxvolume = 0.60" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="60%"
elif grep -q "maxvolume = 0.50" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="50%"
elif grep -q "maxvolume = 0.40" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="40%"
elif grep -q "maxvolume = 0.30" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="30%"
elif grep -q "maxvolume = 0.20" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="20%"
elif grep -q "maxvolume = 0.10" "/home/pi/RetroPie/roms/music/BGM.py"; then
	volume="10%"
fi
}
main_menu
