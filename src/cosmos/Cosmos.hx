package cosmos;


import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Context;
#if macro
import sys.io.File;
#end

class Cosmos
{
	private static var entityTypeDefinitions : Map<String,TypeDefinition>;


	macro public static function addEntity(model : ExprOf<Model>, components : ExprOf<Array<{}>>):Expr{
		var pos = Context.currentPos();

		var pack = [];
		var name = "";
		
		trace("----------------------");
		switch(components.expr){
			case EArrayDecl(declarations): 
				for(decl in declarations){
					switch(decl.expr){
						case ENew(typePath, params):
							trace("TYPE : " + Context.getType(typePath.name));
						case EConst(constant):
							switch(constant){
								case CIdent(ident):
								 	var type = Context.getType(ident);
								 	if(type != null){
								 		trace("TYPE : " + type);
							 		}else{
							 			//TODO remove as it get TDynamic
										trace("TYPE : " + ident + " : " + Context.getLocalVars()[ident]);
							 		}
									
								default:  Context.error("not supported " + components,pos);
							}

						//TODO Recursive EField access to support qualified name
						// case EField(expr,fieldName):
						// 	switch(expr.expr){
						// 		case EConst(constant):
						// 			switch(constant){
						// 				case CIdent(ident):

						// 				default: Context.error("not supported " + components,pos);
						// 			}
						// 		default: Context.error("not supported " + components,pos);
						// 	}


						default : Context.error("not supported " + components,pos);
					}
				}
			default:Context.error("not supported " + components,pos);
		}
		

		var kind = TDClass({pack:["cosmos"],name:"Entity"},[],false);
		var fields = [];

		var complexType = TPath({
			pack:pack,
			name:name
			});

		Context.defineType({
			pos:pos,
			pack:pack,
			name:name,
			kind:kind,
			fields:fields
			});

		return macro 1;//cosmos.test();
	}

	
}