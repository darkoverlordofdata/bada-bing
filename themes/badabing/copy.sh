#!/usr/local/bin/bash
#
#	Copy & resize the wallpaper to fit on the device
#
convert $1 -resize $2x$3 /home/darko/.local/share/metalock/themes/badabing/bg.jpg
#
#	Crop out the dialog box
#
convert /home/darko/.local/share/metalock/themes/badabing/bg.jpg +clone -crop $4x$5+$6+$7  -geometry +$6+$7 -composite /home/darko/.local/share/metalock/themes/badabing/box.png


