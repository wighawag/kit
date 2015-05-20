package jsloka.asset;


abstract Image(js.html.Image) to(js.html.Image){
	inline public function new(image : js.html.Image){
		this = image;
	}
}
