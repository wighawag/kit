package glmat;

import loka.util.Float32Array;

abstract Vec2(Float32Array){

	inline public function new(?x:Float=0,?y:Float=0){
		this = new Float32Array(2);
	    this[0] = x;
	    this[1] = y;
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
}