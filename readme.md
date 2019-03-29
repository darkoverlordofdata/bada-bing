# Ba Da Bing
## Hey Linux, we gotch yer wallpaper here



    Images are copyright to their respective owners. 
    Bing is a trademark of Microsoft. 
    This application is not affiliated with Bing or its services in any way.

    Usage:
    com.github.darkoverlordofdata.bing-wall [OPTION?]

    Help Options:
    -h, --help          Show help options

    Application Options:
    --schedule=INT      Run scheduled
    --display           Display the gui
    --update            Update the wallpaper
    --force             Force overwwrite
    --list              List cache content
    --locale=STRING     Locale
    --auto              Auto start



### work in progress

    I'm writng this because I like bing wallpaer. So this works on my desktop,
    antergos-deepin, which is based on gnome. It should work on most gnome based DE's.

    todo:
    manage cache
    finish gui


### build

    meson build --prefix=/usr
    cd build
    ninja
    sudo ninja install

### translation

    ninja com.github.darkoverlordofdata.bing-wall-pot
    ninja com.github.darkoverlordofdata.bing-wall-update-po

### run with cron
To setup regular checks for new wallapers, edit crontab for the current user, using:

    $ crontab -u $USER -e

, and add this line:

    0 */6 * * * com.github.darkoverlordofdata.bing-wall --update > /dev/null 2>&1

This will run every 6 hours. You can use [this link](http://www.crontab-generator.org/) for reference.

### what's it (supposed to) do?

    get the xml/json from bing, using maximum to determine the # of records to request.
    the 1st entry is the current wallpaper.
    Loop thru, make sure all are in cache, download any that are not.
    Loop thru cache, any that are not in xml should be purged.
    save the xml as the local 'database'

    use gui (--display) to edit preferences, view cache list


