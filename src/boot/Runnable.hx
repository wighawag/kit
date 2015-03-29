package boot;

interface Runnable{
	function start(now : Float):Void;
	function update(now : Float, dt : Float):Void;
}