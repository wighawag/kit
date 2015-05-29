package boot;

import loka.asset.Loader;

using StringTools;
using tink.CoreApi;

typedef AssetsOutcome = Outcome<Assets,{partialResult : Assets, failures : Array<String>, successes : Array<AssetId>}>;

private typedef TmpOutcome = Outcome<{data:Dynamic, id:AssetId},String>;

@:access(boot.Assets)
class GenericAssetLoader{

	public static function init() : GenericAssetLoader{
		return new GenericAssetLoader();
	}

	var loader : Loader;

	private function new(){
		loader = new Loader();
	}

	public function load(ids : Array<AssetId>):Future<AssetsOutcome>{

		//TODO paths :
		var paths = null;

		if(paths == null){
            paths = ids;
        }

        while(paths.length < ids.length ){
            paths.push(ids[paths.length]);
        }

		var allFutures : Array<Future<TmpOutcome>> = [];
        for (i in 0...paths.length){
            var path = paths[i];
            var id = ids[i];
            var future = loadOne(path).map(function(o){
                switch(o){
                    case Success(d):return Success({data:d,id:id});
                    case Failure(e): return Failure(e);
                }
            });
            allFutures.push(future);         
        }        

        var futureForAll : Future<Array<TmpOutcome>> = allFutures;
        
        var futureTrigger : FutureTrigger<AssetsOutcome> = Future.trigger();

        futureForAll.handle(function(outcomes : Array<TmpOutcome>){
                var data = new Map<AssetId,Dynamic>();
                var failures = new Array<String>();
                var successes = new Array<AssetId>();
                var atleastOneFailed = false;
                for (outcome in outcomes){
                    switch(outcome){
                        case Success(d): 
                            data.set(d.id,d.data);
                            successes.push(d.id);
                        case Failure(error): 
                            atleastOneFailed = true;
                            failures.push(error);
                    }
                }

                if(atleastOneFailed){
                    futureTrigger.trigger(Failure({
                    	partialResult : new Assets(data), 
                    	failures:failures,
                    	successes:successes
                    	}));
                }else{
                    futureTrigger.trigger(Success(new Assets(data)));
                }
                
            });

        return futureTrigger.asFuture();
	}

	private function loadOne(path : String) : Future<Outcome<Dynamic, String>>{
		if(path.endsWith(".png")){
			return loadImage(path);
		}
		if(path.endsWith(".jpeg")){
			return loadImage(path);
		
		}
		if(path.endsWith(".jpg")){
			return loadImage(path);
		
		}
		if(path.endsWith(".json")){
			return loadText(path);
		}

		//TODO unsuported
		//for now default to text
		return loadText(path);

	}

	private function loadImage(path : String) : Future<Outcome<Dynamic, String>>{

		return Future.async(function (handler: Outcome<Dynamic, String>->Void) {
			loader.loadImage(path,
				function (data) handler(Success(data)),
				function (error) handler(Failure(error))
				);
	    });
	}

	private function loadText(path : String) : Future<Outcome<Dynamic, String>>{

		return Future.async(function (handler: Outcome<Dynamic, String>->Void) {
			loader.loadText(path,
				function (data) handler(Success(data)),
				function (error) handler(Failure(error))
				);
	    });
	}
}