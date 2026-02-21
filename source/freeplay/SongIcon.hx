package freeplay;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class SongIcon extends FlxSprite
{
	private var isOldIcon:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf')
	{
		super();
		isOldIcon = (char == 'bf-old');
		changeIcon(char);
		scrollFactor.set();
	}

	private var iconOffsets:Array<Float> = [0, 0, 0];

	public function changeIcon(char:String)
	{
		if (this.char != char)
		{
			var name:String = 'freeplay/icons/' + char + "pixel";
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'freeplay/icons/icon' + char + "pixel"; // Older versions of psych engine's support
			// if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon

			frames = Paths.getSparrowAtlas(name);
			animation.addByPrefix("idle", "idle", 12, true);
			animation.addByPrefix("confirm", "confirm", 12, false);
			animation.addByPrefix("confirm-hold", "confirm-hold", 12, true);
		}
	}

	public function confirm():Void
	{
		animation.play("confirm");
		animation.onFinish.add(function(name:String):Void
		{
			if (name == 'confirm')
				animation.play('confirm-hold');
		});
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String
	{
		return char;
	}
}
