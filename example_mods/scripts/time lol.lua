-----Settings------

local gfSpeed = 1;

-------------------

function onCreatePost()
	setProperty('timeBar.x', 30);
    setProperty('timeBarBG.x', 30);
	setProperty('timeBar.y', 705);
    setProperty('timeBarBG.y', 705);
    setProperty('timeTxt.x', -60);
    setProperty('timeTxt.y', 657);
end

function onBeatHit()

	if (curBeat % gfSpeed == 0) then
		if curBeat % (gfSpeed * 2) == 0 then
			setProperty('timeTxt.scale.x', 0.85 );
			setProperty('timeTxt.scale.y', 0.85 );

			setProperty('timeTxt.angle', 15);
		else
			setProperty('timeTxt.scale.x', 0.85 );
			setProperty('timeTxt.scale.y', 0.85 );

			setProperty('timeTxt.angle', -15);
		end
      end
end

function onUpdate()

    if (getProperty('timeTxt.angle') >= 0) then
	    if ('timeTxt.angle' ~= 0) then
    	    setProperty('timeTxt.angle', getProperty('timeTxt.angle')-1);
    	end
    else
        if ('timeTxt.angle' ~= 0) then
    	    setProperty('timeTxt.angle', getProperty('timeTxt.angle')+1);
    	end
    end
end