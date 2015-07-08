package glaze.tmx;

import haxe.xml.Fast;

class TmxPropertySet implements Dynamic<String>
{

	public function new()
	{
		keys = new Map<String,String>();
	}

	public function resolve(name:String):String
	{
		return keys.get(name);
	}

	public function extend(source:Fast)
	{
		var prop:Fast;
		for (prop in source.nodes.property)
		{
			keys.set(prop.att.name, prop.att.value);
		}
	}

	public var keys:Map<String,String>;
	
}
