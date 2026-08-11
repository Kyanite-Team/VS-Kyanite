package engine.resultscreen;

import flixel.sound.FlxSound;

import haxe.PosInfos;
import haxe.Log;

import hscript.Parser;
import hscript.Interp;
import sys.io.File;

import flixel.FlxG;

using StringTools;

class ResultScript extends Interp{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_StopScript:Dynamic = 2;

	public static var interpScript:String; // For initializing scripts on strings instead.
	public static var originClass:String = "";

	var name:String;
    
    var parser:Parser;
	var program:Dynamic;
	var interp:Interp;

    var result:Dynamic;

	public static var sounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public static var script_variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public function new(?scriptName:String, ?ext:String = "hx", ?additionalVars:Map<String, Dynamic>){
        super();

		parser = new Parser();
		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;
		name = originClass;
		if (scriptName == null)
		{
			if (interpScript != null)
			{
				var o:String = "hscript";
				if (originClass != null)
					o = originClass;
				try
				{
					program = parser.parseString(interpScript, o);
				}
				catch (e)
				{
					trace('There was an error while parsing a script! $e');
				}
			}
			else
			{
				trace("Cannot initialize empty script!");
				return;
			}
		}
		else
		{
			var script:String = File.getContent(scriptName + ext);
			program = parser.parseString(script, scriptName + ext);
			name = scriptName + ext;
		}
		interp = new Interp();
		variables = interp.variables; // Match the interp's vars for later use.

		// Reset these for later use.
		interpScript = null;
		originClass = "";

		// trace(name);

		// Default imports.
		setVar("FlxG", flixel.FlxG);
		setVar("FlxGroup", flixel.group.FlxGroup);
		setVar("FlxTypedGroup", flixel.group.FlxGroup.FlxTypedGroup);
		setVar("FlxSpriteGroup", flixel.group.FlxSpriteGroup);
		setVar("FlxTypedSpriteGroup", flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup);
		setVar("StringTools", StringTools);
		setVar("ClientPrefs", ClientPrefs);
		setVar("Paths", Paths);
		setVar("CoolUtil", CoolUtil);
		setVar("Conductor", Conductor);

		/* setVar("changePresence", DiscordClient.changePresence);
		setVar("swapToken", DiscordClient.swapToken);
		setVar("setToken", DiscordClient.swapToken); */

		setVar("Std", Std);
		setVar("FlxSound", FlxSound);

		setVar("add", FlxG.state.add);
		setVar("insert", FlxG.state.insert);
		setVar("remove", FlxG.state.remove);
		if (additionalVars != null)
		{
			trace(additionalVars);
			for (k => v in additionalVars)
			{
				setVar(k, v);
			}
		}
		var sFolder:String = '';
		var pathS:Array<String> = scriptName.split("/");
		pathS.pop();
		sFolder = pathS.join("/");
        for (key => value in variables)
        {
            if (!script_variables.exists(key)) // avoid setting the same variavles over and over
                script_variables.set(key, value); // match instance variables.
        }

        result = interp.execute(program);
    }

	public function exists(name:String):Bool
		return interp.variables.exists(name);

	function isFunc(name:String):Bool
		return Reflect.isFunction(interp.variables.get(name));

	public function callFunc(name:String, args:Array<Dynamic>):Dynamic
	{
		try
		{
			if (exists(name)) // if it is debug, run the func regardless of if it exists, then spit out the error afterward.
			{
				// trace("Test Trace: Func called: " + name + " with arguments: " + args);
				try
				{
					return call(this, interp.variables.get(name), args);
				}
				catch (e:Dynamic)
				{
					trace(e);
				}
			}
		}
		catch (e:Dynamic)
		{
			if (Std.string(e).trim() == "Null Function Pointer")
			{
				trace('[ ${interp.posInfos()} ]Function $name does not exist in `${this.name}`');
			}
			else
			{
				Log.trace(e, interp.posInfos());
			}
		}
		return null;
	}

	public override function setVar(k:String, v:Dynamic)
	{
		script_variables.set(k, v);
		interp.variables.set(k, v);
		super.setVar(k, v);
	}
}