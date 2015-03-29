package glee;

import loka.gl.GL;

typedef AttributeData = {
	stride : Int,
	shaderLocation : Int
}

@:autoBuild(glee.macro.GPUProgramMacro.apply())
interface GPUProgram{

}
