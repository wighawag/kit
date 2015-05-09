package glee;

import loka.App;
import loka.Window;
import loka.asset.Image;
import loka.gl.GL;
import glee.GPUBuffer;
import glee.GPUTexture;
import loka.Window;

typedef GPUOption = {
	?viewportType : ViewportType,
	?viewportPosition : ViewportPosition,
	?maxHDPI : Int  //TODO
	//?window : Window
}

enum ViewportType{
	Manual;
	Fixed(width : Int, height :Int); 
	Fill;
	FillUpToRatios(minRatio : Float, maxRatio : Float);
	KeepRatioUsingBorder(width : Int, height :Int);
	KeepRatioUsingCropping(width : Int, height :Int);
	KeepRatioUsingBorderWithoutScalingUp(width : Int, height :Int);
	KeepRatioUsingCroppingWithoutScalingUp(width : Int, height :Int);
}

enum ViewportPosition{
	TopLeft;
	Top;
	TopRight;
	Right;
	BottomRight;
	Bottom;
	BottomLeft;
	Left;
	Center;
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

	var _viewportChangeCallback : Int->Int->Int->Int->Void;
	public var viewportX(default,null) : Int = 0;
	public var viewportY(default,null) : Int = 0;
	public var viewportWidth(default,null) : Int = 0;
	public var viewportHeight(default,null) : Int = 0;	

	var _currentProgram : GPUProgram;

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
			viewportType:Fill,
			viewportPosition:Center,
			maxHDPI:1
		};
		if(option != null){
			option.viewportType = option.viewportType == null ? defaultOption.viewportType : option.viewportType;
			option.viewportPosition = option.viewportPosition == null ? defaultOption.viewportPosition : option.viewportPosition;
			option.maxHDPI = option.maxHDPI == null ? defaultOption.maxHDPI : option.maxHDPI;
		}else{
			option = defaultOption;
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
		
		if(_windowResizeCallback != null){
			_windowResizeCallback(width,height);
		}
		setViewportAutomatically();
	}

	public function setRenderFunction(render : RenderFunction){
		_window.setRenderFunction(render);
	}

	function setViewportAutomatically(){
		var width = windowWidth;
		var height = windowHeight;
		switch(_option.viewportType){
			case Manual : return;
			case Fill : 
				width = untyped gl.drawingBufferWidth;
				height = untyped gl.drawingBufferHeight;
			case FillUpToRatios(minRatio, maxRatio):
				var drawingBufferWidth = untyped gl.drawingBufferWidth;
				var drawingBufferHeight = untyped gl.drawingBufferHeight;
				if (drawingBufferWidth / drawingBufferHeight > maxRatio){
					width = drawingBufferHeight * maxRatio;
					height = drawingBufferHeight;
				}else if(drawingBufferWidth / drawingBufferHeight < minRatio){
					width = drawingBufferHeight;
					height = drawingBufferHeight * minRatio;
				}else{
					width = drawingBufferWidth;
					height = drawingBufferHeight;
				}
				
			case Fixed(w,h) : 
				width = w;
				height = h;
			case KeepRatioUsingBorder(w,h):
				var widthRatio = width/w;
				var heightRatio = height/h;
				if(widthRatio > heightRatio){
					width = w * heightRatio; 
				}else{
					height = h * widthRatio; 
				}
			case KeepRatioUsingBorderWithoutScalingUp(w,h):
				var widthRatio = width/w;
				var heightRatio = height/h;
				if(widthRatio > 1 || heightRatio > 1){
					width = w;
					height = h;
				}else if(widthRatio > heightRatio){
					width = w * heightRatio; 
				}else{
					height = h * widthRatio; 
				}
			case KeepRatioUsingCropping(w,h):
				var widthRatio = width/w;
				var heightRatio = height/h;
				if(widthRatio < heightRatio){
					width = w * heightRatio; 
				}else{
					height = h * widthRatio; 
				}
			case KeepRatioUsingCroppingWithoutScalingUp(w,h):
				var widthRatio = width/w;
				var heightRatio = height/h;
				if(widthRatio > 1 || heightRatio > 1){
					width = w;
					height = h;
				}else if(widthRatio < heightRatio){
					width = w * heightRatio; 
				}else{
					height = h * widthRatio; 
				}
		}
		//TODO add option to not scale up?

		//TODO support drawingBufferWidth < windowWidth and drawingBufferHeight < windowHeight

		var x : Float = 0;
		var y : Float = 0;
		switch(_option.viewportPosition){
			case Center : 
				x = (windowWidth - width) / 2;
				y = (windowHeight - height) / 2;
			case TopLeft : 
				y = (windowHeight - height);
			case Top : 
				x = (windowWidth - width) / 2;
				y = (windowHeight - height);
			case TopRight:
				x = (windowWidth - width);
				y = (windowHeight - height);
			case Right:
				x = (windowWidth - width);
				y = (windowHeight - height) / 2;
			case BottomRight:
				x = (windowWidth - width);
			case Bottom:
				x = (windowWidth - width) / 2;
			case BottomLeft:
			case Left:
				y = (windowHeight - height) / 2;

		}

		//TODO check if not changed
		_setViewPort(x, y, width, height);
		
	}

	inline public function setViewPort(x : Float, y : Float, width : Float, height : Float){
		_option.viewportType = Manual;
		_setViewPort(x,y, width, height);
	}

	public function setViewportChangeCallback(callback : Int->Int->Int->Int->Void){
		_viewportChangeCallback = callback;
	}

	inline private function _setViewPort(x : Float, y : Float, width : Float, height : Float){
		viewportX = Std.int(x);
		viewportY = Std.int(y);
		viewportWidth = Std.int(width);
		viewportHeight = Std.int(height);
		gl.viewport(viewportX, viewportY, viewportWidth, viewportHeight);
		if(_viewportChangeCallback != null){
			_viewportChangeCallback(viewportX, viewportY, viewportWidth , viewportHeight);
		}
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