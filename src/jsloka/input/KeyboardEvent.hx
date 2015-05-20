package jsloka.input;

abstract KeyboardEvent(js.html.KeyboardEvent) to (js.html.KeyboardEvent){

	//TODO could use @:forward
	public var keyCode(get,never):Key;
	inline function get_keyCode():Key{
		return cast this.keyCode;
	}
}