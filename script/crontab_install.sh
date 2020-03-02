#!/usr/bin/env bash
#
# create a bash file to run from crontab with users environment variables 
#
cat << 'EOF' > $HOME/bin/badabing.sh
#!/usr/bin/env bash
#
#   run badabing from crontab
#
EOF
echo "SHELL=$SHELL" >> $HOME/bin/badabing.sh
echo "HOME=$HOME" >> $HOME/bin/badabing.sh
echo "PATH=$PATH" >> $HOME/bin/badabing.sh
echo "export DISPLAY=$DISPLAY" >> $HOME/bin/badabing.sh
cat << 'EOF' >> $HOME/bin/badabing.sh

geometry=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
width=$(echo $geometry | cut -f1 -dx)
height=$(echo $geometry | cut -f2 -dx)

/usr/bin/env com.github.darkoverlordofdata.badabing --update --width=$width --height=$height
EOF
#
#   Add to crontab
#
chmod +x $HOME/bin/badabing.sh
croncmd="DISPLAY=$DISPLAY $HOME/bin/badabing.sh"
cronjob="1 0  * * * $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
# crontab -l | grep -v -F "$croncmd" | crontab -


