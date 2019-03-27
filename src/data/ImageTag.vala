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
 public class BingWall.ImageTag : Object
 {
     public string url;
     public string urlBase;
     public string startdate;
     public string headline;
     public string copyright;

     public ImageTag(Xml.Node* parent)
     {
        for (Xml.Node* node = *xml->children; node != null; node = node->next) {
            if (node->type == Xml.ElementType.ELEMENT_NODE) {
                switch (node->name) {

                    case "url":
                        this.url = node->get_content();
                        break;
        
                    case "urlBase":
                        this.urlBase = node->get_content();
                        break;
        
                    case "startdate":
                        this.startdate = node->get_content();
                        break;

                    case "headline":
                        this.headline = node->get_content();
                        break;

                    case "copyright":
                        this.copyright = node->get_content();
                        break;

                    default:
                        break;
                }
            }
        }
     }
 }
 