package glee.macro;

import glee.GLSLShaderGroup;
import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.ClassBuilder;
import tink.macro.Member;

using tink.MacroApi;

using belt.MacroUtils;

class GPUProgramMacro{


	macro static public function apply() : Array<Field>{
		
        return ClassBuilder.run([generateFieldsFromShaders], false); //true for debug

    }

    static private function generateFieldsFromShaders(classBuilder : ClassBuilder):Void{

        var pos = Context.currentPos();

        var target = classBuilder.target;
        if (target.isInterface){
            return;
        }

        
		

        var targetPath = {pack:target.pack, name: target.name};


        var metadata = target.meta.get();

        var shaderGroup = getShaderGroupFromMetadata(metadata);

        var glMember = {
                        name: "_gl",
                        pos: pos,
                        access: [APrivate],
                        kind: FVar(macro : loka.gl.GL,macro null),
                        };
        classBuilder.addMember(glMember);
        
        var nativeProgramMember = {
                        name: "_nativeProgram",
                        pos: pos,
                        access: [APrivate],
                        kind: FVar(macro : loka.gl.GL.GLProgram,macro null),
                        };
        classBuilder.addMember(nativeProgramMember);
        

        var constructor = classBuilder.getConstructor();
        constructor.isPublic = false;
        constructor.addArg("gl",macro : loka.gl.GL);
        constructor.addArg("nativeProgram",macro : loka.gl.GL.GLProgram);
        constructor.addStatement(macro _nativeProgram = nativeProgram);
        constructor.addStatement(macro _gl = gl);
        

        var assignExpr : Expr = macro var program = glee.GPUPorgramUtil.GPUProgramUtil.upload(gpu.gl,$v{shaderGroup.vertexShaderSrc},$v{shaderGroup.fragmentShaderSrc});
        var uploadBody : Expr = [
            assignExpr,
            {pos:pos, expr : EReturn({pos:pos,expr:ENew(targetPath,[
                macro gpu.gl,
                macro program
                ])})}
        ].toBlock();
        
        var arguments = [Functions.toArg("gpu",macro : glee.GPU)];
        var uploadMember = Member.method("upload",Functions.func(
            uploadBody, 
            arguments,
            TPath(targetPath),
            null,
            false));
        uploadMember.isStatic = true;
        classBuilder.addMember(uploadMember);


        


        var numTexture = 0;
        for (uniform in shaderGroup.uniforms){
            var uniformName = uniform.name;
            var uniformLocationVariableName = "_" + uniformName + "_shaderLocation";

            classBuilder.addMember({
                name: uniformLocationVariableName,
                pos: pos,
                access: [APrivate],
                kind: FVar(macro : loka.gl.GL.GLUniformLocation,macro null), 
                });


            constructor.addStatement(macro $i{uniformLocationVariableName} =  _gl.getUniformLocation(_nativeProgram,$v{uniformName}));

            var arguments = [];

            var body : Expr = macro _gl.useProgram(_nativeProgram); //TODO do it in draw and save the data to be uploaded
            var attrTPath = switch(cast uniform.type){
                case TPath(att): att;
                default: Context.error("should be a TPath", pos); null;
            };
            switch(attrTPath.name){
                case "Vec2":
                    arguments.push(Functions.toArg("x", macro : Float));
                    arguments.push(Functions.toArg("y", macro : Float));
                    body.append(macro _gl.uniform2f($i{uniformLocationVariableName}, x, y));
                    //arguments.push(Functions.toArg("vec", uniform.type));
                    //body.append(macro _gl.uniform2f($i{uniformLocationVariableName}, vec.x, vec.y));
                case "Vec3":
                    arguments.push(Functions.toArg("x", macro : Float));
                    arguments.push(Functions.toArg("y", macro : Float));
                    arguments.push(Functions.toArg("z", macro : Float));
                    body.append(macro _gl.uniform3f($i{uniformLocationVariableName}, x, y, z));
                    //arguments.push(Functions.toArg("vec", uniform.type));
                    //body.append(macro _gl.uniform3f($i{uniformLocationVariableName}, vec.x, vec.y, vec.z));
                    
                case "Vec4":
                    arguments.push(Functions.toArg("x", macro : Float));
                    arguments.push(Functions.toArg("y", macro : Float));
                    arguments.push(Functions.toArg("z", macro : Float));
                    arguments.push(Functions.toArg("w", macro : Float));
                    body.append(macro _gl.uniform4f($i{uniformLocationVariableName}, x, y, z, w));
                    //arguments.push(Functions.toArg("vec", uniform.type));
                    //body.append(macro _gl.uniform4f($i{uniformLocationVariableName}, vec.x, vec.y, vec.z, vec.w));
                case "Int":
                    arguments.push(Functions.toArg("x", macro : Int));
                    body.append(macro _gl.uniform1i($i{uniformLocationVariableName}, x));
                case "Float":
                    arguments.push(Functions.toArg("x", macro : Float));
                    body.append(macro _gl.uniform1f($i{uniformLocationVariableName}, x));
                case "Mat4":
                    //arguments.push(Functions.toArg("mat", macro : loka.util.Float32Array));
                    //body.append(macro _gl.uniformMatrix4fv($i{uniformLocationVariableName}, false, mat));
                    arguments.push(Functions.toArg("mat", uniform.type));
                    body.append(macro _gl.uniformMatrix4fv($i{uniformLocationVariableName}, false, mat));
                case "GPUTexture":
                    //arguments.push(Functions.toArg("texture", macro : glee.GPUTexture));
                    //body.append(macro _gl.activeTexture (loka.gl.GL.TEXTURE0 + $v{numTexture})); //TODO store the texture Index                 
                    //body.append(macro _gl.bindTexture (loka.gl.GL.TEXTURE_2D, texture.nativeTexture));
                    //body.append(macro _gl.uniform1i($i{uniformLocationVariableName}, $v{numTexture}));
                    //numTexture ++;
                    arguments.push(Functions.toArg("texture", uniform.type));
                    body.append(macro _gl.activeTexture (loka.gl.GL.TEXTURE0 + $v{numTexture})); //TODO store the texture Index                   
                    body.append(macro _gl.bindTexture (loka.gl.GL.TEXTURE_2D, texture.nativeTexture));
                    body.append(macro _gl.uniform1i($i{uniformLocationVariableName}, $v{numTexture}));                    
                    numTexture ++;
                case "GPUCubeTexture":
                    //arguments.push(Functions.toArg("texture", macro : glee.GPUCubeTexture));
                    //body.append(macro _gl.activeTexture (loka.gl.GL.TEXTURE0 + $v{numTexture})); //TODO store the texture Index
                    //body.append(macro _gl.bindTexture (loka.gl.GL.TEXTURE_CUBE_MAP, texture.nativeTexture));
                    //body.append(macro _gl.uniform1i($i{uniformLocationVariableName}, $v{numTexture}));/
                    //numTexture ++;
                    arguments.push(Functions.toArg("texture", uniform.type));
                    body.append(macro _gl.activeTexture (loka.gl.GL.TEXTURE0 + $v{numTexture})); 
                    body.append(macro _gl.bindTexture (loka.gl.GL.TEXTURE_CUBE_MAP, texture.nativeTexture));
                    body.append(macro _gl.uniform1i($i{uniformLocationVariableName}, $v{numTexture}));//TODO store the texture Index
                    numTexture ++;
                //default :
                //    throw "" + uniform.type + " not supported yet";
            }
            

            var member = Member.method("set_" + uniform.name,Functions.func(body, arguments,null,null,false));
            classBuilder.addMember(member);
            
        }


        var attributes = shaderGroup.attributes;

        //TODO remove duplication (see GPUBufferMacro)

        
        var totalStride : Int = 0;
        for (attribute in attributes){
            var numValues = 1;
            var attrTPath = switch(cast attribute.type){
                case TPath(att): att;
                default: Context.error("should be a TPath", pos); null;
            };
            if(attrTPath.name == "Vec4"){
                numValues = 4;
            }else if(attrTPath.name == "Vec3"){
                numValues = 3;
            }else if(attrTPath.name == "Vec2"){
                numValues = 2;
            }
            totalStride+= numValues; //work for samme types attributes //TODO make it work for mixed types Int/Float...
        }         


        var drawBody =  macro _gl.useProgram(_nativeProgram);
        drawBody.append(macro _gl.bindBuffer(loka.gl.GL.ARRAY_BUFFER,buffer.nativeBuffer));

        //TODO remove duplication (see GPUBufferMacro)
        var stride = 0;   
        for (attribute in attributes){
            var attributeName = attribute.name;
            var attributeLocationVariableName = "_" + attributeName + "_shaderLocation";


            var numValues = 1;
            var attrTPath = switch(cast attribute.type){
                case TPath(att): att;
                default: Context.error("should be a TPath", pos); null;
            };
            if(attrTPath.name == "Vec4"){
                numValues = 4;
            }else if(attrTPath.name == "Vec3"){
                numValues = 3;
            }else if(attrTPath.name == "Vec2"){
                numValues = 2;
            }

            classBuilder.addMember({
                name: attributeLocationVariableName,
                pos: pos,
                access: [APrivate],
                kind: FVar(macro : Int,macro 0), //TODO -1 or 0 ? 
                });

            constructor.addStatement(macro $i{attributeLocationVariableName} = _gl.getAttribLocation(_nativeProgram,$v{attributeName}));
            drawBody.append(macro _gl.enableVertexAttribArray($i{attributeLocationVariableName}));
            drawBody.append(macro _gl.vertexAttribPointer ($i{attributeLocationVariableName}, $v{numValues}, loka.gl.GL.FLOAT, false, $v{totalStride} * 4, $v{stride} * 4)); //TODO only FLOAT need Int...

            stride += numValues;
        }

        drawBody.append(macro if (!buffer.uploaded){buffer.upload();});
        drawBody.append(macro _gl.bindBuffer (loka.gl.GL.ARRAY_BUFFER, buffer.nativeBuffer));
        drawBody.append(macro 
            if(buffer.nativeIndexBuffer != null){
                _gl.bindBuffer (loka.gl.GL.ELEMENT_ARRAY_BUFFER, buffer.nativeIndexBuffer);  
                _gl.drawElements(loka.gl.GL.TRIANGLES, buffer.getNumIndicesWritten(), loka.gl.GL.UNSIGNED_SHORT, 0);
            }else{
                _gl.drawArrays(loka.gl.GL.TRIANGLES, 0, buffer.getNumVerticesWritten());        
            }
        );//Std.int(buffer.numVertices/2))); // TODO use index, else have to specify number of triangles

        drawBody.append(macro  _gl.useProgram(null)); //TODO remove ?
        

        var bufferClass = glee.macro.GPUBufferMacro.getBufferClassFromAttributes(shaderGroup.attributes);
        var arguments = [Functions.toArg("buffer",bufferClass)];
        var drawMember = Member.method("draw",Functions.func(
            drawBody, 
            arguments,
            null,
            null,
            false));
        classBuilder.addMember(drawMember);

	}

