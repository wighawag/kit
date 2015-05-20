package jsloka.asset;

//TODO decide if we use these names:
@:forward(loop,play,videoWidth,videoHeight)
abstract Video(js.html.VideoElement) to(js.html.VideoElement){
	inline public function new(video : js.html.VideoElement){
		this = video;
	}
}