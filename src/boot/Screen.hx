package boot;

interface Screen<T>{
	function enter(shell : Shell<T>, now : Float) : Void;
    function update(now : Float, dt : Float) : Bool;
    function quit(now : Float) : Void;
}