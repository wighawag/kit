package cosmos.macro;

import haxe.macro.Expr;

class SystemMacro
{

	macro public static function apply() : Array<Field> {
        var context = haxe.macro.Context;
        var pos = context.currentPos();

        // get the Component Class
        var localClass = context.getLocalClass().get();

        // if it is an interface, skip as we are here implementing methods
        if (localClass.isInterface){
            return null;
        }

        // get the fields of the current class
        var fields = context.getBuildFields();
        trace(fields);

        return fields;
    }
}