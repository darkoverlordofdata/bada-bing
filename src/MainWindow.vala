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

 public class Wallpaper.MainWindow : Gtk.Window 
 {
    public WallpaperApp app;
    public AppIndicator.Indicator indicator;
    private Gtk.Grid view;

    public MainWindow(WallpaperApp app) {
        this.app = app;
        this.set_application(app);
        this.set_size_request(950, 650);
        window_position = Gtk.WindowPosition.CENTER;
        var header = new Widget.Header(this, false);
        this.set_titlebar(header);


        //Define style
        var provider = new Gtk.CssProvider();
        provider.load_from_resource("/com/github/darkoverlordofdata/bing-wall/application.css");
        Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        var setting = new Settings("com.github.darkoverlordofdata.bing-wall");
        setting.get_boolean("dark");
        if (setting.get_boolean("dark")) {
            Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
        } else {
            Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
        }

        //create main view
        var overlay = new Gtk.Overlay();
        view = new Gtk.Grid();
        view.expand = true;
        view.halign = Gtk.Align.FILL;
        view.valign = Gtk.Align.FILL;
        view.attach(new Gtk.Label("Loading ..."), 0, 0, 1, 1);
        overlay.add_overlay(view);

        add(overlay);
        this.show_all();
    }

    public void change_view(Gtk.Widget widget) {
        this.view.get_child_at(0,0).destroy();
        widget.expand = true;
        this.view.attach(widget, 0, 0, 1, 1);
        widget.show_all();
    }

    public void create_indicator() {
    }

    public void show_indicator() {
    }

    public void hide_indicator() {
    }

}
