This has all the files needed to install the background music script with added overlays!

Install Dependencies:

     sudo apt-get install omxplayer python-pygame mpg123 imagemagick python-urllib3 libpng12-0 fbi
&

     pip install requests

Just make the bash script executable with "sudo chmod +x BGM_Install.sh" and run it (NOT AS ROOT!!!) ("./BGM_Install.sh") and it will do the following:

Download stuff needed (make sure u have the dependencies above, if you have ODROID it should autodetect and install the needed ones)

Move pngview to the correct directory.

Create the /home/pi/RetroPie/roms/music folder for music.

Add a menu items in the retropie section to enable/disable the music and set volume, plus setup for custom and other music.

Pictures here: https://imgur.com/a/J9iek

## To install
```
wget -qO- https://raw.githubusercontent.com/ALLRiPPED/retropie_music_overlay/master/BGM_Install.sh | bash
```

<b>You will still have to set up the script to run automatically when the Pi boots!:
Run "sudo nano /etc/rc.local"
Near the bottom, on the line above "exit 0", put the following code

     su pi -c 'python /home/pi/RetroPie/roms/music/BGM.py &'

Press Control+X, Y, and Enter to save changes.
Reboot and enjoy!</b>
(Note: you must change "pi" to "pigaming" if you are running RetroPie on an ODROID!)

Example rc.local file: https://pastebin.com/E8NvrJJ1

<br><br>
Edit these to adjust the script to your needs:
<br>
###CONFIG SECTION###

startdelay = 0 # Value (in seconds) to delay audio start.  If you have a splash screen with audio and the script is playing music over the top of it, increase this value to delay the script from starting.

musicdir = '/home/pi/RetroPie/roms/music'

maxvolume = 0.50

volumefadespeed = 0.02

restart = True # If true, this will cause the script to fade the music out and -stop- the song rather than pause it.

startsong = "" # if this is not blank, this is the EXACT, CaSeSeNsAtIvE filename of the song you always want to play first on boot.

<br>
###Overlay Config###

overlay_pngview_location = '/usr/local/bin/pngview'

overlay_background_color = 'black'

overlay_text_color = 'white'

overlay_text_font = 'FreeSans'

overlay_tmp_file = '/dev/shm/song_title.png

<br><br>


Props to Livewire for the original script: https://retropie.org.uk/forum/topic/347/background-music-continued-from-help-support

Special thanks to AndrewFromMelbourne for pngview: https://github.com/AndrewFromMelbourne/raspidmx

RetroPie forum thread: https://retropie.org.uk/forum/topic/16458/modified-background-music-script-with-added-overlays
