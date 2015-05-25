package glaze.util;

/**
 * ...
 * @author rje
 */

class Maths 
{

    inline public static var ZERO_TOLERANCE = 1e-08;

    inline public static var RAD_DEG = 180 / PI;

    inline public static var DEG_RAD = PI / 180;

    inline public static var LN2 = 0.6931471805599453;

    inline public static var LN10 = 2.302585092994046;

    inline public static var PIHALF = 1.5707963267948966;

    inline public static var PI = 3.141592653589793;

    inline public static var PI2 = 6.283185307179586;

    inline public static var EPS = 1e-6;

    inline public static var SQRT2 = 1.414213562373095;

    
    inline public static function toRad(deg:Float):Float {
        return deg * DEG_RAD;
    }

    inline public static function toDeg(rad:Float):Float {
        return rad * RAD_DEG;
    }
    
    inline public static function Clamp(value:Float,min:Float,max:Float):Float {
        return Math.min(Math.max(value,min),max);
    } 
    
    public static function ScaleRectangleWithRatio(containerRect:Vector2D, itemRect:Vector2D):Float {
        
        //var sX = itemRect.x / containerRect.x;
        //var sY = itemRect.y / containerRect.y;
        
        var sX = containerRect.x / itemRect.x;
        var sY = containerRect.y / itemRect.y;
        
        var rD = containerRect.x / containerRect.y;
        var rR = itemRect.x / itemRect.y;
        
        return rD < rR ? sX : sY;
        
    }
    
}