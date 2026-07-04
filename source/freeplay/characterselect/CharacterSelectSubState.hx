package freeplay.characterselect;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import haxe.Json;
import lime.utils.Assets;
#if MODS_ALLOWED
import sys.*;
import sys.io.*;
#end
import flixel.FlxCamera;

import freeplay.characterselect.CharacterBox;

using StringTools;

typedef FreeplayCharacter = {
    var name:String;
    var character:String;
}

class CharacterSelectSubState extends MusicBeatSubstate
{   
    var charList:Array<String> = [];
	var directories:Array<String> = [
		Paths.getPreloadPath("freeplay/characters"),
		Paths.mods(Paths.currentModDirectory + 'freeplay/characters/'),
		Paths.mods("freeplay/characters")
	];

	var curChar:String;

	var grpChars:FlxTypedSpriteGroup<CharacterBox>;
	var grpSpacing = 10;

    override function create(){
        var charMap:Map<String, Bool> = new Map();

		for (mod in Paths.getGlobalMods())
            directories.push(Paths.mods(mod+'freeplay/characters'));

		for (i in 0...directories.length)
		{
			var directory:String = directories[i];
			if (FileSystem.exists(directory))
			{
				for (file in FileSystem.readDirectory(directory))
				{
					var path = haxe.io.Path.join([directory, file]);
					if (!sys.FileSystem.isDirectory(path) && file.endsWith('.json'))
					{
						var charToCheck:String = file.substr(0, file.length - 5);
                        if (!charMap.exists(charToCheck)){
						    charList.push(charToCheck);
                            charMap.set(charToCheck, true);
                            trace("Successfully loaded: "+path);
                        }
                        else
                            trace("Character already exists!: "+path);
					}
				}
			}
		}

		grpChars = new FlxTypedSpriteGroup<CharacterBox>();
		add(grpChars);

		grpChars.x = 150;
		grpChars.y = 150;

		// using this because of some weird issues
		var tempX:Float = 0;
		var tempY:Float = 0;

		// yey, math (from fnf v-slice but let's ignore that)
		for (index => char in charList){
			var xPos = (index % 5);
			var yPos = Math.floor(index / 5);

			var character = new CharacterBox((xPos * grpSpacing)+tempX, (yPos * grpSpacing)+tempY, char);
			tempX += character.x;
			tempY += character.y;

			trace(tempX);
			grpChars.add(character);
		}

        super.create();
    }

	override function destroy(){
		FlxG.switchState(FreeplayState.build({
			character: curChar
		}));
	}

	public static function loadJson(path:String):FreeplayCharacter
	{
		var rawJson = null;

		if (rawJson == null)
		{
			var curPath:String = "";

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
			// creditsJson = defaultData();
		}
		return creditsJson;
	}

	public static function parseJSONshit(rawJson:String):FreeplayCharacter
		return cast Json.parse(rawJson);
}
