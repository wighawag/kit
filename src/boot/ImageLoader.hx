package boot;

import loka.asset.Loader;
import boot.AssetId;
import tink.core.Future;
import tink.core.Outcome;
import loka.asset.Image;

typedef ImageOutcome = Outcome<Image, String>;

class ImageLoader implements AssetLoader<Image>{

	private var futures : Map<AssetId,Future<ImageOutcome>>;

	public function new() {
		futures = new Map();
	}

	public function load(assetId : AssetId, ?path = null) : Future<ImageOutcome>{
		if (path == null){
			path = assetId;
		}

  		var future  = futures.get(assetId);
        if (future != null){
            return future;
        }

		future = Future.async(function (handler:ImageOutcome->Void) {
			var loader = new Loader();
			loader.loadImage(path,
				function (data) handler(Success(data)),
				function (error) handler(Failure(error))
				);
	    });
        
		
        return future;
	}

}