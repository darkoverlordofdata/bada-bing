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
 public class BaDaBing.Widget.Header : Gtk.HeaderBar 
 {
    public Gtk.Button loc_button;
    public Gtk.Button ref_button;
    public Gtk.RadioButton current_but;
    public Gtk.RadioButton history_but;
    public signal void show_mapwindow();

    public Header(BaDaBing.MainWindow window, bool view) {
        show_close_button = true;
        has_subtitle = false;

        //Create menu
        var menu = new Gtk.Menu();
        var pref_item = new Gtk.MenuItem.with_label(_("Preferences"));
        var about_item = new Gtk.MenuItem.with_label(_("About Ba Da Bing"));
        menu.add(pref_item);
        menu.add(new Gtk.SeparatorMenuItem());
        menu.add(about_item);
        pref_item.activate.connect(() => {
            var preferences = new BaDaBing.Widget.Preferences(window, this);
            preferences.run();
        });
        about_item.activate.connect(() => {
            var about = new BaDaBing.Widget.About(window);
            about.show();
        });

        var app_button = new Gtk.MenuButton();
        app_button.popup = menu;
        app_button.tooltip_text = _("Options");
        app_button.image = new Gtk.Image.from_icon_name("open-menu-symbolic", Gtk.IconSize.BUTTON);
        menu.show_all();

        //Right buttons
        loc_button = new Gtk.Button.from_icon_name("mark-location-symbolic", Gtk.IconSize.BUTTON);
        loc_button.tooltip_text = _("Change location");
        ref_button = new Gtk.Button.from_icon_name("view-refresh-symbolic", Gtk.IconSize.BUTTON);
        ref_button.tooltip_text = _("Refresh");
        ref_button.sensitive = false;

        loc_button.clicked.connect(() => {
            window.change_view(new BaDaBing.Widget.Location(window, this));
            window.show_all();
        });
        ref_button.clicked.connect(() => {
            ref_button.sensitive = false;
            window.change_view(new BaDaBing.Widget.Refresh(window, this));
            window.show_all();
        });
        pack_end(app_button);
        pack_end(loc_button);
        pack_end(ref_button);

        //Left buttons
        current_but = new Gtk.RadioButton.with_label_from_widget(null, _("Current"));
        history_but = new Gtk.RadioButton.with_label_from_widget(current_but, _("History"));
        Gtk.RadioButton[] buttons = {current_but, history_but};
        var butbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        butbox.get_style_context().add_class(Gtk.STYLE_CLASS_LINKED);
        butbox.homogeneous = true;
        butbox.spacing = 0;
        butbox.hexpand=false;
        foreach(Gtk.Button button in buttons) {
           (button as Gtk.ToggleButton).draw_indicator = false;
           (button as Gtk.Widget).sensitive = false;
            butbox.pack_start(button, false, true, 0);
        }
        current_but.toggled.connect(() => {
            window.change_view(new BaDaBing.Widget.Refresh(window, this));
            window.show_all();
        });
        history_but.toggled.connect(() => {
            this.show_mapwindow();
        });
        pack_start(butbox);
        change_visible(false);
    }

    public void change_visible(bool s) {
        this.loc_button.sensitive = s;
        this.history_but.sensitive = s;
        this.current_but.sensitive = s;
    }

    public void restart_switcher() {
        this.history_but.active = false;
        this.current_but.active = true;
    }

 }