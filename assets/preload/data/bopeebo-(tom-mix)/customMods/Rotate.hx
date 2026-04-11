//
function initMod(mod){
    var pivotPoint:Vector2 = new Vector2(0, 0);
	var point:Vector2 = new Vector2(0, 0);

	var strumXRotA:Array<Float> = [];
	var strumXRotB:Array<Float> = [];

	var strumYRotA:Array<Float> = [];
	var strumYRotB:Array<Float> = [];

	var strumZRotA:Array<Float> = [];
	var strumZRotB:Array<Float> = [];

	mod.subValues.set("x", new ModifierSubValue(0.0));
	mod.subValues.set("y", new ModifierSubValue(0.0));
	mod.subValues.set("z", new ModifierSubValue(0.0));

	mod.subValues.set('offset_x', new ModifierSubValue(0.0));
	mod.subValues.set('offset_y', new ModifierSubValue(0.0));
	mod.subValues.set('offset_z', new ModifierSubValue(0.0));

	function getPivot(noteData:NotePositionData, lane:Int, type:String = "x")
	{
		switch (type)
		{
			case "x":
				var r:Float = 0;
					
				//1 should return oponent's midPoint, while 2 should return player's
				var downStrumPosition:Float = NoteMovement.defaultStrumX[
					(lane < NoteMovement.keyCount ? (Std.int(NoteMovement.totalKeyCount/2)) : (NoteMovement.totalKeyCount)) - Std.int((NoteMovement.keyCount/2)) - 1
				];
				var upStrumPosition:Float = NoteMovement.defaultStrumX[
					(lane < NoteMovement.keyCount ? (Std.int(NoteMovement.totalKeyCount/2)) : (NoteMovement.totalKeyCount)) - Std.int((NoteMovement.keyCount/2))
				];

				var midPosition = (upStrumPosition - downStrumPosition) / 2;
				r += downStrumPosition + midPosition;
				r += mod.subValues.get("offset_x").value;
				return r;
			case "y":
				return ((FlxG.height/2) - (NoteMovement.arrowSize / 2)) + mod.subValues.get("offset_y").value;
			case "z":
				return 0.0 + mod.subValues.get("offset_z").value;
			default:
				return 0.0;
		}
	}

	function rotatePivot(noteData:NotePositionData, lane:Int, pf:Int, type:String = "x")
	{
		var angleX:Float = mod.subValues.get("x").value;
		var angleY:Float = mod.subValues.get("y").value;
		var angleZ:Float = mod.subValues.get("z").value;

		switch (type)
		{
			case "z":
				pivotPoint.x = getPivot(noteData, lane, "x");
				pivotPoint.y = getPivot(noteData, lane, "y");
				point.x = noteData.x;
				point.y = noteData.y;
				var output:Vector2 = ModchartUtil.rotateAround(pivotPoint, point, angleZ);
				noteData.x = output.x;
				noteData.y = output.y;
				strumZRotA[lane] = point.x - output.x;
				strumZRotB[lane] = point.y - output.y;
			case "y":
				pivotPoint.x = getPivot(noteData, lane, "x");
				pivotPoint.y = getPivot(noteData, lane, "z");
				point.x = noteData.x;
				point.y = noteData.z;
				var output:Vector2 = ModchartUtil.rotateAround(pivotPoint, point, angleY);
				noteData.x = output.x;
				noteData.z = output.y;
				strumYRotA[lane] = point.x - output.x;
				strumYRotB[lane] = point.y - output.y;
			case "x":
				pivotPoint.x = getPivot(noteData, lane, "z");
				pivotPoint.y = getPivot(noteData, lane, "y");
				point.x = noteData.z;
				point.y = noteData.y;
				var output:Vector2 = ModchartUtil.rotateAround(pivotPoint, point, angleX);
				noteData.z = output.x;
				noteData.y = output.y;
				strumXRotA[lane] = point.x - output.x;
				strumXRotB[lane] = point.y - output.y;
		}
	}

    mod.noteMath = function(noteData, lane, curPos, pf){
        rotatePivot(noteData, lane, pf, "x");
		rotatePivot(noteData, lane, pf, "y");
		rotatePivot(noteData, lane, pf, "z");
    }

    mod.strumMath = function(noteData, lane, pf){
        mod.noteMath(noteData, lane, 0, pf);
    }
}