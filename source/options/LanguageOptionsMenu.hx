package options;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import freeplay.FreeplayState;

import flixel.system.FlxAssets.FlxGraphicAsset;

using StringTools;

class LanguageOptionsMenu extends MusicBeatSubstate
{
	var grpLanguages:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
	var languages:Array<String> = [];
	var curSelected:Int = 0;
	var curSelectedItem:Int;

	var oldSelection:Int;

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	var flagArray:Array<Flag> = [];

	public function new()
	{
		super();

		var bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();
		add(bg);
		add(grpLanguages);

		// languages.push(ClientPrefs.defaultData.language); // English (US)
		// displayLanguages.set(ClientPrefs.defaultData.language, Language.defaultLangName);
		var directories:Array<String> = [
			Paths.mods("language"),
			Paths.mods(Paths.currentModDirectory + "language"),
			Paths.getPreloadPath("language")
		];
		for (directory in directories)
		{
			// trace(directory);
			if (FileSystem.exists(directory))
			{
				for (file in FileSystem.readDirectory(directory))
				{
					if (file.toLowerCase().endsWith('.json'))
					{
						var langFile:String = file.substring(0, file.length - '.json'.length).trim();
						if (!languages.contains(langFile))
							languages.push(langFile);
					}
				}
			}
		}

		languages.sort(function(a:String, b:String)
		{
			a = a.toLowerCase();
			b = b.toLowerCase();
			if (a < b)
				return -1;
			else if (a > b)
				return 1;
			return 0;
		});

		oldSelection = curSelectedItem = curSelected = languages.indexOf(ClientPrefs.language);

		for (i => lang in languages)
		{
			var file = LanguageFile.loadJson(lang);

			var display:Alphabet = new Alphabet(0, 300, file.display_name, true);
			display.isMenuItem = true;
			display.screenCenter();
			display.y += (100 * (i - (languages.length / 2))) + 50;
			// display.targetY = i;
			display.changeX = false;
			var flag = new Flag(LanguageFile.flag(file.id));
			flag.sprTracker = display;
			flag.xAdd = display.width + 10;
			flagArray.push(flag);
			grpLanguages.add(display);
			add(flag);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelected();
	}

	var changedLanguage:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var curLang = grpLanguages.members[curSelectedItem];
		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
		selectorLeft.y = selectorRight.y = FlxMath.lerp(selectorLeft.y, curLang.y, lerpVal);
		selectorLeft.x = FlxMath.lerp(selectorLeft.x, curLang.x - 63, lerpVal);
		selectorRight.x = FlxMath.lerp(selectorRight.x, (curLang.x + curLang.width + flagArray[curSelectedItem].width) + 15, lerpVal);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		if (controls.UI_UP_P)
			changeSelected(-1 * mult);
		if (controls.UI_DOWN_P)
			changeSelected(1 * mult);
		if (FlxG.mouse.wheel != 0)
			changeSelected(FlxG.mouse.wheel * mult);

		if (controls.BACK)
		{
			if (changedLanguage)
			{
				TitleState.initialized = false;
				TitleState.closedState = false;
				if (FreeplayState.vocals != null)
				{
					FreeplayState.vocals.fadeOut(0.3);
					FreeplayState.vocals = null;
				}
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
			}
			else
				close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.6);
			ClientPrefs.language = languages[curSelected];
			trace('curSelected language: ${ClientPrefs.language}');
			ClientPrefs.saveSettings();

			changedLanguage = (oldSelection != languages.indexOf(ClientPrefs.language));

			LanguageFile.loadLanguage(ClientPrefs.language);

			curSelectedItem = languages.indexOf(ClientPrefs.language);
		}
	}

	function changeSelected(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, languages.length - 1);
		for (num => lang in grpLanguages)
		{
			lang.targetY = num - curSelected;
			lang.alpha = 0.6;
			if (num == curSelected)
				lang.alpha = 1;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		// trace(changedLanguage);
	}
}

class Flag extends FlxSprite{
	public var sprTracker:FlxSprite;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;
	public var angleAdd:Float = 0;
	public var alphaMult:Float = 1;

	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;
	public var copyVisible:Bool = false;

	public function new(graphic:FlxGraphicAsset)
	{
		super();
		loadGraphic(graphic);
		updateHitbox();
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
		{
			setPosition(sprTracker.x + xAdd, sprTracker.y + yAdd);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);

			if (copyAngle)
				angle = sprTracker.angle + angleAdd;

			if (copyAlpha)
				alpha = sprTracker.alpha * alphaMult;

			if (copyVisible)
				visible = sprTracker.visible;
		}
	}
}