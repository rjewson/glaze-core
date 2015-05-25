package glaze.util;

/**
 * ...
 * @author rje
 */

class Random 
{

    private static var PseudoRandomSeed:Int = 3489752;

    inline public static function SetPseudoRandomSeed(seed:Int):Void {
        PseudoRandomSeed = seed;
    }

    inline public static function RandomFloat(min : Float,max : Float) : Float {
        return  Math.random() * (max - min) + min;
    }

    inline public static function RandomBoolean(chance : Float = 0.5) : Bool {
        return ( Math.random() < chance);
    }

    inline public static function RandomSign(chance : Float = 0.5) : Int {
        return ( Math.random() < chance) ? 1 : -1;
    }

    inline public static function RandomInteger(min : Int,max : Int) : Int {
        return Math.floor(RandomFloat(min, max));
    }
    
    inline public static function PseudoInteger(n : Int = Limits.INT32_MAX) : Int {
        return n > 0 ? Std.int(PseudoFloat() * n) : Std.int(PseudoFloat());
    }

    inline public static function PseudoFloat() : Float {
        PseudoRandomSeed = (PseudoRandomSeed * 9301 + 49297) % 233280;
        return PseudoRandomSeed / 233280.0;
    }   
    
}