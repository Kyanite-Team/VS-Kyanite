package engine;

import flixel.FlxG;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.AssetType;

using StringTools;

typedef Language =
{
	var id:String;
	var display_name:String;
	var phrases:Array<Translations>;
}

typedef Translations =
{
	var key:String;
	var translation:String;
}

class LanguageFile
{
	public static var phrases:Map<String, String> = [];
	public static var displayName:String = null;
	static var id:String;

	public static function loadJson(file:String)
	{
		var rawJson:String = null;
		var dirs:Array<String> = [Paths.getPreloadPath('language/$file.json'), Paths.modFolders('language/$file.json')];

		for (dir in dirs){
			if (FileSystem.exists(dir))
				rawJson = CoolUtil.merge(rawJson, File.getContent(dir).trim());
		}

		/*if (FileSystem.exists(Paths.modFolders('language/${file}.json')))
			path = Paths.modFolders('language/${file}.json');
		else if (FileSystem.exists(Paths.getPreloadPath('language/${file}.json')))
			path = Paths.getPreloadPath('language/${file}.json');*/

		/* #if sys
		if (FileSystem.exists(path))
			rawJson = File.getContent(path).trim();
		else
		#end
		rawJson = Assets.getText(path).trim(); */

		return parseJSON(rawJson);
	}

	public static function loadLanguage(file:String){
		var languageJson = loadJson(file);
		displayName = languageJson.display_name;
		phrases = [];
		for (phrase in languageJson.phrases)
		{
			if (!phrases.exists(phrase.key)){
				phrases.set(phrase.key, phrase.translation);
			}
		}
		id = languageJson.id;
	}

	public static function parseJSON(rawJson:String):Language
	{
		return cast Json.parse(rawJson);
	}

	public static function getPhrase(key:String):String
	{
		var returnPhrase:String = null;
		if (phrases.exists(key))
			returnPhrase = phrases.get(key);
		else
			returnPhrase = key;
		return returnPhrase;
	}

	public static function getLanguageFile(key:String):String
	{
		var tempPath:String = 'language/$id/$key';
		return tempPath.trim().toLowerCase();
	}

	static function returnFlag(key:String)
	{
		var modKey:String = Paths.modFolders('language/flags/$key.png');
		trace(modKey);
		if (FileSystem.exists(modKey))
		{
			if (!Paths.currentTrackedAssets.exists(modKey))
			{
				var newBitmap:BitmapData = BitmapData.fromFile(modKey);
				var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, modKey);
				newGraphic.persist = true;
				Paths.currentTrackedAssets.set(modKey, newGraphic);
			}
			Paths.localTrackedAssets.push(modKey);
			return Paths.currentTrackedAssets.get(modKey);
		}

		var path = Paths.getPath('language/flags/$key.png', IMAGE, null);
		trace(path);
		if (OpenFlAssets.exists(path, IMAGE))
		{
			if (!Paths.currentTrackedAssets.exists(path))
			{
				var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
				newGraphic.persist = true;
				Paths.currentTrackedAssets.set(path, newGraphic);
			}
			Paths.localTrackedAssets.push(path);
			return Paths.currentTrackedAssets.get(path);
		}
		trace('oh no flags returning null NOOOO');
		return null;
	}

	public static function flag(key:String)
	{
		return returnFlag(key);
	}
}
