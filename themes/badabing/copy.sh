#!/usr/local/bin/bash
#
#	Copy & resize the wallpaper to fit on the device
#
convert $2 -resize $3x$4 $1/metalock/themes/badabing/bg.jpg
#
#	Crop out the dialog box
#
convert $1/metalock/themes/badabing/bg.jpg +clone -crop $5x$6+$7+$8  -geometry +$7+$8 -composite $1/metalock/themes/badabing/box.png


