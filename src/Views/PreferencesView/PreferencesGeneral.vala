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
 public class BadaBing.PreferencesGeneral : Granite.SimpleSettingsPage
{

    CronJob cronjob;
    AutoStart autostart;
    TrayIcon tray_icon;
    LockScreen lockscreen;

    public PreferencesGeneral() 
    {
        Object(
            activatable: false,
            description: "General preferences",
            header: "General",
            icon_name: "system-run", 
            title: "General"
        );
    }

    construct 
    {
        cronjob = new CronJob ();
        autostart = new AutoStart ();
        tray_icon = new TrayIcon ();
        lockscreen = new LockScreen ();

        var setting = new Settings(APPLICATION_ID);

        //Select start on boot
        var boot_label = new Gtk.Label(_("Launch on start:"));
        boot_label.halign = Gtk.Align.END;
        var boot_sw = new Gtk.Switch();
        boot_sw.halign = Gtk.Align.START;
        if (setting.get_boolean("start-on-boot")) {
            boot_sw.active = true;
        } 
        else {
            boot_sw.active = false;
        }
        boot_sw.notify["active"].connect(() => {
            if (boot_sw.get_active()) {
                autostart.enable();
                setting.set_boolean("start-on-boot", true);
            } 
            else {
                autostart.disable();
                setting.set_boolean("start-on-boot", false);
            }
        });

        //Enable Tray Icon
        var tray_icon_label = new Gtk.Label(_("Enable TrayIcon:"));
        tray_icon_label.halign = Gtk.Align.END;
        var tray_icon_sw = new Gtk.Switch();
        tray_icon_sw.halign = Gtk.Align.START;
        if (setting.get_boolean("tray-icon")) {
            tray_icon_sw.active = true;
        } 
        else {
            tray_icon_sw.active = false;
        }
        tray_icon_sw.notify["active"].connect(() => {
            if (tray_icon_sw.get_active()) {
                tray_icon.enable();
                setting.set_boolean("tray-icon", true);
            } 
            else {
                tray_icon.disable();
                setting.set_boolean("tray-icon", false);
            }
        });


        //Daily CronTab job
        var cron_label = new Gtk.Label(_("Run daily cron job:"));
        cron_label.halign = Gtk.Align.END;
        var cron_sw = new Gtk.Switch();
        cron_sw.halign = Gtk.Align.START;
        if (setting.get_boolean("use-cron-job")) {
            cron_sw.active = true;
        } 
        else {
            cron_sw.active = false;
        }
        cron_sw.notify["active"].connect(() => {
            if (cron_sw.get_active()) {
                cronjob.enable();
                setting.set_boolean("use-cron-job", true);
            } 
            else {
                cronjob.disable();
                setting.set_boolean("use-cron-job", false);
            }
        });



        //Select indicator
        var ind_label = new Gtk.Label(_("Use system tray indicator:"));
        ind_label.halign = Gtk.Align.END;
        var ind_sw = new Gtk.Switch();
        ind_sw.halign = Gtk.Align.START;
        if (setting.get_boolean("indicator")) {
            ind_sw.active = true;
        } 
        else {
            ind_sw.active = false;
        }
        ind_sw.notify["active"].connect(() => {
            if (ind_sw.active) {
                setting.set_boolean("indicator", true);
            } 
            else {
                setting.set_boolean("indicator", false);
            }
        });


        //Integrated Screen Lock
        var lock_label = new Gtk.Label(_("Generate screen lock assets:"));
        lock_label.halign = Gtk.Align.END;
        var lock_sw = new Gtk.Switch();
        lock_sw.halign = Gtk.Align.START;
        if (setting.get_boolean("create-lock-assets")) {
            lock_sw.active = true;
        } 
        else {
            lock_sw.active = false;
        }
        lock_sw.notify["active"].connect(() => {
            if (lock_sw.get_active()) {
                lockscreen.enable();
                setting.set_boolean("create-lock-assets", true);
            } 
            else {
                lockscreen.disable();
                setting.set_boolean("create-lock-assets", false);
            }
        });


        //Create UI
        content_area.valign = Gtk.Align.START;
        content_area.column_spacing = 12;
        content_area.row_spacing = 12;
        content_area.margin = 12;
        content_area.margin_top = 0;

        content_area.attach(boot_label, 2, 7, 1, 1);
        content_area.attach(boot_sw, 3, 7, 1, 1);

        
        content_area.attach(tray_icon_label, 2, 8, 1, 1);
        content_area.attach(tray_icon_sw, 3, 8, 1, 1);


        content_area.attach(cron_label, 2, 9, 1, 1);
        content_area.attach(cron_sw, 3, 9, 1, 1);

        content_area.attach(ind_label, 2, 12, 1, 1);
        content_area.attach(ind_sw, 3, 12, 1, 1);

        content_area.attach(lock_label, 2, 14, 1, 1);
        content_area.attach(lock_sw, 3, 14, 1, 1);
    }

}

