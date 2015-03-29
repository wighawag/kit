package boot;

import tink.core.Future;

interface AssetLoader<T> {
    public function load(assetId : AssetId, ?path : String = null) : Surprise<T, String>;
}
