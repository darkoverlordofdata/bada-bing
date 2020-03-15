# Bada Bing
## Daily Wallpaper from https://bing.wallpaper.pics/ for Linux & Unix

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

### build

    meson build --prefix=/usr
    ninja -C build
    sudo ninja -C build install

### post build

    On freebsd, you must run ./freebsd_schema.py to add required preferences keys to dconf.

    Integrates with catlock (https://github.com/darkoverlordofdata/kitty-cat-lock.git), my screen lock application.
    use ./enable_catlock.sh to copy theme to catlock.

    General Preferences:

        autostart:
            creates a desktop file in ./config/autostart

        cron:
            run daily at 12.01 am

        notify:
            notify when the screen changes

        screen lock:
            openbox with catlock


### todo

    screen lock drop down list: catlock; metalock

### icon

    The icon is from [icons8](https://icons8.com/icon/pack/user%20interface/small)

    [terms](https://community.icons8.com/t/can-i-use-icons8-for-free/30)

### other

    originaly concieved on ElementaryOS. Over the course of time and distro surf, Ive run/tested this on Ubuntu, Debian (Buster), Raspberrian, Antergos, EndeavourOS, RebornOS, GhostBSD, and NomadBSD. Requires minimal Gnome installation for gsettings, dconf, and notifications 

    for ubuntu/elementaryos (https://launchpad.net/~darkoverlordofdata/+archive/ubuntu/badabing)

    sudo add-apt-repository ppa:darkoverlordofdata/badabing
    sudo apt update 
    sudo apt install com.github.darkoverlordofdata.badabing

    for other distros, bsd, or for latest version, build from source. 


### dependancies

    sudo apt install valac -y
    sudo apt install libgtk-3-dev libgranite-dev libjson-glib-dev libappindicator3-dev libsoup2.4-dev libnotify-dev gettext -y

    this app pops up a notification when a new wallpaper is installed. 
    You missed it and want to review it later? 
    Install the indicator-notifications GTK3 applet:

    sudo apt-add-repository ppa:jconti/recent-notifications
    sudo apt update 
    sudo apt install recent-notifications

