package korrigan;

import glee.GPU;
using glmat.Mat4;
using glmat.Vec3;

typedef OrthoCameraOption = {
	?scale : Bool
}

class OrthoCamera{

	var _gpu : GPU;
	var _option : OrthoCameraOption;
	var _scale : Float = 1;

	var _proj : Mat4;
	var _view: Mat4;
	public var viewproj(default,null) : Mat4; //TODO return a Const<Mat4>

	var _visibleWidth : Float;
	var _visibleHeight : Float;

	var _focusWidth : Float = 600;
	var _focusHeight : Float = 400;

	

	public function new(gpu : GPU, width : Float, height : Float, ?option : OrthoCameraOption){
		_gpu = gpu;
		_focusWidth = width;
		_focusHeight = height;
		_proj = new Mat4();
		_view = new Mat4();
		viewproj = new Mat4();
		var defaultOption : OrthoCameraOption = {
			scale:true
		};
		if(option != null){
			option.scale = option.scale == null ? defaultOption.scale : option.scale;
		}else{
			option = defaultOption;
		} 
		_option =option;
		
		_gpu.setViewportChangeCallback(onViewportChanged);
		onViewportChanged(_gpu.viewportX, _gpu.viewportY, _gpu.viewportWidth, _gpu.viewportHeight);
	}

	
	function onViewportChanged(x : Int, y : Int, width : Int, height : Int){
		//TODO set viewproj to dirty
		_proj.ortho(0, width, height,0,-1,1);

		var widthRatio = width/_focusWidth;
		var heightRatio = height/_focusHeight;
		if(_option.scale){
			if(widthRatio > heightRatio){
				_scale = heightRatio; 
			}else{
				_scale = widthRatio; 
			}
		 }else{
		 	_scale = 1;
		 }
		//_proj.scale(_proj,_scale, _scale, 1); 
		_visibleWidth = width / _scale;
		_visibleHeight = height / _scale;
		//TODO support light when _scale =1 (while the drawingbuffer has a different scale)
	}

	public function centerOn(x : Float, y : Float){
		//TODO keep in memory (state)
		_view.identity();
		_view.scale(_view,_scale,_scale,1);
		_view.translate(_view, _visibleWidth/2 - x,_visibleHeight/2 - y, 0);
		viewproj.multiply(_proj, _view);

		//TODO limit the side

		//TODO support zooming
	}

	public function toBufferCoordinates(vec3 : Vec3, out : Vec3) : Vec3{
		out = out.transformMat4(vec3, _view);
		out.x + _gpu.viewportX;
		out.y + _gpu.viewportY;
		return out;
	}

	
}