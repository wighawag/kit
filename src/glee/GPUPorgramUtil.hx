package glee;

import loka.gl.GL;

class GPUProgramUtil{

	private static function setupShader(gl : GL, shaderSrc : String, shaderType : Int) : GLShader{
        var shader = gl.createShader(shaderType);
        gl.shaderSource(shader, shaderSrc);
        gl.compileShader(shader);
        var success = gl.getShaderParameter(shader, GL.COMPILE_STATUS);
        if (success == 0) {
            // Something went wrong during compilation; get the error
            throw "could not compile shader:" + gl.getShaderInfoLog(shader);
        }
        return shader;
    }

    public static function upload(gl : GL, vertexShaderSrc : String, fragmentShaderSrc : String):GLProgram{
		var vertexShader = setupShader(gl, vertexShaderSrc, GL.VERTEX_SHADER);
		var fragmentShader = setupShader(gl, fragmentShaderSrc, GL.FRAGMENT_SHADER);

		var nativeProgram = gl.createProgram();
        gl.attachShader(nativeProgram, vertexShader);
        gl.attachShader(nativeProgram, fragmentShader);
        gl.linkProgram(nativeProgram);

        var success = gl.getProgramParameter(nativeProgram, GL.LINK_STATUS);
        if (success == 0) {
            // something went wrong with the link
            throw ("program filed to link:" + gl.getProgramInfoLog (nativeProgram));
        }

        return nativeProgram;
	}

	public static function unload(gl : GL, nativeProgram : GLProgram):Void{
		gl.deleteProgram(nativeProgram);	
	}

}