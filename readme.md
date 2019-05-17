# Ba Da Bing
## Hey Linux, we gotch yer wallpaper here


    Images are copyright to their respective owners. 
    Bing is a trademark of Microsoft. 
    This application is not affiliated with Bing or its services in any way.

    Usage:
    com.github.darkoverlordofdata.badabing [OPTION?]

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

### notifications

    this app pops up a notification when a new wallpaper is installed. You missed it and want to review it later? Install the indicator-notifications GTK3 applet:

    sudo add-apt-repository ppa:jconti/recent-notifications
    sudo apt-get update 
    sudo apt-get install indicator-notifications

### build

    Why is CMakeLists.txt empty? I use https://github.com/prozum/meson-cmake-wrapper for compatability with VSCode using the CMakeTools extension.

    meson build --prefix=/usr
    cd build
    ninja
    sudo ninja install

### dependancies

    sudo apt install libgtk-3-dev libgranite-dev libjson-glib-dev libappindicator3-dev libsoup2.4-dev libnotify-dev

### what's it (supposed to) do?

    get the xml/json from bing, using maximum to determine the # of records to request.
    the 1st entry is the current wallpaper.
    Loop thru, make sure all are in cache, download any that are not.
    Loop thru cache, any that are not in xml should be purged.
    save the xml as the local 'database'

    use gui (--display) to edit preferences, view cache list

    Originally intended to be cross-platform, but in Windows10 this is now a native option, so it's not needed.

### work in progress

    todo:
    clean cache so it only keeps the last (1-7) days
    finish gui
    I'm a complete noob when it comes to the po & debian folders. They may be set up wrong.

### icon

    The icon is from [icons8](https://icons8.com/icon/pack/user%20interface/small)

    [terms](https://community.icons8.com/t/can-i-use-icons8-for-free/30)