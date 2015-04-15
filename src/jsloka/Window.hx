package jsloka;

import jsloka.gl.GL;
import js.html.CanvasElement;

class Window{

        public var gl : GL;
        var _canvas : CanvasElement;

        public var width(get, null) : Float;
        function get_width():Float{
           return _canvas.clientWidth;
        }
        public var height(get, null) : Float;
        function get_height():Float{
           return _canvas.clientHeight;
        }

        static public function createWindow(fullscreen:Bool=true,inputwidth="100%",inputheight="100%") : Window{
        	return new Window(fullscreen,inputwidth,inputheight);
        }

        public function resize(){
            var width = _canvas.clientWidth;
            var height = _canvas.clientHeight;
            if (_canvas.width != width ||
                _canvas.height != height) {
                _canvas.width = width;
                _canvas.height = height;
            }
        }

        public function new(fullscreen:Bool=true, inputwidth="100%",inputheight="100%"){
            if(fullscreen==false){
            _canvas=cast(js.Browser.document.getElementById("canvas"));}
            else{
        	_canvas = js.Browser.document.createCanvasElement();

            //assign the sizes
            _canvas.style.width = inputwidth;
            _canvas.style.height = inputheight;
            
            //make sure it displays nicely
             _canvas.style.display = 'block';
            _canvas.style.position = 'relative';
            _canvas.style.margin = '0 auto 0 auto';
            _canvas.style.background = '#000';

            //add it to the document
            js.Browser.document.body.appendChild(_canvas);
            }
        	gl = new GL(_canvas.getContextWebGL({}));
        }
}