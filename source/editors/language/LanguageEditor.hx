package editors.language;

import haxe.ui.backend.flixel.UIState;
import flixel.FlxG;
import haxe.ui.containers.VBox;
import haxe.ui.components.Button;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.ScrollView;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import editors.language.*;
import editors.language.components.*;
import editors.cursor.Cursor;

class LanguageEditor extends UIState
{
	var menuBar:EditorMenuBar;
	var translationDialog:TranslationDialog;

	var languageFile:LanguageFile.Language;

	public var instance:LanguageEditor;

	public function new()
	{
		instance = this;
		super();
	}

	override function create()
	{
		menuBar = new EditorMenuBar();
		add(menuBar);
		translationDialog = new TranslationDialog();
		translationDialog.left = 10;
		translationDialog.top = 20;
		add(translationDialog);

		handleMenuInputs();

		Cursor.show();
		super.create();
	}

	override function update(elapsed:Float)
	{
		handleCursor();
		super.update(elapsed);
	}

	override function destroy()
	{
		Cursor.hide();
		super.destroy();
	}

	function handleCursor()
	{
		if (FlxG.mouse.justPressed)
			FlxG.sound.play(Paths.sound("editorSounds/ClickDown"));
		if (FlxG.mouse.justReleased)
			FlxG.sound.play(Paths.sound("editorSounds/ClickUp"));

		var targetCursorMode:Null<CursorMode> = null;

		Cursor.cursorMode = targetCursorMode ?? Default;
	}

	function handleMenuInputs()
	{
		menuBar.exitbtn.onClick = function(event)
		{
			FlxG.switchState(new editors.MasterEditorMenu());
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		menuBar.loadbtn.onClick = function(event)
		{
			Dialogs.openTextFile("Open Language File", [{label: "Language File", extension: "json"}], function(selectedFile)
			{
				if (selectedFile != null)
				{
					trace(selectedFile.name);
					languageFile = LanguageFile.loadJson(selectedFile.text);

					if (languageFile != null){
						for (i => key in languageFile.menuKeys)
						{
							var button:Button = new Button();
							var dialog:LanguageDialog = new LanguageDialog(key.key, key.translationKeys);
							button.text = key.key;
							button.onClick = function(event){
								dialog.showDialog();
							}
							translationDialog.translations.addComponent(button);
						}
					}

					/*if (languageFile != null)
					{
						translations.removeAllComponents();
						rootKey = translations.addNode({text: languageFile.id});
						for (i => key in languageFile.menuKeys)
						{
							var menu = rootKey.addNode({text: key.key});
							for (j => translation in key.translationKeys)
							{
								var item = menu.addNode({text: translation.key});
							}
						}
					}*/

					/* if (languageFile != null)
								{
									translationDialog.translations.removeAllComponents();
									for (i => key in languageFile.menuKeys)
									{
										var page:TranslationContent = new TranslationContent();
										page.text = key.key;
										for (j => item in key.translationKeys)
										{
											page.addButton(item.key);
										}
										translationDialog.translations.addComponent(page);
										var box:VBox = new VBox();
											box.text = key.key;
											box.styleNames = "translation_box";
											var scrollView:ScrollView = new ScrollView();
											scrollView.styleNames = "scroll_box";
											for (j => item in key.translationKeys){
												var button:Button = new Button();
												button.text = item.key;
												button.styleNames = "translation_box";
												scrollView.addComponent(button);
											}
											box.addComponent(scrollView);
											translationDialog.translations.addComponent(box);
							 
						}
					}*/
				}
			});
		}
	}
}
