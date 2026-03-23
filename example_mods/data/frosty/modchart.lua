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

    startMod("brake", "Brake", "all", 0)
    startMod(op.."brake", "Brake", op, 0)
    startMod(plr.."brake", "Brake", plr, 0)

    startMod("boost", "Boost", "all", 0)
    startMod(op.."boost", "Boost", op, 0)
    startMod(plr.."boost", "Boost", plr, 0)

    startMod("yd", "YD", "all", 0)
    startMod(op.."yd", "YD", op, 0)
    startMod(plr.."yd", "YD", plr, 0)

    startMod("tipsy", "TipsyY", "all", 0)
    startMod(op.."tipsy", "TipsyY", op, 0)
    startMod(plr.."tipsy", "TipsyY", plr, 0)
    
    startMod("stealth", "Stealth", "all", 0)
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

    startMod("invsine", "InvertSine", "all", 0)
    startMod(op.."invsine", "InvertSine", op, 0)
    startMod(plr.."invsine", "InvertSine", plr, 0)
end

--[[function callplayermods(pn)
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

    startMod("stealth"..pn, "Stealth", "all", pn)
    startMod(op.."stealth"..pn, "Stealth", op, pn)
    startMod(plr.."stealth"..pn, "Stealth", plr, pn)

    startMod("invert"..pn, "Invert", "all", pn)
    startMod(op.."invert"..pn, "Invert", op, pn)
    startMod(plr.."invert"..pn, "Invert", plr, pn)

    startMod("flip"..pn, "Flip", "all", pn)
    startMod(op.."flip"..pn, "Flip", op, pn)
    startMod(plr.."flip"..pn, "Flip", plr, pn)
end]]

function setup()
    setdefault(50, "opponentSwap")

    setdefault(100, "stealth", 1)
    setdefault(50, "stealth", 2)

    setdefault(100, "brake")
end

function modactions()
    local mult = 0
    perframe{128, 188, function(b)
        if (b >= 160)then
            if b <= 165 then
                mult = math.clamp(((b-160)/5), 0, 1)
            end
            setMod(op.."z", 200*mult*math.cos(b/4))
            setMod(plr.."z", -200*mult*math.cos(b/4))
        end
        setMod(op.."x", 200*math.sin(b/4))
        setMod(plr.."x", -200*math.sin(b/4))
    end}

    perframe{192, 256, function(b)
        setMod("blacksphere", (math.deg(b*1.5))%360)
    end}

    m2{256-0.1, function()
        addHaxeLibrary('FlxCamera', 'flixel')
        runHaxeCode([[
            noteCam = new FlxCamera();
            noteCam.bgColor = 0x00;

            fakeNoteCam = new FlxCamera();
            fakeNoteCam.x = 0;
            fakeNoteCam.y = 0;
            fakeNoteCam.bgColor = 0x00;

            game.notes.cameras = [noteCam, fakeNoteCam];
            game.strumLineNotes.cameras = [noteCam, fakeNoteCam];
            game.playfieldRenderer.cameras = [noteCam, fakeNoteCam];
            game.grpNoteSplashes.cameras = [noteCam, fakeNoteCam];

            FlxG.cameras.remove(game.camOther, false);
            FlxG.cameras.remove(game.camHUD, false);
            FlxG.cameras.add(fakeNoteCam, false);
            FlxG.cameras.add(noteCam, false);
            FlxG.cameras.add(game.camHUD, false);
            FlxG.cameras.add(game.camOther, false);

            setVar('noteCam', noteCam);
            setVar('fakeNoteCam', fakeNoteCam);
        ]])
    end, true}

    perframe{256, 320, function(b)
        setProperty("noteCam.zoom", getProperty("camHUD.zoom"))
        setProperty("fakeNoteCam.zoom", getProperty("noteCam.zoom"))
    end}

    perframe{288, 320, function(b)
        setProperty("noteCam.x", ((b%8)/8)*1280)
        setProperty("fakeNoteCam.x", -1280+((b%8)/8)*1280)
        setMod("blacksphere", -(math.deg(b*1.5))%360)
    end}

    m2{320, function()
        setProperty("noteCam.x", 0)
        setProperty("fakeNoteCam.x", 0)
        setProperty("fakeNoteCam.x", 0)
        setProperty("fakeNoteCam.visible", false)
        setMod("blacksphere", 0)
    end, true}
    m2{320, function()
        runHaxeCode([[
            game.notes.camera = game.camHUD;
            game.strumLineNotes.camera = game.camHUD;
            game.playfieldRenderer.camera = game.camHUD;
            game.grpNoteSplashes.camera = game.camHUD;

            FlxG.cameras.remove(noteCam, true);
            FlxG.cameras.remove(fakeNoteCam, true);
        ]])
    end, true}

    eventsetup()
