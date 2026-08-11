package editors.language;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import editors.language.*;

@:build(haxe.ui.ComponentBuilder.build("assets/exclude/ui/language/languageDialog.xml"))
class TranslationDialog extends Dialog{
    public function new(){
        super();

		/* addMenuKey.onClick = function(event)
		{
			var addKey:AddMenuKeyDialog = new AddMenuKeyDialog();
			addKey.showDialog(false);
			addKey.onDialogClosed = function(e)
			{
				if (e.button == DialogButton.APPLY)
				{
					var page:TranslationContent = new TranslationContent();
					page.text = addKey.menuKeyInput.text;
					translations.addComponent(page);
				}
			}
		} */
    }
}