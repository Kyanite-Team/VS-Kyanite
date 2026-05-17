//
function initMod(mod){
    mod.subValues.set("freq", new ModifierSubValue(1.0));
	mod.noteMath = function (noteData:NotePositionData, lane:Int, curPos:Float, pf:Int)
	{
		noteData.x += FlxMath.fastSin(0 + (curPos * (mod.subValues.get("freq").value * 0.004))) * (NoteMovement.arrowSizes[lane] * mod.currentValue * 0.5);
	}
}