package engine.resultscreen;

import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxColor;

import engine.resultscreen.ResultScript;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class ResultScreen extends MusicBeatState{
	public var camGame:FlxCamera;
    
	//hscript
	public var scriptArray:Array<ResultScript> = [];

    // Lua shit
	/* public static var instance:ResultScreen;

	public var luaArray:Array<ResultLua> = [];

	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var variables:Map<String, Dynamic> = new Map();
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>(); */

	var atlas:FlxAnimate;

    override function create(){
		Paths.clearStoredMemory();

		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);

		// for lua
		// instance = this;

		#if LUA_ALLOWED
		/* luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		//luaDebugGroup.camera = camGame;
		add(luaDebugGroup); */

		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('resultScreen/')];

		#if MODS_ALLOWED
		foldersToCheck.push(Paths.mods('resultScreen/'));
		if (Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.push(Paths.mods(Paths.currentModDirectory + '/resultScreen/'));

		for (mod in Paths.getGlobalMods())
			foldersToCheck.push(Paths.mods(mod + '/resultScreen/'));
		#end

		for (folder in foldersToCheck)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.hx') && !filesPushed.contains(file)){
						scriptArray.push(new ResultScript(folder+file));
						filesPushed.push(file);
					}
					/* if (file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new ResultLua(folder + file));
						filesPushed.push(file);
					} */
				}
			}
		}
		#end

		atlas = new FlxAnimate();
		Paths.loadAnimateAtlas(atlas, "test");
		atlas.anim.addBySymbol("lost", "pico loss final", 24, true);
		add(atlas);

		// callOnScripts('CreateResult', []);

		// callOnLuas('CreateResult', []);
        super.create();
    }

    override function update(elapsed:Float){
        if (controls.BACK){
            MusicBeatState.switchState(new MainMenuState());
        }

		if (FlxG.keys.justPressed.SPACE)
			atlas.anim.play("lost");
        super.update(elapsed);
    }

    override function destroy(){
		/* for (lua in luaArray)
		{
			lua.call('DestroyResult', []);
			lua.stop();
		}
		luaArray = []; */

		// callOnScripts('DestroyResult', []);
		scriptArray = [];
        super.destroy();
    }

	/*public function callOnScripts(event:String, ars:Array<Dynamic>, ?ignoreStops:Bool = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null){
		var returnVal:Dynamic = ResultScript.Function_Continue;

		if (exclusions == null)
			exclusions = new Array();
		if (excludeValues == null)
			excludeValues = new Array();
		excludeValues.push(ResultScript.Function_Continue);

		var len:Int = scriptArray.length;
		if (len < 1)
			return returnVal;
		
		for (script in scriptArray)
		{
			@:privateAccess
			if (script == null || !script.exists(event))
				continue;

			var callValue = script.call(event, args);
			if (callValue != null)
			{
				var myValue:Dynamic = callValue.returnValue;

				if (myValue == ResultScript.Function_StopScript && !excludeValues.contains(myValue)	&& !ignoreStops)
				{
					returnVal = myValue;
					break;
				}

				if (myValue != null && !excludeValues.contains(myValue))
					returnVal = myValue;
			}
		}

		return returnVal;
	}*/

	/*public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic
	{
		var returnVal:Dynamic = ResultLua.Function_Continue;
		#if LUA_ALLOWED
		if (exclusions == null)
			exclusions = [];
		for (script in luaArray)
		{
			if (exclusions.contains(script.scriptName))
				continue;

			var ret:Dynamic = script.call(event, args);
			if (ret == ResultLua.Function_StopLua && !ignoreStops)
				break;

			// had to do this because there is a bug in haxe where Stop != Continue doesnt work
			var bool:Bool = ret == ResultLua.Function_Continue;
			if (!bool && ret != 0)
			{
				returnVal = cast ret;
			}
		}
		#end
		// trace(event, returnVal);
		return returnVal;
	}

	public function getLuaObject(tag:String, text:Bool = true):FlxSprite
	{
		if (modchartSprites.exists(tag))
			return modchartSprites.get(tag);
		if (text && modchartTexts.exists(tag))
			return modchartTexts.get(tag);
		if (variables.exists(tag))
			return variables.get(tag);
		return null;
	}

	public function addTextToDebug(text:String, color:FlxColor)
	{
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText)
		{
			spr.y += 20;
		});

		if (luaDebugGroup.members.length > 34)
		{
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup, color));
		#end
	}*/
}