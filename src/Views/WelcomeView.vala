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
    public WelcomeView(MainWindow parent, Gtk.Stack panel) {

        var welcome = new Granite.Widgets.Welcome("Ba Da Bing", 
            "Hey, Linux. We got yer wallpaper here.");

        welcome.append("help-about", 
            "About", "About Ba Da Bing");

        welcome.append("preferences-desktop",
            "Preferences", "Set preferences");

        welcome.append("preferences-desktop-wallpaper", 
            "Galery", "View Galery");

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
                    parent.showBackButton();                        
                    try {
                        panel.set_visible_child_name("preferences");
                    } catch(Error e) {
                        warning(e.message);
                    }
                    break;

                case 2:
                    parent.showBackButton();                        
                    try {
                        panel.set_visible_child_name("galery");
                    } catch(Error e) {
                        warning(e.message);
                    }
                    break;

                default:
                    parent.hideBackButton();
                    break;

            }
        });
    }
}
