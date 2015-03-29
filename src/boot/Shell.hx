package boot;

import boot.Runnable;

class Shell<T> implements Runnable{

	public var data(default,null) : T;

	var screens : Array<Screen<T>>;
	var currentIndex : Int = 0;
	var currentScreen : Screen<T>;

	public function new (data : T, screens : Array<Screen<T>>){
		this.data = data;
		this.screens = screens;
	}

	public function start(now : Float):Void{
		currentIndex = 0;
        enterScreen(now);
	}

	function enterScreen(now : Float){
        currentScreen = screens[currentIndex];
        currentScreen.enter(this, now);
    }

	public function update(now : Float, dt : Float):Void{

        var done = currentScreen.update(now, dt);
        if (done) {
            currentScreen.quit(now);
            currentIndex++;
            if (currentIndex >= screens.length) {
                currentIndex = 0;
                //TODO
            }
            enterScreen(now);
        }
	}

}