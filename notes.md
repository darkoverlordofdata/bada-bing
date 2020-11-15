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

33 15  * * * DISPLAY=:0 bash /home/darko/.config/badabing/cronjob.sh >> /home/darko/.local/share/badabing/logs/badabing.log 2>&1
