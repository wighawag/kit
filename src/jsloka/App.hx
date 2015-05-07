package jsloka;

import js.Browser;
import js.html.CanvasElement;
import loka.gl.GL;
import haxe.Timer;


class App{

	static var _window : Window;

	@:access(jsloka.Window.new)
	public static function initWindow() : Window{
		if(_window != null){
			trace("ERROR : window already initialised");
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
	    	_window = new Window(canvas, new GL(webGlContext)); 
	    }

	    return _window;
	}	
}
