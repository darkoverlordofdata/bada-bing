# Ba Da Bing
## Hey Linux, we gotch yer wallpaper here



    Images are copyright to their respective owners. 
    Bing is a trademark of Microsoft. 
    This application is not affiliated with Bing or its services in any way.

    Usage:
    com.github.darkoverlordofdata.bada-bing [OPTION?]

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

    tested on antergos-deepin, deepin-manjaro, deepin, elementary

    todo:
    manage cache
    finish gui

### dependancies

    sudo apt install libgtk-3-dev libgranite-dev libjson-glib-dev libappindicator3-dev libsoup-2.4-dev libnotify-dev




### build

    meson build --prefix=/usr
    cd build
    ninja
    sudo ninja install

### translation

    ninja com.github.darkoverlordofdata.bada-bing-pot
    ninja com.github.darkoverlordofdata.bada-bing-update-po


### what's it (supposed to) do?

    get the xml/json from bing, using maximum to determine the # of records to request.
    the 1st entry is the current wallpaper.
    Loop thru, make sure all are in cache, download any that are not.
    Loop thru cache, any that are not in xml should be purged.
    save the xml as the local 'database'

    use gui (--display) to edit preferences, view cache list

    Originally intended to be cross-platform, but in Windows10 this is now a native option, so it's not needed.


com.github.darkoverlordofdata.bada-bing --update --schedule=21600

build/com.github.darkoverlordofdata.bada-bing --update --schedule=60

com.github.darkoverlordofdata.bada-bing --update --schedule=60 &