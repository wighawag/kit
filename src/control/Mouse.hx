package control;
//TODO support multi platform


import loka.input.MouseEvent;

class Mouse{

	var _mouse : loka.input.Mouse;

	public var x(default,null):Float;
	public var y(default,null):Float;
	public var down(default,null):Bool;
	
	private function new(mouse : loka.input.Mouse){
		_mouse = mouse;
		_mouse.onMouseMove(mouseMove);
		_mouse.onMouseDown(mouseDown);
		_mouse.onMouseUp(mouseUp);
	}

	function mouseMove(e : loka.input.MouseEvent):Void {
        x = e.mouseX; 
		y = e.mouseY;
    }

    function mouseDown(e : loka.input.MouseEvent):Void {
        down = true;
    }

    function mouseUp(e : loka.input.MouseEvent):Void {
        down = false;
    }
}