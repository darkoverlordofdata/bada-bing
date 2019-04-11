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
 public class BaDaBing.SettingsAutoStart : Granite.SimpleSettingsPage
{
    public SettingsAutoStart() 
    {
        Object(
            activatable: true,
            description: "Start after reboot",
            header: "AutoStart",
            icon_name: "view-refresh",
            title: "Autostart on boot"
        );
    }

    construct 
    {
        //  var icon_label = new Gtk.Label("Icon Name:");
        //  icon_label.xalign = 1;

        //  var icon_entry = new Gtk.Entry();
        //  icon_entry.hexpand = true;
        //  icon_entry.placeholder_text = "This page's icon name";
        //  icon_entry.text = icon_name;

        //  var title_label = new Gtk.Label("Title:");
        //  title_label.xalign = 1;

        //  var title_entry = new Gtk.Entry();
        //  title_entry.hexpand = true;
        //  title_entry.placeholder_text = "This page's title";

        //  var description_label = new Gtk.Label("Description:");
        //  description_label.xalign = 1;

        //  var description_entry = new Gtk.Entry();
        //  description_entry.hexpand = true;
        //  description_entry.placeholder_text = "This page's description";

        //  content_area.attach(icon_label, 0, 0, 1, 1);
        //  content_area.attach(icon_entry, 1, 0, 1, 1);
        //  content_area.attach(title_label, 0, 1, 1, 1);
        //  content_area.attach(title_entry, 1, 1, 1, 1);
        //  content_area.attach(description_label, 0, 2, 1, 1);
        //  content_area.attach(description_entry, 1, 2, 1, 1);

        update_status();

        //  description_entry.changed.connect(() => {
        //      description = description_entry.text;
        //  });

        //  icon_entry.changed.connect(() => {
        //      icon_name = icon_entry.text;
        //  });

        status_switch.notify["active"].connect(update_status);

        //  title_entry.changed.connect(() => {
        //      title = title_entry.text;
        //  });
    }

    private void update_status() 
    {
    //     if (status_switch.active) {
    //          status_type = Granite.SettingsPage.StatusType.SUCCESS;
    //          status = _("Enabled");
    //      } else {
    //          status_type = Granite.SettingsPage.StatusType.OFFLINE;
    //          status = _("Disabled");
    //      }
    }

}

