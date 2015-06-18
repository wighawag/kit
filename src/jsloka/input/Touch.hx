package jsloka.input;

import js.html.CanvasElement;

//TODO abstract
class Touch{

	var _canvas : CanvasElement;

	private function new(canvas : CanvasElement){
		_canvas = canvas;
	}
}