function onCreate()
	-- background shit
	makeLuaSprite('stages/Old Kyan Stage/bg', 'stages/Old Kyan Stage/bg', -600, -300);
	
	makeLuaSprite('no', 'no', -650, 600);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		setPropertyLuaSprite('no', 'flipX', true); --mirror sprite horizontally
		setLuaSpriteScrollFactor('no', 1.3, 1.3);
		scaleObject('no', 0.9, 0.9);
	end

	addLuaSprite('stages/Old Kyan Stage/bg', false);
	addLuaSprite('no', false);
	addLuaSprite('no', false);
	addLuaSprite('no', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end