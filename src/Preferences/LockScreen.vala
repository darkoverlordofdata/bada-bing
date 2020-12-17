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
		print (@"creating $(GLib.Environment.get_home_dir())/.local/share/catlock/themes/badabing");
		var catlock = File.new_for_path (@"$(GLib.Environment.get_home_dir())/.local/share/catlock/themes/badabing");
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
#  $1 - user data dir, usually ~/.local/share
#  $2 - chached background jpg 
#  $3 - screen width
#  $4 - screen height
#
#	Copy & resize the wallpaper to fit on the device
#
convert $2 -resize $3x$4\! $1/catlock/themes/badabing/bg.jpg
#
#	copy to modal background, using avatar (192x192) if available 
#
# if [ -f $1/catlock/themes/badabing/avatar.png ]; then

	let center=($3/2)-96
	let top=$4/6

	convert $2 -resize $3x$4\! -fill black -colorize 40% $1/catlock/themes/badabing/box1.jpg
	convert $1/catlock/themes/badabing/box1.jpg  $1/catlock/themes/badabing/avatar.png -geometry +$center+$top -composite $1/catlock/themes/badabing/box.jpg
	rm -f $1/catlock/themes/badabing/box1.jpg

# else

#     convert $2 -resize $3x$4 -fill black -colorize 40% $1/catlock/themes/badabing/box.jpg

# fi       
""";

	}


}

