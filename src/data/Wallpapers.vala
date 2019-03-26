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
 /**
  * Wallpaper collection
  */
public class BingWall.Wallpapers : Object 
{
    public int count;
    public GenericArray<Wallpaper> paper;
    GenericArray<Serializer> data;
    string config_dir;
    string config_dat;  

    const int MAJIK = 0xd16a;
 
    /**
     * Initialize the environment
     */
    public Wallpapers() 
    {
        config_dir = @"$(Environment.get_user_cache_dir())/bing-wall";
        config_dat = @"$(config_dir)/ix";

        /**
         * make sure the /home/user/.config/bing-wall folder exists
         */
        if (!FileUtils.test(config_dir, FileTest.EXISTS)) {
            var dir = File.new_for_path(config_dir);
            dir.make_directory();
        }

        /**
         * make sure the /home/user/.config/bing-wall/data file exists
         */
        if (!FileUtils.test(config_dat, FileTest.EXISTS)) {
            var file = File.new_for_path(config_dat);
            var fios = file.create_readwrite(FileCreateFlags.PRIVATE);
            reset();
        }

        paper = new GenericArray<Wallpaper>();
        data = new GenericArray<Serializer>();
    }

    /**
     * list the wallpaper currently in cache
     */
    public void list() 
    {
        var file = File.new_for_path(config_dat);
        var fios = file.open_readwrite();
        var stream = new DataInputStream(fios.input_stream);
        var magic = stream.read_int32();
        if (magic != MAJIK) {
            throw new Exception.InvalidDataFormat(@"Invalid format in $config_dat");
        }
        count = stream.read_int32();
        if (count == 0) {
            print("No images in cache\n");
        }
        else {
            var w = new Wallpaper();
            var data = new Serializer(w, fios);
            for (var i=0; i<count; i++) {
                data.deserialize();
                print("recno: %d\ndate: %s\npath: %s\ndesc: %s\n", w.recno, w.timestamp, w.path, w.desc);
            }
        }
    }
    
    /**
     * reset file data to 0 records
     */
    public void reset()
    {
        var file = File.new_for_path(config_dat);
        var fios = file.open_readwrite();
        var output = new DataOutputStream(fios.output_stream);
        output.put_int32(MAJIK);
        output.put_int32(0);
    }

    /**
     * load from file
     */
    public void load()
    {
        var file = File.new_for_path(config_dat);
        var fios = file.open_readwrite();

        var input = new DataInputStream(fios.input_stream);

        var magic = input.read_int32();
        if (magic != MAJIK) {
            throw new Exception.InvalidDataFormat(@"Invalid format in $config_dat");
        }
        count = input.read_int32();
        for (var i=0; i<count; i++) {
            var d = new Serializer(new Wallpaper(), fios);
            paper.add(d.object);
            data.add(d);
            d.deserialize();
        }
    }

    /**
     * Add a record, re-writes file
     * 
     * @param timestamp 
     * @param path
     * @param desc
     * 
     */
    public void add(string timestamp, string path, string desc) 
    {
        load();
        var file = File.new_for_path(config_dat);
        var fios = file.open_readwrite();

        var object = new Wallpaper(count, timestamp, path, desc);
        paper.add(object);
        data.add(new Serializer(object, fios));

        var output = new DataOutputStream(fios.output_stream);
        output.put_int32(MAJIK);
        output.put_int32(++count);
        data.foreach((d) => d.serialize());
    }
}