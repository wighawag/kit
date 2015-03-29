package glee;

import loka.asset.Image;
import loka.gl.GL;

//TODO remove duplicate code in GPUTexture
class GPUCubeTexture{

	public static function upload(gpu : GPU, negx : Image,negy : Image,negz : Image,posx : Image,posy : Image,posz : Image) : GPUCubeTexture{

		var gl = gpu.gl;
        var nativeTexture = gl.createTexture();
        gl.bindTexture(GL.TEXTURE_CUBE_MAP, nativeTexture);
        //TODO ? gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 0);
        gl.texImage2DViaImage(GL.TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, negx);
        gl.texImage2DViaImage(GL.TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, negy);
        gl.texImage2DViaImage(GL.TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, negz);
        gl.texImage2DViaImage(GL.TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, posx);
        gl.texImage2DViaImage(GL.TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, posy);
        gl.texImage2DViaImage(GL.TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, posz);
        //TODO ? gl.generateMipmap(GL.TEXTURE_CUBE_MAP);
        //gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_R, GL.CLAMP_TO_EDGE);
        gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
        gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MIN_FILTER, GL.LINEAR);//GL.LINEAR_MIPMAP_LINEAR);
        gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
        //gl.bindTexture(GL.TEXTURE_CUBE_MAP, null); //TODO not neccesary ?

        return new GPUCubeTexture(gl,nativeTexture);
	}

	public var nativeTexture(default,null) : GLTexture;
	var _gl : GL;

	private function new(gl : GL, nativeTexture : GLTexture){
		_gl = gl;
		this.nativeTexture = nativeTexture;
	}
}