package glaze.tmx;

import glaze.ds.Bytes2D;
import glaze.ds.TypedArray2D;
import glaze.tmx.TmxTileSet;
import haxe.xml.Fast;

class TmxLayer
{
	public var map:TmxMap;
	public var name:String;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var opacity:Float;
	public var visible:Bool;
	public var tileGIDs:Bytes2D;
	public var properties:TmxPropertySet;
	
	public function new(source:Fast, parent:TmxMap)
	{
		properties = new TmxPropertySet();
		map = parent;
		name = source.att.name;
		x = (source.has.x) ? Std.parseInt(source.att.x) : 0;
		y = (source.has.y) ? Std.parseInt(source.att.y) : 0;
		width = Std.parseInt(source.att.width); 
		height = Std.parseInt(source.att.height); 
		visible = (source.has.visible && source.att.visible == "1") ? true : false;
		opacity = (source.has.opacity) ? Std.parseFloat(source.att.opacity) : 0;
		
		//load properties
		var node:Fast;
		for (node in source.nodes.properties)
			properties.extend(node);
		
		//load tile GIDs
		//tileGIDs = [];
		var data:Fast = source.node.data;
		if(data != null)
		{
			var chunk:String = "";
			switch(data.att.encoding)
			{
				case "base64":
					chunk = StringTools.trim(data.innerData);
					var compressed:Bool = false;
					if (data.has.compression)
					{
						switch(data.att.compression)
						{
							case "zlib":
								compressed = true;
							default:
								throw "TmxLayer - data compression type not supported!";
						}
					}
					// js.Lib.debug();
					var _d = glaze.ds.Bytes2D.uncompressData(chunk,compressed);
					tileGIDs = new glaze.ds.Bytes2D(width,height,parent.realTileSize,4,_d);
					// tileGIDs.get(4,5,0);
					//tileGIDs = new Array2D(width,height,Base64.Decode(chunk));//base64ToArray(chunk, width, compressed);
				case "csv":
					// chunk = data.innerData;
					// tileGIDs = csvToArray(chunk);
				default:
					// //create a 2dimensional array
					// var lineWidth:Int = width;
					// var rowIdx:Int = -1;
					// for (node in data.nodes.tile)
					// {
					// 	//new line?
					// 	if(++lineWidth >= width)
					// 	{
					// 		tileGIDs[++rowIdx] = new Array<Int>();
					// 		lineWidth = 0;
					// 	}
					// 	var gid:Int = Std.parseInt(node.att.gid);
					// 	tileGIDs[rowIdx].push(gid);
					// }
			}
		}
	}
	
	// public function toCsv(tileSet:TmxTileSet = null):String
	// {
	// 	var max:Int = 0xFFFFFF;
	// 	var offset:Int = 0;
	// 	if(tileSet != null)
	// 	{
	// 		offset = tileSet.firstGID;
	// 		max = tileSet.numTiles - 1;
	// 	}
	// 	var result:String = "";
	// 	var row:Array<Int>;
	// 	for (row in tileGIDs)
	// 	{
	// 		var id:Int = 0;
	// 		for (id in row)
	// 		{
	// 			id -= offset;
	// 			if(id < 0 || id > max)
	// 				id = 0;
	// 			result +=  id + ",";
	// 		}
	// 		result += id + "\n";
	// 	}
	// 	return result;
	// }
	
	/* ONE DIMENSION ARRAY
	public static function arrayToCSV(input:Array, lineWidth:Int):String
	{
		var result:String = "";
		var lineBreaker:Int = lineWidth;
		for each(var entry:uint in input)
		{
			result += entry+",";
			if(--lineBreaker == 0)
			{
				result += "\n";
				lineBreaker = lineWidth;
			}
		}
		return result;
	}
	*/
	
	private static function csvToArray(input:String):Array<Array<Int>>
	{
		var result:Array<Array<Int>> = new Array<Array<Int>>();
		var rows:Array<String> = input.split("\n");
		var row:String;
		for (row in rows)
		{
			if (row == "") continue;
			var resultRow:Array<Int> = new Array<Int>();
			var entries:Array<String> = row.split(",");
			var entry:String;
			for (entry in entries)
				resultRow.push(Std.parseInt(entry)); //convert to int
			result.push(resultRow);
		}
		return result;
	}

