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
public class BadaBing.CronJob : Object, IPreference
{

    /**
    * Enable cron job -
    * 
    * writes the file ~/.config/badabing/cronjob.sh
    * then schedules it to run once per day via cron
    */
    public void enable() {
        
        var HOME = Environment.get_home_dir();
        var DISPLAY = Environment.get_variable("DISPLAY");
        var SHELL = Environment.get_variable("SHELL");
        var PATH = Environment.get_variable("PATH");

        var badabing = File.new_for_path(@"$(GLib.Environment.get_home_dir())/.config/badabing");
        if (!badabing.query_exists())
            badabing.make_directory_with_parents();
            
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

/usr/bin/env com.github.darkoverlordofdata.badabing --update --width=$width --height=$height %s
""".printf(SHELL, HOME, PATH, DISPLAY, (WallpaperApplication.notify ? "--notify" : "") ));

        try {

            FileIOStream iostream;
            File crontab_sh = File.new_tmp ("tpl-XXXXXX.sh", out iostream);
            print ("tmp crontab_sh name: %s\n", crontab_sh.get_path ());
            var stream2 = new DataOutputStream(iostream.output_stream);

            stream2.put_string("""#!/usr/bin/env bash
#
#   edit the crontab to add the cronjob   
#
croncmd="DISPLAY=$DISPLAY $HOME/%s"
cronjob="1 0  * * * $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
""".printf(CRONJOB_PATH));

            Process.spawn_command_line_async (@"bash $(crontab_sh.get_path ())");
        } catch (GLib.Error e) {
            print (@"Error: $(e.message)\n");
            critical (e.message);
        }                

    }


    /**
    * Disable cron job -
    * 
    * removed ~/.config/badabing/cronjob.sh 
    * remove the scheduled cron job 
    */
    public void disable() {
        var cronjob = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CRONJOB_PATH");
        if (cronjob.query_exists()) {
            cronjob.delete();
        }    

        try {
            FileIOStream iostream;
            File crontab_sh = File.new_tmp ("tpl-XXXXXX.sh", out iostream);
            print ("tmp crontab_sh name: %s\n", crontab_sh.get_path ());
            var stream2 = new DataOutputStream(iostream.output_stream);
            stream2.put_string("""#!/usr/bin/env bash
#
#   edit the crontab to remove the cronjob   
#
croncmd="DISPLAY=$DISPLAY $HOME/%s"
cronjob="1 0  * * * $croncmd"

crontab -l | grep -v -F "$croncmd" | crontab -
""".printf(CRONJOB_PATH));

            Process.spawn_command_line_async (@"bash $(crontab_sh.get_path ())");
        } catch (GLib.Error e) {
            print (@"Error: $(e.message)\n");
            critical (e.message);
        }
        
    }
}

