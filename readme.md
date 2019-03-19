# bing-wall - Daily Bing Wallpaper for Linux

This was started on ElementaryOS. I've moved on to antegros-deepin. 
Requires Gtk3.

## WIP - work in progress

    Images are copyright to their respective owners. 
    Bing is a trademark of Microsoft. 
    This application is not affiliated with Bing or its services in any way.

### build

    meson build --prefix=/usr
    cd build
    ninja
    sudo ninja install

### translation

    ninja com.github.darkoverlordofdata.bing-wall-pot
    ninja com.github.darkoverlordofdata.bing-wall-update-po

### remove from menu

    sudo rm /usr/bin/com.github.darkoverlordofdata.bing-wall
    sudo rm /usr/share/applications/com.github.darkoverlordofdata.bing-wall.desktop
    sudo rm /usr/share/metainfo/com.github.darkoverlordofdata.bing-wall.appdata.xml



https://www.bing.com/th?id=OHR.SeptimiusSeverus_EN-US6750540711_1920x1080.jpg&rf=NorthMale_1920x1200.jpg&pid=hp



https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=US-en




th?id=OHR.TofinoCoast_EN-US7059338912_1920x1200.jpg&rf=NorthMale_1920x1200.jpg&pid=hp

th?id=OHR.TofinoCoast_EN-US7059338912

https://www.bing.com/th?id=OHR.TofinoCoast_EN-US7059338912_1920x1200.jpg


to run:
com.github.darkoverlordofdata.bing-wall --display
com.github.darkoverlordofdata.bing-wall --help
com.github.darkoverlordofdata.bing-wall --update
com.github.darkoverlordofdata.bing-wall --update --force
com.github.darkoverlordofdata.bing-wall --update --force --schedule=21600
com.github.darkoverlordofdata.bing-wall --update --schedule=21600

## Setting Up Cron
To setup regular checks for new wallapers, edit crontab for the current user, using:

    $ crontab -u $USER -e

, and add this line:

    0 */6 * * * com.github.darkoverlordofdata.bing-wall --update > /dev/null 2>&1

This will run every 6 hours. You can use [this link](http://www.crontab-generator.org/) for reference.

