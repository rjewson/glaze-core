package glaze.tmx;
import glaze.geom.Vector2;
import haxe.xml.Fast;

class TmxObject
{
	public var group:TmxObjectGroup;
	public var name:String;
	public var type:String;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var gid:Int;
	public var custom:TmxPropertySet;
	public var shared:TmxPropertySet;

	public var combined:Map<String,String>;

	public var polyline:Array<Vector2>;
	
	public function new(source:Fast, parent:TmxObjectGroup)
	{
		group = parent;
		name = (source.has.name) ? source.att.name : "[object]";
		type = (source.has.type) ? source.att.type : "";
		x = Std.parseInt(source.att.x);
		y = Std.parseInt(source.att.y);
		width = (source.has.width) ? Std.parseInt(source.att.width) : 0;
		height = (source.has.height) ? Std.parseInt(source.att.height) : 0;
		//resolve inheritence
		shared = null;
		gid = -1;
		if(source.has.gid && source.att.gid.length != 0) //object with tile association?
		{
			gid = Std.parseInt(source.att.gid);
			var set:TmxTileSet;
			for (set in group.map.tilesets)
			{
				shared = set.getPropertiesByGid(gid);
				if(shared != null)
					break;
			}
		}
		
		//load properties
		var node:Xml;
		custom = new TmxPropertySet();
		for (node in source.nodes.properties)
			custom.extend(node);

		combined = new Map<String,String>();
		if (shared!=null) extend(combined,shared.keys);
		extend(combined,custom.keys);

		for (node in source.nodes.polyline)
		{
			polyline = new Array<Vector2>();
			var points : Array<String> = node.att.points.split(" ");
			var p : String;
			for (p in points)
			{
				var coords : Array<String> = p.split(",");
				var px : Float = Std.parseFloat(coords[0]);
				var py : Float = Std.parseFloat(coords[1]);
				polyline.push(new Vector2(x+px, y+py));
			}
		}

	}

	function extend(dest:Map<String,String>,source:Map<String,String>) {
		for (key in source.keys()) {
			dest.set(key,source.get(key));
		}
	}

}