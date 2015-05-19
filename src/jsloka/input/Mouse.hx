package jsloka.input;
//TODO should use events : create Abstract Event to keep same signature

import js.html.CanvasElement;
import js.html.MouseEvent;

class Mouse{

	var _canvas : CanvasElement;

	public var x(default,null):Float;
	public var y(default,null):Float;
	public var down(default,null):Bool;
	
	private function new(canvas : CanvasElement){
		_canvas = canvas;
		_canvas.addEventListener('mousemove', mouseMoved, false);
		_canvas.addEventListener('mousedown', mouseDowned, false);
		_canvas.addEventListener('mouseup', mouseUped, false);
	}

	function mouseMoved(e : MouseEvent):Void {
        x = e.clientX == null ? e.clientX : e.pageX; 
		y = e.clientY == null ? e.clientX :  e.pageY;
    }

    function mouseDowned(e : MouseEvent):Void {
        down = true;
    }

    function mouseUped(e : MouseEvent):Void {
        down = false;
    }
}