	// public function addTileType(index:Int,x:Int,y:Int) {
 //        var v:Float = 0xFF << 24 | 0 << 16 | y << 8 | x;
 //        tiles.set(index,v);
 //    }

 //    public function toTexture():Array2D {
 //        var textureData = new ds.Array2D(mapData.w,mapData.h);
 //        for (xp in 0...mapData.w) {
 //             for (yp in 0...mapData.h) {
 //                var source = mapData.get(xp,yp);
 //                if (source>0) {
 //                    textureData.set(xp,yp,tiles.get(source));
 //                } else {
 //                    textureData.set(xp,yp,0xFFFFFFFF);
 //                }
 //             }
 //        }
 //        return textureData;
 //    }
	
	
	public static function LayerToCoordTexture(layer:TmxLayer):TypedArray2D {
		//Assumes all tiles are from same set...function
		var tileSet:TmxTileSet = null;
		var textureData = new TypedArray2D(layer.width,layer.height);

        for (xp in 0...layer.width) {
             for (yp in 0...layer.height) {
                // var source = layer.tileGIDs.get(xp,yp,0); //need 2 bytes here!!!!
                var source = layer.tileGIDs.get(xp,yp,3) <<24 | layer.tileGIDs.get(xp,yp,2) <<16 | layer.tileGIDs.get(xp,yp,1) <<8 | layer.tileGIDs.get(xp,yp,0);
                if (source>0) {
                	// js.Lib.debug();
                    // if (tileSet==null) {
                    //    tileSet = layer.map.getGidOwner(source);
                    // }

                    var superSet = Math.floor(source/1024);
                    var superY = Math.floor(superSet/8);
                    var superX = superSet % 8;

                    var relativeID = source-(superSet*1024);
					relativeID--; //Not sure why ATM
                    var y = Math.floor(relativeID/32);
                    var x = relativeID-(32*y);
                    var v:Float = superY << 24 | superX << 16 | y << 8 | x;
                    textureData.set(xp,yp,v);

                    //Switched to hardcoded single tileset
                    //This is not needed now...

                    // var relativeID = source-tileSet.firstGID;
                    // var y = Math.floor(relativeID/tileSet.numCols);
                    // var x = relativeID-(tileSet.numCols*y);
                    // var v:Float = superY << 24 | superX << 16 | y << 8 | x;
                    // textureData.set(xp,yp,v);
                } else {
                    textureData.set(xp,yp,0xFFFFFFFF);
                }
             }
        }		
        return textureData;
	}	

