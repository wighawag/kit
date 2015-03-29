package boot;

import loka.asset.Loader;
import boot.AssetId;
import tink.core.Future;
import tink.core.Outcome;


typedef TextOutcome = Outcome<String, String>;

class TextLoader implements AssetLoader<String>{

	private var futures : Map<AssetId,Future<TextOutcome>>;

	public function new() {
		futures = new Map();
	}

	public function load(assetId : AssetId, ?path = null) : Future<TextOutcome>{
		if (path == null){
			path = assetId;
		}

  		var future  = futures.get(assetId);
        if (future != null){
            return future;
        }

		future = Future.async(function (handler:TextOutcome->Void) {
			var loader = new Loader();
			loader.loadText(path,
				function (data) handler(Success(data)),
				function (error) handler(Failure(error))
				);
	    });
        
		
        return future;
	}

}