package jsloka;

import js.Browser;
import js.html.CanvasElement;
import js.html.Event;
import loka.gl.GL;
import haxe.Timer;

import loka.Window.RenderFunction;

class Window{

	public var width(default, null) : Float;
	public var height(default, null) : Float;

	var _render : RenderFunction;
	
	var _canvas : CanvasElement;
	var _gl : GL;
	var _resizeCallback : Float->Float->Void;

	function new(canvas : CanvasElement, gl : GL){ //TODO : make Window constructor private and access via friend (App.initWindow)
		_canvas = canvas;
		_gl = gl;
		_canvas.addEventListener("resize",onResized);
		onResized(null);
	}

	public function setOnResizeCallback(callback : Float->Float->Void){
		_resizeCallback = callback;
	}

	function onResized(event : Event){
		width = _canvas.clientWidth;
		height = _canvas.clientHeight;
		resizeCanvas();
		if(_resizeCallback != null){
			_resizeCallback(width,height);
		}
	}

	function resizeCanvas(){ 
		//TODO hdpi
	    if (_canvas.width != width || _canvas.height != height) {
	        _canvas.width = Std.int(width);
	        _canvas.height = Std.int(height);
	    }
	}

	public function getGL(){
		return _gl;
	}

	public function setRenderFunction(render : RenderFunction){
		if(_render == null){
			Browser.window.requestAnimationFrame(internalRender);
		}
		_render = render;
	}

	function internalRender(t : Float){//TODO : could use "t" as now if the corss platform implementation time util return the same value
		var now = Timer.stamp(); //TODO use a cross platform performant implementation (see js : Performance.now())
		_render(now);
		Browser.window.requestAnimationFrame(internalRender);
	}

}
