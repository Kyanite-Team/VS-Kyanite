function onCreate() 
	setProperty('introSoundsSuffix', '-amogusinirl')
end

--Countdown Time
function onCountdownTick(counter)
	if counter == 0 then
		playSound('intro3-og')
	elseif counter == 1 then
		playSound('intro2-og')	
	elseif counter == 2 then
		playSound('intro1-og')
	elseif counter == 3 then
		playSound('introGo-og')
	end
end