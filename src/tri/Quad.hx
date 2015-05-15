package tri;


import glee.GPUBuffer;
import glmat.Vec3;
import glmat.Vec2;

class Quad{
	public static function writeTexturedQuad(buffer : GPUBuffer<{position:Vec3, texCoords:Vec2}>, width : Float, height : Float){
		buffer.write_position(-width,height,0);
		buffer.write_texCoords(0, 1);
		buffer.write_position(-width,0,0);
		buffer.write_texCoords(0,0);
		buffer.write_position(0,0,0);
		buffer.write_texCoords(1,0);

		buffer.write_position(0,0,0);
		buffer.write_texCoords(1,0);
		buffer.write_position(0,height,0);
		buffer.write_texCoords(1,1);
		buffer.write_position(-width,height,0);
		buffer.write_texCoords(0,1);


		buffer.write_position(0,height,0);
		buffer.write_texCoords(0, 1);
		buffer.write_position(0,0,0);
		buffer.write_texCoords(0,0);
		buffer.write_position(width,0,0);
		buffer.write_texCoords(1,0);

		buffer.write_position(width,0,0);
		buffer.write_texCoords(1,0);
		buffer.write_position(width,height,0);
		buffer.write_texCoords(1,1);
		buffer.write_position(0,height,0);
		buffer.write_texCoords(0,1);
		
	}
}