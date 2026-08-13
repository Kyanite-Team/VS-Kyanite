package editors.language;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import lime.utils.Assets;

using StringTools;

typedef Language = {
    var id:String;
    var phrases:Array<Translations>;
}

typedef Translations = {
    var key:String;
    var translation:String;
}

class LanguageFile{
    public static var phrases:Map<String, String> = [];
    static var id:String;
    public static function loadJson(file:String){
        var path:String = null;
        if(FileSystem.exists(Paths.modFolders('language/${file}.json')))
			path = Paths.modFolders('language/${file}.json');
		else if (FileSystem.exists(Paths.getPreloadPath('language/${file}.json')))
			path = Paths.getPreloadPath('language/${file}.json');

        var rawJson:String = null;

		#if sys
		if (FileSystem.exists(path))
			rawJson = File.getContent(path).trim();
		else
		#end
		    rawJson = Assets.getText(path).trim();

        var languageJson:Language = parseJSON(rawJson);
        for(phrase in languageJson.phrases){
            if(!phrases.exists(phrase.key)){
                phrases.set(phrase.key, phrase.translation);
            }
        }
        id = languageJson.id;
    }

	public static function parseJSON(rawJson:String):Language
	{
		return cast Json.parse(rawJson);
	}

    public static function findPhrase(key:String):String{
		var returnPhrase:String = null;
        if (phrases.exists(key))
            returnPhrase = phrases.get(key);
        else
            returnPhrase = key;
        return returnPhrase;
    }

    public static function getLanguageFile(key:String):String{
        var tempPath:String = 'language/${id.toUpperCase()}/$key';
        var directories:Array<String> = [Paths.mods(tempPath), Paths.mods(Paths.currentModDirectory+tempPath), Paths.getPreloadPath(tempPath)];
        for (i => directory in directories){
            if (FileSystem.exists(directory))
                return directory;
        }
        return null;
    }
}