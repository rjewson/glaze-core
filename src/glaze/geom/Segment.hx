
package glaze.geom;

import glaze.geom.Vector2;

class Segment 
{

    public var start:Vector2 = new Vector2();
    public var end:Vector2 = new Vector2();
    public var delta:Vector2 = new Vector2();
    public var scale:Vector2 = new Vector2();
    public var sign:Vector2 = new Vector2();

    public function new() {
    }

    public function set(s:Vector2,e:Vector2) {
        start.copy(s);
        end.copy(e);
        delta.copy(end);
        delta.minusEquals(start);
        scale.setTo(1/delta.x,1/delta.y);
        sign.x = delta.x < 0 ? -1 : 1;
        sign.y = delta.y < 0 ? -1 : 1;
    }

}