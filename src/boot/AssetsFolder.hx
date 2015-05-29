package boot;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

import sys.FileSystem;

class AssetsFolder{

	public static function apply(folder:String):Array<Field>
    {
    	var output = Compiler.getOutput();
    	var outputDir = output.substr(0,output.lastIndexOf("/"));

    	folder = folder + "/";
    	outputDir = outputDir + "/" + folder;
        var fileReferences:Array<FileRef> = [];
        var fileNames = recursiveReadFolder(outputDir);
        for (fileName in fileNames){
            if (!FileSystem.isDirectory(outputDir + fileName)){
                fileReferences.push(new FileRef(fileName, folder + fileName));
            }
        }
       
       	var all = new Array<String>(); 
        var fields:Array<Field> = Context.getBuildFields();
        for (fileRef in fileReferences)
        {
            fields.push({
                    name: fileRef.name,
                    doc: fileRef.documentation,
                    access: [Access.APublic, Access.AStatic, Access.AInline],
                    kind: FieldType.FVar(macro:String, macro $v{fileRef.value}),
                    pos: Context.currentPos()
                });
            all.push(fileRef.value);
        }

         fields.push({
                    name: "ALL",
                    doc: null, //TODO ?
                    access: [Access.APublic, Access.AStatic],
                    kind: FieldType.FVar(macro:Array<String>, macro $v{all}),
                    pos: Context.currentPos()
                });

        return fields;
    }

    private static function recursiveReadFolder(folderPath : String, ?root : String = "", ?filePaths : Array<String> = null) : Array<String>{
		if(filePaths == null){
			filePaths = new Array<String>();
		}
		var files = FileSystem.readDirectory(folderPath);
		for (fileName in files){
			var filePath = folderPath + "/" + fileName;
			if (FileSystem.isDirectory(filePath)){
				recursiveReadFolder(filePath, root + fileName + "/", filePaths);
			}else{
				filePaths.push(root + fileName);				
			}
		}
		return filePaths;
	}
}

// internal class
class FileRef
{
    public var name:String;
    public var value:String;
    public var documentation:String;
   
    public function new(name : String, value:String)
    {
        this.value = value;
       
        // replace forbidden characters to underscores, since variables cannot use these symbols.
        this.name = name.split("-").join("_").split(".").join("__").split("/").join("_");
       
        // generate documentation
        this.documentation = "Reference to file on disk \"" + value + "\". (auto generated)";
    }
}