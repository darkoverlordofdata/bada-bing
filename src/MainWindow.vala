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
