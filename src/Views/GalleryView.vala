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

public class BaDaBing.GalleryView : Gtk.Grid 
{
    private Gtk.Grid grid;
    private Gtk.Button load_button;

    public GalleryView() 
    {

        grid = new Gtk.Grid();

        var scrolled = new Gtk.ScrolledWindow(null, null);
        scrolled.expand = true;
        scrolled.get_style_context().add_class(Gtk.STYLE_CLASS_VIEW);
        scrolled.add(grid);

        load_button = new Gtk.Button.with_label("");
        load_button.clicked.connect(() => load_images.begin());

        attach(scrolled, 0, 0, 1, 1);
        attach(load_button, 0, 2, 1, 1);
        load_button.hide();
        load_button.clicked();
    }

    private async void load_images() {
        load_button.destroy();
        var xml = false;
        var cache_dir = @"$(Environment.get_user_cache_dir())/badabing";
        var data = File.new_for_path(cache_dir);
        if (!data.query_exists())
            data.make_directory();
        var cache_api = @"$(cache_dir)/$(BING_API).$(xml ? XML : JSON)";
        if (!FileUtils.test(cache_api, FileTest.EXISTS)) return;

        uint8[] src;
        var index = 0;
        var row = 0;
        var col = 0;
        if (FileUtils.get_data(cache_api, out src)) {
            var images = xml ? WallpaperApplication.parseXml((string)src) : WallpaperApplication.parseJson((string)src);
            images.foreach((tag) => {
                var image = new Granite.AsyncImage();   
        
                var path = tag.urlBase.replace("/th?id=OHR.", "");
                var cache_jpg = @"$(cache_dir)/$(path).jpg";
                Value filename = Value(Type.STRING);
                filename.set_string(path);
                image.set_property("name", cache_jpg);

                var file = File.new_for_path (cache_jpg);

                if (!FileUtils.test(cache_jpg, FileTest.EXISTS)) {
                    WallpaperApplication.updateWallpaper(index, false);
                }
                index += 1;
                image.set_from_file_async(File.new_for_path(cache_jpg), 288, 180, true);
                var label = new Gtk.Label(tag.copyright);
                label.set_line_wrap(true);
                label.set_lines(2);
                var button = new Gtk.Button();
                button.clicked.connect(button_onclick);
                button.set_relief(Gtk.ReliefStyle.NONE);
                button.set_image(image);
                grid.attach(label, col, row, 1, 1);
                grid.attach(button, col, row+1, 1, 1);
                col += 1;
                if (col > 1) {
                    col = 0;
                    row += 2;
                }
                grid.show_all();

            });
        }
    }

    void button_onclick(Gtk.Button button) {
        var image = (Gtk.Image)button.get_image();
        Value filename = Value(Type.STRING);
        image.get_property("name", ref filename);

        var cache_jpg = filename.get_string();
        print(@"Hey, you clicked $cache_jpg \n");

        var settings = new Settings(GNOME_WALLPAPER);
        settings.set_string("picture-uri", @"file://$cache_jpg");
        var desktop = Environment.get_variable("DESKTOP_SESSION");
        if (desktop == "LXDE-pi") {
            try {
                Process.spawn_command_line_async (@"pcmanfm --set-wallpaper $cache_jpg");
            } catch (GLib.Error e) {
                print(@"Error: $(e.message)\n");
            }                
        }
    }
}
