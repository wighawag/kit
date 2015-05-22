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

    var numVerticesSoFar = buffer.getNumVerticesWritten();
    buffer.writeIndex(numVerticesSoFar+0);
    buffer.writeIndex(numVerticesSoFar+1);
    buffer.writeIndex(numVerticesSoFar+2);
    buffer.writeIndex(numVerticesSoFar+2);
    buffer.writeIndex(numVerticesSoFar+3);
    buffer.writeIndex(numVerticesSoFar+0);

    buffer.writeIndex(numVerticesSoFar+4);
    buffer.writeIndex(numVerticesSoFar+1);
    buffer.writeIndex(numVerticesSoFar+0);
    buffer.writeIndex(numVerticesSoFar+0);
    buffer.writeIndex(numVerticesSoFar+5);
    buffer.writeIndex(numVerticesSoFar+4);

    buffer.writeIndex(numVerticesSoFar+2);
    buffer.writeIndex(numVerticesSoFar+3);
    buffer.writeIndex(numVerticesSoFar+7);
    buffer.writeIndex(numVerticesSoFar+7);
    buffer.writeIndex(numVerticesSoFar+6);
    buffer.writeIndex(numVerticesSoFar+2);

    buffer.writeIndex(numVerticesSoFar+4);
    buffer.writeIndex(numVerticesSoFar+5);
    buffer.writeIndex(numVerticesSoFar+7);
    buffer.writeIndex(numVerticesSoFar+7);
    buffer.writeIndex(numVerticesSoFar+6);
    buffer.writeIndex(numVerticesSoFar+4);

    buffer.writeIndex(numVerticesSoFar+0);
    buffer.writeIndex(numVerticesSoFar+3);
    buffer.writeIndex(numVerticesSoFar+7);
    buffer.writeIndex(numVerticesSoFar+7);
    buffer.writeIndex(numVerticesSoFar+5);
    buffer.writeIndex(numVerticesSoFar+0);

    buffer.writeIndex(numVerticesSoFar+1);
    buffer.writeIndex(numVerticesSoFar+4);
    buffer.writeIndex(numVerticesSoFar+2);
    buffer.writeIndex(numVerticesSoFar+2);
    buffer.writeIndex(numVerticesSoFar+0);
    buffer.writeIndex(numVerticesSoFar+1);

		buffer.write_position(-width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, -height/2, -depth/2);	
		buffer.write_position(width/2, -height/2, -depth/2);
		buffer.write_position(width/2, height/2, -depth/2);	
		buffer.write_position(-width/2, -height/2, depth/2);	
		buffer.write_position(-width/2, height/2, depth/2);	
 		buffer.write_position(width/2, -height/2, depth/2);	
 		buffer.write_position(width/2, height/2, depth/2);	
  	
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