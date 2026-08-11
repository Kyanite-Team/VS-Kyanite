package editors.language;

import haxe.ui.containers.menus.MenuBar;

@:build(haxe.ui.ComponentBuilder.build("assets/exclude/ui/language/menubar.xml"))
class EditorMenuBar extends MenuBar{
    public function new(){
        super();
    }
}