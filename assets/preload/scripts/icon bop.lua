local gfSpeed = 1;

function onBeatHit()
	if (curBeat % gfSpeed == 0) then
		if curBeat % (gfSpeed * 2) == 0 then
			scaleObject('iconP1', 1.2, 0)
			scaleObject('iconP2', 1.2, 0)
		else
			scaleObject('iconP1', 1, 0)
			scaleObject('iconP2', 1, 0)
		end
	end
end