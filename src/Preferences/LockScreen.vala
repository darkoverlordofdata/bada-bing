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
public class BadaBing.LockScreen : Object, IPreference
{

	/**
	* Enable catlock -
	* 
	* create the catock folder and copy job
	*/
	public void enable() {
		print (@"creating $(GLib.Environment.get_home_dir())/.local/share/catlock/themes");
		var catlock = File.new_for_path (@"$(GLib.Environment.get_home_dir())/.local/share/catlock/themes");
		if (!catlock.query_exists())
			catlock.make_directory_with_parents();

		var catlock_sh = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CATLOCK_PATH");
		var stream = new DataOutputStream(catlock_sh.create(FileCreateFlags.NONE));
		stream.put_string(copy_assets());
	
	}

	/**
	* Disable catlock -
	* 
	* remove the catlock copy job
	*/
	public void disable() {
		var catlock_sh = File.new_for_path(@"$(GLib.Environment.get_home_dir())/$CATLOCK_PATH");
		if (catlock_sh.query_exists()) {
			catlock_sh.delete();
		}    
	}

	/**
	* copy_assets
	* 
	* copy the assets for lock screen
	*/
	public string copy_assets() {
		return """#!/usr/bin/env bash
#
#  $1 - home, usually ~/
#  $2 - user data dir, usually ~/.local/share
#  $3 - chached background jpg 
#  $4 - screen width
#  $5 - screen height
#
#	Copy & resize the wallpaper to fit on the device
#
convert $3 -resize $4x$5\! $2/catlock/themes/badabing.locked.jpg
#
#	copy to modal background, using avatar (192x192) if available 
#
# if [ -f $1/.iface ]; then

	let center=($4/2)-96
	let top=$5/6

	convert $3 -resize $4x$5\! -fill black -colorize 40% $2/catlock/themes/badabing.tmp.jpg
	convert $2/catlock/themes/badabing.tmp.jpg  $2/catlock/themes/avatar.png -geometry +$center+$top -composite $2/catlock/themes/badabing.input.jpg
#	convert $2/catlock/themes/badabing.tmp.jpg  $1/.iface -geometry +$center+$top -composite $2/catlock/themes/badabing.input.jpg
	rm -f $2/catlock/themes/badabing.tmp.jpg

# else

#     convert $3 -resize $4x$5 -fill black -colorize 40% $2/catlock/themes/badabing.input.jpg

# fi       
""";

	}


}

