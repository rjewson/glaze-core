package glaze.ds;

import js.html.ArrayBuffer;
import js.html.Uint32Array;
import js.html.Uint8Array;

class TypedArray2D {

    public var w:Int;
    public var h:Int;

    public var buffer:ArrayBuffer;
    public var data32:Uint32Array;
    public var data8:Uint8Array;

    public function new(width:Int,height:Int,buffer:ArrayBuffer=null) {
        w = width;
        h = height;

        if (buffer==null)
            this.buffer = new ArrayBuffer(w*h*4);
        else
            this.buffer = buffer;
        data32 = new Uint32Array(this.buffer);
        data8 = new Uint8Array(this.buffer);
    }

    inline public function get(x:Int, y:Int):Int {
        return data32[getIndex(x,y)];
    }

    inline public function set(x:Int, y:Int, v:Dynamic) {
        data32[getIndex(x,y)] = v;
    }

    inline public function getIndex(x:Int, y:Int):Int {
        return y * w + x;
    }

}