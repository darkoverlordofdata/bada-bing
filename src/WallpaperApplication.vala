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
using Xml;
using Soup;
using Notify;

/**
 * Wallpaper Application
 */
public class BadaBing.WallpaperApplication : Gtk.Application 
{
    /**
     * Run the gui
     * 
     * com.github.darkoverlordofdata.badabing --display
     */
    public WallpaperApplication() 
    {
        Object(
            application_id: APPLICATION_ID,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate() 
    {
        if (get_windows() == null) {
            window = new MainWindow(this);
            //  window.set_decorated(false);
            window.show_all();
        } 
        else {
            window.present();
        }
        screen_width = window.width;
        screen_height = window.height;
    }

    private MainWindow window;
    private static string wallpaper_path;

    
    /**
     * Command line
     * 
     *  Usage:
     *  com.github.darkoverlordofdata.badabing [OPTION?]
     *
     *  Help Options:
     *  -h, --help       Show help options
     *
     *  Application Options:
     *  --schedule          Schedule cron job
     *  --display           Display the gui
     *  --update            Update the wallpaper
     *  --force             Force overwwrite
     *  --list              List cache content
     *  --locale=STRING     Locale
     *  --auto              Auto start
     *  --height            Screen height
     *  --width             Screen width
     *  --desktop           <pcmanfm, feh, gnome, mate>
     *  --notify            Notify user
     * 
     */
	const OptionEntry[] options = {
		{ "schedule", 0, 0, OptionArg.NONE, ref schedule, "Schedule cron job", null },
		{ "width", 0, 0, OptionArg.INT, ref screen_width, "Screen width", "INT" },
		{ "height", 0, 0, OptionArg.INT, ref screen_height, "Screen height", "INT" },
		{ "display", 0, 0, OptionArg.NONE, ref gui, "Display the gui", null },
		{ "update", 0, 0, OptionArg.NONE, ref update, "Update the wallpaper", null },
		{ "force", 0, 0, OptionArg.NONE, ref force, "Force overwwrite", null },
        { "list", 0, 0, OptionArg.NONE, ref list, "List cache content", null },
        { "locale", 0, 0, OptionArg.STRING, ref locale, "Locale", "STRING" },
        { "auto", 0, 0, OptionArg.NONE, ref auto, "Auto start", null },
        { "desktop", 0, 0, OptionArg.STRING, ref desktop, "Desktop to use", "STRING" },
		{ "notify", 0, 0, OptionArg.NONE, ref notify, "Notify when wallpaper is updated", null },
		{ null }
    };

    public static int screen_width;
    public static int screen_height;
    public static int number = 7;
    public static bool schedule = false;
    public static bool notify = false;
    public static bool update = false;
    public static bool force = false;
    public static bool list = false;
    public static bool gui = true;
    public static bool xml = false;
    public static bool auto = false;
    public static string? locale = null;
    public static string? desktop = null;
    
    private static GenericArray<string> files;

    public static int main(string[] args)
    {
        /** get flags & options */
		try {
            var opt_context = new OptionContext();
            opt_context.set_help_enabled(true);
			opt_context.add_main_entries(options, null);
            opt_context.parse(ref args);
		} catch (OptionError e) {
			print("error: %s\n", e.message);
			print("Run '%s --help' to see a full list of available command line options.\n", args[0]);
            critical (e.message);
			return 0;
        }


        var home = Environment.get_home_dir();
        if (FileUtils.test(@"$home/Wallpapers", FileTest.EXISTS)) 
            wallpaper_path = @"$home/Wallpapers/badabing.jpg";
        else
            wallpaper_path = @"$home/Pictures/badabing.jpg";
 
        
        /** set globals */
        var config = new Settings(APPLICATION_ID);

        notify = config.get_boolean("indicator");

        xml = config.get_boolean("xml");
        number = config.get_int("maximum");
        gui = !config.get_boolean("minimized");
        if (locale == null) locale = DEFAULT_LOCALE;

        switch (desktop) {
            case "gnome":
                desktop_manager = Desktop.Gnome;
                break;
            case "ubuntu":
                desktop_manager = Desktop.Ubuntu;
                break;
            case "pop":
                desktop_manager = Desktop.Pop;
                break;
            case "mate":
                desktop_manager = Desktop.Mate;
                break;
            case "pcmanfm":
                desktop_manager = Desktop.PCManFM;
                break;
            case "feh":
                desktop_manager = Desktop.Feh;
                break;
            case null:
                desktop_manager = Desktop.Unspecified;
                break;
                
            default:
                print(@"Unknown desktop: $desktop\n");
                critical(@"Unknown desktop: $desktop\n");
                Process.exit(1);
        }

        /**
         * --auto
         * 
         * add to autostart menu
         */
        if (auto) {
            var autostart = @"$(Environment.get_user_config_dir())/autostart/badabing.desktop";
            FileUtils.set_data(autostart, AUTOSTART.data);
			return 0;
        }

        /** 
         * --list
         * 
         * list the api cache
         */
        if (list) {
            listCache();
            return 0;
        }

        /** 
         * --update
         * 
         * download the xml and update current image
         */
        if (update) {
            updateWallpaper();
            return 0;
        }

        /**
         * --gui
         * 
         * open the gui
         */
        if (gui) {
            var app = new WallpaperApplication();
            return app.run(args);    
        }

        /**
         * --schedule
         * 
         * recurring in background
         */
        if (schedule) {
            return 0;
        }    

        print("Run '%s --help' to see a full list of available command line options.\n", args[0]);
        return 0;
    }


    /**
     * List the local cache
     * Lists out the most recently downloaded api response
     * 
     */
    public static void listCache()
    {
        var cache_dir = @"$(Environment.get_user_data_dir())/badabing";
        var cache_api = @"$(cache_dir)/$(BING_API).$(xml ? XML : JSON)";

        uint8[] src;
        if (FileUtils.get_data(cache_api, out src)) {
            var images = xml ? parseXml((string)src) : parseJson((string)src);
            images.foreach((image) => print(@"$image\n"));    
        }
    }

    /** 
     * Set the registration slot to point to our wallpaper
     */
    public static void initializeDesktop(Desktop desktop_manager) {
        var home = Environment.get_home_dir();
        switch (desktop_manager) {
            case Desktop.Gnome, Desktop.Ubuntu, Desktop.Pop:
                try {
                    print(@"gsettings set org.gnome.desktop.background picture-uri file://$wallpaper_path");
                    Process.spawn_command_line_async (@"gsettings set org.gnome.desktop.background picture-uri file://$wallpaper_path");
                    print(@"gsettings set org.gnome.desktop.screensaver picture-uri file://$wallpaper_path");
                    Process.spawn_command_line_async (@"gsettings set org.gnome.desktop.screensaver picture-uri file://$wallpaper_path");
                } catch (GLib.Error e) {
                    print(@"Error: $(e.message)\n");
                    critical (e.message);
                }
                break;

            case Desktop.Mate:
                try {
                    print(@"gsettings set org.mate.background picture-filename $wallpaper_path");
                    Process.spawn_command_line_async (@"gsettings set org.mate.background picture-filename $wallpaper_path");
                } catch (GLib.Error e) {
                    print(@"Error: $(e.message)\n");
                    critical (e.message);
                }                
                break;

            case Desktop.PCManFM:
                try {
                    print(@"pcmanfm --wallpaper-mode=screen --set-wallpaper=$wallpaper_path\n");
                    Process.spawn_command_line_async (@"pcmanfm --wallpaper-mode=screen --set-wallpaper=$wallpaper_path");
                } catch (GLib.Error e) {
                    print(@"Error: $(e.message)\n");
                    critical (e.message);
                }                
                break;

            case Desktop.Feh:
                try {
                    print(@"feh --bg-scale $wallpaper_path\n");
                    Process.spawn_command_line_async (@"feh --bg-scale $wallpaper_path");
                } catch (GLib.Error e) {
                    print(@"Error: $(e.message)\n");
                    critical (e.message);
                }                
                break;

            default:
                print("unable to determine which desktop manager is in use\n");
                Process.exit(1);
                break;
        }

    }


    /**
     * Get the bing metadata
     * first, try to get the hi-res (1980x1200) jpg
     * if that is not found, retrieve the default jpg
     * save jpg and text info to ~/Pictures/Bing and 
     * update dconf picture-uri setting.
     * 
     */
    public static void updateWallpaper(int index=0, bool update=true) {
        try {
            var setting = new Settings(APPLICATION_ID);
            var locale = setting.get_string("locale");
            var session = new Soup.Session();
            var message = new Soup.Message("GET", getApi(xml, locale, number));
            session.send_message(message);
            var source = (string)message.response_body.data;

            var images = xml ? parseXml(source) : parseJson(source);
            var url = images[index].url;
            var urlBase = images[index].urlBase;
            var copyright = images[index].copyright;
            var startdate = images[index].startdate;
            var title = images[index].title;
            var resolution = setting.get_string("resolution");

            var filename = urlBase.replace("/th?id=OHR.", "");

            var cache_dir = @"$(Environment.get_user_data_dir())/badabing";
            if (!FileUtils.test(cache_dir, FileTest.EXISTS)) {
                var cache = File.new_for_path(cache_dir);
                cache.make_directory();
            }
            var cache_jpg = @"$(cache_dir)/$(filename).jpg";
            var cache_api = @"$(cache_dir)/$(BING_API).$(xml ? XML : JSON)";
            var cache_url = @"$(BING_URL)$(urlBase)_$(resolution).jpg";
            var download = new Soup.Message("GET", cache_url);
            session.send_message(download);
            if (download.response_body.length < 2048) {
                // we got a blank placeholder image - fallback to the default url:
                cache_url = @"$(BING_URL)$(url)";
                download = new Soup.Message("GET", cache_url);
                session.send_message(download);
            }
            
            if (!FileUtils.test(cache_jpg, FileTest.EXISTS) || force) {
                FileUtils.set_data(cache_jpg, download.response_body.data);
            }
            FileUtils.set_data(cache_api, source.data);

            var home = Environment.get_home_dir();
            var config = Environment.get_user_config_dir();
            var desktop = Environment.get_variable("DESKTOP_SESSION");
            print(@"DESKTOP_SESSION = $desktop\n");
            var dest = @"$wallpaper_path";
            if (desktop == "gnome" || desktop == "ubuntu" || desktop == "pop") {
                print("gnome \n");
                try {
                    // copy to stadard location
                    Process.spawn_command_line_async(@"cp $cache_jpg $wallpaper_path");
                } catch (GLib.Error e) {
                    print(@"Error: $(e.message)\n");
                    critical (e.message);
                }
            }
            else if (desktop == "mate" || desktop.index_of("/mate") > 0) {
                print("mate\n");
                try {
                    //  Process.spawn_command_line_async(@"cp $cache_jpg $wallpaper_path");
                    Process.spawn_command_line_sync(@"cp $cache_jpg $wallpaper_path");
                    Process.spawn_command_line_async (@"gsettings set org.mate.background picture-filename $wallpaper_path");
                } catch (GLib.Error e) {
                    print(@"Error: $(e.message)\n");
                    critical (e.message);
                }                
            }
            else {  
                // is pcmanfm installed? (LXDE, OpenBox, ...)
                if ((FileUtils.test("/usr/local/bin/pcmanfm", FileTest.EXISTS) 
                || FileUtils.test("/usr/bin/pcmanfm", FileTest.EXISTS)
                && FileUtils.test(@"$config/pcmanfm/default/desktop-items-0.conf", FileTest.EXISTS)
                )) {

                    var source_file = File.new_for_path(cache_jpg);
                    var dest_file = File.new_for_path(dest);
                    try {
                        source_file.copy(dest_file, FileCopyFlags.OVERWRITE, null, (cbytes, tbytes) => {});
                        print(@"pcmanfm --wallpaper-mode=screen --set-wallpaper=$wallpaper_path\n");
                        Process.spawn_command_line_async (@"pcmanfm --wallpaper-mode=screen --set-wallpaper=$dest");
                    } catch (GLib.Error e) {
                        print(@"Error: $(e.message)\n");
                        critical (e.message);
                    }                
                } 
                // is feh installed?
                else if ((FileUtils.test("/usr/local/bin/feh", FileTest.EXISTS)
                || FileUtils.test("/usr/bin/feh", FileTest.EXISTS)
                && FileUtils.test(@"$home/.fehbg", FileTest.EXISTS)
                )) {
                    try {
                        Process.spawn_command_line_async(@"cp $cache_jpg $wallpaper_path");
                    } catch (GLib.Error e) {
                        print(@"Error: $(e.message)\n");
                        critical (e.message);
                    }
                }                
                else {
                    print("unable to determine which desktop manager to use\n");
                }            
            }
            print("SIZE = %d, %d\n", screen_width, screen_height);

            var data_dir = Environment.get_user_data_dir();
            if (FileUtils.test(@"$(data_dir)/catlock/themes/badabing/copy.sh", FileTest.EXISTS)) { 
                /*
                * Copy to catlock background, resizing to screen dimensions
                */
                try {
                    assert(screen_width != 0);
                    assert(screen_height != 0);
                    var block_width = 430;
                    var block_height = 170;
                    var gw = screen_width / 2 - 0.5*block_width;
                    var gh = screen_height / 2 - 0.5*block_height;
                    var shell_copy = @"bash $(data_dir)/catlock/themes/badabing/copy.sh $(data_dir) $wallpaper_path $(screen_width) $(screen_height) $(block_width) $(block_height) $(gw) $(gh)";

                    Process.spawn_command_line_async (shell_copy);
                } catch (GLib.Error e) {
                    print(@"Error: $(e.message)\n");
                    critical (e.message);
                }                
            }

            if (notify) {

                print("Notify\n");

                Notify.init("Bada Bing!");
                var icon = "/usr/share/icons/com.github.darkoverlordofdata.badabing.png";

                try {
                    new Notify.Notification(title, copyright, icon).show();
                } catch (GLib.Error e) {
                    print("Notifications not available on this system\n");
                    critical (e.message);
                }                
            }
            //  if (update) purgeWallpaper(images);

        } catch (GLib.Error e) {
            print(@"Error: $(e.message)\n");
            critical (e.message);
        }                
    }

    ////////////////////////////////////////////////////////////////////////////////
    // utils
    ////////////////////////////////////////////////////////////////////////////////

    public static void purgeWallpaper(GenericArray<ImageTag> images)
    {
        var cache_dir = @"$(Environment.get_user_data_dir())/badabing";
        var cache = File.new_for_path(cache_dir);
        files = new GenericArray<string>();
        listFiles(cache);
        files.foreach((filename) => {
            print("file: %s/%s\n", cache_dir, filename);
            var found = false;
            for (var i=0; i<images.length; i++) {
                if (filename.replace(".jpg", "") == images[i].urlBase.replace("/th?id=OHR.", "")) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                print("purge %s\n", filename);
            }
        });
    }

    /**
     * Form an API url
     * 
     * @param xml true, json false
     * @param locale to get from
     * @param number of images to get
     */
    public static string getApi(bool xml, string locale, int number) {
        return xml
            ? @"$(BING_URL)/$(BING_API).aspx?format=xml&idx=0&mkt=$(locale)&n=$(number)"
            : @"$(BING_URL)/$(BING_API).aspx?format=js&idx=0&mkt=$(locale)&n=$(number)";
    }

    private static void listFiles(File file, string space = "", Cancellable? cancellable = null) throws GLib.Error 
    {
        var enumerator = file.enumerate_children (
            "standard::*",
            FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
            cancellable);
    
        FileInfo info = null;
        while (cancellable.is_cancelled() == false && ((info = enumerator.next_file(cancellable)) != null)) {
            if (info.get_file_type() == FileType.DIRECTORY) {
                File subdir = file.resolve_relative_path(info.get_name ());
                listFiles(subdir, space + " ", cancellable);
            } 
            else {
                if (info.get_name().index_of(".jpg") == -1) continue;
                if (info.get_is_hidden()) continue;
                files.add(info.get_name());
            }
        }
    
        if (cancellable.is_cancelled ()) {
            throw new IOError.CANCELLED ("Operation was cancelled");
        }    
    }

    /**
     * Parse the API Json response
     * 
     * @param source string
     * @return GenericArray<ImageTag>
     */
    public static GenericArray<ImageTag> parseJson(string source)
    {
        var parser = new Json.Parser();
        parser.load_from_data(source);
        var root_object = parser.get_root().get_object();
        var images = new GenericArray<ImageTag>();

        var nodes = root_object.get_array_member("images");
        if (nodes == null) {
            throw new Exception.JsonParser("Invalid json document");            
        }
        nodes.foreach_element((array, index, node) => 
            images.add(new ImageTag.from_json(node)));
        return images;
    }

    /**
     * Parse the API Xml response
     * 
     * @param source string
     * @return GenericArray<ImageTag>
     */
    public static GenericArray<ImageTag> parseXml(string source)
    {
        var doc = Xml.Parser.parse_doc(source);
        if (doc == null) {
            throw new Exception.XmlParser("Invalid xml document");
        }
        var node = doc->get_root_element();
        if (node == null) {
            throw new Exception.XmlParser("Root mode not found in xml");
        }
        if (node->name != "images") {
            throw new Exception.XmlParser(@"Images not found, $(node->name) found instead");
        }

        var images = new GenericArray<ImageTag>();
        int recno = 0;
        for (var iter = node->children; iter != null; iter = iter->next) {
            if (iter->type == Xml.ElementType.ELEMENT_NODE) {
                if (iter->name == "image") {
                    images.add(new ImageTag.from_xml(iter));
                    recno++;
                }
            }
        }
        return images;
    }
}

