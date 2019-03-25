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
 * Wallpaper serializer
 */
public class BingWall.Serializer : Object, ISerialize
{
    public Wallpaper object;
    FileIOStream stream;
    string delim = "\0";

    /**
     * Construct serializer
     * 
     * @param object
     * @param stream
     */
    public Serializer(Wallpaper object, FileIOStream stream) 
    {
        this.object = object;
        this.stream = stream;
    }

    /**
     * Serialize the data to disk
     */
    public void serialize()
    {
        var s = new DataOutputStream(stream.output_stream);

        s.put_int32(object.recno);
        s.put_int32(object.timestamp);
        s.put_string(object.path);
        s.put_string(object.desc);
    }

    /**
     * Deserialize the data from disk
     */
    public void deserialize()
    {
        size_t l;
        var s = new DataInputStream(stream.input_stream);

        object.recno = s.read_int32();
        object.timestamp = s.read_int32();
        object.path = s.read_upto(delim, 1, out l);
        object.desc = s.read_upto(delim, 1, out l);
    }
}



