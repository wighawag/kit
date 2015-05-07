package glee;

import loka.App;
import loka.Window;
import loka.asset.Image;
import loka.gl.GL;
import glee.GPUBuffer;
import glee.GPUTexture;
import loka.Window;

typedef GPUOption = {
	?autoViewPort : Bool,
	?maxHDPI : Int  //TODO
	//?window : Window
}

class GPU{
	
	static var _gpu : GPU;

	public var gl(default,null) : GL; //TODO make it private

	var _window : Window;
	var _option : GPUOption;

	var _render : RenderFunction;
	var _windowResizeCallback : Float->Float->Void;

	public var windowWidth(default,null) : Float = 0;
	public var windowHeight(default,null) : Float = 0;


	static inline public function init(?option : GPUOption) : GPU{
		if(_gpu != null){
			trace("ERROR : GPU already initialised");
			return null;
		}
		var window = /*option != null && option.window != null ? option.window :*/ App.initWindow();
		if(window == null){
			trace("the window has already been initialised via App.initWindow, GPU cannot take control of the GL rendering");
			return null;
		}
		return new GPU(window, option);
	} 

	public function new(window : Window, option : GPUOption){
		this._window = window;
		

		this.gl = _window.getGL();
		var defaultOption : GPUOption = {
			autoViewPort:true,
			maxHDPI:1
		};
		if(option != null){
			option.autoViewPort = option.autoViewPort == null ? defaultOption.autoViewPort : option.autoViewPort;
			option.maxHDPI = option.maxHDPI == null ? defaultOption.maxHDPI : option.maxHDPI;
		}else{
			_option = defaultOption;
		} 
		_option =option;

		window.setOnResizeCallback(onWindowResized);
		onWindowResized(window.width, window.height);

	}

	public function setWindowResizeCallback(callback : Float->Float->Void){
		_windowResizeCallback = callback;
	}

	function onWindowResized(width : Float, height : Float){
		windowWidth = width;
		windowHeight = height;
		if(_option.autoViewPort){
			_setViewPort(0, 0, windowWidth, windowHeight);
		}
		if(_windowResizeCallback != null){
			_windowResizeCallback(width,height);
		}
	}

	public function setRenderFunction(render : RenderFunction){
		_window.setRenderFunction(render);
	}

	inline public function setViewPort(x : Float, y : Float, width : Float, height : Float){
		_option.autoViewPort = false;
		_setViewPort(x,y, width, height);
	}

	inline private function _setViewPort(x : Float, y : Float, width : Float, height : Float){
		gl.viewport(Std.int(x), Std.int(y), Std.int(width) ,  Std.int(height));
	}

	inline public function clearWith(r : Float, g : Float, b : Float, a : Float):Void{
		gl.clearColor(r,g,b,a);
		gl.clear(GL.COLOR_BUFFER_BIT);
	}

	inline public function uploadTexture(image : Image) : GPUTexture{
		return GPUTexture.upload(this, image);
	}

	inline public function uploadCubeTexture(negx : Image,negy : Image,negz : Image,posx : Image,posy : Image,posz : Image) : GPUCubeTexture{
		return GPUCubeTexture.upload(this, negx,negy,negz,posx,posy,posz);
	}

}