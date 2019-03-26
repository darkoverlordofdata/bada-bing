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

errordomain Exception {
	UnableToCreateContext,
	UnableToEvalXPath,
	InvalidXPathObjectType,
	ValueNotSet,
    NoContent,
    InvalidDataFormat,
}

public class BingWall.WallpaperApp : Gtk.Application 
{
    public static int schedule;
    public static int maximum = 7;
    public static int number =  1;
    public static bool update = false;
    public static bool force = false;
    public static bool list = false;
    public static bool gui = false;
    public static bool xml = false;
    public static string? locale = null;

    public static GenericArray<string> files;
    public static Soup.Session session;
    public static Soup.Message message;
    public static Settings settings;
    
    /**
     * 
     *  Usage:
     *  com.github.darkoverlordofdata.bing-wall [OPTION?]
     *
     *  Help Options:
     *  -h, --help       Show help options
     *
     *  Application Options:
     *  --schedule=INT   Run scheduled
     *  --display        Display the gui
     *  --update         Update the wallpaper
     *  --force          Force overwwrite
     *  --list           List cache
     * 
     */
	const OptionEntry[] options = {
		{ "schedule", 0, 0, OptionArg.INT, ref schedule, "Run scheduled", "INT" },
		{ "number", 0, 0, OptionArg.INT, ref number, "Number of days to get", "INT" },
		{ "display", 0, 0, OptionArg.NONE, ref gui, "Display the gui", null },
		{ "update", 0, 0, OptionArg.NONE, ref update, "Update the wallpaper", null },
		{ "force", 0, 0, OptionArg.NONE, ref force, "Force overwwrite", null },
        { "list", 0, 0, OptionArg.NONE, ref list, "List cache content", null },
        { "xml", 0, 0, OptionArg.NONE, ref xml, "Just the xml", null},
        { "locale", 0, 0, OptionArg.STRING, ref locale, "Locale", "STRING" },
		{ null }
    };

    public MainWindow window;

    public static int main(string[] args)
    {
        bool done = false;
        if (locale == null) locale = "EN-us";

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

        settings = new Settings("org.gnome.desktop.background");
        session = new Soup.Session();
        
        var setting = new Settings("com.github.darkoverlordofdata.bing-wall");
        maximum = setting.get_int("maximum");
        //  print("Setting max = %d\n", maximum);
        //  print("home %s\n", Environment.get_home_dir());
        //  print("config %s\n", Environment.get_user_config_dir());

        if (xml) {
            print(@"$(getXml())");
            return 0;
        }

        if (list) {
            var w = new Wallpapers();
            w.list();
            return 0;
        }
        
        /** 
         * --update
         * 
         * get the current image and update the wallpaper
         */
        if (update) {
            updateWallpaper(force);
            limitCount(maximum);
            done = true;
        }

        if (schedule > 0) {
            Timeout.add_seconds(schedule, () => {
                updateWallpaper(force);
                limitCount(maximum);
                return true;
            });
            new MainLoop().run();    
            done = true;
            return 0;
        }    

        /**
         * --gui
         * 
         * open the gui
         */
        if (gui) {
            var app = new WallpaperApp();
            done = true;
            return app.run(args);    
        }

        if (maximum > 0) {
            limitCount(maximum);
            done = true;
        }

        if (!done)
            print("Run '%s --help' to see a full list of available command line options.\n", args[0]);
        return 0;
    }

    private static void limitCount(int maximum) {
        //  if (maximum <= 0) return;

        //  File file = File.new_for_commandline_arg(@"$(Environment.get_home_dir())/Pictures/Bing");
        //  try {
        //      files = new GenericArray<string>();
        //      list_children(file, "", new Cancellable());
        //  } catch (GLib.Error e) {
        //      print (@"Error: $(e.message)\n");
        //  }
        //  files.foreach((str) => {
        //      print("File %s\n", str);
        //  });

    }

