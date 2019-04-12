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
 public class BaDaBing.WelcomeView : Gtk.Grid 
{
    construct 
    {
        var welcome = new Granite.Widgets.Welcome("Ba Da Bing", 
            "Hey, Linux. We got yer wallpaper here.");
        welcome.append("help-about", 
            "About", "About Ba Da Bing");
        welcome.append("preferences-desktop-wallpaper", //"text-x-source", 
            "Get Source", "Ba Da Bing's source code is hosted on GitHub.");

        add(welcome);

        welcome.activated.connect((index) => {
            switch(index) {
                case 0:
                    try {
                        new BaDaBing.Widget.About().show();
                    } catch(Error e) {
                        warning(e.message);
                    }

                    break;
                case 1:
                    try {
                        AppInfo.launch_default_for_uri("https://github.com/darkoverlordofdata/bada-bing", null);
                    } catch(Error e) {
                        warning(e.message);
                    }

                    break;
            }
        });
    }
}
