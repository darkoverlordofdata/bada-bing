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
 public class BaDaBing.Widget.About : Gtk.AboutDialog 
 {
    public About (BaDaBing.MainWindow window) {
        transient_for = window;
        modal = true;
        destroy_with_parent = true;

        artists = { "bruce davidson <darkoverlordofdata@gmail.com>" };
        authors = { "bruce davidson <darkoverlordofdata@gmail.com>" };
        comments = _("Daily Wallaper Changer");
        copyright = "Copyright \xc2\xa9 darkoverlordofdata 2019";
        documenters = authors;
        //  license_type = Gtk.License.Custom;
        logo_icon_name = ICON_NAME;
        program_name = APP_NAME;
        translator_credits = "";
        version = VERSION;
        website = "https://github.com/darkoverlordofdata/bada-bing";
        website_label = _("website");

        response.connect (() => {
                destroy ();
        });
    }
}