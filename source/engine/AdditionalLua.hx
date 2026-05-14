package engine;

import haxe.Json;
import openfl.net.FileReference;
import flixel.FlxG;
#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

import modcharting.Modifier;
import modcharting.PlayfieldRenderer;
import modcharting.NoteMovement;
import modcharting.ModchartUtil;
import modcharting.ModchartMusicBeatState;

import openfl.events.Event;
import openfl.events.IOErrorEvent;

using StringTools;

class AdditionalLua{
    #if LUA_ALLOWED
    public static function loadAdditionalLua(){
        for (funkin in PlayState.instance.luaArray){
            Lua_helper.add_callback(funkin.lua, "getMod", function(name:String, base:Bool = false){
                var result = getMod(name, base);
                return result;
            });
            Lua_helper.add_callback(funkin.lua, "getSubMod", function(name:String, subMod:String, base:Bool = false){
                var result = getSubMod(name, subMod, base);
                return result;
            });
        }
    }
    #end

    public static function getMod(name:String, base:Bool, ?instance:ModchartMusicBeatState = null):Dynamic{
        if (instance == null) instance = PlayState.instance;

        if (instance.playfieldRenderer.modifierTable.modifiers.exists(name)){
            if (!base)
                return instance.playfieldRenderer.modifierTable.modifiers.get(name).currentValue;
            else
                return instance.playfieldRenderer.modifierTable.modifiers.get(name).baseValue;
        }
        else
            return 0;
    }
	public static function getSubMod(name:String, subValName:String, base:Bool, ?instance:ModchartMusicBeatState = null):Dynamic
	{
		if (instance == null)
		{
			// if (editor)
			//     instance = EditorPlayState.instance;
			// else
			instance = PlayState.instance;
		}

		if (instance.playfieldRenderer.modifierTable.modifiers.exists(name))
		{
			if (instance.playfieldRenderer.modifierTable.modifiers.get(name).subValues.exists(subValName))
			{
				if (!base)
					return instance.playfieldRenderer.modifierTable.modifiers.get(name).subValues.get(subValName).value;
				else
					return instance.playfieldRenderer.modifierTable.modifiers.get(name).subValues.get(subValName).baseValue;
			}
			else
			{
				return 0;
			}
		}
		else
			return 0;
	}
}