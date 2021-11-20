#!/bin/bash
#RetroPie Background Music Overlay Control Script Version 1.65
SCRIPT_LOC="/home/pi/RetroPie/roms/music/BGM.py"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
INSTALL_DIR=$(dirname "${SCRIPT_LOC}")
MUSIC_DIR="$(grep 'musicdir =' "${SCRIPT_LOC}"|awk '{print $3}')"

SECTION="RetroPie Background Music Overlay v1.65"
BACKTITLE="RetroPie Background Music Overlay Control Script v1.65"
TITLE="RetroPie Background Music Overlay v1.65"
AUTOSTART="/opt/retropie/configs/all/autostart.sh"
OLDIFS=$IFS

main_menu() {
stats_check
    local choice
    while true; do
        choice=$(dialog --colors --backtitle "RetroPie Background Music Overlay Control Script v1.65		BGM On-Boot $bgmos		BGM Status $bgms		Volume: $volume		Now Playing: $ms" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose An Option Below" 25 85 20 \
            01 "Enable/Disable Background Music $bgms" \
            02 "Enable/Disable BGM On-Boot $bgmos" \
            03 "Volume Control $volume" \
            04 "Music Selection $ms" \
            - "-------------------------------------" \
            05 "Enable/Disable Overlay $ovs" \
            06 "Enable/Disable Overlay Fadeout $ovf" \
            07 "Adjust Overlay Fadeout Time $oft" \
            08 "Enable/Disable Overlay Rounded Corners $ocr" \
            09 "Enable/Disable Overlay Line Separator $ons" \
            10 "Enable/Disable Exit Splash $exs" \
            - "-------------------------------------" \
            11 "View RetroPie BGM Overlay Disclamer" \
            2>&1 > /dev/tty)
        case "$choice" in
            01) enable_music  ;;
            02) enable_musicos  ;;
            03) set_bgm_volume  ;;
            04) music_select  ;;
            05) overlay_enable  ;;
            06) overlay_fade_out  ;;
            07) overlay_fade_out_time ;;
            08) overlay_rounded_corners  ;;
            09) overlay_replace_newline  ;;
            10) exit_splash  ;;
            11) disclaim  ;;
            -) none  ;;
            +) nono  ;;
            *) break ;;
        esac
    done
}
enable_music() {
if [ -f "$INSTALL_DIR"/DisableMusic ]; then
	sudo rm -f "$INSTALL_DIR"/DisableMusic
	(nohup python ${SCRIPT_LOC} > /dev/null 2>&1) &
else
touch "$INSTALL_DIR"/DisableMusic
	pgrep -f "python $SCRIPT_LOC"|xargs sudo kill -9 > /dev/null 2>&1 &
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1 &
fi
sleep 1
stats_check
}
enable_musicos() {
if grep -q '#(nohup python '${SCRIPT_LOC}' > /dev/null 2>&1) &' "${AUTOSTART}"; then
	sudo sed -i 's/\#(nohup python/(nohup python/g' $AUTOSTART
elif grep -q '(nohup python '${SCRIPT_LOC}' > /dev/null 2>&1) &' "${AUTOSTART}"; then
	sudo sed -i 's/(nohup python/\#(nohup python/g' ${AUTOSTART}
fi
stats_check
}
set_bgm_volume() {
local NEW_VAL
NEW_VAL=$(dialog \
--backtitle "$BACKTITLE" \
--title "$TITLE" \
--rangebox "Set volume level (D+/U-): " 0 50 0 100 "$CUR_VOL" \
2>&1 >/dev/tty)
if [ -z "$NEW_VAL" ] || [ "$NEW_VAL" == "$CUR_VOL" ]; then return; fi;
echo "BGM volume set to $NEW_VAL%"
NEW_VAL=$(echo "$NEW_VAL" | awk '{print $1 / 100}')
export NEW_VAL
CUR_VAL=$(grep "maxvolume =" ${SCRIPT_LOC}|awk '{print $3}')
export CUR_VAL
perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = $ENV{NEW_VAL}/g' ${SCRIPT_LOC}
bgm_check
stats_check
}
overlay_enable() {
if grep -q 'overlay_enable = True' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_enable = True/overlay_enable = False/g' ${SCRIPT_LOC}
elif grep -q 'overlay_enable = False' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_enable = False/overlay_enable = True/g' ${SCRIPT_LOC}
fi
bgm_check
stats_check
}
overlay_fade_out() {
if grep -q 'overlay_fade_out = True' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_fade_out = True/overlay_fade_out = False/g' ${SCRIPT_LOC}
elif grep -q 'overlay_fade_out = False' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_fade_out = False/overlay_fade_out = True/g' ${SCRIPT_LOC}
fi
bgm_check
stats_check
}
overlay_fade_out_time() {
oldfadeouttime=$(grep "overlay_fade_out_time = " ${SCRIPT_LOC}|awk '{print $3}')
export oldfadeouttime
fadeouttime=$(dialog --colors --title "Adjust the Fadeout time of the Relay		BGM On-Boot $bgmos		BGM Status $bgms		Volume: $volume		Now Playing: $ms" --inputbox "Input the Relay Fadeout Time:" 8 40 3>&1 1>&2 2>&3 3>&-)
export fadeouttime
perl -p -i -e 's/overlay_fade_out_time = $ENV{oldfadeouttime}/overlay_fade_out_time = $ENV{fadeouttime}/g' ${SCRIPT_LOC}
bgm_check
stats_check
}
overlay_rounded_corners() {
if grep -q 'overlay_rounded_corners = True' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_rounded_corners = True/overlay_rounded_corners = False/g' ${SCRIPT_LOC}
elif grep -q 'overlay_rounded_corners = False' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_rounded_corners = False/overlay_rounded_corners = True/g' ${SCRIPT_LOC}
fi
bgm_check
stats_check
}
overlay_replace_newline() {
if grep -q 'overlay_replace_newline = True' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_replace_newline = True/overlay_replace_newline = False/g' ${SCRIPT_LOC}
elif grep -q 'overlay_replace_newline = False' "${SCRIPT_LOC}"; then
	sed -i -E 's/overlay_replace_newline = False/overlay_replace_newline = True/g' ${SCRIPT_LOC}
fi
bgm_check
stats_check
}
music_select() {
stats_check
local choice
    while true; do
        choice=$(dialog --colors --backtitle "Select Your Music Choice Below		BGM On-Boot $bgmos		BGM Status $bgms		Volume: $volume		Now Playing: $ms" --title " MAIN MENU " \
            --ok-label OK --cancel-label Back \
            --menu "What action would you like to perform? Background Music $bgms" 25 85 20 \
            01 "Enable/Disable Arcade Music" \
            02 "Enable/Disable BTTF Music" \
            03 "Enable/Disable Custom Music" \
            04 "Enable/Disable Nostalgia Trip V3 Music" \
            05 "Enable/Disable Supreme Team Music" \
            06 "Enable/Disable Ultimate Vs Fighter Music" \
            07 "Enable/Disable Venom Music" \
            08 "Disable Music Folder" \
            2>&1 > /dev/tty)
        case "$choice" in
            01) enable_arcade  ;;
            02) enable_bttf  ;;
            03) enable_custom  ;;
            04) enable_nt  ;;
            05) enable_st  ;;
            06) enable_uvf  ;;
            07) enable_venom  ;;
            08) disable_music_dir ;;
            *)  break ;;
        esac
    done
}
enable_arcade() {
if grep -q 'musicdir = musicdiroff' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirac/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirac/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirac/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdirac/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirac/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdiruvf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirac/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirac/g' ${SCRIPT_LOC}
else
if grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
fi
bgm_check
stats_check
}
enable_bttf() {
if grep -q 'musicdir = musicdiroff' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirbttf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirbttf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirbttf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdirbttf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirbttf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdiruvf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirbttf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirbttf/g' ${SCRIPT_LOC}
else
if grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
fi
bgm_check
stats_check
}
enable_custom() {
if grep -q 'musicdir = musicdiroff' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdircustom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdircustom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdircustom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdircustom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdircustom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdiruvf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdircustom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdircustom/g' ${SCRIPT_LOC}
else
if grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
fi
bgm_check
stats_check
}
enable_nt() {
if grep -q 'musicdir = musicdiroff' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirnt/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirnt/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirnt/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirnt/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirnt/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdiruvf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirnt/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirnt/g' ${SCRIPT_LOC}
else
if grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
fi
bgm_check
stats_check
}
enable_st() {
if grep -q 'musicdir = musicdiroff' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirst/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirst/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirst/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirst/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdirst/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdiruvf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirst/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdirst/g' ${SCRIPT_LOC}
else
if grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
fi
bgm_check
stats_check
}
enable_uvf() {
if grep -q 'musicdir = musicdiroff' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdiruvf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiruvf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiruvf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiruvf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdiruvf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiruvf/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiruvf/g' ${SCRIPT_LOC}
else
if grep -q 'musicdir = musicdiruvf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
fi
bgm_check
stats_check
}
enable_venom() {
if grep -q 'musicdir = musicdiroff' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiroff/musicdir = musicdirvenom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdirvenom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdirvenom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdirvenom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdirvenom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdirvenom/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdiruvf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdiruvf/musicdir = musicdirvenom/g' ${SCRIPT_LOC}
else
if grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
fi
bgm_check
stats_check
}
disable_music_dir() {
if grep -q 'musicdir =  musicdiroff' "${SCRIPT_LOC}"; then
	echo "Direcorty Already Disabled"
elif grep -q 'musicdir = musicdirac' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirac/musicdir = musicdiroff/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirbttf' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirbttf/musicdir = musicdiroff/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdircustom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdircustom/musicdir = musicdiroff/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirnt' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirnt/musicdir = musicdiroff/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirst' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirst/musicdir = musicdiroff/g' ${SCRIPT_LOC}
elif grep -q 'musicdir = musicdirvenom' "${SCRIPT_LOC}"; then
	sed -i -E 's/musicdir = musicdirvenom/musicdir = musicdiroff/g' ${SCRIPT_LOC}
fi
bgm_check
stats_check
}
exit_splash() {
if [ -f /home/pi/RetroPie/splashscreens/JarvisExitOff.mp4 ]; then
	sudo mv -f /home/pi/RetroPie/splashscreens/JarvisExitOff.mp4 /home/pi/RetroPie/splashscreens/JarvisExit.mp4
else
	sudo mv -f /home/pi/RetroPie/splashscreens/JarvisExit.mp4 /home/pi/RetroPie/splashscreens/JarvisExitOff.mp4
fi
stats_check
}
stats_check() {
enable="(\Z2Enabled\Zn)"
disable="(\Z1Disabled\Zn)"

if [ -f /home/pi/RetroPie/roms/music/DisableMusic ]; then
	bgms=$disable
else
	bgms=$enable
fi
if grep -q "#(nohup python ${SCRIPT_LOC} > /dev/null 2>&1) &" "$AUTOSTART"; then
	bgmos=$disable
elif grep -q "(nohup python ${SCRIPT_LOC} > /dev/null 2>&1) &" "$AUTOSTART"; then
	bgmos=$enable
else
	bgmos=$disable
fi
if grep -q "overlay_enable = True" "${SCRIPT_LOC}"; then
	ovs=$enable
else
	ovs=$disable
fi
if grep -q "overlay_fade_out = True" "${SCRIPT_LOC}"; then
	ovf=$enable
else
	ovf=$disable
fi
overlay_fadeout_time=$(grep "overlay_fade_out_time = " "$SCRIPT_LOC"|awk '{print $3}')
export overlay_fadeout_time
oft="(\Z3"$overlay_fadeout_time" Sec\Zn)"
if grep -q "overlay_rounded_corners = True" "${SCRIPT_LOC}"; then
	ocr=$enable
else
	ocr=$disable
fi
if grep -q "overlay_replace_newline = True" "${SCRIPT_LOC}"; then
	ons=$enable
else
	ons=$disable
fi
if grep -q "musicdir = musicdiroff" "${SCRIPT_LOC}"; then
	ms="(\Z1Disabled\Zn)"
elif grep -q "musicdir = musicdirac" "${SCRIPT_LOC}"; then
	ms="(\Z3Arcade\Zn)"
elif grep -q "musicdir = musicdirbttf" "${SCRIPT_LOC}"; then
	ms="(\Z3Back To The Future\Zn)"
elif grep -q "musicdir = musicdircustom" "${SCRIPT_LOC}"; then
	ms="(\Z3Custom\Zn)"
elif grep -q "musicdir = musicdirst" "${SCRIPT_LOC}"; then
	ms="(\Z3Supreme Team\Zn)"
elif grep -q "musicdir = musicdirnt" "${SCRIPT_LOC}"; then
	ms="(\Z3Nostalgia Trip V3\Zn)"
elif grep -q "musicdir = musicdiruvf" "${SCRIPT_LOC}"; then
	ms="(\Z3Ultimate Vs Fighter\Zn)"
elif grep -q "musicdir = musicdirvenom" "${SCRIPT_LOC}"; then
	ms="(\Z3Venom\Zn)"
else
	ms="(\Z3Other\Zn)"
fi
vol=$(grep "maxvolume =" "${SCRIPT_LOC}"|awk '{print $3}' | awk '{print $1 * 100}')
volume="(\Z3"$vol"%\Zn)"
if [ -f /home/pi/RetroPie/splashscreens/JarvisExitOff.mp4 ]; then
	exs=$disable
else
	exs=$enable
fi
}
bgm_check() {
if [ -f "$INSTALL_DIR"/DisableMusic ]
then
	echo "Background Music Disabled!"
else
	pgrep -f "python "$SCRIPT_LOC|xargs sudo kill -9 > /dev/null 2>&1 &
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1 &
	sleep 1
	(nohup python $SCRIPT_LOC > /dev/null 2>&1) &  > /dev/null 2>&1 &
fi
sleep 1
}
function disclaim() {
DISCLAIMER= ""
DISCLAIMER="${DISCLAIMER}_______________________________________________________\n\n"
DISCLAIMER="${DISCLAIMER}\n"
DISCLAIMER="${DISCLAIMER}RetroPie Background Music Overlay Control Script\n\n"
DISCLAIMER="${DISCLAIMER}The background music python script has been installed on this system.\n"
DISCLAIMER="${DISCLAIMER}This script will play MP3 & OGG files during menu navigation in either Emulation Station or Attract mode.\n"
DISCLAIMER="${DISCLAIMER}A Few special new folders have been created in the /home/pi/RetroPie/roms/music directory called \"arcade\"\n"
DISCLAIMER="${DISCLAIMER}(Arcade), \"bttf\" (Back To The Future), \"st\" (Supremem Team), \"uvf\" (Ultimate Vs Fighter), \"venom\" (Venom),\n"
DISCLAIMER="${DISCLAIMER}and this last one \"custom\" (Custom) is for placing your own MP3 files into.\n"
DISCLAIMER="${DISCLAIMER}Also included in this script is the ability to select between the different music folders you can disable them all\n"
DISCLAIMER="${DISCLAIMER}or enable them, but only one at a time, the music will then automatically start playing.\n"
DISCLAIMER="${DISCLAIMER}Launch a game, the music will stop. Upon exiting out of the game the music will begin playing again.\n"
DISCLAIMER="${DISCLAIMER}This also lets you turn off certain options for BGM.py such as, Enable/Disable the Overlay, Fadeout effect,\n"
DISCLAIMER="${DISCLAIMER}Rounded Corners on Overlays, an option to turn the dashes, or hyphens, with a space on both sides\n"
DISCLAIMER="${DISCLAIMER}\" - \"\n"
DISCLAIMER="${DISCLAIMER}and separate the song title to a separate newlines.\n"
DISCLAIMER="${DISCLAIMER}https://github.com/ALLRiPPED/retropie_music_overlay/\n"
dialog --colors --backtitle "RetroPie Background Music Overlay Control Script v2.00 beta		BGM On-Boot $bgmos		BGM Status $bgms		Volume: $volume		Now Playing: $ms" \
--title "DISCLAIMER" \
--msgbox "${DISCLAIMER}" 35 110
}
main_menu
