package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = LanguageFile.getPhrase('gameplay.title');
		rpcTitle = LanguageFile.getPhrase('gameplay.discord'); //for Discord Rich Presence

		var option:Option = new Option(LanguageFile.getPhrase("gameplay.controller_mode"),
			LanguageFile.getPhrase("gameplay.controller_tip"),
			'controllerMode',
			'bool',
			false);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option(LanguageFile.getPhrase("gameplay.downscroll"), //Name
			LanguageFile.getPhrase("gameplay.downscroll_tip"), //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("gameplay.middlescroll"),
			LanguageFile.getPhrase("gameplay.middlescroll_tip"),
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("gameplay.opponent_notes"),
			LanguageFile.getPhrase("gameplay.opponent_notes_tip"),
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("gameplay.ghost_tapping"),
		LanguageFile.getPhrase("gameplay.ghost_tapping_tip"),
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase('gameplay.no_reset'),
			LanguageFile.getPhrase("gameplay.no_reset_tip"),
			'noReset',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase('gameplay.hitsound_volume'),
			LanguageFile.getPhrase('gameplay.hitsound_volume_tip'),
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option(LanguageFile.getPhrase('gameplay.rating_offset'),
			LanguageFile.getPhrase('gameplay.rating_offset_tip'),
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase('gameplay.sick_window'),
			LanguageFile.getPhrase('gameplay.sick_window_tip'),
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase('gameplay.good_window'),
			LanguageFile.getPhrase('gameplay.good_window_tip'),
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase('gameplay.bad_window'),
			LanguageFile.getPhrase('gameplay.bad_window_tip'),
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase('gameplay.safe_frames'),
			LanguageFile.getPhrase('gameplay.safe_frames_tip'),
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
	}
}