package transition.stickers;

class StickerSprite extends FlxSprite{
    public var timer:Float = 0;

    public function new(x:Float, y:Float, filePath:String):Void{
        super(x, y);
        loadGraphic(filePath);
        updateHitbox();
        scrollFactor.set();
    }
}