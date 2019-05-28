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
 public class BaDaBing.PreferencesAppearance : Granite.SimpleSettingsPage
{
    public PreferencesAppearance() 
    {
        Object(
            activatable: false,
            description: "Select Interface Elements",
            header: "Appearance",
            icon_name: "preferences-desktop-personal",
            title: "Apperance"
        );
    }

    construct 
    {
        var setting = new Settings(APPLICATION_ID);

        //Change to dark theme
        var theme_lab = new Gtk.Label(_("Dark theme:"));
        theme_lab.halign = Gtk.Align.END;
        var theme = new Gtk.Switch();
        theme.halign = Gtk.Align.START;
        if (setting.get_boolean("dark")) {
            theme.active = true;
        } else {
            theme.active = false;
        }
        theme.notify["active"].connect(() => {
           if (theme.get_active()) {
               Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
               setting.set_boolean("dark", true);
           } else {
               Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
               setting.set_boolean("dark", false);
           }
        });

        // locale
        //  US, UK, DE, CA, AU, FR, CH, JP

        var locale_lab = new Gtk.Label(_("Locale :"));
        locale_lab.halign = Gtk.Align.END;
        var locale_box = new Gtk.ComboBoxText();
        locale_box.append_text(_("United States"));
        locale_box.append_text(_("United Kingdom"));
        locale_box.append_text(_("Deutch"));
        locale_box.append_text(_("Canada"));
        locale_box.append_text(_("Australia"));
        locale_box.append_text(_("France"));
        locale_box.append_text(_("China"));
        locale_box.append_text(_("Japan"));
        string locale = setting.get_string("locale");
        switch(locale) {
            case LOCALE_US:
                locale_box.active = 0;
                break;
            case LOCALE_UK:
                locale_box.active = 1;
                break;
            case LOCALE_DE:
                locale_box.active = 2;
                break;
            case LOCALE_CA:
                locale_box.active = 3;
                break;
            case LOCALE_AU:
                locale_box.active = 4;
                break;
            case LOCALE_FR:
                locale_box.active = 5;
                break;
            case LOCALE_CH:
                locale_box.active = 6;
                break;
            case LOCALE_JP:
                locale_box.active = 7;
                break;
            default:
                locale_box.active = 1;
                break;
        }

        locale_box.changed.connect(() => {
            switch(locale_box.active) {
                case 0:
                    locale = LOCALE_US;
                    break;
                case 1:
                    locale = LOCALE_UK;
                    break;
                case 2:
                    locale = LOCALE_DE;
                    break;
                case 3:
                    locale = LOCALE_CA;
                    break;
                case 4:
                    locale = LOCALE_AU;
                    break;
                case 5:
                    locale = LOCALE_FR;
                    break;
                case 6:
                    locale = LOCALE_CH;
                    break;
                case 7:
                    locale = LOCALE_JP;
                    break;
                default:
                    locale = DEFAULT_LOCALE;
                    break;
            }
            setting.set_string("locale", locale);
        });

        // resolution
        //  1366x768
        //  1920x1280
        //  1920x1200
        //  
        var resolution_lab = new Gtk.Label(_("Resolution :"));
        resolution_lab.halign = Gtk.Align.END;
        var resolution_box = new Gtk.ComboBoxText();
        resolution_box.append_text(_("1366x768"));
        resolution_box.append_text(_("1920x1280"));
        resolution_box.append_text(_("1920x1280"));
        string resolution = setting.get_string("resolution");
        switch(resolution) {
            case RESOLUTION_1366_768:
                resolution_box.active = 0;
                break;
            case RESOLUTION_1920_1200:
                resolution_box.active = 1;
                break;
            case RESOLUTION_1920_1280:
                resolution_box.active = 2;
                break;
            default:
                resolution_box.active = 1;
                break;
        }

        resolution_box.changed.connect(() => {
            switch(resolution_box.active) {
                case 0:
                    resolution = RESOLUTION_1366_768;
                    break;
                case 1:
                    resolution = RESOLUTION_1920_1200;
                    break;
                case 2:
                    resolution = RESOLUTION_1920_1280;
                    break;
                default:
                    resolution = DEFAULT_RESOLUTION;
                    break;
            }
            setting.set_string("resolution", resolution);
        });
        
        content_area.attach(theme_lab, 2, 3, 1, 1);
        content_area.attach(theme, 3, 3, 1, 1);

        content_area.attach(locale_lab, 2, 5, 1, 1);
        content_area.attach(locale_box, 3, 5, 1, 1);

        content_area.attach(resolution_lab, 2, 7, 1, 1);
        content_area.attach(resolution_box, 3, 7, 1, 1);
    }

}

