package options;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import sys.FileSystem;
import sys.io.File;
import editors.language.LanguageFile;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;

using StringTools;

class LanguageOptionsMenu extends MusicBeatSubstate{
	var grpLanguages:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
	var languages:Array<String> = [];
	var curSelected:Int = 0;

	public function new()
	{
		super();

		var bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();
		add(bg);
		add(grpLanguages);

		//languages.push(ClientPrefs.defaultData.language); // English (US)
		//displayLanguages.set(ClientPrefs.defaultData.language, Language.defaultLangName);
		var directories:Array<String> = [Paths.mods("language"), Paths.mods(Paths.currentModDirectory+"language"), Paths.getPreloadPath("language")];
		for (directory in directories)
		{
            trace(directory);
            if (FileSystem.exists(directory)){
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

        for (i => lang in languages){
            var name = lang;

            var display:Alphabet = new Alphabet(0, 300, name, true);
            display.isMenuItem = true;
            display.targetY = i;
            display.changeX = false;
            display.screenCenter(X);
            grpLanguages.add(display);
        }

		changeSelected();
	}

	var changedLanguage:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

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
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				MusicBeatState.resetState();
			}
			else
				close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.6);
			ClientPrefs.language = languages[curSelected];
			trace(ClientPrefs.language);
			ClientPrefs.saveSettings();
			changedLanguage = true;
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
	}
}