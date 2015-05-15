package tri;

import glee.GPU;
import glmat.Vec3;
using glmat.Mat4;


class PerspectiveCamera{
	var _gpu : GPU;

	//TODO : decide which one to expose (viewproj or individuals)
	public var proj(default,null) : Mat4;
	public var view(default,null): Mat4;
	var _eye : Vec3;
	var _center : Vec3;
	var _up : Vec3;
	public var viewproj(default,null) : Mat4; //TODO return a Const<Mat4>

	public function new(gpu : GPU){
		_gpu = gpu;
		proj = new Mat4();
		view = new Mat4();
		viewproj = new Mat4();
		_eye = new Vec3(0,10,0);
		_center = new Vec3(0,10,0);
		_up = new Vec3(0,1,0);
			
		_gpu.setViewportChangeCallback(onViewportChanged);
		onViewportChanged(_gpu.viewportX, _gpu.viewportY, _gpu.viewportWidth, _gpu.viewportHeight);
	}

	
	function onViewportChanged(x : Int, y : Int, width : Int, height : Int){
		//TODO set viewproj to dirty
		proj = proj.perspective(45,width/height,0.01,1000);
		_recomputeViewProj();
	}

	function _recomputeViewProj(){
		view = view.lookAt(_eye,_center,_up);
		viewproj.multiply(proj, view);
	}

	public function setEyePosition(x : Float, y : Float, z : Float){
		//TODO set viewproj to dirty
		_eye.x = x;
		_eye.y = y;
		_eye.z = z;
		_recomputeViewProj();
	}

	public function setCenterPosition(x : Float, y : Float, z : Float){
		//TODO set viewproj to dirty
		_center.x = x;
		_center.y = y;
		_center.z = z;
		_recomputeViewProj();
	}

}