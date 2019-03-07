using Xml;
using Soup;

//https://stackoverflow.com/questions/10639914/is-there-a-way-to-get-bings-photo-of-the-day

errordomain Exception {
	UnableToCreateContext,00
	UnableToEvalXPath,
	InvalidXPathObjectType,
	ValueNotSet,
	NoContent
}

const string imagePath = "HPImageArchive.aspx?format=xml&idx=0&n=1"; 
const string bingUrl = "https://www.bing.com";

int error(string msg) {
	print("%s\n", msg);
	return 1;
}
public static int main(string[] args) {
	try {

		// get the locale
		uint8[] buff = new uint8[2048];
		FileUtils.get_data(Environment.get_home_dir() + "/.config/user-dirs.locale", out buff);
		string locale = ((string)buff).replace("_", "-");
		
		// get the wallpaper location
		Settings settings = new Settings("org.gnome.desktop.background");
		string pictureUri = settings.get_string("picture-uri");

		// get metadata
		var session = new Soup.Session();
		var message = new Soup.Message("GET", @"$bingUrl/$(imagePath)&mkt=$(locale)");
		session.send_message(message);
		var doc = Xml.Parser.parse_doc((string)message.response_body.data);

		var ctx = new XPath.Context(doc);
		if (ctx == null) 
			throw new Exception.UnableToCreateContext("Failed to create the xpath context");

		var obj = ctx.eval("//images/image/url");
		if (obj == null) 
			throw new Exception.UnableToEvalXPath("Failed to evaluate xpath");

		if (obj->type != XPath.ObjectType.NODESET) 
			throw new Exception.InvalidXPathObjectType("Expected NodeSet");

		if (obj->nodesetval == null) 
			throw new Exception.ValueNotSet("NodeSet is null");

		if (obj->nodesetval->length() == 0) 
			throw new Exception.NoContent("NodeSet has no content");


		var node = obj->nodesetval->item(0);
		var srcUrl = @"$bingUrl$(node->get_content())";
		var dstUri = File.new_for_uri(pictureUri);
		var srcFile = File.new_for_path(node->get_content());

		print(@"srcUrl = $srcUrl\n");
		var download = new Soup.Message("GET", srcUrl);
		session.send_message(download);


		/**
		 * 640x480
		 * 1024x768
		 * 800x600
		 * 1152x864
		 * 1280x720
		 * 1280x800
		 * 1280x1024
		 * 1400x1050
		 * 1440x900
		 * 1600x900
		 * 1600x1200
		 * 1680x1050
		 * 1920x1080
		 * 1920x1200
		 * 1920x1280
		 * 1920x1440
		 * 
		 * 
		 */
		// 	_1366x768.jpg 
		//	_1920x1200.jpg
		//	_1920x1080.jpg

		// urlBase + "_1920x1200.jpg"
		
		string jpg = dstUri.get_parent().get_path() + "/" + srcFile.get_basename();
		print("%s\n", jpg);
		//  FileUtils.set_data(jpg, download.response_body.data);
		//  settings.set_string("picture-uri", jpg);

		delete obj;
		delete doc;

	} catch (GLib.Error e) {
		print("Error: %s\n", e.message);
	}
	return 0;
}
