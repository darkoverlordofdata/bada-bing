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
    DataOutputStream output;
    DataInputStream input;

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
        output = new DataOutputStream(this.stream.output_stream);
        input = new DataInputStream(this.stream.input_stream);

    }

    /**
     * Serialize the data to disk
     */
    public void serialize()
    {

        output.put_int32(object.recno);
        output.put_string(object.timestamp);
        output.put_byte(0);
        output.put_string(object.path);
        output.put_byte(0);
        output.put_string(object.desc);
        output.put_byte(0);
    }

    /**
     * Deserialize the data from disk
     */
    public void deserialize()
    {
        size_t l;

        object.recno = input.read_int32();
        object.timestamp = input.read_upto(delim, 1, out l);
        input.read_byte();
        object.path = input.read_upto(delim, 1, out l);
        input.read_byte();
        object.desc = input.read_upto(delim, 1, out l);
        input.read_byte();
    }
}



