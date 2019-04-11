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
