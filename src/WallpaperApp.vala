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
    public static int maximum;
    public static bool update;
    public static bool force;
    public static bool gui;
    public static GenericArray<string> files;

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
     * 
     */
	const OptionEntry[] options = {
		{ "schedule", 0, 0, OptionArg.INT, ref schedule, "Run scheduled", "INT" },
		{ "display", 0, 0, OptionArg.NONE, ref gui, "Display the gui", null },
		{ "update", 0, 0, OptionArg.NONE, ref update, "Update the wallpaper", null },
		{ "force", 0, 0, OptionArg.NONE, ref force, "Force overwwrite", null },
		{ null }
    };

    public MainWindow window;

    public static int main(string[] args)
    {
        bool done = false;

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
        
        var setting = new Settings("com.github.darkoverlordofdata.bing-wall");
        maximum = setting.get_int("maximum");
        print("Setting max = %d\n", maximum);

        print("home %s\n", Environment.get_home_dir());
        print("config %s\n", Environment.get_user_config_dir());


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
        if (maximum <= 0) return;

        File file = File.new_for_commandline_arg(@"$(Environment.get_home_dir())/Pictures/Bing");
        try {
            files = new GenericArray<string>();
            list_children(file, "", new Cancellable());
        } catch (GLib.Error e) {
            print (@"Error: $(e.message)\n");
        }
        files.foreach((str) => {
            print("File %s\n", str);
        });

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

    /**
     * Get the bing schedule metadata
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

            // get the locale
            //  uint8[] buff = new uint8[2048];
            //  FileUtils.get_data(Environment.get_user_config_dir() + "/user-dirs.locale", out buff);
            //  string locale = ((string)buff).replace("_", "-");
            string locale = "EN-us";
            
            // get the wallpaper location
            Settings settings = new Settings("org.gnome.desktop.background");
            string pictureUri = settings.get_string("picture-uri");
    
            // get metadata
            var session = new Soup.Session();
            var message = new Soup.Message("GET", @"$(Constants.BING_API)&mkt=$(locale)");
            session.send_message(message);
            var doc = Xml.Parser.parse_doc((string)message.response_body.data);
    
            var ctx = new XPath.Context(doc);
            if (ctx == null) 
                throw new Exception.UnableToCreateContext("Failed to create the xpath context");
    
            var dstUri = File.new_for_uri(pictureUri);
            var bing = dstUri.get_parent();
            if (!bing.query_exists()) 
                bing.make_directory(); 

            var url = getNodeText(ctx, "//images/image/url");
            var urlBase = getNodeText(ctx, "//images/image/urlBase");
            var copyright = getNodeText(ctx, "//images/image/copyright");
            string filename;
            if (urlBase.index_of("=") > 0)
                filename = urlBase.split("=")[1];
            else
                filename = urlBase;

            string local_jpg = @"$(dstUri.get_parent().get_path())/$(filename).jpg";
            string local_txt = @"$(dstUri.get_parent().get_path())/$(filename).txt";
            string config_dir = @"$(Environment.get_user_config_dir())/bing-wall";
            string config_idx = @"$(config_dir)/index";

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
            if (!FileUtils.test(local_txt, FileTest.EXISTS) || force) {
                FileUtils.set_data(local_txt, copyright.data);
            }

            var w = new Wallpapers();
            w.add(20190324, local_jpg, copyright);
            

            //  var rec = new Wallpaper(0, 20190324, local_jpg, copyright);

            //  var data = new GenericArray<Wallpaper?>();
            //  data.add(rec);

            //  var sb = new StringBuilder();
            //  sb.printf("%d,%d,%s,%s", rec.recno, rec.timestamp, rec.path, rec.desc.escape());

            //  FileUtils.set_data(config_idx, sb.str.data);
            settings.set_string("picture-uri", @"file://$local_jpg");
            delete doc;

        } catch (GLib.Error e) {
            print(@"Error: $(e.message)\n");
        }
    }
}

