package glaze.ds;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.ExprTools;
#end

abstract DynamicObject<T>(Dynamic<T>) from Dynamic<T> {

    public inline function new() {
        this = {};
    }

    @:arrayAccess
    public inline function set(key:String, value:T):Void {
        Reflect.setField(this, key, value);
    }

    @:arrayAccess
    public inline function get(key:String):Null<T> {
        #if js
        return untyped this[key];
        #else
        return Reflect.field(this, key);
        #end
    }

    macro public function fastGet(self :Expr, key:String):ExprOf<T> {
        return macro untyped $self.$key;
    }

    // macro public function fastGet(self :Expr, key:String):ExprOf<T> {
    //     return macro untyped $self.$key;
    // }

    public inline function exists(key:String):Bool {
        return Reflect.hasField(this, key);
    }

    public inline function remove(key:String):Bool {
        return Reflect.deleteField(this, key);
    }

    public inline function keys():Array<String> {
        return Reflect.fields(this);
    }
}