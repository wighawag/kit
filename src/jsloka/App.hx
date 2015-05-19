package jsloka;

import js.Browser;
import js.html.CanvasElement;
import loka.gl.GL;
import haxe.Timer;
import loka.input.Mouse;
import loka.input.Keyboard;


class App{

	static var _window : Window;
	static var _mouse : Mouse;
	static var _keyboard : Keyboard;
	static var _canvas : CanvasElement;

	static function initOrGetCanvas() : CanvasElement{
		if(_canvas != null){
			return _canvas;
		}
		_canvas=cast(js.Browser.document.getElementById("canvas"));
	    if(_canvas == null){
		    _canvas = js.Browser.document.createCanvasElement();

		    //make sure it displays nicely
		    _canvas.style.display = 'block';
		    _canvas.style.position = 'relative';
		    _canvas.style.margin = '0 auto 0 auto';
		    _canvas.style.background = '#000';

		    //assign the sizes
		    _canvas.style.width = "100%";
	    	_canvas.style.height = "100%";

		    //add it to the document
		    js.Browser.document.body.appendChild(_canvas);
	    }
	    return _canvas;
	}

	@:access(jsloka.Window.new)
	public static function initWindow() : Window{
		if(_window != null){
			trace("ERROR : window already initialised");
			return null;
		}
		
		var canvas = initOrGetCanvas();
	   
	    var webGlContext = canvas.getContextWebGL({});
	    if(webGlContext != null){
	    	_window = new Window(canvas, new GL(webGlContext)); 
	    }

	    return _window;
	}	

	@:access(jsloka.input.Mouse.new)
	public static function initMouse() : Mouse{
		if(_mouse != null){
			trace("ERROR : mouse already initialised");
			return null;
		}

		var canvas = initOrGetCanvas();
		_mouse = new Mouse(canvas);
		return _mouse;
	}	

	@:access(jsloka.input.Keyboard.new)
	public static function initKeyboard() : Keyboard{
		if(_keyboard != null){
			trace("ERROR : keyboard already initialised");
			return null;
		}

		var canvas = initOrGetCanvas();
		_keyboard = new Keyboard(canvas);
		return _keyboard;
	}	
}
