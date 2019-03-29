namespace Constants 
{
    public const string DATADIR = Config.DATADIR;
    public const string PKGDATADIR = Config.PKG_DATADIR;
    public const string GETTEXT_PACKAGE = Config.GETTEXT_PACKAGE;
    public const string INSTALL_PREFIX = Config.PREFIX;
    public const string EXEC_NAME = Config.PACKAGE;
    public const string ICON_NAME = Config.PACKAGE;
    public const string LOCALE_DIR = Config.LOCALE_DIR;
    public const string VERSION = Config.VERSION;
    public const string APP_NAME = "Bing Wallpaper";
    public const string VERSION_INFO = "Stable";
    public const string RELEASE = "stable";

    public const string AUTOSTART = """[Desktop Entry]
Name=Ba Da Bing
GenericName=Wallpaper
Comment=Hey Linux, we gotch yer wallpaper
Categories=Utility;
Exec=com.github.darkoverlordofdata.bing-wall --update --force --schedule=21600
Icon=/usr/share/icons/com.github.darkoverlordofdata.bing-wall.svg
Terminal=false
Type=Application
Keywords=Wallpaper;
""";
}
