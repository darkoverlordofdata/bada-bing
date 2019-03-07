# bing-wall - Daily Bing Wallpaper for ElementaryOS


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


