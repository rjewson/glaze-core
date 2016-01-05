package glaze.ds;

class Queue<T> {

	public var data:Array<T>;
	public var length:Int;

	public function new(length:Int) {
		this.length = length;
		data = new Array<T>();
	}

	public function enqueue(item:T):Bool {
		if (isFull())
			return false;
		data.push(item);
		return true;
	}

	public function dequeue():T {
		return data.shift();
	}

	public function isFull() {
		return data.length==length;
	}

}