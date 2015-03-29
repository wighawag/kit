package glee;

import loka.gl.GL;
import loka.util.Float32Array;

class GPUBufferBase{
	var  _gl : GL;

	public var nativeBuffer(default,null) : GLBuffer;
	
	var _float32Array : Float32Array;
	var _usage : Int;

	
	public var uploaded(default,null) : Bool;
	
	public function new(gpu : GPU, usage : Int){
		_gl = gpu.gl;
		_usage = usage;
		nativeBuffer = _gl.createBuffer();
	}

	public function upload() :Void{
		var offset = 0;
        _gl.bindBuffer (GL.ARRAY_BUFFER, nativeBuffer);
        if (offset != 0) {
            _gl.bufferSubData(GL.ARRAY_BUFFER, offset, _float32Array);
        }else {
            _gl.bufferData (GL.ARRAY_BUFFER, _float32Array, _usage);
        }
        _gl.bindBuffer (GL.ARRAY_BUFFER, null);
        uploaded = true;
	}
	

}