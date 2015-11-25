import haxe.ds.StringMap;

class FiniteStateMachine {

	public var states:StringMap<Void->Void> = new StringMap<Void->Void>();

	public var currentState:Void->Void;

	public function new() {
	}

	public function registerState(stateName:String,state:Void->Void) {
		states.set(stateName,state);
	}

	public function transitionState(stateName:String) {
		if (states.exists(stateName))
			states.get(stateName)();
	}

}