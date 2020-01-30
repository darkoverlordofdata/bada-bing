# Ba Da Bing
## Hey Linux, we gotcha wallpaper here


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
    --height            Screen height
    --width             Screen width

![Screenshot](https://github.com/darkoverlordofdata/badabing/raw/master/Screenshot1.png "Screenshot")

![Screenshot](https://github.com/darkoverlordofdata/badabing/raw/master/Screenshot2.png "Screenshot")

### install

    for ubuntu/elementaryos (https://launchpad.net/~darkoverlordofdata/+archive/ubuntu/badabing)

    sudo add-repository ppa:darkoverlordofdata/badabing
    sudo apt update 
    sudo apt install com.github.darkoverlordofdata.badabing

    otherwise, build from source. Updated to work on Raspbian Buster (rpi3)

### dependancies

    sudo apt install valac -y
    sudo apt install libgtk-3-dev libgranite-dev libjson-glib-dev libappindicator3-dev libsoup2.4-dev libnotify-dev -y

    this app pops up a notification when a new wallpaper is installed. 
    You missed it and want to review it later? 
    Install the indicator-notifications GTK3 applet:

    sudo apt-add-repository ppa:jconti/recent-notifications
    sudo apt update 
    sudo apt install recent-notifications

### build

    meson build --prefix=/usr
    ninja -C build
    sudo ninja -C build install

### post build


    Integrates with catlock (https://github.com/darkoverlordofdata/kitty-cat-lock.git), my screen lock application.
    use ./enable_catlock.sh to copy theme to catlock.

    Preferences:

    On linux 
        enabling autostart will create a desktop file in the .config/autostart folder. 
        enabling refesh will run every 1-24 hrs based on selection.
    
    On bsd
        use ./install.sh to create bin/badabing.sh, and add as daily job to crontab.
        manually add bin/badabing.sh to autostart tool.

### what's it (supposed to) do?

    get the xml/json from bing, using maximum to determine the # of records to request.
    the 1st entry is the current wallpaper.
    Loop thru, make sure all are in cache, download any that are not.
    Loop thru cache, any that are not in xml should be purged.
    save the xml as the local 'database'

    use gui (--display) to edit preferences, view cache list


### icon

    The icon is from [icons8](https://icons8.com/icon/pack/user%20interface/small)

    [terms](https://community.icons8.com/t/can-i-use-icons8-for-free/30)






