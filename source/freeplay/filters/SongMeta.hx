package freeplay.filters;

import haxe.Json;
import lime.utils.Assets;
#if MODS_ALLOWED
import sys.*;
import sys.io.*;
#end

using StringTools;

typedef MetaJSON = {
    var artist:String;
    var charter:String;
    var allowTwistedVariants:Bool;
    var freeplayCharacter:String;    
};

class SongMeta{
	public static function loadJson(path:String):MetaJSON
	{
		var rawJson = null;

		var formattedFolder:String = Paths.formatToSongPath(path);

		if (rawJson == null)
		{
			var curPath:String = Paths.json(formattedFolder + '/' + 'meta');

			#if sys
			if (FileSystem.exists(curPath))
				rawJson = File.getContent(curPath).trim();
			else
			#end
			rawJson = Assets.getText(Paths.json(curPath)).trim();
		}

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		var creditsJson:Dynamic = parseJSONshit(rawJson);
		if (creditsJson == null)
		{
			trace("Couldn't load song metadata! Check the file exists! `" + path + "`");
			creditsJson = defaultData();
		}
		return creditsJson;
	}

	public static function parseJSONshit(rawJson:String):MetaJSON
		return cast Json.parse(rawJson);

	public static function defaultData():MetaJSON
	{
		return {
			artist: "unknown",
			charter: "unknown",
			allowTwistedVariants: false,
			freeplayCharacter: "bf"
		};
	}
}