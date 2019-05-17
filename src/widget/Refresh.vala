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
 public class BaDaBing.Widget.Refresh : Gtk.Box
 {
    public Refresh(BaDaBing.MainWindow window, BaDaBing.Widget.Header header) {
        orientation = Gtk.Orientation.HORIZONTAL;

        var setting = new Settings(APPLICATION_ID);
        header.custom_title = null;
        //  header.set_title(setting.get_string("location") + ", " + setting.get_string("state") + " " + setting.get_string("country"));
        header.change_visible(true);
    }
}