/* ******************************************************************************
 * Copyright 2019 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
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


public class BingWallpaper : Gtk.Application {

    public BingWallpaper () {
        Object (
            application_id: "com.github.darkoverlordofdata.bing-wall",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 300;
        main_window.default_width = 300;
        main_window.title = "Bing Wallpaper";

        var label = new Gtk.Label ("Bing Wallpaper");
        main_window.add (label);
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new BingWallpaper ();
        return app.run (args);
    }
}