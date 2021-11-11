## RetroPie Background Music Overlay v1.60
This has all the files needed to install the background music script with added overlays!

If you would like to manually install this script:

     sudo apt-get install omxplayer python-pygame mpg123 imagemagick python-urllib3 libpng12-0 fbi python-pip python3-pip
&

     pip install requests gdown
then

     git clone https://github.com/ALLRiPPED/retropie_music_overlay.git
     cd retropie_music_overlay
     sudo chmod +x BGM_Install.sh
     ./BGM_Install.sh
and it will do the following:

Download stuff needed (make sure u have the dependencies above, if you have ODROID it should autodetect and install the needed ones)

Move pngview to the correct directory.

Create the /home/pi/RetroPie/roms/music folder for music.

Add a menu items in the retropie section to enable/disable the music and set volume, plus setup for custom and other music.

Picture here:<br>
<img src="https://i.imgur.com/d1uGlbm.png" alt="Preview" width="400" target="_blank"/>

## More Information
This is apart of a background music script I have been working on, does something similar to Kio Diekin's theme and music script, but mine only deals in music, and of course the splash screens installation.

This is open source and free for anyone to use, just drop me a little credit is all I ask.
the script has a one line install, so no need to clone a repo (it does all that for you), it has one of two ways to install, with my own custom music included and without so you can add your own, the first one included is Arcade Music ambient background noises from the arcades plus some arcade based music, second we have Back to the Future, this was taken from MBM's Pleasure Paradise Back To The Future build, third is Nostalgia Trip V3, from Damaso's NTv3 build, fourth is Supreme Team, this music is found on a base image of Supreme Ultra V1, fifth is Ultimate Vs Fighter music from David Ball's UVF build, and last, but definitely not least we have Kiodiekin's music from Venom ( I think I got it from the 327gb build).

Now if you so choose to install my custom music what you wil;l get is the music Soundtrack from the game Brutal Legends, starring Jack Black.
This "Custom" music consists of 108 Heavy Metal songs from the original game soundtrack.

I also included in the control script are ways to turn on and off certain features, like the Overlay itself, Overlay Fadeout, Rounded Corrners (purely cosmetic), and Line Separator that basically separates to a new line after a dash/hyphen is present in the file name, simplier terms it takes a file named

     Crash Team Racing Nitro-Fueled - Menu Theme
and shows up like this

     Crash Team Racing Nitro-Fueled
               Menu Theme

but there it is folks have fun

## Preview
[![](https://i.imgur.com/89zHvNN.png)](https://www.youtube.com/watch?v=99B3D2kEkZI "Preview")
## To install, This will Also Install Splash and Exit Screens
     wget -qO- https://git.io/JKum9 | bash

## To Update
     wget -qO- https://git.io/JPkkg | bash

## Future Plans
#### Adding the ability to turn the exit splash on or off
#### Adding the ability to change overlay and text colors
#### Adding the ability to change the placement of the overlay (top, bottom, right, left)
#### Adding the ability to change overlay and text colors
#### Adding the ability to change the size of the overlay
#### Adding the ability to change how long to hide the overlay in seconds

## CONFIG SECTION
Edit these manually to adjust the script to your needs:
<br>
startdelay = 0 # Value (in seconds) to delay audio start.  If you have a splash screen with audio and the script is playing music over the top of it, increase this value to delay the script from starting.

maxvolume = 0.50

volumefadespeed = 0.02

restart = True # If true, this will cause the script to fade the music out and -stop- the song rather than pause it.

startsong = "" # if this is not blank, this is the EXACT, CaSeSeNsAtIvE filename of the song you always want to play first on boot.

<br>
###Overlay Config###

overlay_enable = True # Enable or disable the overlay

overlay_fade_out = True # Change to "False" to have the overlay remain on the screen until an emulator/application is launched

overlay_fade_out_time = 5 # Hide the overlay after X seconds

overlay_pngview_location = '/usr/local/bin/pngview'

overlay_background_color = 'black'

overlay_text_color = 'white'

overlay_text_font = 'FreeSans'

overlay_tmp_file = '/dev/shm/song_title.png

overlay_rounded_corners = False #Set to "True" round the corners of the overlay

overlay_size = '600x64'

overlay_x_offset = '0'

overlay_y_offset = '0'
## Credits
Props to Livewire for the original script: https://retropie.org.uk/forum/topic/347/background-music-continued-from-help-support

Special thanks to AndrewFromMelbourne for pngview: https://github.com/AndrewFromMelbourne/raspidmx

RetroPie forum thread: https://retropie.org.uk/forum/topic/16458/modified-background-music-script-with-added-overlays

BGM Overlay code added by madmodder123

Version 1.01 - Changed song_title.png to write to RAM instead of the SD Card (Thanks zerojay!)

Version 1.60 - Added one line install and control scripts by thepitster
