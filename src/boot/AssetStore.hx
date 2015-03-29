package boot;

interface AssetStore<T> {
    function get(assetId : AssetId) : T;
    function all() : Array<T>; // TODO use Iterator
}
