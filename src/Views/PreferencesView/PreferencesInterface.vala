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
 public class BaDaBing.PreferencesInterface : Granite.SimpleSettingsPage
{
    public PreferencesInterface() 
    {
        Object(
            activatable: false,
            description: "Select Interface Elements",
            header: "Interface",
            icon_name: "dashboard-show",
            title: "Show Interface"
        );
    }

    construct 
    {
        var setting = new Settings(APPLICATION_ID);

        //Change to dark theme
        var theme_lab = new Gtk.Label(_("Dark theme:"));
        theme_lab.halign = Gtk.Align.END;
        var theme = new Gtk.Switch();
        theme.halign = Gtk.Align.START;
        if (setting.get_boolean("dark")) {
            theme.active = true;
        } else {
            theme.active = false;
        }
        theme.notify["active"].connect(() => {
           if (theme.get_active()) {
               Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
               setting.set_boolean("dark", true);
           } else {
               Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
               setting.set_boolean("dark", false);
           }
        });

        //Select indicator
        var ind_label = new Gtk.Label(_("Use System Tray Indicator:"));
        ind_label.halign = Gtk.Align.END;
        var ind = new Gtk.Switch();
        ind.halign = Gtk.Align.START;
        if (setting.get_boolean("indicator")) {
            ind.active = true;
            //  minz.sensitive = true;
        } else {
            ind.active = false;
            //  minz.sensitive = false;
        }
        ind.notify["active"].connect(() => {
            if (ind.active) {
                setting.set_boolean("indicator", true);
                //  minz.sensitive = true;
                //  minz.active = true;
                //  window.show_indicator();
            } else {
                setting.set_boolean("indicator", false);
                //  minz.active = false;
                //  minz.sensitive = false;
                //  window.hide_indicator();
            }
        });

        content_area.attach(theme_lab, 2, 3, 1, 1);
        content_area.attach(theme, 3, 3, 1, 1);
        content_area.attach(ind_label, 2, 4, 1, 1);
        content_area.attach(ind, 3, 4, 1, 1);


    }

}

