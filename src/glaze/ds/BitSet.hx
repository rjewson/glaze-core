package glaze.ds;

import haxe.ds.Vector;

class BitSet {
	
	// @:allow(BitSet)
	var _bits:Vector<Int>;
	// @:allow(BitSet)
	var _arrSize:Int;
	var _bitSize:Int;
    
    public function new(size:Int) {
		_bits = null;
		_bitSize = 0;
		_arrSize = 0;
		
		resize(size);		
	}

	public function free() {
		_bits = null;
	}
	
	inline public function capacity():Int {
		return _bitSize;
	}

	inline public function size():Int {
		var c = 0;
		for (i in 0..._arrSize)
			c += ones(_bits[i]);
		return c;
	}

	inline public function bucketSize():Int {
		return _arrSize;
	}

	inline public function has(i:Int):Bool {
		return ((_bits[i >> 5] & (1 << (i & (32 - 1)))) >> (i & (32 - 1))) != 0;
	}

	inline public function set(i:Int) {
		var p = i >> 5;
		_bits[p] = _bits[p] | (1 << (i & (32 - 1)));
	}

	inline public function clr(i:Int) {
		var p = i >> 5;
		_bits[p] = _bits[p] & (~(1 << (i & (32 - 1))));
	}

	inline public function clrAll() {
		for (i in 0..._arrSize) _bits[i] = 0;
	}

	inline public function setAll() {
		for (i in 0..._arrSize) _bits[i] = -1;
	}

	// public function containsAll(compBitSet:BitSet) {
	// 	for (i in 0...compBitSet.capacity()) {
	// 		if (compBitSet.has(i)&&!has(i))
	// 			return false;
	// 	}
	// 	return true;
	// }

	public function containsAll(comparisonSet:BitSet) {
		for (i in 0...comparisonSet._arrSize) {
			if ((_bits[i] & comparisonSet._bits[i]) != comparisonSet._bits[i]) 
				return false;
		}
		return true;
	}

	public function containsOne(comparisonSet:BitSet) {
		for (i in 0...comparisonSet._arrSize) {
			if ((_bits[i] & comparisonSet._bits[i]) != 0) 
				return true;
		}
		return false;
	}

	public function containsNone(comparisonSet:BitSet) {
		for (i in 0...comparisonSet._arrSize) {
			if ((_bits[i] & comparisonSet._bits[i]) != 0) 
				return false;
		}
		return true;
	}

	public function resize(x:Int) {
		if (_bitSize == x) return;
		
		var newSize = x >> 5;
		if ((x & (32 - 1)) > 0) newSize++;
		
		if (_bits == null) {
			_bits = new Vector(newSize);
			
			for (i in 0...newSize) _bits[i] = 0;
		} else if (newSize < _arrSize) {
			_bits = new Vector(newSize);
			
			for (i in 0...newSize) _bits[i] = 0;
		} else if (newSize > _arrSize) {
			var t = new Vector<Int>(newSize);
			Vector.blit(_bits, 0, t, 0, _arrSize);
			for (i in _arrSize...newSize) t[i] = 0;
			_bits = t;
		} else if (x < _bitSize) {
			for (i in 0...newSize) _bits[i] = 0;
		}
		
		_bitSize = x;
		_arrSize = newSize;
	}

	inline public static function ones(x:Int) {
		x -= ((x >> 1) & 0x55555555);
		x = (((x >> 2) & 0x33333333) + (x & 0x33333333));
		x = (((x >> 4) + x) & 0x0f0f0f0f);
		x += (x >> 8);
		x += (x >> 16);
		return(x & 0x0000003f);
	}

	public function toString():String {
		var s = "";
		for (i in 0..._bitSize) {
			s += has(_bitSize-i-1) ? "1" : "0";
		}
		return s;
	}


}