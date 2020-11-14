## recurring task

	periodic checks were made using sleep in source code.
	this has been changed to use crontab. But this fails in ubuntu.

	to fix this, use a standard location for wallpaper:

		~/Wallpaper/badabing.png

	the wallpaper location is registered when the app is run interactively so gsettings will work.
	the cron job merely has to copy/rename a file.

## instructions

	The first time, you must run interactively, this will set the default desktop environment for cron jobs. Use preference screen recurrence setting to write out he cronjob. The cron job will use --desktop flag to pass this value.

## preferences

	put a check in the code to write default schema settings if not found.

	remove the preferences option to Start Minimized

	add a preferences option to install catlock

	check the 'Use System Tray Indicator' flag in code to notify user.



* *  * * * DISPLAY=unix:0.0 /home/darko/bin/refresh-menu.sh
1 0  * * * DISPLAY=unix:0.0 /home/darko/bin/badabing.sh


#!/usr/local/bin/bash
#
#   run badabing from crontab
#
SHELL=/usr/local/bin/bash
HOME=/home/darko
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/darko/bin:/home/darko/.yarn/bin:/usr/local/lib

geometry=$(xrandr | grep -w connected  | awk -F'[ \+]' '{print $3}')
width=$(echo $geometry | cut -f1 -dx)
height=$(echo $geometry | cut -f2 -dx)

/usr/local/bin/com.github.darkoverlordofdata.badabing --update --width=$width --height=$height

=======================================================================================
=======================================================================================
=======================================================================================

mate
SIZE = 0, 0
**
ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Bail out! ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Abort trap (core dumped)
[darko@barsoomian /usr/home/darko]$ com.github.darkoverlordofdata.badabing
gsettings set org.mate.background picture-filename /home/darko/Pictures/badabing.jpgDESKTOP_SESSION = mate
mate
SIZE = 0, 0
**
ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Bail out! ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Abort trap (core dumped)
[darko@barsoomian /usr/home/darko]$ com.github.darkoverlordofdata.badabing
gsettings set org.mate.background picture-filename /home/darko/Pictures/badabing.jpgDESKTOP_SESSION = mate
mate
SIZE = 0, 0
**
ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Bail out! ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Abort trap (core dumped)
[darko@barsoomian /usr/home/darko]$ com.github.darkoverlordofdata.badabing
gsettings set org.mate.background picture-filename /home/darko/Pictures/badabing.jpgDESKTOP_SESSION = mate
mate
SIZE = 0, 0
**
ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Bail out! ERROR:../src/WallpaperApplication.vala:420:bada_bing_wallpaper_application_updateWallpaper: assertion failed: (screen_width != 0)
Abort trap (core dumped)
[darko@barsoomian /usr/home/darko]$ com.github.darkoverlordofdata.badabing
gsettings set org.mate.background picture-filename /home/darko/Pictures/badabing.jpgHey, you clicked /home/darko/.local/share/badabing/ConneryPond_EN-US4665862450.jpg 
DESKTOP_SESSION = mate
mate
SIZE = 1366, 768
Notify
convert: unable to open image `/home/darko/.local/share/catlock/themes/badabing/avatar.png': No such file or directory @ error/blob.c/OpenBlob/2881.
convert: image sequence is required `-composite' @ error/mogrify.c/MogrifyImageList/7985.
convert: no images defined `/home/darko/.local/share/catlock/themes/badabing/box.jpg' @ error/convert.c/ConvertImageCommand/3226.
[darko@barsoomian /usr/home/darko]$ 

