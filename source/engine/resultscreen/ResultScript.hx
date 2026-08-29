package engine.resultscreen;

import flixel.FlxG;
import kanimate.FlxAnimate;
import flixel.util.FlxColor;

import sys.io.File;
import sys.FileSystem;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import crowplexus.hscript.Expr.Error as IrisError;
import crowplexus.hscript.Printer;

import haxe.ValueException;

using StringTools;

typedef HScriptInfos =
{
	> haxe.PosInfos,
	var ?funcName:String;
	var ?showLine:Null<Bool>;
}

class ResultScript extends Iris{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_StopScript:Dynamic = 2;

	public var filePath:String;
	public var modFolder:String;
	public var returnValue:Dynamic;

	public var origin:String;

	override public function new(?parent:Dynamic, ?file:String, ?varsToBring:Any = null, ?manualRun:Bool = false)
	{
		if (file == null)
			file = '';

		filePath = file;
		if (filePath != null && filePath.length > 0)
		{
			this.origin = filePath;
			#if MODS_ALLOWED
			var myFolder:Array<String> = filePath.split('/');
			if (myFolder[0] + '/' == Paths.mods()
				&& (Paths.currentModDirectory == myFolder[1] || Paths.getGlobalMods().contains(myFolder[1]))) // is inside mods folder
				this.modFolder = myFolder[1];
			#end
		}
		var scriptThing:String = file;
		var scriptName:String = null;
		if (parent == null && file != null)
		{
			var f:String = file.replace('\\', '/');
			if (f.contains('/') && !f.contains('\n'))
			{
				scriptThing = File.getContent(f);
				scriptName = f;
			}
		}
		super(scriptThing, new IrisConfig(scriptName, false, false));
		var customInterp:CustomInterp = new CustomInterp();
		customInterp.parentInstance = FlxG.state;
		customInterp.showPosOnLog = false;
		this.interp = customInterp;

		preset();

		this.varsToBring = varsToBring;

		if (!manualRun)
		{
			try
			{
				var ret:Dynamic = execute();
				returnValue = ret;
			}
			catch (e:IrisError)
			{
				returnValue = null;
				this.destroy();
				throw e;
			}
		}
	}

	var varsToBring(default, set):Any = null;

	override function preset()
	{
		super.preset();

		// Some very commonly used classes
		set('Type', Type);
		#if sys
		set('File', File);
		set('FileSystem', FileSystem);
		#end
		set('FlxG', flixel.FlxG);
		set('FlxMath', flixel.math.FlxMath);
		set('FlxSprite', flixel.FlxSprite);
		set('FlxText', flixel.text.FlxText);
		set('FlxCamera', flixel.FlxCamera);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxColor', CustomFlxColor);
		set('Paths', Paths);
		set('Conductor', Conductor);
		set('ClientPrefs', ClientPrefs);
		#if ACHIEVEMENTS_ALLOWED
		set('Achievements', Achievements);
		#end
		set('Character', Character);
		set('Alphabet', Alphabet);
		set('Note', Note);
		#if (!flash && sys)
		set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);
		#end
		set('ShaderFilter', openfl.filters.ShaderFilter);
		set('StringTools', StringTools);
		#if flxanimate
		set('FlxAnimate', FlxAnimate);
		#end

		set('debugPrint', function(text:String, ?color:FlxColor = null)
		{
			if (color == null)
				color = FlxColor.WHITE;
			ResultScreen.instance.addTextToDebug(text, color);
		});

		set('this', this);
		set('game', FlxG.state);

		#if windows
		set('buildTarget', 'windows');
		#elseif linux
		set('buildTarget', 'linux');
		#elseif mac
		set('buildTarget', 'mac');
		#elseif html5
		set('buildTarget', 'browser');
		#elseif android
		set('buildTarget', 'android');
		#else
		set('buildTarget', 'unknown');
		#end

