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
 public class BaDaBing.ImageTag : Object
 {
     public string url;
     public string urlBase;
     public string startdate;
     public string title;
     public string copyright;

     /**
      * Create image tag from JSON node
      */
      public ImageTag.from_json(Json.Node node) 
     {
         var object = node.get_object();
          
         this.url       = object.get_string_member("url");
         this.urlBase   = object.get_string_member("urlbase");
         this.startdate = object.get_string_member("startdate");
         this.title     = object.get_string_member("title");
         this.copyright = object.get_string_member("copyright");
     }

     /**
      * Create image tag from Xml node
      */
     public ImageTag.from_xml(Xml.Node* parent) 
     {
        for (Xml.Node* node = parent->children; node != null; node = node->next) {
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
                        this.title = node->get_content();
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

     /**
      * String representation of current node
      */
     public string to_string() {
        return "%s - %s - %s".printf(startdate, title, urlBase);
     }
 }