package boot;

import boot.AssetId;
import tink.core.Outcome;
import tink.core.Future;

typedef BatchOutcome<T> = Outcome<Batch<T>, Array<Outcome<T,String>>>;

private typedef TmpBatchOutcome<T> = Outcome<{data:T, id:AssetId},String>;

class Batch<T> implements AssetStore<T> {

    inline static public function load<T>(assetLoader : AssetLoader<T>, ids : Array<AssetId>, ?paths : Array<String> = null) : Future<BatchOutcome<T>>{
        if(paths == null){
            paths = ids;
        }

        
        while(paths.length < ids.length ){
            paths.push(ids[paths.length]);
        }

        var allFutures : Array<Future<TmpBatchOutcome<T>>> = [];
        for (i in 0...paths.length){
            var path = paths[i];
            var id = ids[i];
            var future = assetLoader.load(path).map(function(o){
                switch(o){
                    case Success(d):return Success({data:d,id:id});
                    case Failure(e): return Failure(e);
                }
            });
            allFutures.push(future);         
        }        

        var futureForAll : Future<Array<TmpBatchOutcome<T>>> = allFutures;
        
        var futureTrigger : FutureTrigger<BatchOutcome<T>> = Future.trigger();

        futureForAll.handle(function(outcomes : Array<Outcome<{data:T, id:AssetId},String>>){
                var data = new Map<AssetId,T>();
                var originalOutcomes = new Array<Outcome<T,String>>();
                var atleastOneFailed = false;
                for (outcome in outcomes){
                    switch(outcome){
                        case Success(d): 
                            data.set(d.id,d.data);
                            originalOutcomes.push(Success(d.data));
                        case Failure(error): 
                            atleastOneFailed = true;
                            originalOutcomes.push(Failure(error));
                    }
                }

                if(atleastOneFailed){
                    futureTrigger.trigger(Failure(originalOutcomes));
                }else{
                    futureTrigger.trigger(Success(new Batch(data)));
                }
                
            });

        return futureTrigger.asFuture();
    }


    private var dict : Map<AssetId,T>;

    public function new(items : Map<AssetId,T>) {
        dict = new Map();
        for (itemId in items.keys()){
            dict.set(itemId, items[itemId]);
        }
    }

    public function get(assetId : AssetId) : T{
        return dict.get(assetId);
    }

    //TODO iterator
    public function all() : Array<T>{
        var all : Array<T> = new Array();
        for ( t in dict){
            all.push(t);
        }
        return all;
    }

}
