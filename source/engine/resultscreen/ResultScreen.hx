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
import engine.resultscreen.ResultScript.HScriptInfos;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import crowplexus.hscript.Expr.Error as IrisError;
import crowplexus.hscript.Printer;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class ResultScreen extends MusicBeatState{
	public var camGame:FlxCamera;
    public var camDebug:FlxCamera;


	//hscript
	public static var instance:ResultScreen;
	public var scriptArray:Array<ResultScript> = [];
	private var debugGroup:FlxTypedGroup<FunkinLua.DebugLuaText>;

    override function create(){
		Paths.clearStoredMemory();

		instance = this;

		camGame = new FlxCamera();

		camDebug = new FlxCamera();
		camDebug.bgColor = 0x00;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camDebug, false);

		debugGroup = new FlxTypedGroup<FunkinLua.DebugLuaText>();
		debugGroup.camera = camDebug;
		add(debugGroup);

		var directories:Array<String> = [Paths.modFolders('resultScreen/'), Paths.getPreloadPath('resultScreen/')];

		for (folder in directories){
			if (FileSystem.exists(folder)){
				for (file in FileSystem.readDirectory(folder)){
					if (file.toLowerCase().endsWith('.hx')){
						initHscript(folder+file);
					}
				}
			}
		}

		callOnScript("CreateResult");

        super.create();
    }

    override function update(elapsed:Float){
        if (controls.BACK){
            MusicBeatState.switchState(new MainMenuState());
        }

        super.update(elapsed);
    }

    override function destroy(){
        super.destroy();
    }

	public function initHscript(file:String){
		var newScript:ResultScript = null;
		try{
			newScript = new ResultScript(null, file);
			trace('Initialized HScript for: $file');
			scriptArray.push(newScript);
		}
		catch(e:IrisError){
			var pos:HScriptInfos = cast {fileName: file, showLine: true};
			Iris.error(Printer.errorToString(e, false), pos);
			var newScript:ResultScript = cast (Iris.instances.get(file), ResultScript);
			if (newScript != null)
				newScript.destroy();
		}
	}

	public function callOnScript(funcToCall:String, args:Array<Dynamic> = null, ?ignoreStops:Bool = false, exclusions:Array<String> = null,
			excludeValues:Array<Dynamic> = null):Dynamic
	{
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
			if (script == null || !script.exists(funcToCall) || exclusions.contains(script.origin))
				continue;

			var callValue = script.call(funcToCall, args);
			if (callValue != null)
			{
				var myValue:Dynamic = callValue.returnValue;

				if ((myValue == ResultScript.Function_StopScript || myValue == ResultScript.Function_Stop)
					&& !excludeValues.contains(myValue)
					&& !ignoreStops)
				{
					returnVal = myValue;
					break;
				}

				if (myValue != null && !excludeValues.contains(myValue))
					returnVal = myValue;
			}
		}

		return returnVal;
	}

	public function addTextToDebug(text:String, color:FlxColor)
	{
		var newText:FunkinLua.DebugLuaText = debugGroup.recycle(FunkinLua.DebugLuaText);
		newText.text = text;
		newText.color = color;
		newText.alpha = 1;
		newText.setPosition(10, 8 - newText.height);

		debugGroup.forEachAlive(function(spr:FunkinLua.DebugLuaText)
		{
			spr.y += newText.height + 2;
		});
		debugGroup.add(newText);

		Sys.println(text);
	}
}