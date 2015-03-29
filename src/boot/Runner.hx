package boot;

import haxe.Timer;

class Runner{

	var runnable : Runnable;
	var lastNow : Float;
	var timer : Timer;

	public function new(runnable : Runnable){
		this.runnable = runnable;
	}

	public function start(?fps : Int = 30):Void{
		lastNow = Timer.stamp();
		this.runnable.start(lastNow);
		timer = new Timer(Std.int(1000 / fps));
		timer.run = update;
	}

	public function update():Void{
		var now = Timer.stamp();
		var delta = now - lastNow;
		lastNow = now;
		runnable.update(now,delta);
	}

}