	public static function LayerToCollisionData(layer:TmxLayer,tileSize:Int):Bytes2D {
		//Assumes all tiles are from same set...function
		var tileSet:TmxTileSet = null;
		var collisionData = new Bytes2D(layer.width,layer.height,tileSize,1);


        for (xp in 0...layer.width) {
             for (yp in 0...layer.height) { 
                var source = layer.tileGIDs.get(xp,yp,0);

                if (source>0) {
                    if (tileSet==null) {
                        tileSet = layer.map.getGidOwner(source);
                    }

                    var tileData = 0x00;
                    var relativeID = source-tileSet.firstGID;

                    // if (relativeID==0) {
                    // 	tileData = 0x1;
                    // } else if (relativeID==1) {
                    // 	tileData = 0x3;
                    // }	

                    // var tileData = 0x00;
                    // tileData = tileData | 0x1;
                    collisionData.set(xp,yp,0,1<<relativeID); //Implicit +1
                    //Original
                    // var props = tileSet.getPropertiesByGid(source);
                    // var tileData = 0x00;
                    // if (props!=null) {
                    // 	var collision = props.resolve("collision");
                    // 	if (collision!=null&&collision=="1") tileData = tileData | 0x1;
                    // }

                    // var y = Math.floor(relativeID/tileSet.numCols);
                    // var x = relativeID-(tileSet.numCols*y);
                    // var v:Int = 0x0 << 24 | tileData << 16 | y << 8 | x;
                    // collisionData.set(xp,yp,0,255);
                    // collisionData.set(xp,yp,1,tileData);
                    // collisionData.set(xp,yp,2,y);
                    // collisionData.set(xp,yp,3,x);
                    //End Original
                    // }

                } else {
                    collisionData.set(xp,yp,0,0);
                }
             }
        }		
        // js.Lib.debug();
        return collisionData;
	}
	
/*
	public static function layerToCollisionMap(layer:TmxLayer):Array2D {
		//Assumes all tiles are from same set...function
		var tileSet:TmxTileSet = null;
		var collisionMap = new Array2D(layer.width,layer.height);

        for (xp in 0...layer.width) {
             for (yp in 0...layer.height) {
                var source = layer.tileGIDs.get(xp,yp);
                if (source>0) {
                    if (tileSet==null) {
                        tileSet = layer.map.getGidOwner(source);
                    }
                    // js.Lib.debug();
                    var relativeID = source-tileSet.firstGID;
                    var props = tileSet.getPropertiesByGid(source);
                    // trace(xp,yp);
                    if (props!=null) {
                    	var collision = props.resolve("collision");
                    	if (collision!=null) {
                    			collisionMap.set(xp,yp,collision);
                    		} else {
                    			collisionMap.set(xp,yp,0);
                    		}
                    } else {
                    	collisionMap.set(xp,yp,0);
                    }   
                } else {
                    collisionMap.set(xp,yp,0);
                }
             }
        }		
        return collisionMap;
	}
*/
	// private static function base64ToArray(chunk:String, lineWidth:Int, compressed:Bool):Array2D //Array<Array<Int>>
	// {
	// 	return 
		// var result:Array<Array<Int>> = new Array<Array<Int>>();
		// var data:ByteArray = base64ToByteArray(chunk);
		// if(compressed)
		// {
		// 	#if (js && !format)
		// 	throw "Need the format library to use compressed map on html5";
		// 	#else 
		// 	data.uncompress();
		// 	#end
		// }
			
		// data.endian = Endian.LITTLE_ENDIAN;
		// while(data.position < data.length)
		// {
		// 	var resultRow:Array<Int> = new Array<Int>();
		// 	var i:Int;
		// 	for (i in 0...lineWidth)
		// 		resultRow.push(data.readInt());
		// 	result.push(resultRow);
		// }
		// return result;
	// }
	
	private static inline var BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
	// private static function base64ToByteArray(data:String):ByteArray 
	// {
	// 	var output:ByteArray = new ByteArray();
	// 	//initialize lookup table
	// 	var lookup:Array<Int> = new Array<Int>();
	// 	var c:Int;
	// 	for (c in 0...BASE64_CHARS.length)
	// 	{
	// 		lookup[BASE64_CHARS.charCodeAt(c)] = c;
	// 	}
		
	// 	var i:Int = 0;
	// 	while (i < data.length - 3) 
	// 	{
	// 		// Ignore whitespace
	// 		if (data.charAt(i) == " " || data.charAt(i) == "\n")
	// 		{
	// 			i++; continue;
	// 		}
			
	// 		//read 4 bytes and look them up in the table
	// 		var a0:Int = lookup[data.charCodeAt(i)];
	// 		var a1:Int = lookup[data.charCodeAt(i + 1)];
	// 		var a2:Int = lookup[data.charCodeAt(i + 2)];
	// 		var a3:Int = lookup[data.charCodeAt(i + 3)];
			
	// 		// convert to and write 3 bytes
	// 		if(a1 < 64)
	// 			output.writeByte((a0 << 2) + ((a1 & 0x30) >> 4));
	// 		if(a2 < 64)
	// 			output.writeByte(((a1 & 0x0f) << 4) + ((a2 & 0x3c) >> 2));
	// 		if(a3 < 64)
	// 			output.writeByte(((a2 & 0x03) << 6) + a3);
			
	// 		i += 4;
	// 	}
		
	// 	// Rewind & return decoded data
	// 	output.position = 0;
	// 	return output;
	// }
}
