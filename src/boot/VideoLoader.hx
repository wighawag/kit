package boot;

import loka.asset.Loader;
import boot.AssetId;
import tink.core.Future;
import tink.core.Outcome;
import loka.asset.Video;

typedef VideoOutcome = Outcome<Video, String>;

class VideoLoader implements AssetLoader<Video>{

	private var futures : Map<AssetId,Future<VideoOutcome>>;

	public function new() {
		futures = new Map();
	}

	public function load(assetId : AssetId, ?path = null) : Future<VideoOutcome>{
		if (path == null){
			path = assetId;
		}

  		var future  = futures.get(assetId);
        if (future != null){
            return future;
        }

		future = Future.async(function (handler:VideoOutcome->Void) {
			var loader = new Loader();
			loader.loadVideo(path,
				function (data) handler(Success(data)),
				function (error) handler(Failure(error))
				);
	    });
        
		
        return future;
	}

}