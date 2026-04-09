package;

import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;

using StringTools;

class AlphaText extends FlxSpriteGroup{
    public var text(default, set):String = "";

    public var textDisplay:FlxText;
    
    public var size:Int;
    public var bold:Bool;

    public var isMenuItem:Bool = false;
	public var targetY:Int = 0;
	public var changeX:Bool = true;
	public var changeY:Bool = true;

    public var distancePerItem:FlxPoint = new FlxPoint(20, 60);
	public var startPosition:FlxPoint = new FlxPoint(0, 0); //for the calculations

    public override function new(x:Float, y:Float, text:String = "", size:Int = 8, ?bold:Bool = false){
        super(x, y);

        textDisplay = new FlxText(x, y, 0, text, size);
        textDisplay.bold = bold;
        add(textDisplay);

        this.startPosition.x = x;
		this.startPosition.y = y;

        this.bold = bold;
        this.size = size;
    }

    function set_text(value:String):String{
        if (value == null)
			return value;
		if (textDisplay == null)
		{
			trace('WARN: Something went wrong!');
			return text = value;
		}

        value = value.replace('\\n', '\n');
        textDisplay.text = value;
        return text = value;
    }

    public function snapToPosition()
	{
		if (isMenuItem)
		{
			if(changeX)
				x = (targetY * distancePerItem.x) + startPosition.x;
			if(changeY)
				y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
		}
	}

    override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
			if(changeX)
				x = FlxMath.lerp(x, (targetY * distancePerItem.x) + startPosition.x, lerpVal);
			if(changeY)
				y = FlxMath.lerp(y, (targetY * 1.3 * distancePerItem.y) + startPosition.y, lerpVal);
		}
		super.update(elapsed);
	}
}