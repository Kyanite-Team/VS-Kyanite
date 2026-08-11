package engine.resultscreen;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

using StringTools;

class ResultLua
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_StopLua:Dynamic = 2;

	public var closed:Bool = false;

	#if LUA_ALLOWED
	public var lua:State = null;
	#end
	public var scriptName:String = '';

	public function new(script:String)
	{
		#if LUA_ALLOWED
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

		// trace('Lua version: ' + Lua.version());
		// trace("LuaJIT version: " + Lua.versionJIT());

		// LuaL.dostring(lua, CLENSE);
		try
		{
			var result:Dynamic = LuaL.dofile(lua, script);
			var resultStr:String = Lua.tostring(lua, result);
			if (resultStr != null && result != 0)
			{
				trace('Error on lua script! ' + resultStr);
				#if windows
				lime.app.Application.current.window.alert(resultStr, 'Error on lua script!');
				#else
				luaTrace('Error loading lua script: "$script"\n' + resultStr, true, false, FlxColor.RED);
				#end
				lua = null;
				return;
			}
		}
		catch (e:Dynamic)
		{
			trace(e);
			return;
		}
		scriptName = script;
		trace('lua file loaded succesfully:' + script);

		// variables
		set('luaDebugMode', false);

		// Screen stuff
		set('screenWidth', FlxG.width);
		set('screenHeight', FlxG.height);

		// functions
		Lua_helper.add_callback(lua, "makeLuaSprite", function(tag:String, image:String, x:Float, y:Float)
		{
			tag = tag.replace('.', '');
			resetSpriteTag(tag);
			var leSprite:ModchartSprite = new ModchartSprite(x, y);
			if (image != null && image.length > 0)
			{
				leSprite.loadGraphic(Paths.image(image));
			}
			leSprite.antialiasing = ClientPrefs.globalAntialiasing;
			ResultScreen.instance.modchartSprites.set(tag, leSprite);
			leSprite.active = true;
		});

		Lua_helper.add_callback(lua, "makeGraphic", function(obj:String, width:Int, height:Int, color:String)
		{
			var colorNum:Int = Std.parseInt(color);
			if (!color.startsWith('0x'))
				colorNum = Std.parseInt('0xff' + color);

			var spr:FlxSprite = ResultScreen.instance.getLuaObject(obj, false);
			if (spr != null)
			{
				ResultScreen.instance.getLuaObject(obj, false).makeGraphic(width, height, colorNum);
				return;
			}

			var object:FlxSprite = Reflect.getProperty(ResultScreen.instance, obj);
			if (object != null)
			{
				object.makeGraphic(width, height, colorNum);
			}
		});

		Lua_helper.add_callback(lua, "addLuaSprite", function(tag:String)
		{
			if (ResultScreen.instance.modchartSprites.exists(tag))
			{
				var shit:ModchartSprite = ResultScreen.instance.modchartSprites.get(tag);
				if (!shit.wasAdded)
				{
					ResultScreen.instance.add(shit);
					shit.wasAdded = true;
					// trace('added a thing: ' + tag);
				}
			}
		});

		Lua_helper.add_callback(lua, "getProperty", function(variable:String)
		{
			var result:Dynamic = null;
			var killMe:Array<String> = variable.split('.');
			if (killMe.length > 1)
				result = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length - 1]);
			else
				result = getVarInArray(ResultScreen.instance, variable);

			if (result == null)
				Lua.pushnil(lua);
			return result;
		});
		Lua_helper.add_callback(lua, "setProperty", function(variable:String, value:Dynamic)
		{
			var killMe:Array<String> = variable.split('.');
			if (killMe.length > 1)
			{
				setVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length - 1], value);
				return true;
			}
			setVarInArray(ResultScreen.instance, variable, value);
			return true;
		});
		#end
	}

	public static function setVarInArray(instance:Dynamic, variable:String, value:Dynamic):Any
	{
		var shit:Array<String> = variable.split('[');
		if (shit.length > 1)
		{
			var blah:Dynamic = null;
			if (ResultScreen.instance.variables.exists(shit[0]))
			{
				var retVal:Dynamic = ResultScreen.instance.variables.get(shit[0]);
				if (retVal != null)
					blah = retVal;
			}
			else
				blah = Reflect.getProperty(instance, shit[0]);

			for (i in 1...shit.length)
			{
				var leNum:Dynamic = shit[i].substr(0, shit[i].length - 1);
				if (i >= shit.length - 1) // Last array
					blah[leNum] = value;
				else // Anything else
					blah = blah[leNum];
			}
			return blah;
		}
		/*if(Std.isOfType(instance, Map))
				instance.set(variable,value);
			else */

		if (ResultScreen.instance.variables.exists(variable))
		{
			ResultScreen.instance.variables.set(variable, value);
			return true;
		}

		Reflect.setProperty(instance, variable, value);
		return true;
	}

	public static function getVarInArray(instance:Dynamic, variable:String):Any
	{
		var shit:Array<String> = variable.split('[');
		if (shit.length > 1)
		{
			var blah:Dynamic = null;
			if (ResultScreen.instance.variables.exists(shit[0]))
			{
				var retVal:Dynamic = ResultScreen.instance.variables.get(shit[0]);
				if (retVal != null)
					blah = retVal;
			}
			else
				blah = Reflect.getProperty(instance, shit[0]);

			for (i in 1...shit.length)
			{
				var leNum:Dynamic = shit[i].substr(0, shit[i].length - 1);
				blah = blah[leNum];
			}
			return blah;
		}

		if (ResultScreen.instance.variables.exists(variable))
		{
			var retVal:Dynamic = ResultScreen.instance.variables.get(variable);
			if (retVal != null)
				return retVal;
		}

		return Reflect.getProperty(instance, variable);
	}

	public static function getPropertyLoopThingWhatever(killMe:Array<String>, ?checkForTextsToo:Bool = true, ?getProperty:Bool = true):Dynamic
	{
		var coverMeInPiss:Dynamic = getObjectDirectly(killMe[0], checkForTextsToo);
		var end = killMe.length;
		if (getProperty)
			end = killMe.length - 1;

		for (i in 1...end)
		{
			coverMeInPiss = getVarInArray(coverMeInPiss, killMe[i]);
		}
		return coverMeInPiss;
	}

	public static function getObjectDirectly(objectName:String, ?checkForTextsToo:Bool = true):Dynamic
	{
		var coverMeInPiss:Dynamic = ResultScreen.instance.getLuaObject(objectName, checkForTextsToo);
		if (coverMeInPiss == null)
			coverMeInPiss = getVarInArray(ResultScreen.instance, objectName);

		return coverMeInPiss;
	}

	function resetSpriteTag(tag:String)
	{
		if (!ResultScreen.instance.modchartSprites.exists(tag))
		{
			return;
		}

		var pee:ModchartSprite = ResultScreen.instance.modchartSprites.get(tag);
		pee.kill();
		if (pee.wasAdded)
		{
			ResultScreen.instance.remove(pee, true);
		}
		pee.destroy();
		ResultScreen.instance.modchartSprites.remove(tag);
	}

	public function luaTrace(text:String, ignoreCheck:Bool = false, deprecated:Bool = false, color:FlxColor = FlxColor.WHITE)
	{
		#if LUA_ALLOWED
		if (ignoreCheck || getBool('luaDebugMode'))
		{
			if (deprecated && !getBool('luaDeprecatedWarnings'))
			{
				return;
			}
			ResultScreen.instance.addTextToDebug(text, color);
			trace(text);
		}
		#end
	}

	function getErrorMessage(status:Int):String
	{
		#if LUA_ALLOWED
		var v:String = Lua.tostring(lua, -1);
		Lua.pop(lua, 1);

		if (v != null)
			v = v.trim();
		if (v == null || v == "")
		{
			switch (status)
			{
				case Lua.LUA_ERRRUN:
					return "Runtime Error";
				case Lua.LUA_ERRMEM:
					return "Memory Allocation Error";
				case Lua.LUA_ERRERR:
					return "Critical Error";
			}
			return "Unknown Error";
		}

		return v;
		#end
		return null;
	}

	#if LUA_ALLOWED
	public function getBool(variable:String)
	{
		var result:String = null;
		Lua.getglobal(lua, variable);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);

		if (result == null)
		{
			return false;
		}
		return (result == 'true');
	}
	#end

	var lastCalledFunction:String = '';

	public function call(func:String, args:Array<Dynamic>):Dynamic
	{
		#if LUA_ALLOWED
		if (closed)
			return Function_Continue;

		lastCalledFunction = func;
		try
		{
			if (lua == null)
				return Function_Continue;

			Lua.getglobal(lua, func);
			var type:Int = Lua.type(lua, -1);

			if (type != Lua.LUA_TFUNCTION)
			{
				if (type > Lua.LUA_TNIL)
					luaTrace("ERROR (" + func + "): attempt to call a " + typeToString(type) + " value", false, false, FlxColor.RED);

				Lua.pop(lua, 1);
				return Function_Continue;
			}

			for (arg in args)
				Convert.toLua(lua, arg);
			var status:Int = Lua.pcall(lua, args.length, 1, 0);

			// Checks if it's not successful, then show a error.
			if (status != Lua.LUA_OK)
			{
				var error:String = getErrorMessage(status);
				luaTrace("ERROR (" + func + "): " + error, false, false, FlxColor.RED);
				return Function_Continue;
			}

			// If successful, pass and then return the result.
			var result:Dynamic = cast Convert.fromLua(lua, -1);
			if (result == null)
				result = Function_Continue;

			Lua.pop(lua, 1);
			return result;
		}
		catch (e:Dynamic)
		{
			trace(e);
		}
		#end
		return Function_Continue;
	}

	public function stop()
	{
		#if LUA_ALLOWED
		if (lua == null)
		{
			return;
		}

		Lua.close(lua);
		lua = null;
		#end
	}

	public function set(variable:String, data:Dynamic)
	{
		#if LUA_ALLOWED
		if (lua == null)
		{
			return;
		}

		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
		#end
	}

	function typeToString(type:Int):String
	{
		#if LUA_ALLOWED
		switch (type)
		{
			case Lua.LUA_TBOOLEAN:
				return "boolean";
			case Lua.LUA_TNUMBER:
				return "number";
			case Lua.LUA_TSTRING:
				return "string";
			case Lua.LUA_TTABLE:
				return "table";
			case Lua.LUA_TFUNCTION:
				return "function";
		}
		if (type <= Lua.LUA_TNIL)
			return "nil";
		#end
		return "unknown";
	}
}

class ModchartSprite extends FlxSprite
{
	public var wasAdded:Bool = false;
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();

	// public var isInFront:Bool = false;

	public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(x, y);
		antialiasing = ClientPrefs.globalAntialiasing;
	}
}

class ModchartText extends FlxText
{
	public var wasAdded:Bool = false;

	public function new(x:Float, y:Float, text:String, width:Float)
	{
		super(x, y, width, text, 16);
		setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		// cameras = [PlayState.instance.camHUD];
		scrollFactor.set();
		borderSize = 2;
	}
}

class DebugLuaText extends FlxText
{
	private var disableTime:Float = 6;

	public var parentGroup:FlxTypedGroup<DebugLuaText>;

	public function new(text:String, parentGroup:FlxTypedGroup<DebugLuaText>, color:FlxColor)
	{
		this.parentGroup = parentGroup;
		super(10, 10, 0, text, 16);
		setFormat(Paths.font("vcr.ttf"), 16, color, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scrollFactor.set();
		borderSize = 1;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		disableTime -= elapsed;
		if (disableTime < 0)
			disableTime = 0;
		if (disableTime < 1)
			alpha = disableTime;
	}
}
