package glaze.ds;

class FastMap<T> {
    
    public var itemMap:Dynamic<T> = {};
    public var itemList:Array<T>  = [];

    public function new() {
        
    }

    macro public function getComponent<A:IMapItem>(self:Expr,clazz:ExprOf<Class<A>>):ExprOf<A> {
        var name = macro $clazz.NAME;
        return macro Std.instance($self.get($name), $clazz);
    }

    macro public function getComponentStr(self:Expr,key:String):ExprOf<IMapItem> {
        return macro untyped $self.itemMap.$key;
    }

    public inline function get(key:String):IMapItem {
        return untyped itemMap[key];
    }

    public inline function add(key:String, value:IMapItem):Void {
        Reflect.setField(itemMap, key, value);
        itemList.push(value);
    }

    public inline function exists(key:String):Bool {
        return Reflect.hasField(itemMap, key);
    }

    public inline function remove(key:String,value:IMapItem):Bool {
        itemList.remove(value);
        return Reflect.deleteField(itemMap, key);
    }


}