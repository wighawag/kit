package cosmos.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;

import sys.FileSystem;
import sys.io.File;

class Generator
{
	macro public static function generateComponents() : Expr{
		var pos = Context.currentPos();


		//TODO trace(Context.definedValue("cosmos-path"));
		var componentPackage = "cosmos.components";
		var entityComponentPackage = componentPackage + ".entity";
		var typeComponentPackage = componentPackage + ".type";
		var entityComponentPath = entityComponentPackage.split(".").join("/");
		var typeComponentPath = typeComponentPackage.split(".").join("/");

		Compiler.addGlobalMetadata(componentPackage,"@:build(cosmos.macro.ComponentMacro.apply())");

		var classpaths = Context.getClassPath();

		var entityComponents = new Array<String>();
		for(classPath in classpaths){
			var dirpath = classPath + "/" + entityComponentPath; 
			if (FileSystem.exists(dirpath)){
				var modules = FileSystem.readDirectory(dirpath);
				for (module in modules){
					var moduleTypes = Context.getModule(entityComponentPackage + "." + module.split(".")[0]);
					for(moduleType in moduleTypes){
						switch (moduleType) {
							case TInst(t,params):
								entityComponents.push(t.get().name);
							default: Context.warning("ignoring " + moduleType,pos);
						}
					}
					//trace(Context.getModule(entityComponentPackage + "." + module.split(".")[0]));
					//entityComponents.push(module.split(".")[0]);

				}
			}
		}

		var typeComponents = new Array<String>();
		for(classPath in classpaths){
			var dirpath = classPath + "/" + typeComponentPath; 
			if (FileSystem.exists(dirpath)){
				var modules = FileSystem.readDirectory(dirpath);
				for (module in modules){
					var moduleTypes = Context.getModule(typeComponentPackage + "." + module.split(".")[0]);
					for(moduleType in moduleTypes){
						switch (moduleType) {
							case TInst(t,params):
								typeComponents.push(t.get().name);
							default: Context.warning("ignoring " + moduleType,pos);
						}
					}
					//trace(Context.getModule(typeComponentPackage + "." + module.split(".")[0]));
					//typeComponents.push(module.split(".")[0]);
				}
			}
		}
		
		//TODO remove
		trace("entityComponents : " + entityComponents);
		trace("typeComponents : " + typeComponents);
		
		//use md5sum to not regenerate same file //add define to force-regneration
		//TODO parse cosmos.json and create class for each component defined
		//create an Entity class that contain field for each

		Context.defineType({pos:pos,pack:[],name:"Test", kind:TDEnum, fields:[]});

		File.saveContent("src/cosmos/Boom.hx", "package cosmos; class Boom{ public function new(){} }");

		//Context.error("dsdsd",pos);
		return null;
	}
}