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

 public class BaDaBing.MainWindow : Gtk.Window 
 {
    public WallpaperApplication app;
    public AppIndicator.Indicator indicator;
    private Gtk.TreeView view;

    struct Person {
        int id;
        string name;
        string city;
        string country;

        public string to_string () {
            return @"$(id), $(name), $(city), $(country)";
        }
    }
    private void on_row_activated (Gtk.TreeView treeview , Gtk.TreePath path, Gtk.TreeViewColumn column) 
    {

    }    

    private void on_selection (Gtk.TreeSelection selection) 
    {
    }

    Person[] data = {
        Person() {id=1, name="Joe Bloggs", city="London", country="England"},
        Person() {id=2, name="Bill Smith", city="Auckland", country="New Zealand"},
        Person() {id=3, name="Joan Miller", city="Boston", country="USA"}
    };

    Gtk.Window window;
    Gtk.TreeView treeview;
    Gtk.ListStore liststore;
    Gtk.Label msg_label;

    public MainWindow(WallpaperApplication app) {
        this.app = app;
        this.set_application(app);
        this.set_size_request(720, 480);
        window_position = Gtk.WindowPosition.CENTER;
        var header = new Widget.Header(this, false);
        this.set_titlebar(header);


        //Define style
        var provider = new Gtk.CssProvider();
        provider.load_from_resource(@"$(APPLICATION_URI)/application.css");
        Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        var setting = new Settings(APPLICATION_ID);
        setting.get_boolean("dark");
        if (setting.get_boolean("dark")) {
            Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
        } else {
            Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
        }

        //create main view
        //  var overlay = new Gtk.Overlay();
        //  view = createView();

        //  view = new Gtk.Grid();
        //  view.expand = true;
        //  view.halign = Gtk.Align.FILL;
        //  view.valign = Gtk.Align.FILL;
        //  add(createView());
        //  view.attach(new Gtk.Label("Loading ..."), 0, 0, 1, 1);
        //  overlay.add_overlay(view);

        //  add(overlay);
        //  this.show_all();
    }

    public void createView() {

        var builder = new Gtk.Builder();
        try {
            builder.add_from_resource(@"$(APPLICATION_URI)/treeview-list.ui");
        }
        catch (Error e) {
            stderr.printf (@"$(e.message)\n");
            //  Posix.exit(1);
            return;
        }
        builder.connect_signals (this);
        this.window = builder.get_object("window") as Gtk.Window;
        this.msg_label = builder.get_object("msg-label") as Gtk.Label;
        this.treeview = builder.get_object ("treeview") as Gtk.TreeView;


      // Load list data.
      this.liststore = builder.get_object ("liststore") as Gtk.ListStore;
      this.liststore.clear ();
      foreach (Person p in this.data) {
          Gtk.TreeIter iter;
          this.liststore.append (out iter);
          this.liststore.set (iter, 0, p.id, 1, p.name, 2, p.city, 3, p.country);
      }
      // Monitor list double-clicks.
      this.treeview.row_activated.connect (on_row_activated);
      // Monitor list selection changes.
      this.treeview.get_selection().changed.connect (on_selection);
      this.window.show_all();
    //    this.window.destroy.connect (Gtk.main_quit);

        //  var view = new Gtk.TreeView();
        //  var listmodel = new Gtk.ListStore (4, typeof (string), typeof (string),
        //                                    typeof (string), typeof (string));
        //  view.set_model (listmodel);

        //  view.insert_column_with_attributes (-1, "Account Name", new Gtk.CellRendererText (), "text", 0);
        //  view.insert_column_with_attributes (-1, "Type", new Gtk.CellRendererText (), "text", 1);

        //  var cell = new Gtk.CellRendererText ();
        //  cell.set ("foreground_set", true);
        //  view.insert_column_with_attributes (-1, "Balance", cell, "text", 2, "foreground", 3);

        //  Gtk.TreeIter iter;
        //  listmodel.append (out iter);
        //  listmodel.set (iter, 0, "My Visacard", 1, "card", 2, "102,10", 3, "red");

        //  listmodel.append (out iter);
        //  listmodel.set (iter, 0, "My Mastercard", 1, "card", 2, "10,20", 3, "red");        

        //  return view;
    }

    public void change_view(Gtk.Widget widget) {
        //  this.view.get_child_at(0,0).destroy();
        //  widget.expand = true;
        //  this.view.attach(widget, 0, 0, 1, 1);
        //  widget.show_all();
    }

    public void create_indicator() {
    }

    public void show_indicator() {
    }

    public void hide_indicator() {
    }

}
