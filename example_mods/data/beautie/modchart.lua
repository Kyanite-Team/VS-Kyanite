local dirs = {"x", "y", "z"}
local op, plr = "opponent", "player"

local l, e = "len", "end"

function callmods()
    for i in pairs(dirs) do
        local dir = dirs[i]
        startMod("beat"..dir, "Beat"..string.upper(dir), "all", 0)
        startMod(op.."beat"..dir, "Beat"..string.upper(dir), op, 0)
        startMod(plr.."beat"..dir, "Beat"..string.upper(dir), plr, 0)


        startMod(dir, string.upper(dir), "all", 0)
        startMod(op..dir, string.upper(dir), op, 0)
        startMod(plr..dir, string.upper(dir), plr, 0)

        startMod("drunk"..dir, "Drunk"..string.upper(dir), "all", 0)
        startMod(op.."drunk"..dir, "Drunk"..string.upper(dir), op, 0)
        startMod(plr.."drunk"..dir, "Drunk"..string.upper(dir), plr, 0)
    end

    startMod("yd", "YD", "all", 0)
    startMod(op.."yd", "YD", op, 0)
    startMod(plr.."yd", "YD", plr, 0)

    startMod("tipsy", "TipsyY", "all", 0)
    
    startMod(op.."stealth", "Stealth", op, 0)
    startMod(plr.."stealth", "Stealth", plr, 0)

    startMod("invert", "Invert", "all", 0)
    startMod(op.."invert", "Invert", op, 0)
    startMod(plr.."invert", "Invert", plr, 0)

    startMod("flip", "Flip", "all", 0)
    startMod(op.."flip", "Flip", op, 0)
    startMod(plr.."flip", "Flip", plr, 0)

    startMod("reverse", "Reverse", "all", 0)
    startMod(op.."reverse", "Reverse", op, 0)
    startMod(plr.."reverse", "Reverse", plr, 0)

    -- startMod("opponentSwap", "OpponentSwap", "all")
end

function callplayermods(pn)
    for i in pairs(dirs) do
        local dir = dirs[i]
        startMod("beat"..dir..pn, "Beat"..string.upper(dir), "all", pn)
        startMod(op.."beat"..dir..pn, "Beat"..string.upper(dir), op, pn)
        startMod(plr.."beat"..dir..pn, "Beat"..string.upper(dir), plr, pn)


        startMod(dir..pn, string.upper(dir), "all", pn)
        startMod(op..dir..pn, string.upper(dir), op, pn)
        startMod(plr..dir..pn, string.upper(dir), plr, pn)

        startMod("drunk"..dir..pn, "Drunk"..string.upper(dir), "all", pn)
        startMod(op.."drunk"..dir..pn, "Drunk"..string.upper(dir), op, pn)
        startMod(plr.."drunk"..dir..pn, "Drunk"..string.upper(dir), plr, pn)
    end

    startMod("yd"..pn, "YD", "all", pn)
    startMod(op.."yd"..pn, "YD", op, pn)
    startMod(plr.."yd"..pn, "YD", plr, pn)

    startMod(op.."stealth"..pn, "Stealth", op, pn)
    startMod(plr.."stealth"..pn, "Stealth", plr, pn)

    startMod("invert"..pn, "Invert", "all", pn)
    startMod(op.."invert"..pn, "Invert", op, pn)
    startMod(plr.."invert"..pn, "Invert", plr, pn)

    startMod("flip"..pn, "Flip", "all", pn)
    startMod(op.."flip"..pn, "Flip", op, pn)
    startMod(plr.."flip"..pn, "Flip", plr, pn)
end

function setup()
    setdefault(100, "tipsy")
    setdefault(100, "stealth", 1)
    setdefault(100, "stealth", 2)

    setdefault(50, "opponentSwap")
    setsubdefault(400, "drunkx", "speed")
end

function modactions()
    m2{70, function()
        addPlayfield(0, 0, 0)
        callplayermods(1)
        setdefault(720*100, "yd1")

        me(70, 0.5, "backOut", 550*100, "yd1", l)
        me(71, 0.5, "backOut", 720*100, "yd", l)

        me(71, 1, "backOut", 0, "yd1", l)

        me(72, 0.25, "circOut", 50, "opponentSwap1", l)
        me(72, 0.25, "circOut", 50, "stealth1", l, 2)

        simple_mod(76, 0, "yd")
        simple_mod(76, -100, "opponentSwap")
        me(78, 0.5, "backOut", -75, "opponentSwap", l)
        me(79, 1, "backOut", 50, "opponentSwap", l)
        me(79, 1, "circOut", -100, "opponentSwap1", l)
    end, true}

    m2{81, function()
        removePlayfield(1)
    end}
    
    eventsetup()
