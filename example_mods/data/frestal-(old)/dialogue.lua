local doDialogue = true
function onStartCountdown()
	if doDialogue and not seenCutscene and not allowCountdown and not isStoryMode then
		startDialogue('dialogue', 'OldDiaTheme') --breakfast is the dialogue music
		doDialogue = false
		return Function_Stop
	end
	return Function_Continue
end