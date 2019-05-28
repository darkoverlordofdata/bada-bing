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
 public class BaDaBing.Widget.Location : Gtk.Box
 {
    public BaDaBing.MainWindow window;
    private BaDaBing.Widget.Header header;

    /*
     * Active values will have their own localized version. 
     * InActive values will be considered as the “Rest of the World” by Bing.
     */
    struct Locale 
    {
        string code;
        bool active;
        string name;
    }
    

    public Location(BaDaBing.MainWindow window, BaDaBing.Widget.Header header) {

        Locale locale[] = {
            Locale() { code = "auto",  active = true,  name = "auto" },
            Locale() { code = "ar-XA", active = false, name = "Arabic (Saudi Arabia)" },
            Locale() { code = "bg-BG", active = false, name = "Bulgarian (Bulgaria)" },
            Locale() { code = "cs-CZ", active = false, name = "Czech (Czech Republic)" },
            Locale() { code = "da-DK", active = false, name = "Danish (Denmark)" },
            Locale() { code = "de-AT", active = false, name = "German (Austria)" },
            Locale() { code = "de-CH", active = false, name = "German (Switzerland)" },
            Locale() { code = "de-DE", active = true,  name = "German (Germany)" },
            Locale() { code = "el-GR", active = false, name = "Greek (Greece)" },
            Locale() { code = "en-AU", active = true,  name = "English (Australia)" },
            Locale() { code = "en-CA", active = true,  name = "English (Canada)" },
            Locale() { code = "en-GB", active = true,  name = "English (United Kingdom)" },
            Locale() { code = "en-ID", active = true,  name = "English (Indonesia)" },
            Locale() { code = "en-IE", active = false, name = "English (Ireland)" },
            Locale() { code = "en-IN", active = false, name = "English (India)" },
            Locale() { code = "en-MY", active = false, name = "English (Malaysia)" },
            Locale() { code = "en-NZ", active = false, name = "English (New Zealand)" },
            Locale() { code = "en-PH", active = false, name = "English (Republic of the Philippines)" },
            Locale() { code = "en-SG", active = false, name = "English (Singapore)" },
            Locale() { code = "en-US", active = false, name = "English (United States)" },
            Locale() { code = "en-XA", active = false, name = "English (Arabia)" },
            Locale() { code = "en-ZA", active = false, name = "English (South Africa)" },
            Locale() { code = "es-AR", active = false, name = "Spanish (Argentina)" },
            Locale() { code = "es-CL", active = false, name = "Spanish (Chile)" },
            Locale() { code = "es-ES", active = false, name = "Spanish (Spain)" },
            Locale() { code = "es-MX", active = false, name = "Spanish (Mexico)" },
            Locale() { code = "es-US", active = false, name = "Spanish (United States)" },
            Locale() { code = "es-XL", active = false, name = "Spanish (Latin America)" },
            Locale() { code = "et-EE", active = false, name = "Estonian (Estonia)" },
            Locale() { code = "fi-FI", active = false, name = "Finnish (Finland)" },
            Locale() { code = "fr-BE", active = false, name = "French (Belgium)" },
            Locale() { code = "fr-CA", active = true,  name = "French (Canada)" },
            Locale() { code = "fr-CH", active = false, name = "French (Switzerland)" },
            Locale() { code = "fr-FR", active = true,  name = "French (France)" },
            Locale() { code = "he-IL", active = false, name = "Hebrew (Israel)" },
            Locale() { code = "hr-HR", active = false, name = "Croatian (Croatia)" },
            Locale() { code = "hu-HU", active = false, name = "Hungarian (Hungary)" },
            Locale() { code = "it-IT", active = false, name = "Italian (Italy)" },
            Locale() { code = "ja-JP", active = true,  name = "Japanese (Japan)" },
            Locale() { code = "ko-KR", active = false, name = "Korean (Korea)" },
            Locale() { code = "lt-LT", active = false, name = "Lithuanian (Lithuania)" },
            Locale() { code = "lv-LV", active = false, name = "Latvian (Latvia)" },
            Locale() { code = "nb-NO", active = false, name = "Norwegian (Bokmål) (Norway)" },
            Locale() { code = "nl-BE", active = false, name = "Dutch (Belgium)" },
            Locale() { code = "nl-NL", active = false, name = "Dutch (Netherlands)" },
            Locale() { code = "pl-PL", active = false, name = "Polish (Poland)" },
            Locale() { code = "pt-BR", active = false, name = "Portuguese (Brazil)" },
            Locale() { code = "pt-PT", active = false, name = "Portuguese (Portugal)" },
            Locale() { code = "ro-RO", active = false, name = "Romanian (Romania)" },
            Locale() { code = "ru-RU", active = false, name = "Russian (Russia)" },
            Locale() { code = "sk-SK", active = false, name = "Slovak (Slovakia)" },
            Locale() { code = "sl-SL", active = false, name = "Slovenian (Slovenia)" },
            Locale() { code = "sv-SE", active = false, name = "Swedish (Sweden)" },
            Locale() { code = "th-TH", active = false, name = "Thai (Thailand)" },
            Locale() { code = "tr-TR", active = false, name = "Turkish (Turkey)" },
            Locale() { code = "uk-UA", active = false, name = "Ukrainian (Ukraine)" },
            Locale() { code = "zh-CN", active = true,  name = "Chinese (S)" },
            Locale() { code = "zh-HK", active = false, name = "Chinese (Hong Kong)" },
            Locale() { code = "zh-TW", active = false, name = "Chinese (T)" },
        };
        orientation = Gtk.Orientation.VERTICAL;
        spacing = 5;

        this.window = window;
        this.header = header;
        window.set_titlebar(header);
        header.set_title("");

        var search_line = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
        pack_start(search_line, false, false, 5);

        var search_label = new Gtk.Label("Search for new location:");
        search_line.pack_start(search_label, false, false, 5);
        var search_entry = new Gtk.Entry();
        search_entry.max_length = 40;
        search_entry.primary_icon_name = "system-search-symbolic";
        search_entry.secondary_icon_name = "edit-clear-symbolic";
        search_line.pack_start(search_entry, true, true, 5);

        var location_view = new Gtk.TreeView();
        location_view.expand = true;
        var location_list = new Gtk.ListStore(5, typeof(double), typeof(double), typeof(string), typeof(string), typeof(string));
        location_view.model = location_list;
        location_view.insert_column_with_attributes(-1, "Code", new Gtk.CellRendererText(), "text", 0);
        location_view.insert_column_with_attributes(-1, "Name", new Gtk.CellRendererText(), "text", 1);
        var scroll = new Gtk.ScrolledWindow(null,null);
        scroll.hscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
        scroll.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
        scroll.add(location_view);

        search_entry.icon_press.connect((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                search_entry.set_text("");
                location_list.clear();
            }
        });

        var overlay = new Gtk.Overlay();
        pack_end(overlay, true, true, 0);
        overlay.add_overlay(scroll);

    }

    //  private static Mycity get_selection(Gtk.TreeModel model, Gtk.TreeIter iter) {
    //      var city = Mycity();
    //      model.get(iter, 0, out city.lat, 1, out city.lon, 2, out city.country, 3, out city.state, 4, out city.town);
    //      return city;
    //  }

    private void on_row_activated(Gtk.TreeView location_view , Gtk.TreePath path, Gtk.TreeViewColumn column) {
        //  Gtk.TreeIter iter;
        //  if (location_view.model.get_iter(out iter, path)) {
        //      Mycity city = get_selection(location_view.model, iter);
        //      var setting = new Settings("com.gitlab.bitseater.meteo");
        //      var uri1 = OWM_API_ADDR + "weather?lat=";
        //      var uri2 = "&type=like&APPID=" + setting.get_string("apiid");
        //      var uri = uri1 + city.lat.to_string() + "&lon=" + city.lon.to_string() + uri2;
        //      setting.set_string("idplace", update_id(uri));
        //      setting.set_string("country", city.country);
        //      setting.set_string("state", city.state);
        //      setting.set_string("location", city.town);
        //      var current = new BaDaBing.Widgets.Current(window, header);
        //      window.change_view(current);
        //      window.show_all();
        //  }
    }

    //  private static string update_id(string uri) {
    //      var session = new Soup.Session();
    //      var message = new Soup.Message("GET", uri);
    //      session.send_message(message);
    //      string id = "";
    //      try {
    //          var parser = new Json.Parser();
    //          parser.load_from_data((string) message.response_body.flatten().data, -1);
    //          var root = parser.get_root().get_object();
    //          id = root.get_int_member("id").to_string();
    //      } catch (Error e) {
    //          debug(e.message);
    //      }
    //      return id;
    //  }
}