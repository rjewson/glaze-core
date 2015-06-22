package glaze.ds;

/**
 * ...
 * @author rje
 */

class Array2D<T>
{

    public var data:Array<T>;
    
    public var gridWidth:Int;
    public var gridHeight:Int;  
    
    public var cellSize:Int;
    public var invCellSize:Float;
    
    
    public function new(gridWidth:Int, gridHeight:Int, cellSize:Int) 
    {
        initalize(gridWidth, gridHeight, cellSize);
    }
    
    public function initalize(gridWidth:Int, gridHeight:Int, cellSize:Int):Void {
        this.gridWidth = gridWidth;
        this.gridHeight = gridHeight;
        
        this.cellSize = cellSize;
        this.invCellSize = 1 / cellSize;
        
        data = new Array<T>();      
    }
    
    inline public function get(x:Int, y:Int):T {
        return data[y * gridWidth + x];
    }

    // inline public function 
     
    inline public function getSafe(x:Int, y:Int):T {
        return ((x >= gridWidth) || (y >= gridHeight) || (x < 0) || (y < 0)) ? null : data[y * gridWidth + x];
    }   
    
    inline public function set(x:Int, y:Int, value:T):Void {
        data[y * gridWidth + x] = value;
    }
    
    inline public function Index(value:Float):Int {
        //FIXME Not sure this always works...
        //return Std.int(value / cellSize);
        //return Math.floor(value * invCellSize);
        return Std.int(value * invCellSize);
    }   
    
    inline public function Width():Int {
        return gridWidth * cellSize;
    }   
    
    inline public function Height():Int {
        return gridHeight * cellSize;
    }
    
}