//
function initMod(mod)
{
	mod.subValues.set('variant', new ModifierSubValue(0.0));
	mod.subValues.set('speedaffect', new ModifierSubValue(1.0));

	mod.curPosMath = function(lane, curPos, pf)
	{
		var value = mod.currentValue % 360;

		var retu_val:Float = 1;
		var speedAffectM:Float = mod.subValues.get("speedaffect").value;
		var yValue:Float = FlxMath.fastSin(value * Math.PI / 180);

		var variant:Bool = (mod.subValues.get("variant").value >= 0.5);

		var laneThing = lane % NoteMovement.keyCount;

		if (variant)
		{
			if (lane % 4 == 1 || laneThing % 4 == 2)
				yValue *= -1;
		}
		else
		{
			if (laneThing % 2 == 1)
				yValue *= -1;
		}

		retu_val += yValue * 0.125 * speedAffectM;

		return curPos * retu_val;
	}

	mod.noteMath = function(noteData, lane, curPos, pf)
	{
		var value = mod.currentValue % 360;

		var invertValue:Float = 0;
		var yValue:Float = 0;

		invertValue = 50 - 50 * FlxMath.fastCos(value * Math.PI / 180);
		invertValue /= 100;

		yValue = 0.5 * FlxMath.fastSin(value * Math.PI / 180);

		var variant:Bool = (mod.subValues.get("variant").value >= 0.5);

		var laneThing = lane % NoteMovement.keyCount;

		if (variant)
		{
			if (laneThing % 4 == 1 || laneThing % 4 == 2)
				yValue *= -1;
		}
		else
		{
			if (laneThing % 2 == 1)
				yValue *= -1;
		}

		noteData.x += NoteMovement.arrowSizes[lane] * (laneThing % 2 == 0 ? 1 : -1) * invertValue;
		noteData.y += NoteMovement.arrowSizes[lane] * yValue;
	}

	mod.strumMath = function(noteData, lane, pf)
	{
		mod.noteMath(noteData, lane, 0, pf);
	}
}
