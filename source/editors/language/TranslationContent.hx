package editors.language;

import haxe.ui.containers.VBox;
import haxe.ui.components.Button;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import editors.language.*;
import editors.language.components.*;

@:build(haxe.ui.ComponentBuilder.build("assets/exclude/ui/language/translationContent.xml"))
class TranslationContent extends Button{
    public function new(){
        super();

		addkey.onClick = function(event){
			var addKey:AddTranslationKeyDialog = new AddTranslationKeyDialog();
			addKey.showDialog(false);
			addKey.onDialogClosed = function(e)
			{
				if (e.button == DialogButton.APPLY)
				{
					addButton(addKey.translationKeyInput.text);
				}
			}
        }
    }

    public function addButton(key:String, translation:String){
		var button:LanguageButton = new LanguageButton();
		button.text = text;
		button.styleNames = "translation_box";
		button.translation = translation;
		contentView.addComponent(button);
    }
}