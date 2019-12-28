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
 public class BadaBing.Widget.About : Gtk.AboutDialog 
 {
    public About() {
        modal = true;
        destroy_with_parent = true;

        artists = { "bruce davidson <darkoverlordofdata@gmail.com>" };
        authors = { "bruce davidson <darkoverlordofdata@gmail.com>" };
        comments = _("Hey Linux, I got yer wallpaper here.");
        copyright = "Copyright \xc2\xa9 darkoverlordofdata 2019";
        documenters = authors;
        //  license_type = Gtk.License.Custom;
        logo_icon_name = ICON_NAME;
        program_name = APP_NAME;
        translator_credits = "";
        version = VERSION;
        website = "https://github.com/darkoverlordofdata/badabing";
        website_label = _("website");

        response.connect (() => {
                destroy ();
        });
    }
}