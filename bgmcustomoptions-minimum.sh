#!/bin/bash
#RetroPie Background Music Overlay Control Script
ver="v2.20"
SCRIPT_LOC="/home/pi/.supreme_bgm/BGM.py"
INSTALL_DIR=$(dirname "${SCRIPT_LOC}")
MUSIC_DIR="/home/pi/RetroPie/roms/music"
MUSIC_DIR="${MUSIC_DIR/#~/$HOME}"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACKTITLE="RetroPie BGM Overlay Control Script $ver"
TITLE="RetroPie Background Music Overlay $ver"
AUTOSTART="/opt/retropie/configs/all/autostart.sh"
LOG_LOC="/dev/shm/retropiemo.log"
OLDIFS=$IFS

main_menu() {
stats_check
    local choice
    while true; do
        choice=$(dialog --colors --backtitle "RetroPie BGM Overlay Control Script $ver  BGM Status $bgms  Volume: $vol  Now Playing: $ms  Overlay POS: $vpos$hpos  Resolution: $resolution" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose An Option Below" 25 85 20 \
            - "------------BGM Settings-------------" \
            01 "Enable/Disable Background Music $bgms" \
            02 "Enable/Disable BGM On-Boot $bgmos" \
            03 "Volume Control $vol" \
            04 "Change Music Folder $ms" \
            05 "Disable Music Folder" \
            06 "Music Start Delay $msd" \
            - "-----------Overlay Settings----------" \
            07 "Overlay Settings" \
            - "----------------Other----------------" \
            08 "View RetroPie BGM Overlay Disclamer" \
            2>&1 > /dev/tty)
        case "$choice" in
            01) enable_music  ;;
            02) enable_musicos  ;;
            03) set_bgm_volume  ;;
            04) set_music_dir  ;;
            05) disable_music_dir ;;
            06) music_startdelay  ;;
            07) overlay_menu  ;;
            08) disclaim  ;;
            -) none  ;;
            +) nono  ;;
            *) break  ;;
        esac
    done
}
enable_music() {
if [ -f "$INSTALL_DIR"/DisableMusic ]; then
	sudo rm -f "$INSTALL_DIR"/DisableMusic
	(nohup python $SCRIPT_LOC > /dev/null 2>&1) &
else
touch "$INSTALL_DIR"/DisableMusic
	pgrep -f "python "$SCRIPT_LOC|xargs sudo kill -9 > /dev/null 2>&1 &
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1 &
fi
sleep 1
stats_check
}
enable_musicos() {
if grep -q "#(nohup python $SCRIPT_LOC > /dev/null 2>&1) &" "$AUTOSTART"; then
	sudo sed -i 's/\#(nohup python/(nohup python/g' $AUTOSTART
elif grep -q "(nohup python $SCRIPT_LOC > /dev/null 2>&1) &" "$AUTOSTART"; then
	sudo sed -i 's/(nohup python/\#(nohup python/g' $AUTOSTART
fi
stats_check
}
set_bgm_volume() {
  local CUR_VOL
  CUR_VOL=$(grep "maxvolume =" "$SCRIPT_LOC"|awk '{print $3}' | awk '{print $1 * 100}')
  export CUR_VOL
  local NEW_VOL
  NEW_VOL=$(dialog \
	--backtitle "$BACKTITLE" \
	--title "$TITLE" \
	--rangebox "Set volume level (D+/U-): " 0 50 0 100 "$CUR_VOL" \
	2>&1 >/dev/tty)
if [ -z "$NEW_VOL" ] || [ "$NEW_VOL" == "$CUR_VOL" ]; then return; fi;
  echo "BGM volume set to $NEW_VOL%"
  NEW_VOL=$(echo  "$NEW_VOL" | awk '{print $1 / 100}')
  export NEW_VOL
  CUR_VOL=$(echo  "$CUR_VOL" | awk '{print $1 / 100}')
  export CUR_VOL
perl -p -i -e 's/maxvolume = $ENV{CUR_VOL}/maxvolume = $ENV{NEW_VOL}/g' $SCRIPT_LOC
bgm_check
stats_check
}
set_music_dir() {
stats_check
  CUR_DIR=""
  CUR_PLY=""
  $SELECTION=""
  SELECT=""
  IFS=$'\n'
  local SELECTION
  CUR_DIR=$(grep "musicdir =" "$SCRIPT_LOC" |(awk '{print $3}') | tr -d '"')/
  export CUR_DIR
  while [ -z $SELECTION ]; do
    [[ "${CUR_DIR}" ]] && CUR_DIR="${CUR_DIR}"/
    local cmd=(dialog --colors \
      --backtitle "$BACKTITLE | Current Folder: $CUR_DIR  BGM Status $bgms  Volume: $vol  Now Playing: $ms  Overlay POS: $vpos$hpos  Resolution: $resolution" \
      --title "$TITLE" \
      --menu "Choose a music directory" 20 70 20 )
    local iterator=1
    local offset=-1
    local options=()
    if [ "$(dirname $CUR_DIR)" != "$CUR_DIR" ]; then
      options+=(0)
      options+=("Parent Directory")
      offset=$(($offset+2))
    fi
    options+=($iterator)
    options+=("<Use This Directory>")
    iterator=$(($iterator+1))
    for DIR in $(find "$CUR_DIR" -maxdepth 1 -mindepth 1 -type d | sort); do
      options+=($iterator)
      options+=("$(basename $DIR)")
      iterator=$(($iterator+1))
    done
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    case $choice in
      0) CUR_DIR="$(dirname $CUR_DIR)" ;;
      1) SELECTION="$CUR_DIR" ;;
      '') return ;;
      *) CUR_DIR="$CUR_DIR${options[ $((2*choice + $offset )) ]}" ;;
    esac
  done
  [[ "${MUSIC_DIR}" ]] && MUSIC_DIR="${MUSIC_DIR}"
  if [ "$SELECTION" != "$MUSIC_DIR" ]; then
    echo "Music directory changed to '$SELECTION'"
    CUR_PLY=$(grep "musicdir =" "$SCRIPT_LOC"|awk '{print $3}')
    export CUR_PLY
    SELECT=$(echo $SELECTION | sed 's:/*$::')
    sed -i -E "s|musicdir = ${CUR_PLY}|musicdir = \"${SELECT}\"|g" $SCRIPT_LOC
    bgm_check
  elif [ "$SELECTION" == "$MUSIC_DIR" ]; then
    echo "Music directory is already '$SELECTION'"
  else
    return
  fi
  IFS=$OLDIFS
