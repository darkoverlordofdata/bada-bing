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
        var DESKTOP_SESSION = Environment.get_variable("DESKTOP_SESSION");

        var badabing = File.new_for_path(@"$HOME/$CRONJOB_DIR");
        if (!badabing.query_exists())
            badabing.make_directory_with_parents();
            
        var cronjob_sh = File.new_for_path(@"$HOME/$CRONJOB_PATH");
        var stream = new DataOutputStream(cronjob_sh.create(FileCreateFlags.NONE));
        var notify = (WallpaperApplication.notify ? "--notify" : "");
        stream.put_string(run_cron(SHELL, HOME, PATH, DISPLAY, APPLICATION_ID, notify, DESKTOP_SESSION));

        try {
            /* 
             * run a temp script to add the job to the crontab
             */
            FileIOStream iostream;
            File temp_sh = File.new_tmp ("tpl-XXXXXX.sh", out iostream);
            print ("tmp temp_sh name: %s\n", temp_sh.get_path ());
            var stream2 = new DataOutputStream(iostream.output_stream);
            stream2.put_string(add_cron(CRONJOB_PATH));
            Process.spawn_command_line_async (@"bash $(temp_sh.get_path ())");
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
            /* 
             * run a temp script to remove the job from the crontab
             */
            FileIOStream iostream;
            File temp_sh = File.new_tmp ("tpl-XXXXXX.sh", out iostream);
            print ("tmp temp_sh name: %s\n", temp_sh.get_path ());
            var stream = new DataOutputStream(iostream.output_stream);
            stream.put_string(remove_cron(CRONJOB_PATH));
            Process.spawn_command_line_async (@"bash $(temp_sh.get_path ())");
        } catch (GLib.Error e) {
            print (@"Error: $(e.message)\n");
            critical (e.message);
        }
        
    }

    /**
    * remove_cron
    * 
    * script to remove job from crontab
    */
    public string remove_cron(string path) {
        return """#!/usr/bin/env bash
#
#   edit the crontab to remove the cronjob   
#
croncmd="DISPLAY=$DISPLAY bash $HOME/%s"
cronjob="1 0  * * * $croncmd >> $HOME/.local/share/badabing/logs/badabing.log 2>&1"

crontab -l | grep -v -F "$croncmd" | crontab -
""".printf(path);
    }


    /**
    * add_cron
    * 
    * script to add job to crontab
    */
    public string add_cron(string path) {
        return """#!/usr/bin/env bash
#
#   edit the crontab to add the cronjob   
#
croncmd="DISPLAY=$DISPLAY bash $HOME/%s"
cronjob="1 0  * * * $croncmd >> $HOME/.local/share/badabing/logs/badabing.log 2>&1"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
""".printf(path);
    }

    /**
    * add_cron
    * 
    * script to add job to crontab
    */
    public string run_cron(string shell, string home, string path, string display, string name, string notify, string desktop) {
        return """#!/usr/bin/env bash
#
#   run badabing from crontab
#
SHELL=%s
HOME=%s
PATH=%s
export DISPLAY=%s
export DESKTOP_SESSION=%s

geometry=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
width=$(echo $geometry | cut -f1 -dx)
height=$(echo $geometry | cut -f2 -dx)

/usr/bin/env %s --update --width=$width --height=$height %s
""".printf(shell, home, path, display, desktop, name, notify);
    }    
}



//sudo: /home/darko/.config/badabing/cronjob.sh: command not found