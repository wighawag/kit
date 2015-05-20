package control;

import loka.App;


@:access(control.Mouse, control.Keyboard)
class Input{

	private static var _mouse : Mouse;
	private static var _keyboard : Keyboard;

	public static function initMouse() : Mouse{
		if(_mouse != null){
			return _mouse;
		}

		_mouse = new Mouse(App.initMouse());
		return _mouse;
	}

	public static function initKeyboard() : Keyboard{
		if(_keyboard != null){
			return _keyboard;
		}

		_keyboard = new Keyboard(App.initKeyboard());
		return _keyboard;
	}
}