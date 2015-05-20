package jsloka.input;


abstract MouseEvent(js.html.MouseEvent) to (js.html.MouseEvent){

	public var mouseX(get,never):Float;
	inline function get_mouseX():Float{
		return this.clientX;
	}

	public var mouseY(get,never):Float;
	inline function get_mouseY():Float{
		return this.clientY;
	}

}