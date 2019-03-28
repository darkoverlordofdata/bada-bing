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
 public class BingWall.Widget.Refresh : Gtk.Box
 {
    public Refresh(BingWall.MainWindow window, BingWall.Widget.Header header) {
        orientation = Gtk.Orientation.HORIZONTAL;

        var setting = new Settings(APPLICATION_ID);
        header.custom_title = null;
        header.set_title(setting.get_string("location") + ", " + setting.get_string("state") + " " + setting.get_string("country"));
        header.change_visible(true);
    }
}