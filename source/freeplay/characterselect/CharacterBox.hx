package freeplay.characterselect;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

class CharacterBox extends FlxSpriteGroup{
    var characterString:String;
    var character:FlxSprite;
	var box:FlxSprite;

    override public function new(x:Float, y:Float, characterString:String){
        this.characterString = characterString;
        super(x, y);

        create();
    }

    function create(){
		box = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(150, 300, FlxColor.TRANSPARENT), x, y, 150, 300, 30, 30, 0x4e4f74);
        add(box);

        var character = new FlxSprite(x+(box.width*0.5), y - box.height).loadGraphic(Paths.image("freeplay/character"+characterString));
        add(character);
    }
}