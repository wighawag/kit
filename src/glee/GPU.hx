package glee;

import loka.asset.Image;
import loka.gl.GL;
import glee.GPUBuffer;
import glee.GPUTexture;

class GPU{
	
	public var gl(default,null) : GL;

	inline public function new(gl : GL){
		this.gl = gl;
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