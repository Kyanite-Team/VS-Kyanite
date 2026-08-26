package freeplay;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.filters.BitmapFilterQuality;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

@:nullSafety
class SongText extends FlxSpriteGroup
{
	public var clipWidth(default, set):Int = 255;
	public var tooLong:Bool = false;

	public var text(default, set):Null<String> = "";

	var glowColor:FlxColor = 0xFF00ccff;

	var whiteText:FlxText;

	public function new(x:Float, y:Float, songTitle:String, size:Int)
	{
		super(x, y);

		whiteText = new FlxText(0, 0, 0, songTitle, size);
		whiteText.font = "5by7";
		whiteText.textField.filters = [
			new openfl.filters.GlowFilter(glowColor, 1, 5, 5, 210, BitmapFilterQuality.MEDIUM)
		];
		add(whiteText);
	}

	function set_clipWidth(value:Int):Int
	{
		resetText();
		checkClipWidth(value);
		return clipWidth = value;
	}

	function set_text(value:String):String
	{
		if (value == null)
			return value;
		if (whiteText == null)
		{
			trace('WARN: Capsule not initialized properly');
			return text = value;
		}

		whiteText.text = value;
		checkClipWidth();
		whiteText.textField.filters = [
			new openfl.filters.GlowFilter(glowColor, 1, 5, 5, 210, BitmapFilterQuality.MEDIUM),
		];

		return text = value;
	}

	function checkClipWidth(?wid:Int):Void
	{
		if (wid == null)
			wid = clipWidth;
		if (whiteText == null)
			return;

		if (whiteText.width > wid)
		{
			tooLong = true;

			whiteText.clipRect = new FlxRect(0, 0, wid, whiteText.height);
		}
		else
		{
			tooLong = false;

			@:nullSafety(Off)
			whiteText.clipRect = null;
		}
	}

	var moveTimer:FlxTimer = new FlxTimer();
	var moveTween:Null<FlxTween>;

	public function initMove():Void
	{
		moveTimer.start(0.6, (timer) ->
		{
			moveTextRight();
		});
	}

	function moveTextRight():Void
	{
		var distToMove:Float = whiteText.width - clipWidth;
		moveTween = FlxTween.tween(whiteText.offset, {x: distToMove}, 2, {
			onUpdate: function(_)
			{
				whiteText.clipRect = new FlxRect(whiteText.offset.x, 0, clipWidth, whiteText.height);
			},
			onComplete: function(_)
			{
				moveTimer.start(0.3, (timer) ->
				{
					moveTextLeft();
				});
			},
			ease: FlxEase.sineInOut
		});
	}

	function moveTextLeft():Void
	{
		moveTween = FlxTween.tween(whiteText.offset, {x: 0}, 2, {
			onUpdate: function(_)
			{
				whiteText.clipRect = new FlxRect(whiteText.offset.x, 0, clipWidth, whiteText.height);
			},
			onComplete: function(_)
			{
				moveTimer.start(0.3, (timer) ->
				{
					moveTextRight();
				});
			},
			ease: FlxEase.sineInOut
		});
	}

	public function resetText():Void
	{
		scale.x = 1;
		scale.y = 1;
		if (moveTimer != null)
			moveTimer.cancel();
		if (moveTween != null)
			moveTween.cancel();
		whiteText.offset.x = 0;
		whiteText.clipRect = new FlxRect(whiteText.offset.x, 0, clipWidth, whiteText.height);
	}

	var flickerState:Bool = false;
	var flickerTimer:Null<FlxTimer>;

	public function flickerText():Void
	{
		resetText();
		flickerTimer = new FlxTimer().start(1 / 24, flickerProgress, 19);
	}

	function flickerProgress(timer:FlxTimer):Void
	{
		if (flickerState == true)
		{
			whiteText.blend = BlendMode.ADD;
			whiteText.color = 0xFFFFFFFF;
			whiteText.textField.filters = [
				new openfl.filters.GlowFilter(0xFFFFFF, 1, 5, 5, 210, BitmapFilterQuality.MEDIUM),
				// new openfl.filters.BlurFilter(5, 5, BitmapFilterQuality.LOW)
			];
		}
		else
		{
			whiteText.color = 0xFFDDDDDD;
			whiteText.textField.filters = [
				new openfl.filters.GlowFilter(0xDDDDDD, 1, 5, 5, 210, BitmapFilterQuality.MEDIUM),
				// new openfl.filters.BlurFilter(5, 5, BitmapFilterQuality.LOW)
			];
		}
		flickerState = !flickerState;
	}
}