		set('Function_StopScript', Function_StopScript);
		set('Function_Stop', Function_Stop);
		set('Function_Continue', Function_Continue);
	}

	override function call(funcToRun:String, ?args:Array<Dynamic>):IrisCall
	{
		if (funcToRun == null || interp == null)
			return null;

		if (!exists(funcToRun))
		{
			Iris.error('No function named: $funcToRun', this.interp.posInfos());
			return null;
		}

		try
		{
			var func:Dynamic = interp.variables.get(funcToRun); // function signature
			final ret = Reflect.callMethod(null, func, args ?? []);
			return {funName: funcToRun, signature: func, returnValue: ret};
		}
		catch (e:IrisError)
		{
			var pos:HScriptInfos = cast this.interp.posInfos();
			pos.funcName = funcToRun;
			Iris.error(Printer.errorToString(e, false), pos);
		}
		catch (e:ValueException)
		{
			var pos:HScriptInfos = cast this.interp.posInfos();
			pos.funcName = funcToRun;
			Iris.error('$e', pos);
		}
		return null;
	}

	override public function destroy()
	{
		origin = null;
		super.destroy();
	}

	function set_varsToBring(values:Any)
	{
		if (varsToBring != null)
			for (key in Reflect.fields(varsToBring))
				if (exists(key.trim()))
					interp.variables.remove(key.trim());

		if (values != null)
		{
			for (key in Reflect.fields(values))
			{
				key = key.trim();
				set(key, Reflect.field(values, key));
			}
		}

		return varsToBring = values;
	}
}

class CustomFlxColor
{
	public static var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	public static var BLACK(default, null):Int = FlxColor.BLACK;
	public static var WHITE(default, null):Int = FlxColor.WHITE;
	public static var GRAY(default, null):Int = FlxColor.GRAY;

	public static var GREEN(default, null):Int = FlxColor.GREEN;
	public static var LIME(default, null):Int = FlxColor.LIME;
	public static var YELLOW(default, null):Int = FlxColor.YELLOW;
	public static var ORANGE(default, null):Int = FlxColor.ORANGE;
	public static var RED(default, null):Int = FlxColor.RED;
	public static var PURPLE(default, null):Int = FlxColor.PURPLE;
	public static var BLUE(default, null):Int = FlxColor.BLUE;
	public static var BROWN(default, null):Int = FlxColor.BROWN;
	public static var PINK(default, null):Int = FlxColor.PINK;
	public static var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	public static var CYAN(default, null):Int = FlxColor.CYAN;

	public static function fromInt(Value:Int):Int
		return cast FlxColor.fromInt(Value);

	public static function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);

	public static function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);

	public static inline function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);

	public static function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);

	public static function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);

	public static function fromString(str:String):Int
		return cast FlxColor.fromString(str);
}

class CustomInterp extends crowplexus.hscript.Interp
{
	public var parentInstance(default, set):Dynamic = [];

	private var _instanceFields:Array<String>;

	function set_parentInstance(inst:Dynamic):Dynamic
	{
		parentInstance = inst;
		if (parentInstance == null)
		{
			_instanceFields = [];
			return inst;
		}
		_instanceFields = Type.getInstanceFields(Type.getClass(inst));
		return inst;
	}

	public function new()
	{
		super();
	}

	override function fcall(o:Dynamic, funcToRun:String, args:Array<Dynamic>):Dynamic
	{
		for (_using in usings)
		{
			var v = _using.call(o, funcToRun, args);
			if (v != null)
				return v;
		}

		var f = get(o, funcToRun);

		if (f == null)
		{
			Iris.error('Tried to call null function $funcToRun', posInfos());
			return null;
		}

		return Reflect.callMethod(o, f, args);
	}

	override function resolve(id:String):Dynamic
	{
		if (locals.exists(id))
		{
			var l = locals.get(id);
			return l.r;
		}

		if (variables.exists(id))
		{
			var v = variables.get(id);
			return v;
		}

		if (imports.exists(id))
		{
			var v = imports.get(id);
			return v;
		}

		if (parentInstance != null && _instanceFields.contains(id))
		{
			var v = Reflect.getProperty(parentInstance, id);
			return v;
		}

		error(EUnknownVariable(id));

		return null;
	}
}