    private static void list_children(File file, string space = "", Cancellable? cancellable = null) throws GLib.Error {
        FileEnumerator enumerator = file.enumerate_children (
            "standard::*",
            FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
            cancellable);
    
        FileInfo info = null;
        while (cancellable.is_cancelled() == false && ((info = enumerator.next_file(cancellable)) != null)) {
            if (info.get_file_type() == FileType.DIRECTORY) {
                File subdir = file.resolve_relative_path(info.get_name ());
                list_children(subdir, space + " ", cancellable);
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
     * Wallpaper Application
     */
    public WallpaperApp() {
        Object(
            application_id: "com.github.darkoverlordofdata.bing-wall",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate() {
        if (get_windows() == null) {
            window = new MainWindow(this);
            window.show_all();
        } else {
            window.present();
        }
    }

    /**
     * Gets the text from the named node
     * 
     * @param Context ctx
     * @param string name
     * returns string
     * 
     */
    private static string getNodeText(XPath.Context ctx, string name) throws Exception {
        var obj = ctx.eval(name);
        if (obj == null) 
            throw new Exception.UnableToEvalXPath(@"Failed to evaluate xpath: $name");

        if (obj->type != XPath.ObjectType.NODESET) 
            throw new Exception.InvalidXPathObjectType("Expected NodeSet");

        if (obj->nodesetval == null) 
            throw new Exception.ValueNotSet("NodeSet is null");

        if (obj->nodesetval->length() == 0) 
            throw new Exception.NoContent("NodeSet has no content");


        var node = obj->nodesetval->item(0);
        var text = node->get_content();
        delete obj;
        return text;
    }

    public static string getXml() {
        try {
            message = new Soup.Message("GET", @"$(Constants.BING_API)&mkt=$(locale)&n=$(number)");
            session.send_message(message);
            return (string)message.response_body.data;
    
        } catch (GLib.Error e) {
            print(@"Error: $(e.message)\n");
            return "";
        }        
    }

    /**
     * Get the bing metadata
     * first, try to get the hi-res (1980x1200) jpg
     * if that is not found, retrieve the default jpg
     * save jpg and text info to ~/Pictures/Bing and 
     * update dconf picture-uri setting.
     * 
     * @param force update
     * 
     */
    public static void updateWallpaper(bool force) {
        try {
            var doc = Xml.Parser.parse_doc(getXml());
    
            var ctx = new XPath.Context(doc);
            if (ctx == null) 
                throw new Exception.UnableToCreateContext("Failed to create the xpath context");
    
            var url = getNodeText(ctx, "//images/image/url");
            var urlBase = getNodeText(ctx, "//images/image/urlBase");
            var copyright = getNodeText(ctx, "//images/image/copyright");
            var startdate = getNodeText(ctx, "//images/image/startdate");
            var headline = getNodeText(ctx, "//images/image/headline");

            string filename;
            if (urlBase.index_of("=") > 0)
                filename = urlBase.split("=")[1].replace("OHR.", "");
            else
                filename = urlBase.replace("OHR.", "");

            string cache_dir = @"$(Environment.get_user_cache_dir())/bing-wall";

            if (!FileUtils.test(cache_dir, FileTest.EXISTS)) {
                var cache = File.new_for_path(cache_dir);
                cache.make_directory();
            }
            string local_jpg = @"$(cache_dir)/$(filename).jpg";
            //  string local_txt = @"$(cache_dir)/$(filename).txt";
    

            var srcUrl = @"$(Constants.BING_URL)$(urlBase)_1920x1200.jpg";
            var download = new Soup.Message("GET", srcUrl);
            session.send_message(download);
            
            if (download.response_body.length == 0) {
                srcUrl = @"$(Constants.BING_URL)$(url)";
                download = new Soup.Message("GET", srcUrl);
                session.send_message(download);
            }
            

            if (!FileUtils.test(local_jpg, FileTest.EXISTS) || force) {
                FileUtils.set_data(local_jpg, download.response_body.data);
            }
            var w = new Wallpapers();
            w.add(startdate, local_jpg, copyright, headline);
            
            settings.set_string("picture-uri", @"file://$local_jpg");
            delete doc;

        } catch (GLib.Error e) {
            print(@"Error: $(e.message)\n");
        }
    }
}

