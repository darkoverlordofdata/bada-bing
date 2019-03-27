# Ba Da Bing
## Hey Linux, we gotch yer wallpaper here

This was started on ElementaryOS. I've moved on to antegros-deepin. 
Requires Gtk3.

Command line options work, including scheduling daily.

Still to do:

    limit to last n downloads
    gui


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



## to run:
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

## whats it do?

get the xml from bing, using maximum to determine the # of records to request.
the 1st entry is the current wallpaper.
Loop thru, make sure all are in cache, download any that are not.
Loop thru cache, any that are not in xml should be deleted.
save the xml as the local 'database'