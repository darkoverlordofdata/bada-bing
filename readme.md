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

### dependancies

    For GhostBSD, install ninja, meson, granite and libappindicator

    For Ubuntu:     
        sudo apt install valac -y
        sudo apt install libgtk-3-dev libgranite-dev libjson-glib-dev libappindicator3-dev libsoup2.4-dev libnotify-dev gettext -y


### build

    (meson build --prefix=/usr/local)
    ninja -C build
    sudo ninja -C build install

### post build

    General Preferences:

        Launch on start:
            creates a desktop file in ./config/autostart

        Run daily cron job:
            creates daily job in crontab at 12.01 am

        Use system tray notifier:
            notify when the screen changes

        Generate screen lock assets:
            Integrate with catlock (https://github.com/darkoverlordofdata/kitty-cat-lock.git), my screen lock application.

### Mate screensaver

    Works with mate-screensaver. On the mate menu, select Preferences->Screensaver.
    Set the background picture to ~/Pictures/badabing.jpg


### todo

    check ~/.face or ~/Pictues/avatar.png for screen lock assets
    take Quit out of StatusIcon script
    screen lock drop down list: catlock; metalock

### icon

    The icon is from [icons8](https://icons8.com/icon/pack/user%20interface/small)

    [terms](https://community.icons8.com/t/can-i-use-icons8-for-free/30)



nohup python /usr/local/share/bin/com.github.darkoverlordofdata.badabing.py &