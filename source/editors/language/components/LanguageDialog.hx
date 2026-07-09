package editors.language.components;

import haxe.ui.containers.dialogs.Dialog;
import editors.language.LanguageFile;

@:build(haxe.ui.ComponentBuilder.build("assets/exclude/ui/language/languageList.xml"))
class LanguageDialog extends Dialog{
    public function new(title:String, list:Array<LanguageFile.TranslationKeys>){
        super();
        this.title = title;
        for(i => translation in list){
            var language:LanguageButton = new LanguageButton(translation);
            languageList.addComponent(language);
        }
    }
}