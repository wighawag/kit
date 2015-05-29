package boot;

@:build(boot.AssetsFolder.apply("assets"))
class Assets{

	private var _assets : Map<AssetId,Dynamic>;

	private function new(assets : Map<AssetId, Dynamic>){
		_assets = assets;
	}

	public function get<T>(assetId : AssetId): T{
		if(!_assets.exists(assetId)){
			trace("not found " + assetId);
			return null;
		}
		var result : T = cast _assets[assetId];
		if(result == null){
			trace(assetId + " is not of the type asked. Its type is " + Type.getClassName(Type.getClass(result)));
		}
		return result;
	}

}