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
 public class BaDaBing.SettingsView : Gtk.Paned 
{
    construct 
    {
        var stack = new Gtk.Stack();
        stack.add_named(new PreferencesInterface(), "preferences_interface");
        stack.add_named(new PreferencesGeneral(), "preferences_general");

        //  stack.add_named(new SettingsMinimized(), "settings_minimized");
        //  stack.add_named(new SettingsIndicator(), "settings_indicator");
        //  stack.add_named(new SettingsAutoStart(), "settings_autostart");
        //  stack.add_named(new SettingsInterval(), "settings_interval");
        var settings_sidebar = new Granite.SettingsSidebar(stack);

        add(settings_sidebar);
        add(stack);
    }
}