end

function InitCommand()
    callmods()
    modactions()
    setup()

    me{6, 2, "", 0, "stealth", p=1}

    for b = 0, 60, 4 do
        local dir = (b%8==0) and 1 or -1

        simple_mod{b, 400*dir, "wiggle", (100*100)*dir, "x", 10, "flip", 10, "invert"}
        me{b, 2, "sineOut", 0, "wiggle", 0, "x", 0, "flip", 0, "invert"}
    end

    for b = 64, 128 do
        local dir = (b%2==0) and 1 or -1

        simple_mod{b, 50*dir, "invert", 400*dir, "invsine"}
        me{b, 1, "quadOut", 0, "invert", 0, "invsine"}
    end

    for b = 128, 188, 4 do
        local dir = (b%8==0) and 1 or -1

        simple_mod{b, 400*dir, "wiggle", 10, "flip", 10, "invert"}
        me{b, 2, "sineOut", 0, "wiggle", 0, "flip", 0, "invert"}
    end

    for b = 192, 256 do
        local dir = (b%2==0) and 1 or -1

        simple_mod{b, -25*dir, "flip", 25*dir, "invert", 400*dir, "invsine"}
        me{b, 1, "quadOut", 0, "flip", 0, "invert", 0, "invsine"}
    end

    for b = 192, 256, 4 do
        local var = (b%8==0) and 1 or 0
        simple_mod{b, var*100, "blacksphere:variant"}
    end

    me{32, 0.5, "quadOut", 50, "tipsy"}

    me{58, 60, "sineOut", 0, "tipsy", mode=e}
    me{64, 68, "sineOut", 0, "stealth", p=2, mode=e}

    simple_mod{64, 0, "opponentSwap", 0, "brake"}

    simple_mod{128, 50, "opponentSwap", 100, "brake"}
    simple_mod{128, 50, "stealth", p=2}

    simple_mod{192, 0, "opponentSwap", 0, "brake"}
    simple_mod{192, 0, "z", 0, "x", p=1}
    simple_mod{192, 0, "z", 0, "x", 0, "stealth", p=2}

    me{256, 1, "cubeOut", 0, "blacksphere", 0, "blacksphere:variant"}

    simple_mod{288, 50, "stealth", p=2}
    simple_mod{320, 0, "stealth", p=2}

    run_events()
end

function modupdate(elapsed)
    eventUpdate(elapsed)
end

-- initializing the modchart
function onCreatePost()
    luaDebugMode = true
    InitCommand()
end
function onUpdate(elapsed)
    modupdate(elapsed)
end

-- template
local eases = {}
local sets = {}

pf = {}
event,curevent = {},1

function me(t)
    table.insert(eases, t)
end

function simple_mod(t)
    table.insert(sets, t)
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

function run_events()
    if #sets > 1 then
        local si = 1
        while si <= #sets do
            local s = sets[si]
            local pl = {plr, op}
            local p = s.p
            local pn = (p ~= 0) and pl[p] or ""
            for i = 2, #s, 2 do
                local mod = s[i+1]
                set(s[1], (s[i]*0.01)..", "..pn..mod)
            end

            si = si +1
        end
    end
    if #eases > 1 then
        local ei = 1
        while ei <= #eases do
            local e = eases[ei]

            local pl = {plr, op}
            local p = e.p
            local pn = (p ~= 0) and pl[p] or ""
            
            local mode = e.mode
            local len = (mode == "end") and (e[2]-e[1]) or e[2]

            for i = 4, #e, 2 do
                
                local mod = e[i+1]
                ease(e[1], len, e[3], (e[i]*0.01)..", "..pn..mod)
            end

            ei = ei +1
        end
    end
end

function eventsetup()
    function modtable_compare(a,b)
		return a[1] < b[1]
	end
    if #event > 1 then
		table.sort(event, modtable_compare)
	end
    if #pf > 1 then
        table.sort(pf, modtable_compare)
    end
end

function m2(t)
	table.insert(event,t)
end

function perframe(t)
    table.insert(pf, t)
end

function eventUpdate(elapsed)
    beat = (getSongPosition() / 1000) * (bpm/60)
    while curevent <= #event and beat>=event[curevent][1] do
		if event[curevent][3] or beat < event[curevent][1]+2 then
			event[curevent][2]()
		end
		curevent = curevent+1;
	end
    curevent = 1

    if #pf > 0 then
        for i = 1, #pf do
            local e = pf[i]
            local len = (e.mode == "len") and (e[1]+e[2]) or e[2]
            if beat > e[1] and beat < len then
                e[3](beat)
            end
        end
    end
end

-- helper funcs

function math.clamp(val,min,max)
	if val < min then return min end
	if val > max then return max end
	return val
end