package editors.language;

import haxe.Json;

typedef Language = {
    var id:String;
    var display:String;
    var menuKeys:Array<MenuKeys>;
}

typedef MenuKeys = {
    var key:String;
    var translationKeys:Array<TranslationKeys>;
}

typedef TranslationKeys = {
    var key:String;
    var translation:String;
}

class LanguageFile{
    public static function loadJson(file:String):Language{
        var languageJson:Dynamic = parseJSON(file);
		return languageJson;
    }

	public static function parseJSON(rawJson:String):Language
	{
		return cast Json.parse(rawJson);
	}
}