package glee;

import loka.gl.GL;
import loka.util.Float32Array;
import loka.util.Int16Array;

class GPUBufferBase{
	var  _gl : GL;

	public var nativeBuffer(default,null) : GLBuffer;
	
	var _float32Array : Float32Array;
	var _usage : Int;

	public var nativeIndexBuffer(default,null) : GLBuffer;
	var _int16Array : Int16Array;

	var _lastIndexPosition : Int;
	public var indexUploaded(default,null) : Bool;
	
	public var uploaded(default,null) : Bool;
	
	public function new(gpu : GPU, usage : Int){
		_gl = gpu.gl;
		_usage = usage;
		nativeBuffer = _gl.createBuffer();
	}

	private function _writeIndex(i : Int){
		if(nativeIndexBuffer == null){
			nativeIndexBuffer = _gl.createBuffer();
			_int16Array = new loka.util.Int16Array(512);
		}
        if (_int16Array.length <= _lastIndexPosition + 1) {
            var newArray = new loka.util.Int16Array(_int16Array.length * 2); //TODO inline growing in javascript
            //TODO : copy values
            _int16Array = newArray;
        }
        _int16Array[++_lastIndexPosition] = i;
        indexUploaded = false;
	}

	public function upload() :Void{
		var offset = 0;//TODO offset
        _gl.bindBuffer (GL.ARRAY_BUFFER, nativeBuffer);
        if (offset != 0) {
            _gl.bufferSubData(GL.ARRAY_BUFFER, offset, _float32Array);
        }else {
            _gl.bufferData (GL.ARRAY_BUFFER, _float32Array, _usage);
        }
        _gl.bindBuffer (GL.ARRAY_BUFFER, null);

        if(!indexUploaded){
        	var offset = 0; //TODO offset
	        _gl.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, nativeIndexBuffer);
	        if (offset != 0) {
	            _gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, offset, _int16Array);
	        }else {
	            _gl.bufferData (GL.ELEMENT_ARRAY_BUFFER, _int16Array, _usage);
	        }
	        _gl.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, null);	
	        indexUploaded = true;
        }

        uploaded = true;
	}
	

}