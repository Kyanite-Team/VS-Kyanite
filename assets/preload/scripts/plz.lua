local dadsing = 0
local bfsing = 0

function opponentNoteHit(c,c,c,sus)
    if sus then
        dadsing = 4
    end
end

function goodNoteHit(c,c,c,sus)
    if sus then
        bfsing = 4
    end
end

function onSpawnNote(i)
    if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
        setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
    end
end

function onUpdate()
    if dadsing > 0 then
        setProperty('dad.holdTimer', 0)
    end
    if bfsing > 0 then
        setProperty('boyfriend.holdTimer', 0)
    end
end

function onStepHit()
    if dadsing > 0 then
        dadsing = dadsing-1
    end
    if bfsing > 0 then
        bfsing = bfsing-1
    end
end