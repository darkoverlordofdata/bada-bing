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
 public class BaDaBing.PreferencesView : Gtk.Paned 
{
    public PreferencesView() 
    {
 
        var stack = new Gtk.Stack();
        stack.add_named(new PreferencesInterface(), "preferences_interface");
        stack.add_named(new PreferencesGeneral(), "preferences_general");

        var settings_sidebar = new Granite.SettingsSidebar(stack);

        add(settings_sidebar);
        add(stack);
    }
}
