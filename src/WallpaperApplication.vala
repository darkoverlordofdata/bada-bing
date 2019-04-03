/* ******************************************************************************
 * Copyright 2019 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0(the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
using Xml;
using Soup;
using Notify;

/**
 * Wallpaper Application
 */
public class BaDaBing.WallpaperApplication : Gtk.Application 
{
    public const string XML = "xml";
    public const string JSON = "json";
    public const string BING_URL = "https://www.bing.com";
    public const string BING_API = "HPImageArchive";
    public const string DEFAULT_LOCALE = "EN-us";
    public const string GNOME_WALLPAPER = "org.gnome.desktop.background";

    public MainWindow window;

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
            window.show_all();
        } else {
            window.present();
        }
    }

    //  protected override void startup()
    //  {
    //      base.startup();
    //      var builder = new Gtk.Builder();
    //      try {
    //          builder.add_from_resource(@"$(APPLICATION_URI)/treeview-list.ui");
    //      }
    //      catch (GLib.Error e) {
    //          stderr.printf(@"$(e.message)\n");
	//  		error("Unable to load file: %s", e.message);
    //          //  Posix.exit(1);
    //          return;
    //      }
    //      builder.connect_signals(this);
    //      var window = builder.get_object("window") as Gtk.Window;
    //      window.show_all();
    //  }

    /**
     * Command line
     * 
     *  Usage:
     *  com.github.darkoverlordofdata.bada-bing [OPTION?]
     *
     *  Help Options:
     *  -h, --help       Show help options
     *
     *  Application Options:
     *  --schedule=INT      Run scheduled
     *  --display           Display the gui
     *  --update            Update the wallpaper
     *  --force             Force overwwrite
     *  --list              List cache content
     *  --locale=STRING     Locale
     *  --auto              Auto start
     * 
     */
	const OptionEntry[] options = {
		{ "schedule", 0, 0, OptionArg.INT, ref schedule, "Run scheduled", "INT" },
		{ "display", 0, 0, OptionArg.NONE, ref gui, "Display the gui", null },
		{ "update", 0, 0, OptionArg.NONE, ref update, "Update the wallpaper", null },
		{ "force", 0, 0, OptionArg.NONE, ref force, "Force overwwrite", null },
        { "list", 0, 0, OptionArg.NONE, ref list, "List cache content", null },
        { "locale", 0, 0, OptionArg.STRING, ref locale, "Locale", "STRING" },
		{ "auto", 0, 0, OptionArg.NONE, ref auto, "Auto start", null },
		{ null }
    };

    public static int schedule;
    public static int number = 7;
    public static bool update = false;
    public static bool force = false;
    public static bool list = false;
    public static bool gui = true;
    public static bool xml = false;
    public static bool auto = false;
    public static string? locale = null;
    
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
			return 0;
        }

        /** set globals */
        var config = new Settings(APPLICATION_ID);
        xml = config.get_boolean("xml");
        number = config.get_int("maximum");
        gui = !config.get_boolean("minimized");
        schedule = config.get_int("interval");
        if (locale == null) locale = DEFAULT_LOCALE;

        /**
         * --auto
         * 
         * add to autostart menu
         */
        if (auto) {
            var autostart = @"$(Environment.get_user_config_dir())/autostart/bada-bing.desktop";
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
            if (schedule > 0) {
                Timeout.add_seconds(schedule, () => {
                    updateWallpaper();
                    return true;
                });
                new MainLoop().run();    
                return 0;
            }    
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
        if (schedule > 0) {
            Timeout.add_seconds(schedule, () => {
                updateWallpaper();
                return true;
            });
            new MainLoop().run();    
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
        var cache_dir = @"$(Environment.get_user_cache_dir())/bada-bing";
        var cache_api = @"$(cache_dir)/$(BING_API).$(xml ? XML : JSON)";

        uint8[] src;
        if (FileUtils.get_data(cache_api, out src)) {
            var images = xml ? parseXml((string)src) : parseJson((string)src);
            images.foreach((image) => print(@"$image\n"));    
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
    public static void updateWallpaper() 
    {
        try {
            var session = new Soup.Session();
            var message = new Soup.Message("GET", getApi(xml, locale, number));
            session.send_message(message);
            var source = (string)message.response_body.data;

            var images = xml ? parseXml(source) : parseJson(source);
            var url = images[0].url;
            var urlBase = images[0].urlBase;
            var copyright = images[0].copyright;
            var startdate = images[0].startdate;
            var title = images[0].title;

            var filename = urlBase.replace("/th?id=OHR.", "");

            var cache_dir = @"$(Environment.get_user_cache_dir())/bada-bing";
            if (!FileUtils.test(cache_dir, FileTest.EXISTS)) {
                var cache = File.new_for_path(cache_dir);
                cache.make_directory();
            }
            var cache_jpg = @"$(cache_dir)/$(filename).jpg";
            var cache_api = @"$(cache_dir)/$(BING_API).$(xml ? XML : JSON)";
            var cache_url = @"$(BING_URL)$(urlBase)_1920x1200.jpg";
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
 
            var settings = new Settings(GNOME_WALLPAPER);
            settings.set_string("picture-uri", @"file://$cache_jpg");

            Notify.init("Ba Da Bing!");
            var icon = "/usr/local/share/icons/com.github.darkoverlordofdata.bada-bing.png";
            //  var notify = new Notify.Notification(title, copyright, icon);
            //  notify.show();

            new Notify.Notification(title, copyright, icon).show();
            
            purgeWallpaper(images);

        } catch (GLib.Error e) {
            print(@"Error: $(e.message)\n");
        }                
    }

    ////////////////////////////////////////////////////////////////////////////////
    // utils
    ////////////////////////////////////////////////////////////////////////////////

    public static void purgeWallpaper(GenericArray<ImageTag> images)
    {
        var cache_dir = @"$(Environment.get_user_cache_dir())/bada-bing";
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
            } else {
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

