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
	NoContent
}

public class Wallpaper.WallpaperApp : Gtk.Application 
{
    //  public const string BING_URL = "https://www.bing.com";
    //  public const string BING_API = "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1";
    //  const string imagePath = "HPImageArchive.aspx?format=xml&idx=0&n=1"; 
    //  const string bingUrl = "https://www.bing.com";
    
    public MainWindow window;

    public static bool update;
    public static bool force;
    public static bool gui;

	const OptionEntry[] options = {
		{ "display", 0, 0, OptionArg.NONE, ref gui, "Display the gui", null },
		{ "update", 0, 0, OptionArg.NONE, ref update, "Update the wallpaper", null },
		{ "force", 0, 0, OptionArg.NONE, ref force, "Force overwwrite", null },
		{ null }
    };

    /**
     * 
     *  Usage:
     *  com.github.darkoverlordofdata.bing-wall [OPTION?]
     *
     *  Help Options:
     *  -h, --help       Show help options
     *
     *  Application Options:
     *  --update         Update the wallpaper
     *  --display        Display the gui
     */
    public static int main(string[] args)
    {

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


        /** 
         * --update
         * 
         * get the current image and update the wallpaper
         */
        if (update) {
            updateWallpaper(force);
            return 0;
        }

        /**
         * --gui
         * 
         * open the gui
         */
        if (gui) {
            var app = new WallpaperApp();
            return app.run(args);    
        }

        print("Run '%s --help' to see a full list of available command line options.\n", args[0]);
        return 0;
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

    public static void updateWallpaper(bool force) {
        print("Do Update\n");
        try {

            // get the locale
            //  uint8[] buff = new uint8[2048];
            //  FileUtils.get_data(Environment.get_home_dir() + "/.config/user-dirs.locale", out buff);
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
    
            var obj = ctx.eval("//images/image/url");
            if (obj == null) 
                throw new Exception.UnableToEvalXPath("Failed to evaluate xpath");
    
            if (obj->type != XPath.ObjectType.NODESET) 
                throw new Exception.InvalidXPathObjectType("Expected NodeSet");
    
            if (obj->nodesetval == null) 
                throw new Exception.ValueNotSet("NodeSet is null");
    
            if (obj->nodesetval->length() == 0) 
                throw new Exception.NoContent("NodeSet has no content");
    
    
            var node = obj->nodesetval->item(0);
            var orig = node->get_content();
            var path = orig.replace("x1080", "x1200");

            var srcUrl = @"$(Constants.BING_URL)$(path)";
            var dstUri = File.new_for_uri(pictureUri);
            var srcFile = File.new_for_path(path);
    
            print(@"srcUrl = $srcUrl\n");
            print(@"pictureUri = $pictureUri\n");
            print(@"srcFile = $(srcFile.get_path())\n");

            string jpg = dstUri.get_parent().get_path() + "/" + srcFile.get_basename();
            print("jpg = %s\n", jpg);

            var download = new Soup.Message("GET", srcUrl);
            session.send_message(download);
            
            if (download.response_body.length == 0) {
                srcUrl = @"$(Constants.BING_URL)$(orig)";
                print(@"srcUrl = $srcUrl\n");
                srcFile = File.new_for_path(path);
                jpg = dstUri.get_parent().get_path() + "/" + srcFile.get_basename();
                download = new Soup.Message("GET", srcUrl);
                session.send_message(download);
            }
            jpg = jpg.replace("?", "");
            
            print("jpg = %s\n", jpg);

            if (!FileUtils.test(jpg, FileTest.EXISTS) || force) {
                FileUtils.set_data(jpg, download.response_body.data);
            }

            
            //  settings.set_string("picture-uri", @"file://$jpg);
    
            delete obj;
            delete doc;

        } catch (GLib.Error e) {
            print("Error: %s\n", e.message);
        }
    }
}

