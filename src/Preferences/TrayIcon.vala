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
public class BadaBing.TrayIcon : Object, IPreference
{

    /**
    * Enable autostart tray menu -
    * 
    * writes the badabing.TrayIcon.desktop file to ~/.config/autostart
    */
    public void enable() {

        print("'%s'/n", @"$(GLib.Environment.get_home_dir())/.config/autostart\n");
        var file = File.new_for_path(@"$(GLib.Environment.get_home_dir())/.config/autostart");
        if (!file.query_exists())
            file.make_directory();

        //  var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/com.github.darkoverlordofdata.badabing.desktop";
        var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/$APPLICATION_ID.TrayIcon.desktop";
        var autostart = File.new_for_path(path);
        var fs = autostart.create(FileCreateFlags.NONE);
        var ds = new DataOutputStream(fs);
        var prefix = (FileUtils.test("/usr/local/share/", FileTest.EXISTS)) 
                    ?  "/usr/local/share"
                    :  "/usr/share";

        ds.put_string(desktop_content(prefix, APPLICATION_ID));
        print("Enable Tray Icon");
        Process.spawn_command_line_async (@"nohup python $prefix/bin/$APPLICATION_ID.py &");
    }
    
    /**
    * Disable autostart -
    * 
    * removes the badabing.desktop file from ~/.config/autostart
    */
    public void disable() {
        var path = @"$(GLib.Environment.get_home_dir())/.config/autostart/$APPLICATION_ID.TrayIcon.desktop";
        var autostart = File.new_for_path(path);
        if (autostart.query_exists()) {
            autostart.delete();
        }    
    }

    /**
    * desktop_content -
    * 
    * create the content for name.desktop file
    */
    public string desktop_content(string prefix, string name) {
        return """[Desktop Entry]
Type=Application
Version=1.0
Name=Bada Bing Tray Icon
Comment=Hey Linux, I got yer wallpaper
Exec=nohup python %s/bin/%s.py &
Icon=%s/icons/%s.svg
Terminal=false
Categories=Utility;
StartupNotify=false
X-GNOME-Autostart-enabled=true
""".printf(prefix, name, prefix, name);
    }

}
