package boot;

import boot.Assets.AssetsOutcome;
import boot.Batch.BatchOutcome;
import tink.core.Outcome;
import tink.core.Future;
import loka.asset.Image;

typedef AssetsError = {textOutcomes : Array<Outcome<String,String>>, imageOutcomes : Array<Outcome<Image,String>>};
typedef AssetsOutcome = Outcome<Assets,AssetsError>;


class Assets{

	private static var textLoader = new TextLoader();
	private static var imageLoader = new ImageLoader();

	public static function load(texts : Array<String>, images : Array<String>) : Future<AssetsOutcome>{

		var textsFuture = Batch.load(textLoader,texts);
		var imagesFuture = Batch.load(imageLoader,images);

		return textsFuture.merge(imagesFuture, function(textBatch : BatchOutcome<String>, imageBatch : BatchOutcome<Image>) : AssetsOutcome{
			var resultingTexts : Batch<String> = null;
			var textError : Array<Outcome<String,String>> = null;
			switch(textBatch){
				case Success(texts): resultingTexts = texts;
				case Failure(outcomes) : textError = outcomes;
			}

			var resultingImages : Batch<Image> = null;
			var imageError : Array<Outcome<Image,String>> = null;
			switch(imageBatch){
				case Success(images): resultingImages = images;
				case Failure(outcomes) : imageError = outcomes;
			}

			if (resultingImages != null && resultingTexts != null){
				return Success(new Assets(resultingTexts, resultingImages));
			}else{
				return Failure({textOutcomes : textError, imageOutcomes : imageError});
			}

		});

	}


	public var texts(default,null) : Batch<String>;
	public var images(default,null) : Batch<Image>;
	//TODO other

	public function new(texts : Batch<String>, images : Batch<Image>){
		this.texts = texts;
		this.images = images;
	}

}