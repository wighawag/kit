package glmat;

import loka.util.Float32Array;

abstract Vec4(Float32Array){

	inline public function new(?x:Float=0,?y:Float=0,?z:Float=0, ?w:Float=0){
		this = new Float32Array(4);
	    this[0] = x;
	    this[1] = y;
	    this[2] = z;
	    this[3] = w; //TODO w ? remove Vec from GLSL
	}

	public var x(get,set):Float;
	inline function get_x():Float{return this[0];}
	inline function set_x(v:Float):Float{
		return this[0] = v;
	}
	public var y(get,set):Float;
	inline function get_y():Float{return this[1];}
	inline function set_y(v:Float):Float{
		return this[1] = v;
	}
	public var z(get,set):Float;
	inline function get_z():Float{return this[2];}
	inline function set_z(v:Float):Float{
		return this[2] = v;
	}
	public var w(get,set):Float;
	inline function get_w():Float{return this[3];}
	inline function set_w(v:Float):Float{
		return this[3] = v;
	}

	/**
	* Transforms the vec4 with a mat4.
	*
	* @param {vec4} out the receiving vector
	* @param {vec4} a the vector to transform
	* @param {mat4} m matrix to transform with
	* @returns {vec4} out
	*/
	inline public function transformMat4(out : Vec4, m : Mat4) : Vec4 {
		out.x = m[0] * x + m[4] * y + m[8] * z + m[12] * w;
		out.y = m[1] * x + m[5] * y + m[9] * z + m[13] * w;
		out.z = m[2] * x + m[6] * y + m[10] * z + m[14] * w;
		out.w = m[3] * x + m[7] * y + m[11] * z + m[15] * w;
		return out;
	}

	// @:arrayAccess public inline function get(i:Int) return this[i];
	// @:arrayAccess public inline function arrayWrite(i:Int, v:Float):Float {
 //    	this[i] = v;
 //    	return v;
	// }
}