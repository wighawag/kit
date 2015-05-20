package control;

import loka.input.KeyboardEvent;
import loka.input.Key;

class Keyboard{

	var _keyboard : loka.input.Keyboard;
	var _keysDown : Map<Key,Bool>;
	
	private function new(keyboard : loka.input.Keyboard){
		_keyboard = keyboard;
		_keysDown = new Map();
		_keyboard.onKeyDown(keyDown);
		_keyboard.onKeyUp(keyUp);
	}

	function keyDown(e : KeyboardEvent){
		_keysDown[e.keyCode] = true;
	}

	function keyUp(e : KeyboardEvent){
		_keysDown[e.keyCode] = false;	
	}

	inline public function isDown(key : Key):Bool{
		return _keysDown[key];
	}

}