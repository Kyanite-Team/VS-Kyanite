package editors.language;

import haxe.ui.containers.dialogs.Dialog;

@:build(haxe.ui.ComponentBuilder.build("assets/exclude/ui/language/addTranslationDialog.xml"))
class AddTranslationKeyDialog extends Dialog
{
	public function new()
	{
		super();
		buttons = DialogButton.CANCEL | DialogButton.APPLY;
	}
}