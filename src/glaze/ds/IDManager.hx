package ds;

/**
 * ...
 * @author rje
 */

class IDManager 
{

	static var NEXT_PERSISTENT_ID:Int = 0;
	
	static var TRANSIENT_START_ID:Int = 10000;
	
	static var TRANSIENT_CACHE_LENGTH:Int = 10000;
	
	static var TRANSIENT_CACHE:Array<Int> = {
		var cache = new Array<Int>();
		for (i in 0...TRANSIENT_CACHE_LENGTH) {
			cache.push(TRANSIENT_START_ID + i);
		}
		cache;
    } 
	
	static var TRANSIENT_POINTER:Int = 0;
	
	public static function GetPersistentID():Int {
		return NEXT_PERSISTENT_ID++;
	}
	
	public static function GetTransientID():Int {
		var id:Int = TRANSIENT_CACHE[TRANSIENT_POINTER];
		//trace(id);
		TRANSIENT_CACHE[TRANSIENT_POINTER] = 0;
		TRANSIENT_POINTER++;
		//trace("Allocated:" + id + " at position " + TRANSIENT_POINTER);
		return id;
	}
	
	public static function ReleaseTransientID(id:Int):Void {
		TRANSIENT_POINTER--;
		TRANSIENT_CACHE[TRANSIENT_POINTER] = id;
		//trace("Returned:" + id + " at position " +TRANSIENT_POINTER);
	}
	
}