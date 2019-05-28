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
 public class BaDaBing.PreferencesGeneral : Granite.SimpleSettingsPage
{
    const string AUTOSTART_PATH = "~/.config/autostart/com.github.darkoverlordofdata.badabing.desktop";

    const string AUTOSTART_URI = "com.github.darkoverlordofdata.badabing";

    public PreferencesGeneral() 
    {
        Object(
            activatable: false,
            description: "general preferences",
            header: "General",
            icon_name: "system-run", //"view-history",
            title: "General Preferences"
        );
    }

    construct 
    {
        var setting = new Settings(APPLICATION_ID);

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
                set_autostart_on();
                setting.set_boolean("start-on-boot", true);
            } else {
                set_autostart_off();
                setting.set_boolean("start-on-boot", false);
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


        //Create UI
        content_area.valign = Gtk.Align.START;
        content_area.column_spacing = 12;
        content_area.row_spacing = 12;
        content_area.margin = 12;
        content_area.margin_top = 0;

        content_area.attach(minz_label, 2, 7, 1, 1);
        content_area.attach(minz, 3, 7, 1, 1);

        content_area.attach(boot_label, 2, 8, 1, 1);
        content_area.attach(boot_sw, 3, 8, 1, 1);

        content_area.attach(update_lab, 2, 9, 1, 1);
        content_area.attach(update_box, 3, 9, 2, 1);
        //  content_area.attach(loc_label, 2, 9, 1, 1);
        //  content_area.attach(loc, 3, 9, 1, 1);
        content_area.attach(ind_label, 2, 11, 1, 1);
        content_area.attach(ind, 3, 11, 1, 1);

    }

    private void set_autostart_on() {

        print("'%s'/n", @"$(GLib.Environment.get_home_dir())/.config/autostart");
        var file = File.new_for_path(@"$(GLib.Environment.get_home_dir())/.config/autostart");
        if (!file.query_exists())
            file.make_directory();

        //  var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/com.github.darkoverlordofdata.badabing.desktop";
        var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/$(AUTOSTART_URI).desktop";
        var autostart = File.new_for_path(path);
        var fs = autostart.create(FileCreateFlags.NONE);
        var ds = new DataOutputStream(fs);
        ds.put_string("""[Desktop Entry]
Type=Application
Version=1.0
Name=Bada Bing
Comment=Hey Linux, I got yer wallpaper
Exec=com.github.darkoverlordofdata.badabing --update --force --schedule=21600
Icon=/usr/share/icons/com.github.darkoverlordofdata.badabing.svg
Terminal=false
Categories=Utility;
StartupNotify=false
X-GNOME-Autostart-enabled=true
""");
        //  FileUtils.chmod(path, 0775);
    }
    
    private void set_autostart_off() {
        //  var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/com.github.darkoverlordofdata.badabing.desktop";
        var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/$(AUTOSTART_URI).desktop";
        var autostart = File.new_for_path(path);
        if (autostart.query_exists()) {
            autostart.delete();
        }    
    }
}

