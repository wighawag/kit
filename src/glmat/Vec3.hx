package glmat;

import loka.util.Float32Array;

abstract Vec3(Float32Array){

	inline public function new(?x:Float=0,?y:Float=0,?z:Float=0){
		this = new Float32Array(3);
	    this[0] = x;
	    this[1] = y;
	    this[2] = z;
	}

	inline public function set(?x:Float=0,?y:Float=0,?z:Float=0){
		this[0] = x;
	    this[1] = y;
	    this[2] = z;
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


	//TODO check if that makes sense
	/**
	* Transforms the vec3 with a mat4.
	*
	* @param {vec3} out the receiving vector
	* @param {vec3} a the vector to transform
	* @param {mat4} m matrix to transform with
	* @returns {vec3} out
	*/
	inline public function transformMat4(out : Vec3, m : Mat4) : Vec3 {
		var x = this[0];
		var y = this[1];
		var z = this[2];
		out.x = m[0] * x + m[4] * y + m[8] * z + m[12];
		out.y = m[1] * x + m[5] * y + m[9] * z + m[13];
		out.z = m[2] * x + m[6] * y + m[10] * z + m[14];
		return out;
	}
}