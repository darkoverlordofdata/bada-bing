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
 public class BaDaBing.PreferencesView : Gtk.Paned
 {
    construct 
    {

        //  MainWindow window = MainWindow.instance;
        var setting = new Settings(APPLICATION_ID);

        //Define sections
        var tit1_pref = new Gtk.Label(_("Interface"));
        tit1_pref.get_style_context().add_class("preferences");
        tit1_pref.halign = Gtk.Align.START;
        var tit2_pref = new Gtk.Label(_("General"));
        tit2_pref.get_style_context().add_class("preferences");
        tit2_pref.halign = Gtk.Align.START;

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

        //Select minimized on start
        var minz_label = new Gtk.Label(_("Start minimized:"));
        minz_label.halign = Gtk.Align.END;
        var minz = new Gtk.Switch();
        minz.halign = Gtk.Align.START;
        if (setting.get_boolean("minimized")) {
            minz.active = true;
        } else {
            minz.active = false;
        }
        minz.notify["active"].connect(() => {
            if (minz.get_active()) {
                setting.set_boolean("minimized", true);
            } else {
                setting.set_boolean("minimized", false);
            }
        });

        //Select indicator
        var ind_label = new Gtk.Label(_("Use System Tray Indicator:"));
        ind_label.halign = Gtk.Align.END;
        var ind = new Gtk.Switch();
        ind.halign = Gtk.Align.START;
        if (setting.get_boolean("indicator")) {
            ind.active = true;
            minz.sensitive = true;
        } else {
            ind.active = false;
            minz.sensitive = false;
        }
        ind.notify["active"].connect(() => {
            if (ind.active) {
                setting.set_boolean("indicator", true);
                minz.sensitive = true;
                minz.active = true;
                //  window.show_indicator();
            } else {
                setting.set_boolean("indicator", false);
                minz.active = false;
                minz.sensitive = false;
                //  window.hide_indicator();
            }
        });

        //Select start on boot
        var boot_label = new Gtk.Label(_("Launch on start:"));
        boot_label.halign = Gtk.Align.END;
        var boot_sw = new Gtk.Switch();
        boot_sw.halign = Gtk.Align.START;
        if (setting.get_boolean("start-on-boot")) {
            boot_sw.active = true;
        } else {
            boot_sw.active = false;
        }
        boot_sw.notify["active"].connect(() => {
            if (boot_sw.get_active()) {
                setting.set_boolean("start-on-boot", true);
                //  BaDaBing.Utils.set_start_on_boot();
            } else {
                setting.set_boolean("start-on-boot", false);
                //  BaDaBing.Utils.reset_start_on_boot();
            }
        });

        //Update interval
        var update_lab = new Gtk.Label(_("Refresh every :"));
        update_lab.halign = Gtk.Align.END;
        var update_box = new Gtk.ComboBoxText();
        update_box.append_text(_("1 hr."));
        update_box.append_text(_("2 hrs."));
        update_box.append_text(_("6 hrs."));
        update_box.append_text(_("12 hrs."));
        update_box.append_text(_("24 hrs."));
        int interval = setting.get_int("interval");
        switch(interval) {
            case 3600:
                update_box.active = 0;
                break;
            case 7200:
                update_box.active = 1;
                break;
            case 21600:
                update_box.active = 2;
                break;
            case 43200:
                update_box.active = 3;
                break;
            case 86400:
                update_box.active = 4;
                break;
            default:
                update_box.active = 1;
                break;
        }

        update_box.changed.connect(() => {
            switch(update_box.active) {
                case 0:
                    interval = 3600;
                    break;
                case 1:
                    interval = 7200;
                    break;
                case 2:
                    interval = 21600;
                    break;
                case 3:
                    interval = 43200;
                    break;
                case 4:
                    interval = 86400;
                    break;
                default:
                    interval = 7200;
                    break;
            }
            setting.set_int("interval", interval);
        });


        //Automatic location - modify to  accept string: EN-us
        //  var loc_label = new Gtk.Label(_("Find my location automatically:"));
        //  loc_label.halign = Gtk.Align.END;
        //  var loc = new Gtk.Switch();
        //  loc.halign = Gtk.Align.START;
        //  if (setting.get_boolean("auto")) {
        //      loc.active = true;
        //  } else {
        //      loc.active = false;
        //  }
        //  loc.notify["active"].connect(() => {
        //      if (loc.get_active()) {
        //          setting.set_boolean("auto", true);
        //      } else {
        //          setting.set_boolean("auto", false);
        //      }
        //  });

        //Create UI
        var layout = new Gtk.Grid();
        layout.valign = Gtk.Align.START;
        layout.column_spacing = 12;
        layout.row_spacing = 12;
        layout.margin = 12;
        layout.margin_top = 0;

        layout.attach(tit1_pref, 0, 0, 2, 1);

        layout.attach(theme_lab, 2, 1, 1, 1);
        layout.attach(theme, 3, 1, 1, 1);
        layout.attach(ind_label, 2, 3, 1, 1);
        layout.attach(ind, 3, 3, 1, 1);

        layout.attach(tit2_pref, 0, 5, 2, 1);

        layout.attach(minz_label, 2, 7, 1, 1);
        layout.attach(minz, 3, 7, 1, 1);

        layout.attach(boot_label, 2, 8, 1, 1);
        layout.attach(boot_sw, 3, 8, 1, 1);

        layout.attach(update_lab, 2, 9, 1, 1);
        layout.attach(update_box, 3, 9, 2, 1);
        //  layout.attach(loc_label, 2, 9, 1, 1);
        //  layout.attach(loc, 3, 9, 1, 1);

            add(layout);
    }
}