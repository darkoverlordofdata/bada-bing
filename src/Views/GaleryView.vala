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
 public class BaDaBing.GaleryView : Gtk.Grid 
{
    private Gtk.FlowBox flow_box;

    construct 
    {
        flow_box = new Gtk.FlowBox();

        var scrolled = new Gtk.ScrolledWindow(null, null);
        scrolled.expand = true;
        scrolled.get_style_context().add_class(Gtk.STYLE_CLASS_VIEW);
        scrolled.add(flow_box);

        var load_button = new Gtk.Button.with_label("");
        load_button.clicked.connect(() => load_images.begin());

        attach(scrolled, 0, 0, 1, 1);
        attach(load_button, 0, 2, 0, 0);
        load_button.clicked();
    }


    private async void load_images() {
        var xml = false;
        var cache_dir = @"$(Environment.get_user_cache_dir())/bada-bing";
        var cache_api = @"$(cache_dir)/$(BING_API).$(xml ? XML : JSON)";

        uint8[] src;
        if (FileUtils.get_data(cache_api, out src)) {
            var images = xml ? WallpaperApplication.parseXml((string)src) : WallpaperApplication.parseJson((string)src);
            images.foreach((tag) => {
                var image = new Granite.AsyncImage();
                var path = tag.urlBase.replace("/th?id=OHR.", "");
                var cache_jpg = @"$(cache_dir)/$(path).jpg";
                image.set_from_file_async(File.new_for_path(cache_jpg), 288, 180, true);
                flow_box.add(image);
                flow_box.show_all();

            });
        }
    }
}