end

function InitCommand()
    callmods()
    modactions()
    setup()

    me(0, 1, "linear", 50, "stealth", l, 2)
    me(6, 4, "linear", 0, "stealth", l, 1)

    me(6, 4, "linear", 0, "stealth", l, 2)

    me(6, 4, "quadOut", 0, "opponentSwap", l)

    me(12, 4, "sineOut", 0, "tipsy", l)

    me(16, 0.5, "quadOut", 100, "beatx", l, 2)
    me(16, 0.5, "quadOut", -100, "beatx", l, 1)

    me(64, 0.5, "quartOut", 0, "beatx", l, 1)
    me(64, 0.5, "quartOut", 0, "beatx", l, 2)

    for b = 16, 28 do
        me(b, 0.5, "quadOut", -10, "reverse", l)
        me(b+0.5, 0.5, "quadIn", 0, "reverse", l)
    end

    me(32, 1, "circOut", 200, "beatx", l, 2)
    me(32, 1, "circOut", -200, "beatx", l, 1)

    for b = 0, 3 do
        local p = (b % 2 == 0) and 1 or 2
        local f = (b <= 1) and "" or "1"

        me(64+(b*4), 0.5, "quadOut", 100, "invert"..f, l, p)
        me(65+(b*4), 0.5, "quadOut", 0, "invert"..f, l, p)
        me(65+(b*4), 0.5, "quadOut", 100, "flip"..f, l, p)
        me(66+(b*4), 0.5, "quadOut", -100, "invert"..f, l, p)
        me(67+(b*4), 0.5, "quadOut", 0, "invert"..f, l, p)
        me(67+(b*4), 0.5, "quadOut", 0, "flip"..f, l, p)
    end

    simple_mod(72, 100, "drunkx")
    simple_mod(72, 100, "tipsy")
    simple_mod(72, 50, "opponentSwap")
    simple_mod(72, 50, "stealth", 2)

    simple_mod(96, 200, "beatx", 2)
    simple_mod(96, -200, "beatx", 1)

    me(96, 104, "sineInOut", 0, "drunkx", e)
    me(96, 104, "sineInOut", 0, "tipsy", e)
    me(96, 104, "sineInOut", 0, "opponentSwap", e)
    me(96, 104, "sineInOut", 0, "stealth", e, 2)

    me(136, 0.5, "circOut", 0, "beatx", l, 1)
    me(136, 0.5, "circOut", 0, "beatx", l, 2)
end

function perframe(elapsed)
    eventUpdate(elapsed)
end

-- initializing the modchart
function onCreatePost()
    luaDebugMode = true
    InitCommand()
end
function onUpdate(elapsed)
    perframe(elapsed)
end

-- template
event,curevent = {},1

function me(beat, len, easefunc, val, mod, type, pn)
    local easelen = 0
    local pl = {plr, op}
    local p = (pn ~= 0) and pl[pn] or ""

    if type == "len" then
        easelen = len
    elseif type == "end" then
        easelen = len-beat
    end

    ease(beat, easelen, easefunc, ""..(val*0.01)..", "..p..mod)
end

function simple_mod(beat, val, mod, pn)
    local pl = {plr, op}
    local p = (pn ~= 0) and pl[pn] or ""
    set(beat, ""..(val*0.01)..", "..p..mod)
end

function setdefault(val, mod, pn)
    local pl = {plr, op}
    local p = (pn ~= 0) and pl[pn] or ""
    setMod(p..mod, val*0.01)
end
function setsubdefault(val, mod, sub, pn)
    local pl = {plr, op}
    local p = (pn ~= 0) and pl[pn] or ""
    setSubMod(p..mod, sub, val*0.01)
end

function eventsetup()
    function modtable_compare(a,b)
		return a[1] < b[1]
	end
    if #event > 1 then
		table.sort(event, modtable_compare)
	end
end

function m2(t)
	table.insert(event,t)
end

function eventUpdate(elapsed)
    beat = (getSongPosition() / 1000) * (bpm/60)
    while curevent <= #event and beat>=event[curevent][1] do
		if event[curevent][3] or beat < event[curevent][1]+2 then
			event[curevent][2]()
		end
		curevent = curevent+1;
	end
end