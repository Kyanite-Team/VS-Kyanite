function onUpdatePost()
 setProperty("iconP1.scale.x", (getProperty("iconP1.scale.x") - 1) / 1.3 + 0.99)
 setProperty("iconP2.scale.x", (getProperty("iconP2.scale.x") - 1) / 1.3 + 0.99)
 if downscroll then
   setProperty("iconP1.y", -100 + (getProperty("iconP1.scale.y") * 100))
   setProperty("iconP2.y", -100 + (getProperty("iconP2.scale.y") * 100))
 else
   setProperty("iconP1.y", 470 + (getProperty("iconP1.scale.y") * 100))
   setProperty("iconP2.y", 470 + (getProperty("iconP2.scale.y") * 100))
 end
end

local gfSpeed = 2;

function onBeatHit()

	if (curBeat % gfSpeed == 2) then
		if curBeat % (gfSpeed * 2) == 2 then
			setProperty('iconP1.scale.y', 1.00001 );
			setProperty('iconP1.scale.x', 1.00001 );
			setProperty('iconP2.scale.y', 1.00001 );
			setProperty('iconP2.scale.x', 1.00001 );
		
			setProperty('iconP1.scale.x', 1.00001 );
			setProperty('iconP1.scale.y', 1.00001 );
			setProperty('iconP2.scale.x', 1.00001 );
			setProperty('iconP2.scale.y', 1.00001 );
 end  end  end
