#!/usr/local/bin/bash
#
# create a bash file to run from crontab with users environment variables 
#
cat << 'EOF' > ~/bin/badabing.sh
#!/usr/local/bin/bash
#
#   run badabing from crontab
#
#	(cp ${workspaceFolder}/data/badabing.sh ~/bin/badabing.sh)
#
EOF
echo "SHELL=$SHELL" >> ~/bin/badabing.sh
echo "HOME=$HOME" >> ~/bin/badabing.sh
echo "PATH=$PATH" >> ~/bin/badabing.sh
cat << 'EOF' >> ~/bin/badabing.sh

geometry=$(xrandr | grep -w connected  | awk -F'[ \+]' '{print $3}')
width=$(echo $geometry | cut -f1 -dx)
height=$(echo $geometry | cut -f2 -dx)

/usr/local/bin/com.github.darkoverlordofdata.badabing --update --width=$width --height=$height
EOF
#
#   Add to crontab
#
chmod +x ~/bin/badabing.sh
croncmd="DISPLAY=unix:0.0 $HOME/bin/badabing.sh"
cronjob="1 0  * * * $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -



