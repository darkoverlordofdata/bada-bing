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

