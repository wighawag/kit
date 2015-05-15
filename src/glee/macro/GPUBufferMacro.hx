package glee.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.Functions;
import tink.macro.Member;
using tink.MacroApi;
using belt.MacroUtils;

class GPUBufferMacro{

    static var bufferTypes : Map<String,ComplexType> = new Map();
    static var bufferTypeNames : Map<String,String> = new Map();
    static var numBufferTypes : Int =0;

	macro static public function apply() : ComplexType{

        var pos = Context.currentPos();

        var localType = Context.getLocalType();

        var typeParam = switch (localType) {
            case TInst(_,[tp]):
                switch(tp){
                    case TType(t,param): t.get().type;
                    case TAnonymous(t) : tp;
                    default : null;
                }
            default:null;
        }
        if(typeParam == null){
            //Still alow specifying buffer via their porgram
            switch (localType) {
            case TInst(_,[t]):
                switch(t){
                    case TInst(ref,_):
                        var programType = ref.get();
                        var metadata = programType.meta.get();
                        var shaderGroup = glee.macro.GPUProgramMacro.getShaderGroupFromMetadata(metadata);
-                       return getBufferClassFromAttributes(shaderGroup.attributes);
                    case TMono(_): Context.error("need to specify the program type explicitly, no type inference supported", pos);
                    default: Context.error("unsuported type : " +  localType, pos);
                }
                default: Context.error("unsuported type : " +  localType, pos);
            }
        }

        if(typeParam == null){
            Context.error("type param not found",pos);
        }

        var fields = switch(typeParam){
            case TInst(ref,_):
                 ref.get().fields.get();
            case TMono(mono):  Context.error("need to specify the program type explicitely, no type inference : " + typeParam + " (" + mono.get() + ")",pos); null; 
            case TAnonymous(ref):
                ref.get().fields;
            default: null;
        }

        if(fields == null){
            Context.error("type param not supported " + typeParam, pos);
            return null;
        }

        var attributes = new Array<glee.GLSLShaderGroup.Attribute>();
        for (field in fields){
            switch(field.type){
                case TAbstract(t,_):
                    var abstractType = t.get();
                    if(abstractType.pack.length == 1 && abstractType.pack[0] == "glmat"){
                        attributes.push({name:field.name, type:TPath({name :abstractType.name, pack :abstractType.pack})});    
                    }else{
                        Context.error("attribute type not supported " + abstractType, pos);
                        return null; 
                    }
                default : 
                    Context.error("attribute type not supported " + field.type, pos);
                    return null;
            }
        }


        var bufferType = getBufferClassFromAttributes(attributes);

        return bufferType;
    }

    static public function getBufferClassFromAttributes(attributes : Array<glee.GLSLShaderGroup.Attribute>) : ComplexType{
        var pos = Context.currentPos();
        var bufferClassPath = getBufferClassPathFromAttributes(attributes);

        if (bufferTypes.exists(bufferClassPath.name)){
            //trace("already generated " + bufferClassPath.name);
            return bufferTypes[bufferClassPath.name];
        }


        var fields : Array<Field> = [];


        var getNumVerticesWrittenBody = macro {var max : Float = 0;};

        var rewindBody = macro {
        };
        

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

        var stride = 0;   
        for (attribute in attributes){
            var attributeName = attribute.name;
            var attributeMetadataName = "_" + attributeName + "_bufferPosition";

            getNumVerticesWrittenBody.append(macro max = Math.max(max,$i{attributeMetadataName}));            

            rewindBody.append(macro  $i{attributeMetadataName} = 0);

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

            //////////////////////initialization //////////////////////////////////////////
            
            
            fields.push({
                name: attributeMetadataName,
                pos: pos,
                access: [APrivate],
                kind: FVar(macro : Int,macro 0), //TODO -1 or 0 ? 
                });
       

            /////////////////////// write function ////////////////////////////////////////////
            var body = macro {
                uploaded = false;
                if(_float32Array == null) {
                    _float32Array = new loka.util.Float32Array(512);
                }
                if (_float32Array.length <= $i{attributeMetadataName} * $v{totalStride} + $v{numValues}) {
                    var newArray = new loka.util.Float32Array(_float32Array.length * 2); //TODO inline growing in javascript
                    //TODO : copy values
                    _float32Array = newArray;
                }


                var pos : Int = $i{attributeMetadataName} * $v{totalStride} + $v{stride}; 
                $i{attributeMetadataName} ++;
            }

            for (i in 0...numValues){
                var arg = "v" + i;
                body.append(macro  _float32Array[pos+$v{i}] = $i{arg});
            }

            //trace(body.toString());

            var arguments = [];                                         
            var attrTPath = switch(cast attribute.type){
                case TPath(att): att;
                default: Context.error("should be a TPath", pos); null;
            };                              
            
            if(attrTPath.name.substr(0,3) == "Vec"){          
                for (i in 0...numValues){                                 
                    arguments.push(                                 
                    Functions.toArg("v"+i,macro : Float)
                    );                                              
                }                                                   
            }else if(attrTPath.name == "Float"){
                arguments.push(                                     
                    Functions.toArg("v0",macro : Float)             
                    );                    
            } 
            
            fields.push(Member.method("write_" + attribute.name,Functions.func(body,arguments)));            
            stride+= numValues; //work for samme types attributes //TODO make it work for mixed types Int/Float...
        }

        getNumVerticesWrittenBody.append(macro return Std.int(max));
        fields.push(Member.method("getNumVerticesWritten",Functions.func(getNumVerticesWrittenBody)));        

        fields.push(Member.method("rewind",Functions.func(rewindBody)));


        var typeDefinition : TypeDefinition = {
            pos : pos,
            pack : bufferClassPath.pack,
            name : bufferClassPath.name,
            kind :TDClass({pack :["glee"], name: "GPUBufferBase"},[], false),
            fields:fields
        }
        Context.defineType(typeDefinition);


        var bufferType = TPath(bufferClassPath);
        bufferTypes[bufferClassPath.name] = bufferType;
        return bufferType;
    } 

    static private function getBufferClassPathFromAttributes(attributes : Array<glee.GLSLShaderGroup.Attribute>): TypePath{
        var bufferClassName =  "Buffer_";
        attributes = attributes.copy();
        attributes.sort(function(x,y){
            if(x.name == y.name){
                return 0;
            }
            return x.name < y.name ? -1 : 1;
            });
        for (attribute in attributes){
            bufferClassName += attribute.name + attribute.type;
        }
        bufferClassName = StringTools.urlEncode(bufferClassName);
        bufferClassName = StringTools.replace(bufferClassName,"%","_");

        if (bufferTypeNames.exists(bufferClassName)){
            //trace("already generated " + bufferClassPath.name);
            bufferClassName = bufferTypeNames[bufferClassName];
        }else{
            //TODO use different naming
            numBufferTypes++;
            var newBufferClassName = "Buffer_" + numBufferTypes;
            bufferTypeNames[bufferClassName] = newBufferClassName;
            bufferClassName = newBufferClassName;
        }
        
        var bufferClassPath = {pack:["glee", "buffer"],name:bufferClassName};

        return bufferClassPath;
    }

    static private function generateFieldsFromTypeParameter(classBuilder : ClassBuilder):Void{

        var pos = Context.currentPos();

        var target = classBuilder.target;
        if (target.isInterface){
            return;
        }

       

	}
}