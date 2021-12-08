## RetroPie Background Music Overlay v2.06
## To install, This will Also Install Splash and Exit Screens
     wget -qO- https://git.io/JKum9 | bash

This has all the files needed to install the background music script with added overlays!<br>
If you would like to manually install this script:

     sudo apt-get install omxplayer python-pygame mpg123 imagemagick python-urllib3 libpng12-0 fbi python-pip python3-pip
&

     pip install requests gdown
then

     git clone https://github.com/ALLRiPPED/retropie_music_overlay.git
     cd retropie_music_overlay
     git checkout tags/rpbgmov2.06
     sudo chmod +x Quick_BGM_Install.sh
     ./Quick_BGM_Install.sh
and it will do the following:<br>
Download stuff needed (make sure u have the dependencies above, if you have ODROID it should autodetect and install the needed ones)<br>
Move pngview to the correct directory.<br>
Create the /home/pi/RetroPie/roms/music folder for music.<br>
Add a menu items in the retropie section to enable/disable the music and set volume, plus setup for custom and other music.<br>
Picture here:<br>
<img src="https://i.imgur.com/TcohoFg.png" alt="Preview" width="400" target="_blank"/><br>
## More Information
This is apart of a background music script I have been working on, does something similar to Kio Diekin's theme and music script, but mine only deals in music, and of course the splash screens installation.<br>
This is open source and free for anyone to use, just drop me a little credit is all I ask.<br>
the script has a one line install, so no need to clone a repo (it does all that for you), it has one of two ways to install, with my own custom music included and without so you can add your own, the first one included is Arcade Music ambient background noises from the arcades plus some arcade based music, second we have Back to the Future, this was taken from MBM's Pleasure Paradise Back To The Future build, third is Nostalgia Trip V3, from Damaso's NTv3 build, fourth is Supreme Team, this music is found on a base image of Supreme Ultra V1, fifth is Ultimate Vs Fighter music from David Ball's UVF build, and last, but definitely not least we have Kiodiekin's music from Venom ( I think I got it from the 327gb build).<br>
Now if you so choose to install my custom music what you will get is the music Soundtrack from the game Brutal Legends, starring Jack Black.<br>
This "Custom" music consists of 108 Heavy Metal songs from the original game soundtrack.<br>
I also included in the control script are ways to turn on and off certain features, like the Overlay itself, Overlay Fadeout, Rounded Corrners (purely cosmetic), and Line Separator that basically separates to a new line after a dash/hyphen is present in the file name, simplier terms it takes a file named

     Crash Team Racing Nitro-Fueled - Menu Theme
and shows up like this

     Crash Team Racing Nitro-Fueled
               Menu Theme

but there it is folks have fun

## Preview
[![](https://i.imgur.com/WK4khHF.png)](https://youtu.be/5VVGCeC3-yw "Demo Preview")
## Future Plans
#### Not Done. <img src="https://i.imgur.com/Jp2FKHX.png" alt="Not Done" style="float: left; margin-right: 10px;" /> Adding the ability to the control script to change overlay and text colors.
#### Not Done. <img src="https://i.imgur.com/Jp2FKHX.png" alt="Not Done" style="float: left; margin-right: 10px;" /> Adding the ability to the control script to change the size of the overlay.
#### Done. <img src="https://i.imgur.com/HtSxEyc.png" alt="Done" style="float: left; margin-right: 10px;" /> ~~Adding the ability to the control script to change the placement of the overlay (top, bottom, right, left).~~ 
#### Done. <img src="https://i.imgur.com/HtSxEyc.png" alt="Done" style="float: left; margin-right: 10px;" /> ~~Adding the ability to the control script to change the music directory to a custom location.~~
#### Done. <img src="https://i.imgur.com/HtSxEyc.png" alt="Done" style="float: left; margin-right: 10px;" /> ~~Adding the ability to the control script to change how long to hide the overlay in seconds.~~
#### Done. <img src="https://i.imgur.com/HtSxEyc.png" alt="Done" style="float: left; margin-right: 10px;" /> ~~Adding the ability to turn the exit splash on or off.~~

## Color Section

This is where you will find the info you will need to change the colors of the background and font on the Overlay.<br>
At the moment I have a color table here with color names that can be typed in to the RPBGMO bash gui, right now they have to be typed in cause getting bash script color is not as easy to code as you would think.
### [Table of Color Names](https://allripped.github.io/ImageMagickColors.html)

## CONFIG SECTION
Edit these manually to adjust the script to your needs:
<br>
startdelay = 0 # Value (in seconds) to delay audio start.  If you have a splash screen with audio and the script is playing music over the top of it, increase this value to delay the script from starting.

maxvolume = 0.50<br>
volumefadespeed = 0.02<br>
restart = True # If true, this will cause the script to fade the music out and -stop- the song rather than pause it.<br>
startsong = "" # if this is not blank, this is the EXACT, CaSeSeNsAtIvE filename of the song you always want to play first on boot.<br>
<br>
###Overlay Config###

overlay_enable = True # Enable or disable the overlay<br>
overlay_fade_out = True # Change to "False" to have the overlay remain on the screen until an emulator/application is launched<br>
overlay_fade_out_time = 5 # Hide the overlay after X seconds<br>
overlay_pngview_location = '/usr/local/bin/pngview'<br>
overlay_background_color = 'black'<br>
overlay_text_color = 'white'<br>
overlay_text_font = 'FreeSans'<br>
overlay_tmp_file = '/dev/shm/song_title.png<br>
overlay_rounded_corners = False #Set to "True" round the corners of the overlay<br>
overlay_size = '600x64'<br>
overlay_x_offset = '0'<br>
overlay_y_offset = '0'<br>
## Credits
Props to Livewire for the original script: https://retropie.org.uk/forum/topic/347/background-music-continued-from-help-support<br>
Special thanks to AndrewFromMelbourne for pngview: https://github.com/AndrewFromMelbourne/raspidmx<br>
RetroPie forum thread: https://retropie.org.uk/forum/topic/16458/modified-background-music-script-with-added-overlays<br>
BGM Overlay code added by madmodder123<br>
Version 1.01 - Changed song_title.png to write to RAM instead of the SD Card (Thanks zerojay!)<br>
Version 1.60 - Added one line install and control scripts by thepitster<br>
