package jsloka.asset;

import jsloka.asset.Image;
import js.html.Document;
import jsloka.asset.Video;



abstract Loader(Document){
	
	inline public function new(){
		this = js.Browser.document;
	}

	//TODO macro embedding of Image ?
	inline public function loadImage(url : String, success : Image->Void, error : String -> Void):Void{
		var image = new js.html.Image();
		image.onload = function(_){
			success(new Image(image));
		}
		image.onerror = function(_){
			error("failed to load " + url);
		}
		image.src = url;
	}

	//TODO macro embedding of Text
	inline public function loadText(url : String, success : String->Void, error : String -> Void):Void{
		var http = new haxe.Http(url);
		http.onData = success;
		http.onError = error;
		//TODO ? http.onStatus = 
		http.request();
	}

	//TODO macro embedding of Video
	inline public function loadVideo(url : String, success : Video->Void, error : String -> Void):Void{
		var video : js.html.VideoElement = cast this.createElement('video');

		//TODO support error and type detection (from extension)
		if (video.canPlayType('video/mp4').length > 0) {
 			video.src = 'loop1.mp4';
			untyped video.autoPlay = false;
			video.loop = false;
			untyped video.oncanplay = function(){
				success(new Video(video));
			};
			untyped video.onloadedmetadata = function () {
		        //TODO ?
		    };
		}else{
			error("cannot play the video (mp4 not supported)");
		}

	}
}