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
    const string AUTOSTART_PATH = "~/.config/autostart/com.github.darkoverlordofdata.badabing.desktop";

    const string AUTOSTART_URI = "com.github.darkoverlordofdata.badabing";

    const string CRONTAB_ADD    = "bin/badabing/crontab_add.sh";
    const string CRONTAB_REM    = "bin/badabing/crontab_rem.sh";
    const string CRONJOB_PATH   = "bin/badabing/cronjob.sh";
    const string CATLOCK_PATH   = ".local/share/catlock/themes/badabing/copy.sh";z


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
                set_autostart_on();
                setting.set_boolean("start-on-boot", true);
            } 
            else {
                set_autostart_off();
                setting.set_boolean("start-on-boot", false);
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
                set_cronjob_on();
                setting.set_boolean("use-cron-job", true);
            } 
            else {
                set_cronjob_off();
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
                set_lockscreen_on();
                setting.set_boolean("create-lock-assets", true);
            } 
            else {
                set_lockscreen_off();
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

        content_area.attach(cron_label, 2, 8, 1, 1);
        content_area.attach(cron_sw, 3, 8, 1, 1);

        content_area.attach(ind_label, 2, 11, 1, 1);
        content_area.attach(ind_sw, 3, 11, 1, 1);

        content_area.attach(lock_label, 2, 13, 1, 1);
        content_area.attach(lock_sw, 3, 13, 1, 1);
    }

    /**
     * Enable cron job -
     * 
     * writes the file ~/bin/badabing/cronjob.sh
     * then schedules it to run once per day via cron
     */
    private void set_cronjob_on() {

        var HOME = Environment.get_home_dir();
        var DISPLAY = Environment.get_variable("DISPLAY");
        var SHELL = Environment.get_variable("SHELL");
        var PATH = Environment.get_variable("PATH");

        var badabing = File.new_for_path(@"$(GLib.Environment.get_home_dir())/bin/badabing");
        if (!badabing.query_exists())
            badabing.make_directory_with_parents();
            
        var crontab = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CRONTAB_REM");
        if (crontab.query_exists()) 
            crontab.delete();

        var cronjob_sh = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CRONJOB_PATH");
        var stream = new DataOutputStream(cronjob_sh.create(FileCreateFlags.NONE));
        stream.put_string("""#!/usr/bin/env bash
#
#   run badabing from crontab
#
SHELL=%s
HOME=%s
PATH=%s
export DISPLAY=%s

geometry=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
width=$(echo $geometry | cut -f1 -dx)
height=$(echo $geometry | cut -f2 -dx)

/usr/bin/env com.github.darkoverlordofdata.badabing --update --width=$width --height=$height
""".printf(SHELL, HOME, PATH, DISPLAY));

        var crontab_sh = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CRONTAB_ADD");
        var stream2 = new DataOutputStream(crontab_sh.create(FileCreateFlags.REPLACE_DESTINATION));
        stream2.put_string("""#!/usr/bin/env bash
#
#   edit the crontab to add the cronjob   
#
croncmd="DISPLAY=$DISPLAY $HOME/%s"
cronjob="1 0  * * * $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
""".printf(CRONJOB_PATH));

        try {
            print (@"$HOME/$CRONTAB_ADD\n");
            Process.spawn_command_line_async (@"bash $HOME/$CRONTAB_ADD");
        } catch (GLib.Error e) {
            print (@"Error: $(e.message)\n");
            critical (e.message);
        }                

    }

    /**
     * Disable cron job -
     * 
     * removed ~/bin/badabing/cronjob.sh 
     * remove the scheduled cron job 
     */
    private void set_cronjob_off() {
        var cronjob = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CRONJOB_PATH");
        if (cronjob.query_exists()) {
            cronjob.delete();
        }    
        var crontab = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CRONTAB_ADD");
        if (crontab.query_exists()) {
            crontab.delete();
        }    

        var HOME = Environment.get_home_dir();
        var crontab_sh = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CRONTAB_REM");
        var stream2 = new DataOutputStream(crontab_sh.create(FileCreateFlags.REPLACE_DESTINATION));
        stream2.put_string("""#!/usr/bin/env bash
#
#   edit the crontab to remove the cronjob   
#
croncmd="DISPLAY=$DISPLAY $HOME/%s"
cronjob="1 0  * * * $croncmd"

crontab -l | grep -v -F "$croncmd" | crontab -
""".printf(CRONJOB_PATH));

        try {
            print (@"$HOME/$CRONTAB_ADD\n");
            Process.spawn_command_line_async (@"bash $HOME/$CRONTAB_REM");
        } catch (GLib.Error e) {
            print (@"Error: $(e.message)\n");
            critical (e.message);
        }                

    }


    /**
     * Enable catlock -
     * 
     * create the catock folder and copy job
     */
     private void set_lockscreen_on() {
        print (@"creating $(GLib.Environment.get_home_dir())/.local/share/catlock");
        var catlock = File.new_for_path (@"$(GLib.Environment.get_home_dir())/.local/share/catlock");
        if (!catlock.query_exists())
            catlock.make_directory_with_parents();

        var catlock_sh = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CATLOCK_PATH");
        var stream = new DataOutputStream(catlock_sh.create(FileCreateFlags.NONE));
        stream.put_string("""#!/usr/bin/env bash
#
#  $1 - user data dir, usually ~/.local/share
#  $2 - chached background jpg 
#  $3 - screen width
#  $4 - screen height
#
#	Copy & resize the wallpaper to fit on the device
#
convert $2 -resize $3x$4 $1/catlock/themes/badabing/bg.jpg
#
#	copy to modal background, using avatar (192x192) if available 
#
# if [ -f $1/catlock/themes/badabing/avatar.png ]; then

    let center=($3/2)-96
    let top=$4/6

    convert $2 -resize $3x$4 -fill black -colorize 40% $1/catlock/themes/badabing/box1.jpg
    convert $1/catlock/themes/badabing/box1.jpg  $1/catlock/themes/badabing/avatar.png -geometry +$center+$top -composite $1/catlock/themes/badabing/box.jpg
    rm -f $1/catlock/themes/badabing/box1.jpg

# else

#     convert $2 -resize $3x$4 -fill black -colorize 40% $1/catlock/themes/badabing/box.jpg

# fi       
""");
    
    }

    /**
     * Disable catlock -
     * 
     * remove the catlock copy job
     */
     private void set_lockscreen_off() {
        var catlock_sh = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CATLOCK_PATH");
        if (catlock_sh.query_exists()) {
            catlock_sh.delete();
        }    
    }

    /**
     * Enable autostart -
     * 
     * writes the badabing.desktop file to ~/.config/autostart
     */
    private void set_autostart_on() {

        print("'%s'/n", @"$(GLib.Environment.get_home_dir())/.config/autostart\n");
        var file = File.new_for_path(@"$(GLib.Environment.get_home_dir())/.config/autostart");
        if (!file.query_exists())
            file.make_directory();

        //  var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/com.github.darkoverlordofdata.badabing.desktop";
        var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/$(AUTOSTART_URI).desktop";
        var autostart = File.new_for_path(path);
        var fs = autostart.create(FileCreateFlags.NONE);
        var ds = new DataOutputStream(fs);
        if (FileUtils.test("/usr/local/share/icons/com.github.darkoverlordofdata.badabing.svg", FileTest.EXISTS)) 
            ds.put_string("""[Desktop Entry]
Type=Application
Version=1.0
Name=Bada Bing
Comment=Hey Linux, I got yer wallpaper
Exec=com.github.darkoverlordofdata.badabing --update --force --schedule
Icon=/usr/local/share/icons/com.github.darkoverlordofdata.badabing.svg
Terminal=false
Categories=Utility;
StartupNotify=false
X-GNOME-Autostart-enabled=true
""");
        else 
            ds.put_string("""[Desktop Entry]
Type=Application
Version=1.0
Name=Bada Bing
Comment=Hey Linux, I got yer wallpaper
Exec=com.github.darkoverlordofdata.badabing --update --force --schedule
Icon=/usr/share/icons/com.github.darkoverlordofdata.badabing.svg
Terminal=false
Categories=Utility;
StartupNotify=false
X-GNOME-Autostart-enabled=true
""");
    
        //  FileUtils.chmod(path, 0775);
    }
    
    /**
     * Disable autostart -
     * 
     * removes the badabing.desktop file from ~/.config/autostart
     */
     private void set_autostart_off() {
        var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/$(AUTOSTART_URI).desktop";
        var autostart = File.new_for_path(path);
        if (autostart.query_exists()) {
            autostart.delete();
        }    
    }
}

