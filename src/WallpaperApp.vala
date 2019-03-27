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
    XmlParser,
    JsonParser,
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

    public static Soup.Session session;
    public static Soup.Message message;
    public static Settings settings;
    public static GenericArray<string> files;
    public static GenericArray<ImageTag> images;
    public static string source;
    
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
        
        var config = new Settings("com.github.darkoverlordofdata.bing-wall");

        xml = config.get_boolean("xml");
        maximum = config.get_int("maximum");
        source = xml ? getXml() : getJson();

        if (list) {
            var images = xml ? parseXml() : parseJson();
            images.foreach((image) => image.print());
            //  images.foreach((image) => {
            //      print("%s|%s|%s\n", image.startdate, image.title, image.urlBase);
            //  });
            done = true;

        }
        /** 
         * --update
         * 
         * download the xml and update current image
         */
        if (update) {
            var images = xml ? parseXml() : parseJson();
            updateWallpaper(images);
            purgeWallpaper(images);
            done = true;
        }

        //  if (schedule > 0) {
        //      Timeout.add_seconds(schedule, () => {
        //          updateWallpaper(force);
        //          return true;
        //      });
        //      new MainLoop().run();    
        //      done = true;
        //      return 0;
        //  }    

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

        if (!done)
            print("Run '%s --help' to see a full list of available command line options.\n", args[0]);
        return 0;
    }

    private static void list_children(File file, string space = "", Cancellable? cancellable = null) throws GLib.Error 
    {
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
    public WallpaperApp() 
    {
        Object(
            application_id: "com.github.darkoverlordofdata.bing-wall",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate() 
    {
        if (get_windows() == null) {
            window = new MainWindow(this);
            window.show_all();
        } else {
            window.present();
        }
    }


    /**
     * Just get the xml
     */
    public static string getXml() 
    {
        try {
            message = new Soup.Message("GET", @"$(Constants.BING_API)?format=xml&idx=0&mkt=$(locale)&n=$(number)");
            session.send_message(message);
            return (string)message.response_body.data;
    
        } catch (GLib.Error e) {
            print(@"Error: $(e.message)\n");
            return "";
        }        
    }

    public static string getJson() 
    {
        try {
            message = new Soup.Message("GET", @"$(Constants.BING_API)?format=js&idx=0&mkt=$(locale)&n=$(number)");
            session.send_message(message);
            return (string)message.response_body.data;
    
        } catch (GLib.Error e) {
            print(@"Error: $(e.message)\n");
            return "";
        }        
    }

    public static GenericArray<ImageTag> parseJson()
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

    public static GenericArray<ImageTag> parseXml()
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

    public static void purgeWallpaper(GenericArray<ImageTag> images)
    {
        var cache_dir = @"$(Environment.get_user_cache_dir())/bing-wall";
        var cache = File.new_for_path(cache_dir);
        list_children(cache);
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
    public static void updateWallpaper(GenericArray<ImageTag> images) 
    {
        var url = images[0].url;
        var urlBase = images[0].urlBase;
        var copyright = images[0].copyright;
        var startdate = images[0].startdate;
        var title = images[0].title;

        string filename;
        if (urlBase.index_of("=") > 0)
            filename = urlBase.split("=")[1].replace("OHR.", "");
        else
            filename = urlBase.replace("OHR.", "");

        var cache_dir = @"$(Environment.get_user_cache_dir())/bing-wall";

        if (!FileUtils.test(cache_dir, FileTest.EXISTS)) {
            var cache = File.new_for_path(cache_dir);
            cache.make_directory();
        }
        var local_jpg = @"$(cache_dir)/$(filename).jpg";
        var local_xml = @"$(cache_dir)/HPImageArchive.xml";


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
        FileUtils.set_data(local_xml, source.data);
        
        settings.set_string("picture-uri", @"file://$local_jpg");
    }
}

