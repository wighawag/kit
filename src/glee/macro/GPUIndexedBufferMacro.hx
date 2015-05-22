package glee.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.Functions;
import tink.macro.Member;
using tink.MacroApi;
using belt.MacroUtils;

class GPUIndexedBufferMacro{

	static var indexBufferTypes : Map<String,ComplexType> = new Map();

	macro static public function apply() : ComplexType{

        var pos = Context.currentPos();

        var localType = Context.getLocalType();

        var bufferType = GPUBufferMacro.getBufferTypeFromLocalType(localType,pos); 
        
        var typePath = 
        switch(bufferType){
        	case TPath(p): p;
        	default: null;
        }

        if(typePath == null){
        	//TODO error
        	return null;
        }
        
        if(indexBufferTypes.exists(typePath.name)){
        	return indexBufferTypes[typePath.name];
        }

        var indexedBufferName = "Indexed" + typePath.name;

        var indexedBuffer = generateIndexedBuffer(indexedBufferName, typePath, pos);
        indexBufferTypes[typePath.name] = indexedBuffer;

        return indexedBuffer;
    }

    static function generateIndexedBuffer(name : String, superClass : TypePath, pos : Position){

        //TODO do not use _writeIndex in base class (GPUBufferBase)? 

    	var fields = []; 
        var arguments = [Functions.toArg("i",macro : Int)];
        var body = macro _writeIndex(i);
        fields.push(Member.method("writeIndex",Functions.func(body,arguments)));

    	var definedType : TypeDefinition = {
    		pos:pos,
    		pack:["glee", "buffer"],
    		name:name,
    		kind:TDClass(superClass,[], false), 
    		fields:fields};
    	Context.defineType(definedType);

    	return TPath({pack:["glee","buffer"], name:name});
    }

 

}