function onEvent(name, value1, value2)
    if name == 'FlashWhite' then
        if not getPropertyFromClass('ClientPrefs', 'flashing') then
            return
        end

        cameraFlash('camGame', 'ffffff', tonumber(value1) or 1, true)
    end
end
