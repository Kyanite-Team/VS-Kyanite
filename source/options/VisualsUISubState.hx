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

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = LanguageFile.getPhrase("visuals_and_ui.title");
		rpcTitle = LanguageFile.getPhrase("visuals_and_ui.discord"); //for Discord Rich Presence

		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.note_splashes"),
			LanguageFile.getPhrase("visuals_and_ui.note_splashes_tip"),
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.hide_hud"),
			LanguageFile.getPhrase("visuals_and_ui.hide_hud_tip"),
			'hideHud',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('${LanguageFile.getPhrase("visuals_and_ui.time_bar")}:',
			LanguageFile.getPhrase("visuals_and_ui.time_bar_tip"),
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.flashing_lights"),
			LanguageFile.getPhrase("visuals_and_ui.flashing_lights_tip"),
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.cam_zooms"),
			LanguageFile.getPhrase("visuals_and_ui.cam_zooms_tip"),
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.score_zoom_hit"),
			LanguageFile.getPhrase("visuals_and_ui.score_zoom_hit_tip"),
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.health_opacity"),
			LanguageFile.getPhrase("visuals_and_ui.health_opacity_tip"),
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.fps_counter"),
			LanguageFile.getPhrase("visuals_and_ui.fps_counter_tip"),
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end
		
		var option:Option = new Option('${LanguageFile.getPhrase("visuals_and_ui.pause_song")}:',
			LanguageFile.getPhrase("visuals_and_ui.pause_song_tip"),
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end

		var option:Option = new Option(LanguageFile.getPhrase("visuals_and_ui.combo_stacking"),
			LanguageFile.getPhrase("visuals_and_ui.combo_stacking_tip"),
			'comboStacking',
			'bool',
			true);
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}
