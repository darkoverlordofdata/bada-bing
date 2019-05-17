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
 public class BaDaBing.WelcomeView : Gtk.Grid 
{
    construct 
    {
        var welcome = new Granite.Widgets.Welcome("Ba Da Bing", 
            "Hey, Linux. We got yer wallpaper here.");
        welcome.append("help-about", 
            "About", "About Ba Da Bing");
        welcome.append("preferences-desktop-wallpaper", //"text-x-source", 
            "Get Source", "Ba Da Bing's source code is hosted on GitHub.");

        add(welcome);

        welcome.activated.connect((index) => {
            switch(index) {
                case 0:
                    try {
                        new BaDaBing.Widget.About().show();
                    } catch(Error e) {
                        warning(e.message);
                    }

                    break;
                case 1:
                    try {
                        AppInfo.launch_default_for_uri("https://github.com/darkoverlordofdata/bada-bing", null);
                    } catch(Error e) {
                        warning(e.message);
                    }

                    break;
            }
        });
    }
}
