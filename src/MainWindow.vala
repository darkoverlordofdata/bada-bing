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

 public class BaDaBing.MainWindow : Gtk.ApplicationWindow 
 {
     
    private Gtk.Stack panel;
    private Gtk.Button button;

    public MainWindow(WallpaperApplication app) {
        Object (application: app);

        button = new Gtk.Button.with_label("Back");
        button.get_style_context().add_class ("back-button");

        button.clicked.connect( () =>{
            panel.set_visible_child_name("welcome"); 
            hideBackButton();
        });
        hideBackButton();

        var go_back = new SimpleAction ("go-back", null);
        go_back.activate.connect( () => {
            panel.set_visible_child_name("welcome");
            hideBackButton();
        });
        add_action(go_back);
        app.set_accels_for_action("win.go-back", {"<Alt>Left", "Back"});

        panel = new Gtk.Stack();
        panel.add_titled(new WelcomeView(this, panel), "welcome", "");
        panel.add_titled(new PreferencesView(), "preferences", "");
        panel.add_titled(new GaleryView(), "galery", "");

        var paned = new Gtk.Paned(Gtk.Orientation.VERTICAL);
        paned.add1(panel);

        var gtk_settings = Gtk.Settings.get_default();

        var headerbar = new Gtk.HeaderBar();
        headerbar.get_style_context().add_class("default-decoration");
        headerbar.show_close_button = true;
        headerbar.pack_start(button);

        add(paned);
        set_default_size(720, 480);
        set_size_request(720, 480);
        set_titlebar(headerbar);
        title = APP_NAME;
        show_all();

        app.add_window(this);
    }
    
    public void hideBackButton() {
        button.visible = false;
        button.no_show_all = true;
    }

    public void showBackButton() {
        button.visible = true;
        button.no_show_all = false;
    }
}
