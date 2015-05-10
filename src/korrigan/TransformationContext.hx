package korrigan;

import glmat.Mat4;
import glmat.Vec4;
import glmat.Vec3;

using glmat.Mat4;

class TransformationContext{

	private static var _scratchMatrix3D = new Mat4();
	//private static var _scratchClipVector = new Vector<Float>(2*3, true);
	//private static var _scratchQuadVector = new Vector<Float>(4*3, true);
	
	//private var _inverseProjection :Matrix3D;
	private var _stateList :TransformationState;

	public var alpha(get,null):Float;
	function get_alpha():Float{
		return getTopState().alpha;
	}

	public function new(){
		_stateList = new TransformationState();
	}

	public function save (){
		var current = _stateList;
		var state = _stateList.next;
		
		if (state == null) {
			// Grow the list
			state = new TransformationState();
			state.prev = current;
			current.next = state;
		}

		state.matrix.copyFrom(current.matrix);
		
		state.alpha = current.alpha;

		//state.scissorEnabled = current.scissorEnabled;
		// if (state.scissorEnabled) {
		// 	state.scissor.copyFrom(current.scissor);
		// }

		_stateList = state;
	}

	public function translate (x :Float, y :Float){
		var state = getTopState();
		state.matrix.translate(state.matrix, x, y, 0);
	}

	public function scale (x :Float, y :Float){
		if (x == 0 || y == 0) {
			return; //TODO check other target as Flash throws an undocumented error if appendScale params are zero
		}
		var state = getTopState();
		state.matrix.scale(state.matrix, x, y, 1);
	}

	public function rotate (rotation :Float){
		var state = getTopState();
		//TODO state.matrix.prependRotation(rotation, Vector3D.Z_AXIS);
	}
	public function rotateX (rotation :Float){
		var state = getTopState();
		state.matrix.rotateX(state.matrix, rotation);
		//TODO state.matrix.prependRotation(rotation, Vector3D.Z_AXIS);
	}
	public function rotateY (rotation :Float){
		var state = getTopState();
		state.matrix.rotateY(state.matrix, rotation);
		//TODO state.matrix.prependRotation(rotation, Vector3D.Z_AXIS);
	}


	public function rotateZ (rotation :Float){
		var state = getTopState();
		state.matrix.rotateZ(state.matrix, rotation);
		//TODO state.matrix.prependRotation(rotation, Vector3D.Z_AXIS);
	}


	public function multiplyAlpha (factor :Float)
	{
		getTopState().alpha *= factor;
	}
	public function setAlpha (alpha :Float)
	{
		getTopState().alpha = alpha;
	}

	public function ortho( left : Float , right : Float , bottom : Float , top : Float , near : Float , far : Float ):Void{
		getTopState().matrix.ortho(left,right,bottom,top,near,far);
	}

	// public function transform (m00 :Float, m10 :Float, m01 :Float, m11 :Float, m02 :Float, m12 :Float){
	// 	var state = getTopState();
	// 	var scratch = _scratchTransformVector;
	// 	scratch[0*4 + 0] = m00;
	// 	scratch[0*4 + 1] = m10;
	// 	scratch[1*4 + 0] = m01;
	// 	scratch[1*4 + 1] = m11;
	// 	scratch[3*4 + 0] = m02;
	// 	scratch[3*4 + 1] = m12;
	// 	_scratchMatrix3D.copyRawDataFrom(scratch);
	// 	state.matrix.prepend(_scratchMatrix3D);
	// }

	public function restore (){
		//TODO Assert.that(_stateList.prev != null, "Can't restore without a previous save");
		_stateList = _stateList.prev;
	}

	//TODO ?
	// public function onResize (width :Int, height :Int){
	// 	var ortho = new Matrix3D(Vector.ofArray([
	// 	2/width, 0, 0, 0,
	// 	0, -2/height, 0, 0,
	// 	0, 0, -1, 0,
	// 	-1, 1, 0, 1,
	// 	]));
	// 	// Reinitialize the stack from an orthographic projection matrix
	// 	_stateList = new DrawingState();
	// 	_stateList.matrix = ortho;
	// 	// May be used to transform back into screen coordinates
	// 	_inverseProjection = ortho.clone();
	// 	_inverseProjection.invert();
	// }

	inline private function getTopState () : TransformationState{
		return _stateList;
	}



	//TODO?
	// private function transformQuad (x :Float, y :Float, width :Float, height :Float) :Vector<Float>{
	// 	var x2 = x + width;
	// 	var y2 = y + height;
	// 	var pos = _scratchQuadVector;
	// 	pos[0] = x;
	// 	pos[1] = y;
	// 	// pos[2] = 0;
	// 	pos[3] = x2;
	// 	pos[4] = y;
	// 	// pos[5] = 0;
	// 	pos[6] = x2;
	// 	pos[7] = y2;
	// 	// pos[8] = 0;
	// 	pos[9] = x;
	// 	pos[10] = y2;
	// 	// pos[11] = 0;
	// 	getTopState().matrix.transformVectors(pos, pos);
	// 	return pos;
	// }

	public function transform(vec : Vec4):Void{
		vec.transformMat4(vec, getTopState().matrix);
	}

	public function transformVec3(vec3 : Vec3):Void{
		vec3.transformMat4(vec3, getTopState().matrix);
	}
}


class TransformationState{
	public var matrix :Mat4;
	public var alpha :Float;

	//public var scissor :Rectangle;
	//public var scissorEnabled :Bool;
	public var prev :TransformationState;
	public var next :TransformationState;
	
	public function new (){
		matrix = new Mat4();
		alpha = 1;
		//scissor = new Rectangle();
	}

	// public function getScissor () :Rectangle{
	// 	return scissorEnabled ? scissor : null;
	// }

	// public function applyScissor (x :Float, y :Float, width :Float, height :Float){
	// 	if (scissorEnabled) {
	// 		// Intersection with the previous scissor rectangle
	// 		var x1 = FMath.max(scissor.x, x);
	// 		var y1 = FMath.max(scissor.y, y);
	// 		var x2 = FMath.min(scissor.x + scissor.width, x + width);
	// 		var y2 = FMath.min(scissor.y + scissor.height, y + height);
	// 		x = x1;
	// 		y = y1;
	// 		width = x2 - x1;
	// 		height = y2 - y1;
	// 	}
	// 	scissor.setTo(x, y, width, height);
	// 	scissorEnabled = true;
	// }

	/**
	* Whether the scissor region is empty. Calling Context3D.setScissorRectangle with an empty
	* rectangle actually disables scissor testing, so this needs to be queried before every draw
	* method.
	*/
	// public function emptyScissor () :Bool
	// {
	// 	return scissorEnabled && (scissor.width < 0.5 || scissor.height < 0.5);
	// }
}