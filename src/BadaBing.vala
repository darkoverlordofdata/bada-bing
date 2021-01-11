/* ******************************************************************************
 * Copyright 2019 darkoverlordofdata.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 ******************************************************************************/

namespace BadaBing { 

    errordomain Exception {
        XmlParser,
        JsonParser,
    }

    public enum Desktop {
        Gnome,
        Ubuntu,
        Pantheon,
        Pop,
        Mate,
        PCManFM,
        Feh,
        Unspecified
    }

    public static Desktop desktop_manager = Desktop.Unspecified;
        
    public const string APPLICATION_ID =   "com.github.darkoverlordofdata.badabing";
    public const string APPLICATION_URI = "/com/github/darkoverlordofdata/badabing";
    public const string DATADIR = Config.DATADIR;
    public const string PKGDATADIR = Config.PKG_DATADIR;
    public const string GETTEXT_PACKAGE = Config.GETTEXT_PACKAGE;
    public const string INSTALL_PREFIX = Config.PREFIX;
    public const string EXEC_NAME = Config.PACKAGE;
    public const string ICON_NAME = Config.PACKAGE;
    public const string LOCALE_DIR = Config.LOCALE_DIR;
    public const string VERSION = Config.VERSION;
    public const string APP_NAME = "Bada Bing";
    public const string VERSION_INFO = "Dev";
    public const string RELEASE = "dev";
    public const string AUTOSTART = """[Desktop Entry]
Name=Bada Bing
GenericName=Wallpaper
Comment=Hey Linux, we gotch yer wallpaper
Categories=Utility;
Exec=com.github.darkoverlordofdata.badabing --update --force --schedule
Icon=/usr/local/share/icons/com.github.darkoverlordofdata.badabing.svg
Terminal=false
Type=Application
Keywords=Wallpaper;
""";
    public const string XML = "xml";
    public const string JSON = "json";
    public const string BING_URL = "https://www.bing.com";
    public const string BING_API = "HPImageArchive";
    public const string DEFAULT_LOCALE = "EN-us";
    public const string LOCALE_US = "EN-us";
    public const string LOCALE_UK = "EN-gb";
    public const string LOCALE_DE = "DE-de";
    public const string LOCALE_CA = "EN-ca";
    public const string LOCALE_AU = "EN-au";
    public const string LOCALE_FR = "FR-fr";
    public const string LOCALE_CH = "ZH-ch";
    public const string LOCALE_JP = "JA-jp";

    public const string DEFAULT_RESOLUTION = "1920x1200";
    public const string RESOLUTION_1366_768 = "1366x768";
    public const string RESOLUTION_1920_1200 = "1920x1200";
    public const string RESOLUTION_1920_1280 = "1920x1280";

        //  1366x768
        //  1920x1280
        //  1920x1200

    //  public const string IMAGE_PATH = "~/Wallpapers/badabing.jpg";

    public const string GNOME_WALLPAPER = "org.gnome.desktop.background";
    public const string GNOME_SCREENSAVER = "org.gnome.desktop.screensaver";
            //  US, UK, DE, CA, AU, FR, CH, JP
            
    public const string AUTOSTART_PATH = "~/.config/autostart/com.github.darkoverlordofdata.badabing.desktop";

    public const string CRONJOB_DIR     = ".config/badabing";
    public const string CRONJOB_PATH    = ".config/badabing/cronjob.sh";
    public const string CATLOCK_PATH    = ".local/share/catlock/themes/badabing.copy.sh";

    public const int BUFLEN = 256;
        

}
