package glaze.util;

import glaze.util.IDestroyable;

/**
 * A generic container that facilitates pooling and recycling of objects.
 * WARNING: Pooled objects must have parameterless constructors: function new()
 */
#if !display
@:generic 
#end
class Pool<T:IDestroyable> implements IPool<T>
{
	public var length(get, never):Int;
	
	private var _pool:Array<T> = [];
	private var _class:Class<T>;
	
	/**
	 * Objects aren't actually removed from the array in order to improve performance.
	 * _count keeps track of the valid, accessible pool objects.
	 */
	private var _count:Int = 0;
	
	public function new(classObj:Class<T>) 
	{
		_class = classObj;
	}
	
	public function get():T
	{
		if (_count == 0)
		{
			return Type.createInstance(_class, []);
		}
		return _pool[--_count];
	}
	
	public function put(obj:T):Void
	{
		// we don't want to have the same object in the accessible pool twice (ok to have multiple in the inaccessible zone)
		if (obj != null)
		{
			var i:Int = _pool.indexOf(obj);
			// if the object's spot in the pool was overwritten, or if it's at or past _count (in the inaccessible zone)
			if (i == -1 || i >= _count)
			{
				obj.destroy();
				_pool[_count++] = obj;
			}
		}
	}
	
	public function putUnsafe(obj:T):Void
	{
		if (obj != null)
		{
			obj.destroy();
			_pool[_count++] = obj;
		}
	}
	
	public function preAllocate(numObjects:Int):Void
	{
		while (numObjects-- > 0)
		{
			_pool[_count++] = Type.createInstance(_class, []);
		}
	}
	
	public function clear():Array<T>
	{
		_count = 0;
		var oldPool = _pool;
		_pool = [];
		return oldPool;
	}
	
	private inline function get_length():Int
	{
		return _count;
	}
}

interface IPooled extends IDestroyable
{
	public function put():Void;
	private var _inPool:Bool;
}

interface IPool<T:IDestroyable> 
{
	public function preAllocate(numObjects:Int):Void;
	public function clear():Array<T>;
}