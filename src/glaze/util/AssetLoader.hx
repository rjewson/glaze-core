
package glaze.util;

import glaze.signals.Signal0;
import haxe.ds.StringMap;
import js.html.Image;
import js.html.XMLHttpRequest;

class AssetLoader
{

    public var assets:StringMap<Dynamic>;
    public var loaders:Array<ILoader>;
    public var completeCount:Int;
    public var running:Bool;

    public var loaded:Signal0;

    public function new() {
        assets = new StringMap<Dynamic>();
        loaded = new Signal0();
        Reset();
    }

    public function Reset() {
        running = false;
        loaders = new Array<ILoader>();       
    }

    public function SetImagesToLoad(urls:Array<String>) {
        for (url in urls) {
            AddAsset(url);
        }
    }

    public function AddAsset(url:String):Void {
        if (running==true)
            return;
        var loader = LoaderFactory(url);
        loader.Init(url);
        loaders.push(loader);
    }

    private function LoaderFactory(url:String):ILoader {
        var extention = url.substring(url.length-3,url.length);
        if (extention=="png")
            return new ImageAsset(this);
        if (extention=="tmx" || extention=="xml" || extention=="son")
            return new BlobAsset(this);
        return null;
    }

    public function Load() {
        if (running==true || loaders.length==0)
            return;
        completeCount = loaders.length;
        running = true;
        for (loader in loaders)
            loader.Load();
    }

    public function onLoad(item:ILoader):Void {
        completeCount--;
        assets.set(item.getKey(),item.getValue());
        if (completeCount==0) {
            loaded.dispatch();
            // super.dispatchEvent({type:"loaded",count:completeCount});
            running = false;
        }
    }

}

interface ILoader
{
    function Init(url:String):Void;
    function Load():Void;
    function getKey():String;
    function getValue():Dynamic;
}

class ImageAsset implements ILoader
{
    public var mgr:AssetLoader;
    public var image:Image;
    public var url:String;

    public function new(mgr:AssetLoader) {
        this.mgr = mgr;
    }

    public function Init(url:String) {
        this.url = url;
        image = new Image();
        image.onload = onLoad;
        image.crossOrigin = "anonymous";
    }

    public function Load():Void {
        image.src = url + "?cb=" + Date.now().getTime();
        if (image.complete==true) {
            onLoad(null);
        } 
    }

    public function onLoad(event:Dynamic):Void {
        if (mgr!=null) {
            mgr.onLoad(this);
        }
    }

    public function getKey():String {
        return url;
    }

    public function getValue():Dynamic {
        return image;
    }

}

class BlobAsset implements ILoader
{
    public var mgr:AssetLoader;
    public var xhr:XMLHttpRequest;
    public var url:String;

    public function new(mgr:AssetLoader) {
        this.mgr = mgr;
    }

    public function Init(url:String) {
        this.url = url;
        xhr = new XMLHttpRequest();
        xhr.responseType = js.html.XMLHttpRequestResponseType.TEXT;//"text";
        xhr.onload = onLoad;
        xhr.open("GET",this.url + "?cb=" + Date.now().getTime(),true);
    }

    public function Load():Void {
        xhr.send();
    }

    public function onLoad(event:Dynamic):Void {
        if (mgr!=null) {
            mgr.onLoad(this);
        }
    }

    public function getKey():String {
        return url;
    }

    public function getValue():Dynamic {
        return xhr.response;
    }

}
