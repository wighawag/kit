package jsloka.input;

//TODO should use events : create Abstract Event to keep same signature

import js.html.CanvasElement;
import js.html.KeyboardEvent;

abstract Key(Int) to(Int){
	inline public function new(value : Int){
		this = value;
	}
}

class Keyboard{


	var _canvas : CanvasElement;
	var _keysDown : Map<Key,Bool>;
	
	private function new(canvas : CanvasElement){
		_canvas = canvas;
		_keysDown = new Map();
		_canvas.addEventListener('keydown', keyDown, false);
		_canvas.addEventListener('keyup', keyUp, false);
	}

	function keyDown(e : KeyboardEvent){
		_keysDown[new Key(e.keyCode)] = true;
	}

	function keyUp(e : KeyboardEvent){
		_keysDown[new Key(e.keyCode)] = false;	
	}

	inline public function isDown(key : Key):Bool{
		return _keysDown[key];
	}


	public static inline var A : Key = new Key(65);
	public static inline var B : Key = new Key(66);
	public static inline var C : Key = new Key(67);
	public static inline var D : Key = new Key(68);
	public static inline var E : Key = new Key(69);
	public static inline var F : Key = new Key(70);
	public static inline var G : Key = new Key(71);
	public static inline var H : Key = new Key(72);
	public static inline var I : Key = new Key(73);
	public static inline var J : Key = new Key(74);
	public static inline var K : Key = new Key(75);
	public static inline var L : Key = new Key(76);
	public static inline var M : Key = new Key(77);
	public static inline var N : Key = new Key(78);
	public static inline var O : Key = new Key(79);
	public static inline var P : Key = new Key(80);
	public static inline var Q : Key = new Key(81);
	public static inline var R : Key = new Key(82);
	public static inline var S : Key = new Key(83);
	public static inline var T : Key = new Key(84);
	public static inline var U : Key = new Key(85);
	public static inline var v : Key = new Key(86);
	public static inline var W : Key = new Key(87);
	public static inline var X : Key = new Key(88);
	public static inline var Y : Key = new Key(89);
	public static inline var Z : Key = new Key(90);

	public static inline var SPACE : Key = new Key(32);
	public static inline var ENTER : Key = new Key(13);
	public static inline var TAB : Key = new Key(9);
	public static inline var ESC : Key = new Key(27);
	public static inline var BACKSPACE : Key = new Key(8);

	public static inline var SHIFT : Key = new Key(16);
	public static inline var CONTROL : Key = new Key(17);
	public static inline var ALT : Key = new Key(18);
	public static inline var CAPS_LOCK : Key = new Key(20);
	public static inline var NUM_LOCK : Key = new Key(144);

	public static inline var ZERO : Key = new Key(48);
	public static inline var ONE : Key = new Key(49);
	public static inline var TWO : Key = new Key(50);
	public static inline var THREE : Key = new Key(51);
	public static inline var FOUR : Key = new Key(52);
	public static inline var FIVE : Key = new Key(53);
	public static inline var SIX : Key = new Key(54);
	public static inline var SEVEN : Key = new Key(55);
	public static inline var EIGHT : Key = new Key(56);
	public static inline var NINE : Key = new Key(57);

	public static inline var LEFT : Key = new Key(37);
	public static inline var UP : Key = new Key(38);
	public static inline var RIGHT : Key = new Key(39);
	public static inline var DOWN : Key = new Key(40);

	public static inline var INSERT : Key = new Key(45);	
	public static inline var DELETE : Key = new Key(46);
	public static inline var HOME : Key = new Key(36);
	public static inline var END : Key = new Key(35);
	public static inline var PAGEUP : Key = new Key(33);
	public static inline var PAGEDOWN : Key = new Key(34);

	public static inline var F1 : Key = new Key(112);
	public static inline var F2 : Key = new Key(113);
	public static inline var F3 : Key = new Key(114);
	public static inline var F4 : Key = new Key(115);
	public static inline var F5 : Key = new Key(116);
	public static inline var F6 : Key = new Key(117);
	public static inline var F7 : Key = new Key(118);
	public static inline var F8 : Key = new Key(119);
	public static inline var F9 : Key = new Key(120);
	public static inline var F10 : Key = new Key(121);
	public static inline var F11 : Key = new Key(122);
	public static inline var F12 : Key = new Key(123);
}