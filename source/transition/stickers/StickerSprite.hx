package transition.stickers;

class StickerSprite extends FlxSprite
{
	public var timer:Float = 0;

	var stickerPath:String;

	public function loadSticker()
	{
		loadGraphic(Paths.image(stickerPath));
		updateHitbox();
		scrollFactor.set();
	}

	public function new(x:Float, y:Float, stickerSet:String, stickerName:String):Void
	{
		super(x, y);
		stickerPath = (stickerSet == null) ? stickerName : 'stickerpacks/$stickerSet/$stickerName';
		antialiasing = ClientPrefs.globalAntialiasing;
		loadSticker();

		trace(stickerSet, stickerName);
	}
}