    static public function getShaderGroupFromMetadata(metadata : Metadata) : GLSLShaderGroup{
        var pos = Context.currentPos();

        var vertexShaderFilePath : String = null;
        var fragmentShaderFilePath : String = null;

        var metadataValues = metadata.getValues("shaders");
        if(metadataValues.length != 1){
            Context.error("There should be exactly 1 shader pair", pos); 
            return null;
        }

        var value = metadataValues[0][0];


        switch(value.expr){
            case EObjectDecl(values) :
                for (value in values){
                    switch (value.field){
                        case "vertex" : 
                            vertexShaderFilePath = extractShaderMetdata(value.expr);
                        case "fragment" : 
                            fragmentShaderFilePath = extractShaderMetdata(value.expr);
                        default : 
                            Context.warning("field " + value.field + " not supported for @shaders metadata", pos);
                    }
                }

            default : Context.error("The metadata should be an object declaration", pos); return null;
        }

        return GLSLShaderGroup.get(vertexShaderFilePath, fragmentShaderFilePath);
    }


	static function extractShaderMetdata(expr : Expr) : String{
		var pos = Context.currentPos();
		return switch (expr.expr){
    		case EConst(c) :
                switch (c){
                    case CString(s): s;
                    default : Context.error("The shader value should be a String", pos); null;
                }
            default: Context.error("The shader value should be a Constant", pos); null;
        }
	}
}