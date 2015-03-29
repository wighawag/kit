package belt;


import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

class ArgumentNameMacro{


	static public function generateFunctionCall(that : Expr,args : Expr, functionName : String, type : Type, pos : Position, errorOnExtraParams : Bool = true) : Expr{
		var error : Bool = false;

		var argExprMap = new Map<String,Expr>();
		var argsToCall = new Array<Expr>();

		switch(args.expr){
			case EObjectDecl(fields):
				for(field in fields){
					argExprMap[field.field] = field.expr;
				}

			default : trace("need to be an EObjectDecl (Anonymous Object)");
		}
		switch(type){
			case TInst(tRef, params):
				var classType = tRef.get();
				var fields = classType.fields.get();
				var field = getFieldByName(fields,functionName);
				if(field == null){

				}else{
					switch(field.type){
						case TFun(funArgs,ret):
							for (funArg in funArgs){
								var exprToMove = argExprMap[funArg.name];
								if(exprToMove == null){
									trace("missing argument : " + funArg.name);
								}else{
									argExprMap.remove(funArg.name);
									argsToCall.push(exprToMove);
								}
							}
						default: trace("not supported " + field.type);
					}
				}
				
		 	default : trace("not supported : " + type);
		}


		for(argName in argExprMap.keys()){
			if(errorOnExtraParams){
				error = true;
			}
			trace(argName + " not needed");
		}

		if(error){
			return null;
		}

		var caller = macro $e{that};
		
		var field = {expr:EField(caller, functionName), pos : pos};
		var call = {expr : ECall(field, argsToCall), pos:pos};
		
		return call;
	}

	static private function getFieldByName(fields : Array<ClassField>, name : String): ClassField{
		for (field in fields){
			if(field.name == name){
				return field;
			}
		}
		return null;
	}
}