bgm_check
stats_check
}
disable_music_dir() {
CUR_PLY=$(grep "musicdir =" "$SCRIPT_LOC"|awk '{print $3}')
export CUR_PLY
DEF_DIR='"/home/pi/.supreme_bgm"'
export DEF_DIR
sed -i -E "s|musicdir = ${CUR_PLY}|musicdir = ${DEF_DIR}|g" $SCRIPT_LOC
bgm_check
stats_check
}
music_startdelay() {
oldstartdelaytime=$(grep "startdelay = " "$SCRIPT_LOC"|awk '{print $3}')
export oldstartdelaytime
startdelaytime=$(dialog --colors --title "Adjust the Music Start Delay" \
	--inputbox "Input the Start Delay Time:" 8 40 "$oldstartdelaytime" 3>&1 1>&2 2>&3 3>&-)
export startdelaytime
if [ $startdelaytime ]; then
perl -p -i -e 's/startdelay = $ENV{oldstartdelaytime}/startdelay = $ENV{startdelaytime}/g' $SCRIPT_LOC
else
	return
fi
bgm_check
stats_check
}
overlay_menu() {
stats_check
local choice
    while true; do
        choice=$(dialog --colors --backtitle "Choose OverLay Settings Below  BGM Status $bgms  Volume: $vol  Now Playing: $ms  Overlay POS: $vpos$hpos  Resolution: $resolution" --title " MAIN MENU " \
            --ok-label OK --cancel-label Back \
            --menu "What action would you like to perform?" 25 85 20 \
            01 "Enable/Disable Overlay $ovs" \
            02 "Enable/Disable Overlay Fadeout $ovf" \
            03 "Adjust Overlay Fadeout Time $oft" \
            04 "Enable/Disable Overlay Rounded Corners $ocr" \
            05 "Enable/Disable Overlay Line Separator $ons" \
            06 "Vertical Position: $vpos" \
            07 "Horizontal Position: $hpos" \
            2>&1 > /dev/tty)
        case "$choice" in
            01) overlay_enable  ;;
            02) overlay_fade_out  ;;
            03) overlay_fade_out_time  ;;
            04) overlay_rounded_corners  ;;
            05) overlay_replace_newline  ;;
            06) overlay_v_pos  ;;
            07) overlay_h_pos  ;;
            *)  break ;;
        esac
    done
}
overlay_enable() {
if grep -q 'overlay_enable = True' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_enable = True/overlay_enable = False/g' $SCRIPT_LOC
elif grep -q 'overlay_enable = False' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_enable = False/overlay_enable = True/g' $SCRIPT_LOC
fi
bgm_check
stats_check
}
overlay_fade_out() {
if grep -q 'overlay_fade_out = True' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_fade_out = True/overlay_fade_out = False/g' $SCRIPT_LOC
elif grep -q 'overlay_fade_out = False' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_fade_out = False/overlay_fade_out = True/g' $SCRIPT_LOC
fi
bgm_check
stats_check
}
overlay_fade_out_time() {
oldfadeouttime=$(grep "overlay_fade_out_time = " "$SCRIPT_LOC"|awk '{print $3}')
export oldfadeouttime
fadeouttime=$(dialog \
	--colors \
	--title "Adjust the Fadeout time of the Relay" \
	--inputbox "Input the Relay Fadeout Time:" 8 40 "$oldfadeouttime" 3>&1 1>&2 2>&3 3>&-)
export fadeouttime
if [ $fadeouttime ]; then
perl -p -i -e 's/overlay_fade_out_time = $ENV{oldfadeouttime}/overlay_fade_out_time = $ENV{fadeouttime}/g' $SCRIPT_LOC
else
	return
fi
bgm_check
stats_check
}
overlay_rounded_corners() {
if grep -q 'overlay_rounded_corners = True' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_rounded_corners = True/overlay_rounded_corners = False/g' $SCRIPT_LOC
elif grep -q 'overlay_rounded_corners = False' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_rounded_corners = False/overlay_rounded_corners = True/g' $SCRIPT_LOC
fi
bgm_check
stats_check
}
overlay_replace_newline() {
if grep -q 'overlay_replace_newline = True' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_replace_newline = True/overlay_replace_newline = False/g' $SCRIPT_LOC
elif grep -q 'overlay_replace_newline = False' "$SCRIPT_LOC"; then
	sed -i -E 's/overlay_replace_newline = False/overlay_replace_newline = True/g' $SCRIPT_LOC
fi
bgm_check
stats_check
}
overlay_v_pos() {
CUR_VPOS=$(grep "overlay_y_offset =" "$SCRIPT_LOC"|awk '{print $3}')
export CUR_VPOS
NEW_VPOST='"0"'
export NEW_VPOST
NEW_VPOSB=\"$((height-overlay_h_size))\"
export NEW_VPOSB
if [ $CUR_VPOS = \"0\" ]; then
	sed -i -E "s/overlay_y_offset = ${CUR_VPOS}/overlay_y_offset = ${NEW_VPOSB}/g" $SCRIPT_LOC
else
	sed -i -E "s/overlay_y_offset = ${CUR_VPOS}/overlay_y_offset = ${NEW_VPOST}/g" $SCRIPT_LOC
fi
bgm_check
stats_check
}
overlay_h_pos() {
CUR_HPOS=$(grep "overlay_x_offset =" "${SCRIPT_LOC}"|awk '{print $3}')
export CUR_HPOS
NEW_HPOSL='"0"'
export NEW_HPOSL
NEW_HPOSR=\"$((width-overlay_w_size))\"
export NEW_HPOSR
if [ $CUR_HPOS = \"0\" ]; then
	sed -i -E "s/overlay_x_offset = ${CUR_HPOS}/overlay_x_offset = ${NEW_HPOSR}/g" $SCRIPT_LOC
else
	sed -i -E "s/overlay_x_offset = ${CUR_HPOS}/overlay_x_offset = ${NEW_HPOSL}/g" $SCRIPT_LOC
fi
bgm_check
stats_check
}
stats_check() {
enable="(\Z2Enabled\Zn)"
disable="(\Z1Disabled\Zn)"
if [ -f /home/pi/.supreme_bgm/DisableMusic ]; then
	bgms=$disable
else
	bgms=$enable
fi
if grep -q "#(nohup python $SCRIPT_LOC > /dev/null 2>&1) &" "$AUTOSTART"; then
	bgmos=$disable
elif grep -q "(nohup python $SCRIPT_LOC > /dev/null 2>&1) &" "$AUTOSTART"; then
	bgmos=$enable
fi
if grep -q "overlay_enable = True" "$SCRIPT_LOC"; then
	ovs=$enable
else
	ovs=$disable
fi
if grep -q "overlay_fade_out = True" "$SCRIPT_LOC"; then
	ovf=$enable
else
	ovf=$disable
fi
overlay_fadeout_time=$(grep "overlay_fade_out_time = " "$SCRIPT_LOC"|awk '{print $3}')
oft="(\Z3$overlay_fadeout_time Sec\Zn)"
msd=$(grep "startdelay = " "$SCRIPT_LOC"|awk '{print $3}')
msd="(\Z3$msd Sec.\Zn)"
if grep -q "overlay_rounded_corners = True" "$SCRIPT_LOC"; then
	ocr=$enable
else
	ocr=$disable
fi
if grep -q "overlay_replace_newline = True" "$SCRIPT_LOC"; then
	ons=$enable
else
	ons=$disable
fi
CUR_HPOS=$(grep "overlay_x_offset =" "$SCRIPT_LOC"|awk '{print $3}' | tr -d '"')
if [ $CUR_HPOS = "0" ]; then
	hpos="(\Z3Left\Zn)"
else
	hpos="(\Z3Right\Zn)"
fi
CUR_VPOS=$(grep "overlay_y_offset =" "$SCRIPT_LOC"|awk '{print $3}' | tr -d '"')
export CUR_VPOS
if [ $CUR_VPOS = "0" ]; then
	vpos="(\Z3Top\Zn)"
else
	vpos="(\Z3Bottom\Zn)"
fi
if grep -q 'musicdir = "/home/pi/.supreme_bgm"' "$SCRIPT_LOC"; then
	ms=$disable
else
	CUR_PLY=$(grep "musicdir =" "$SCRIPT_LOC"|awk '{print $3}')
	export CUR_PLY
	ms="(\Z3$(basename $CUR_PLY | tr -d '"')\Zn)"
fi
vol=$(grep "maxvolume =" "$SCRIPT_LOC"|awk '{print $3}' | awk '{print $1 * 100}')
vol="(\Z3$vol%\Zn)"
width=$(fbset -fb /dev/fb0 | grep '\".*\"' | grep -m 1 -o '[0-9][0-9][0-9]\+x' | tr -d 'x')
height=$(fbset -fb /dev/fb0 | grep '\".*\"' | grep -m 1 -o 'x[0-9][0-9][0-9]\+' | tr -d 'x')
if [ "${width}" -ge 3800 ] && [ "${height}" -ge 2100 ]; then
	res="2160p"
elif [ "${width}" -ge 1900 ] && [ "${height}" -ge 1000 ] && [ "${width}" -le 2100 ] && [ "${height}" -le 3800 ]; then
	res="1080p"
elif [ "${width}" -ge 1000 ] && [ "${height}" -ge 600 ] && [ "${width}" -le 1900 ] && [ "${height}" -le 1000 ]; then
	res="720p"
elif [ "${height}" -le 599 ]; then
	res="SD"
fi
resolution="(\Z3$res\Zn)"
if [ "${width}" -ge 1900 ] && [ "${height}" -ge 1000 ]; then
	overlay_w_size=600
	overlay_h_size=32
elif [ "${width}" -ge 1000 ] && [ "${height}" -ge 600 ] && [ "${width}" -le 1900 ] && [ "${height}" -le 1000 ]; then
	overlay_w_size=300
	overlay_h_size=21
elif [ "${height}" -le 599 ]; then
	overlay_w_size=150
	overlay_h_size=15
fi
}
bgm_check() {
if [ -f "$INSTALL_DIR"/DisableMusic ]; then
	echo "Background Music Disabled!"
else
	pgrep -f "python "$SCRIPT_LOC |xargs sudo kill -9 > /dev/null 2>&1 &
	pgrep -f pngview|xargs sudo kill -9 > /dev/null 2>&1 &
	sleep 1
	(nohup python $SCRIPT_LOC > /dev/null 2>&1) &
fi
sleep 1
}
disclaim() {
DISCLAIMER=""
DISCLAIMER="${DISCLAIMER}_______________________________________________________\n\n"
DISCLAIMER="${DISCLAIMER}\n"
DISCLAIMER="${DISCLAIMER}RetroPie Background Music Overlay Control Script\n\n"
DISCLAIMER="${DISCLAIMER}The background music python script has been installed on this system.\n"
DISCLAIMER="${DISCLAIMER}This script will play MP3 & OGG files during menu navigation in either Emulation Station or Attract mode.\n"
DISCLAIMER="${DISCLAIMER}Also included in this script is the ability to select between the different music folders you can disable them all\n"
DISCLAIMER="${DISCLAIMER}or enable them, but only one at a time, the music will then automatically start playing.\n"
DISCLAIMER="${DISCLAIMER}Launch a game, the music will stop. Upon exiting out of the game the music will begin playing again.\n"
DISCLAIMER="${DISCLAIMER}This also lets you turn off certain options for BGM.py such as, Enable/Disable the Overlay, Fadeout effect,\n"
DISCLAIMER="${DISCLAIMER}Rounded Corners on Overlays, an option to turn the dashes, or hyphens, with a space on both sides\n"
DISCLAIMER="${DISCLAIMER}\" - \"\n"
DISCLAIMER="${DISCLAIMER}and separate the song title to separate new line(s).\n"
DISCLAIMER="${DISCLAIMER}\n"
DISCLAIMER="${DISCLAIMER}Overlay disappeared when you change resolutions? Set postion to Top-Left so you can see\n"
DISCLAIMER="${DISCLAIMER}it then set it to desired postition, compatible with all resolutions.\n"
DISCLAIMER="${DISCLAIMER}\n"
DISCLAIMER="${DISCLAIMER}https://github.com/ALLRiPPED/retropie_music_overlay\n"
dialog --colors --backtitle "RetroPie BGM Overlay Control Script $ver  BGM Status $bgms  Volume: $vol  Music: $ms  Overlay: $vpos$hpos  Resolution: $resolution" \
--title "DISCLAIMER" \
--msgbox "${DISCLAIMER}" 35 110
}
main_menu
