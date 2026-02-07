local rotateBeat = false
function onEvent(name, value1)
  if name == 'HUD stuff' then
    if value1 == 'On' then
      rotateBeat = true
    else
      if value1 == 'Off' then
        rotateBeat = false
      end
    end
  end
end

function onBeatHit()
  if rotateBeat == true then
    triggerEvent('Add Camera Zoom', 0.015, 0.03)
    if curBeat % 2 == 0 then
      setProperty('camHUD.angle', 1.5)
    else
      setProperty('camHUD.angle', -1.5)
    end
    doTweenAngle('rotateTween', 'camHUD', 0, ((60/curBpm)/100)*95, 'sineOut')
  end
end