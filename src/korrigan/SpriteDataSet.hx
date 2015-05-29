package korrigan;

import haxe.DynamicAccess;

typedef TexturedQuadMeshData =  {x1:Float,y1:Float, x2:Float,y2:Float,u1:Float,v1:Float, u2:Float,v2:Float, refX : Float, refY : Float};
typedef FrameData = {textureCutOut : String, ?meshData : TexturedQuadMeshData, ?overrideMsDuration : Int, ?scaleX : Float, ?scaleY : Float};
typedef AnimationData = {frames:Array<FrameData>, defaultMsDuration:Int,?loopStartFrame:Int};
typedef SpriteData = DynamicAccess<AnimationData>;

typedef SpriteDataSet = {textureAtlas:String, sprites:DynamicAccess<SpriteData>};
typedef TexturePlacement = {
	//textureId :textureCutOut.textureId,
    srcX1 : Float,
    srcY1 : Float,
    srcX2 : Float,
    srcY2 : Float,
    dstX1 : Float,
    dstY1 : Float,
    dstX2 : Float,
    dstY2 : Float,
    dstX3 : Float,
    dstY3 : Float,
    dstX4 : Float,
    dstY4 : Float,
    dstZ : Float,
}
