
package glaze.geom;

typedef V2 = Vector2;

class Vector2 
{

    public var x:Float;
    public var y:Float;

    inline public static var ZERO_TOLERANCE = 1e-08;

    inline public function new(x:Float=.0,y:Float=.0) {
        this.x = x;
        this.y = y;
    }    

    inline public function setTo(x:Float,y:Float):Void {
        this.x = x;
        this.y = y;
    }

    inline public function copy(v:Vector2):Void {
        this.x = v.x; 
        this.y = v.y; 
    }

    inline public function clone():Vector2 {
        return new Vector2(x,y);
    }

    inline public function normalize():Float {
        var t = Math.sqrt(x * x + y * y) + ZERO_TOLERANCE;
        x /= t;
        y /= t;
        return t;
    }

    inline public function length():Float {
        return Math.sqrt(x * x + y * y);
    }

    inline public function lengthSqrd():Float {
        return x * x + y * y;
    }

    inline public function clampScalar(max:Float) {
        var l = length();
        if (l > max) {
            multEquals(max / l);
        }
    }

    inline public function clampVector(v:Vector2) {
        this.x = Math.min(Math.max(x,-v.x),v.x);
        this.y = Math.min(Math.max(y,-v.y),v.y);
    }

    inline public function plusEquals(v:Vector2):Void {
        this.x += v.x;
        this.y += v.y;
    }

    inline public function minusEquals(v:Vector2):Void {
        this.x -= v.x;
        this.y -= v.y;
    }

    inline public function multEquals(s:Float):Void {
        this.x*=s;
        this.y*=s;
    }

    inline public function plusMultEquals(v:Vector2,s:Float):Void {
        this.x += v.x*s;
        this.y += v.y*s;
    }

    inline public function minusMultEquals(v:Vector2,s:Float):Void {
        this.x -= v.x*s;
        this.y -= v.y*s;
    }

    inline public function dot(v:Vector2):Float {
        return x * v.x + y * v.y;
    }

    inline public function cross(v:Vector2):Float {
        return x * v.y - y * v.x;
    }

    public function leftHandNormal():Vector2 {
        return new Vector2(this.y, -this.x);
    }    

    inline public function leftHandNormalEquals() {
        var t = this.x;
        this.x = this.y;
        this.y = -t;
    }

    inline public function rightHandNormal():Vector2 {
        return new Vector2(-this.y, this.x);
    }

    inline public function rightHandNormalEquals() {
        var t = this.x;
        this.x = -this.y;
        this.y = t;
    }

    inline public function reflectEquals(normal:Vector2) {
        var d = dot(normal);
        this.x -= 2*d*normal.x;
        this.y -= 2*d*normal.y;
    }

    inline public function interpolate(v1:Vector2, v2:Vector2, t:Float) {
        copy(v1);
        multEquals(1-t);
        plusMultEquals(v2,t);
        // return v1.mult(1 - t).plus(v2.mult(t));
    }

    inline public function setAngle(angle:Float) {
        var len = length();
        this.x = Math.cos(angle)*len;
        this.y = Math.sin(angle)*len;
    }

    inline public function rotateEquals(angle : Float) {
        var a : Float = angle * (Math.PI / 180);
        var cos : Float = Math.cos(a);
        var sin : Float = Math.sin(a);
        this.x = (cos * x) - (sin * y);
        this.y = (cos * y) + (sin * x);
    }

    public function setUnitRotation(angle:Float) {
        var a : Float = angle * (Math.PI / 180);
        this.x = Math.cos(a);
        this.y = Math.sin(a);
    }

    public function heading():Float {
        return Math.atan2(this.y,this.x);
    }

    inline public function distSqrd(v:Vector2):Float {
        var dX = x - v.x;
        var dY = y - v.y;
        return dX*dX + dY*dY;
    }

}