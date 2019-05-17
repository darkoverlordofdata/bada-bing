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

 public class BaDaBing.MainWindow : Gtk.Window 
 {
    public MainWindow(WallpaperApplication app) {

        this.set_size_request(720, 480);
        window_position = Gtk.WindowPosition.CENTER;

        var rightPanel = new Gtk.Stack();
        rightPanel.add_titled(new WelcomeView(), "welcome", "Welcome");
        rightPanel.add_titled(new PreferencesView(), "preferences", "Preferences");
        rightPanel.add_titled(new GaleryView(), "galery", "Galery");

        var leftPanel = new Gtk.StackSidebar();
        leftPanel.stack = rightPanel;

        var paned = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
        paned.add1(leftPanel);
        paned.add2(rightPanel);

        var gtk_settings = Gtk.Settings.get_default();

        var headerbar = new Gtk.HeaderBar();
        headerbar.get_style_context().add_class("default-decoration");
        headerbar.show_close_button = true;

        this.add(paned);
        this.set_default_size(900, 600);
        this.set_size_request(750, 500);
        this.set_titlebar(headerbar);
        this.title = APP_NAME;
        this.show_all();

        app.add_window(this);
    }


}
