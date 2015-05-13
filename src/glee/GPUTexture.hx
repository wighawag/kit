package glee;

import loka.gl.GL;
import loka.asset.Video;

class GPUTexture{

	// TODO remove as we have noew member upload?
	public static function upload(gpu : GPU, image) : GPUTexture{

		var gl = gpu.gl;
        var nativeTexture = gl.createTexture();
        gl.bindTexture(GL.TEXTURE_2D, nativeTexture);
        gl.texImage2DViaImage(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, image);
        gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST); 
        gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE); //Prevents s-coordinate wrapping (repeating).
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);//TODO make them as parameters
        gl.bindTexture(GL.TEXTURE_2D, null); //TODO not neccesary ?

        return new GPUTexture(gl,nativeTexture);
	}

	public static function create(gpu : GPU) : GPUTexture{

		var gl = gpu.gl;
        var nativeTexture = gl.createTexture();
        gl.bindTexture(GL.TEXTURE_2D, nativeTexture);
        gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST); 
        gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE); //Prevents s-coordinate wrapping (repeating).
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);//TODO make them as parameters
        return new GPUTexture(gl,nativeTexture);
	}


	//TODO uploadImage
	public function uploadVideo(video : Video){
		_gl.bindTexture(GL.TEXTURE_2D, nativeTexture);
        _gl.texImage2DViaVideo(GL.TEXTURE_2D, 0, GL.RGB, GL.RGB, GL.UNSIGNED_BYTE, video);
	}

	public var nativeTexture(default,null) : GLTexture;
	var _gl : GL;

	private function new(gl : GL, nativeTexture : GLTexture){
		_gl = gl;
		this.nativeTexture = nativeTexture;
	}
}