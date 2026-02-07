local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.1);
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag)
	if tag == 'startDialogue' then
		triggerEvent('startDia')
		startDialogue('dialogue', 'Kyanite dialogue theme');
	end
	if tag == 'firstLine' then
        onSpeak(0)
    end
end

function onNextDialogue(count)
	onSpeak(count)
end

function onSkipDialogue(count)
	stopSound('dialogueLine')
end

function onSpeak(line)
	stopSound('dialogueLine')
	playSound('Kyanite dialogues/'..songPath..'/dialogue'..line+1, 1, 'dialogueLine')
end

function onEvent(name)
	if name == 'startDia' then
        runTimer('firstLine', 0.1)
	end
end