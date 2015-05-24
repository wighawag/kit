package korrigan;

typedef CutOut = {
	x1 : Int,
	y1 : Int,
	x2 : Int,
	y2 : Int,
	refX : Int,
	refY : Int,
}

// class TextureAtlas{
// 	public var width(default,null) : Int;
// 	public var height(default,null) : Int;
// 	public var cutOuts(default,null):Map<String,CutOut>;
// }

typedef TextureAtlas = {
	bitmapId : String,
	width : Int,
	height : Int,
	cutOuts : Map<String, CutOut> //TODO DynamicAccess
}