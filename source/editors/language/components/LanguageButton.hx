package editors.language.components;

import haxe.ui.components.Button;
import haxe.ui.containers.dialogs.Dialog;
import editors.language.LanguageFile;

class LanguageButton extends Button{
    public var translations:LanguageFile.TranslationKeys;
    public function new(key:TranslationKeys){
        super();
		translations = key;
        text = key.key;
    }
}