//
function initMod(mod)
{
	mod.noteMath = function(noteData, lane, curMos, pf)
	{
		var distX = FlxG.width * .5;
        noteData.x -= (distX * ((lane>3)? 1:-1))*mod.currentValue;
	}
	mod.strumMath = function(noteData, lane, pf)
	{
		mod.noteMath(noteData, lane, 0, pf);
	}
}
