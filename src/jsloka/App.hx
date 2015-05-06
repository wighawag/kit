package jsloka;

import js.Browser;
import js.html.CanvasElement;
import loka.gl.GL;
import haxe.Timer;

typedef RenderFunction = Float->Float->Void;

class App{

	static var _app : App;

	public var width(get, null) : Float;
	public var height(get, null) : Float;

	var _render : RenderFunction;
	
	var _canvas : CanvasElement;
	var _gl : GL;

	var _lastNow : Float;

	private function new(canvas : CanvasElement, gl : GL){
		_canvas = canvas;
		_gl = gl;
	}

	function get_width():Float{
		return _canvas.clientWidth;
	}

	function get_height():Float{
		return _canvas.clientHeight;
	}

	function resize(){ //reset the value properly
		var width = _canvas.clientWidth;
	    var height = _canvas.clientHeight;
	    if (_canvas.width != width || _canvas.height != height) {
	        _canvas.width = width;
	        _canvas.height = height;
	    }
	}

	public function getGL(){
		return _gl;
	}

	public function setRenderFunction(render : RenderFunction){
		if(_render == null){
			_lastNow = Timer.stamp();
			Browser.window.requestAnimationFrame(internalRender);
		}
		_render = render;
	}

	function internalRender(t : Float){
		resize(); //TODO events ?
		var now = Timer.stamp();
		var delta = now - _lastNow;
		_lastNow = now;
		_render(now, delta);
		Browser.window.requestAnimationFrame(internalRender);
	}

	public static function init() : App{
		if(_app != null){
			trace("ERROR : app already initialised");
			return null;
		}
		var canvas=cast(js.Browser.document.getElementById("canvas"));
	    if(canvas == null){
		    canvas = js.Browser.document.createCanvasElement();

		    //make sure it displays nicely
		    canvas.style.display = 'block';
		    canvas.style.position = 'relative';
		    canvas.style.margin = '0 auto 0 auto';
		    canvas.style.background = '#000';

		    //assign the sizes
		    canvas.style.width = "100%";
	    	canvas.style.height = "100%";

		    //add it to the document
		    js.Browser.document.body.appendChild(canvas);
	    }
	   
	    var webGlContext = canvas.getContextWebGL({});
	    if(webGlContext != null){
	    	_app = new App(canvas, new GL(webGlContext));
	    }

	    return _app;
	}	
}
