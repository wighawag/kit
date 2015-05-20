package jsloka.input;


import js.html.CanvasElement;

abstract Keyboard(CanvasElement){
	
	inline private function new(canvas : CanvasElement){
		this = canvas;
	}

	inline public function onKeyDown(f : KeyboardEvent -> Void, ?useCapture : Bool):Void {
       this.addEventListener("keydown",f, useCapture);
    }

   inline public function onKeyUp(f : KeyboardEvent -> Void, ?useCapture : Bool):Void {
       this.addEventListener("keyup",f, useCapture);
    }

}
