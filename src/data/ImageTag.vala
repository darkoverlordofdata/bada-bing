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