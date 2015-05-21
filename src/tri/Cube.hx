package tri;

import glee.GPUIndexedBuffer;
import glmat.Vec3;
import glmat.Vec2;


class Cube{
	var width : Float;
	var height : Float;
	var depth : Float;

	public function new(width : Float, height : Float, depth : Float){
		this.width = width;
		this.height = height;
		this.depth = depth;
	}

	public function write(buffer : GPUIndexedBuffer<{position:Vec3}>){
		buffer.write_position(-width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, -height/2, -depth/2);	
		buffer.write_position(width/2, -height/2, -depth/2);
		buffer.write_position(width/2, -height/2, -depth/2);	
		buffer.write_position(width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, height/2, -depth/2);	

		buffer.write_position(-width/2, -height/2, depth/2);	
		buffer.write_position(-width/2, -height/2, -depth/2);	
		buffer.write_position(-width/2, height/2, -depth/2);
		buffer.write_position(-width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, height/2, depth/2);	
		buffer.write_position(-width/2, -height/2, depth/2);	
  
  		buffer.write_position(width/2, -height/2, -depth/2);	
  		buffer.write_position(width/2, -height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, -depth/2);	
  		buffer.write_position(width/2, -height/2, -depth/2);	

		buffer.write_position(-width/2, -height/2, depth/2);	
  		buffer.write_position(-width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, -height/2, depth/2);	
  		buffer.write_position(-width/2, -height/2, depth/2);	
   
  		buffer.write_position(-width/2, height/2, -depth/2);	
  		buffer.write_position(width/2, height/2, -depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(-width/2, height/2, depth/2);	
  		buffer.write_position(-width/2, height/2, -depth/2);	
  
  		buffer.write_position(-width/2, -height/2, -depth/2);	
  		buffer.write_position(-width/2, -height/2, depth/2);	
  		buffer.write_position(width/2, -height/2, -depth/2);	
  		buffer.write_position(width/2, -height/2, -depth/2);	
  		buffer.write_position(-width/2, -height/2, depth/2);	
  		buffer.write_position(width/2, -height/2, depth/2);	
	}


	public function writeTexturedCylinder(buffer : GPUIndexedBuffer<{position:Vec3, texCoords:Vec2}>){
		buffer.write_position(-width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, -height/2, -depth/2);	
		buffer.write_position(width/2, -height/2, -depth/2);
		buffer.write_position(width/2, -height/2, -depth/2);	
		buffer.write_position(width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, height/2, -depth/2);	

		buffer.write_position(-width/2, -height/2, depth/2);	
		buffer.write_position(-width/2, -height/2, -depth/2);	
		buffer.write_position(-width/2, height/2, -depth/2);
		buffer.write_position(-width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, height/2, depth/2);	
		buffer.write_position(-width/2, -height/2, depth/2);	
  
  		buffer.write_position(width/2, -height/2, -depth/2);	
  		buffer.write_position(width/2, -height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, -depth/2);	
  		buffer.write_position(width/2, -height/2, -depth/2);	

		buffer.write_position(-width/2, -height/2, depth/2);	
  		buffer.write_position(-width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, -height/2, depth/2);	
  		buffer.write_position(-width/2, -height/2, depth/2);	
   
  		buffer.write_position(-width/2, height/2, -depth/2);	
  		buffer.write_position(width/2, height/2, -depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(width/2, height/2, depth/2);	
  		buffer.write_position(-width/2, height/2, depth/2);	
  		buffer.write_position(-width/2, height/2, -depth/2);	
  
  		buffer.write_position(-width/2, -height/2, -depth/2);	
  		buffer.write_position(-width/2, -height/2, depth/2);	
  		buffer.write_position(width/2, -height/2, -depth/2);	
  		buffer.write_position(width/2, -height/2, -depth/2);	
  		buffer.write_position(-width/2, -height/2, depth/2);	
  		buffer.write_position(width/2, -height/2, depth/2);	
	}
}