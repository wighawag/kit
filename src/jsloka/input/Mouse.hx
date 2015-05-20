package jsloka.input;

import js.html.CanvasElement;
import jsloka.input.MouseEvent;

abstract Mouse(CanvasElement){

	inline private function new(canvas : CanvasElement){
		this = canvas;
	}

	inline public function onMouseMove(f : MouseEvent -> Void, ?useCapture : Bool):Void {
       this.addEventListener("mousemove",f, useCapture);
    }

   inline public function onMouseDown(f : MouseEvent -> Void, ?useCapture : Bool):Void {
       this.addEventListener("mousedown",f, useCapture);
    }

  inline public function onMouseUp(f : MouseEvent -> Void, ?useCapture : Bool):Void {
       this.addEventListener("mouseup",f, useCapture);
    }
}