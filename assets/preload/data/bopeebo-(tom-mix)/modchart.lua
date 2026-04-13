local dirs = { "x", "y", "z" }
local op, plr = "opponent", "player"

local l, e = "len", "end"

local debug = false

function callmods()
    for i in pairs(dirs) do
        local dir = dirs[i]
        startMod("beat" .. dir, "Beat" .. string.upper(dir), "all", 0)
        startMod(op .. "beat" .. dir, "Beat" .. string.upper(dir), op, 0)
        startMod(plr .. "beat" .. dir, "Beat" .. string.upper(dir), plr, 0)


        startMod(dir, string.upper(dir), "all", 0)
        startMod(op .. dir, string.upper(dir), op, 0)
        startMod(plr .. dir, string.upper(dir), plr, 0)

        startMod("drunk" .. dir, "Drunk" .. string.upper(dir), "all", 0)
        startMod(op .. "drunk" .. dir, "Drunk" .. string.upper(dir), op, 0)
        startMod(plr .. "drunk" .. dir, "Drunk" .. string.upper(dir), plr, 0)
    end

    startMod("brake", "Brake", "all", 0)
    startMod(op .. "brake", "Brake", op, 0)
    startMod(plr .. "brake", "Brake", plr, 0)

    startMod("boost", "Boost", "all", 0)
    startMod(op .. "boost", "Boost", op, 0)
    startMod(plr .. "boost", "Boost", plr, 0)

    startMod("yd", "YD", "all", 0)
    startMod(op .. "yd", "YD", op, 0)
    startMod(plr .. "yd", "YD", plr, 0)

    startMod("tipsy", "TipsyY", "all", 0)
    startMod(op .. "tipsy", "TipsyY", op, 0)
    startMod(plr .. "tipsy", "TipsyY", plr, 0)

    startMod("stealth", "Stealth", "all", 0)
    startMod(op .. "stealth", "Stealth", op, 0)
    startMod(plr .. "stealth", "Stealth", plr, 0)

    startMod("invert", "Invert", "all", 0)
    startMod(op .. "invert", "Invert", op, 0)
    startMod(plr .. "invert", "Invert", plr, 0)

    startMod("flip", "Flip", "all", 0)
    startMod(op .. "flip", "Flip", op, 0)
    startMod(plr .. "flip", "Flip", plr, 0)

    startMod("reverse", "Reverse", "all", 0)
    startMod(op .. "reverse", "Reverse", op, 0)
    startMod(plr .. "reverse", "Reverse", plr, 0)

    startMod("invsine", "InvertSine", "all", 0)
    startMod(op .. "invsine", "InvertSine", op, 0)
    startMod(plr .. "invsine", "InvertSine", plr, 0)

    startMod("tornado", "Tordnado", "all", 0)
    startMod(op .. "tornado", "Tordnado", op, 0)
    startMod(plr .. "tornado", "Tordnado", plr, 0)
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
    setdefault(200, "beatx", 1)
    setdefault(-200, "beatx", 2)
end

function modactions()
    perframe { 32, 64, function(b)
        local sinFunc = math.abs(math.sin((b*2)*(math.pi*0.5)))
        runHaxeCode([[
            game.camHUD.y = ]] .. -20*sinFunc .. [[;
            game.camGame.y = ]] .. -20*sinFunc .. [[;
        ]])
    end }
    m2{32, function()
        runHaxeCode([[
            game.healthBar.visible = false;
            game.healthBarBG.visible = false;
            game.healthSprite.visible = false;

            game.iconP1.visible = false;
            game.iconP2.visible = false;

            game.scoreTxt.visible = false;
        ]])
    end, true}
    m2{80, function()
        runHaxeCode([[
            game.healthBar.visible = false;
            game.healthBarBG.visible = false;
            game.healthSprite.visible = false;

            game.iconP1.visible = false;
            game.iconP2.visible = false;

            game.scoreTxt.visible = false;
        ]])
    end, true}

    m2{64, function()
        runHaxeCode([[
            game.healthBar.visible = true;
            game.healthBarBG.visible = true;
            game.healthSprite.visible = true;

            game.iconP1.visible = true;
            game.iconP2.visible = true;

            game.scoreTxt.visible = true;

            game.camHUD.y = 0;
            game.camGame.y = 0;
        ]])
    end, true}
    m2{128, function()
        runHaxeCode([[
            game.healthBar.visible = true;
            game.healthBarBG.visible = true;
            game.healthSprite.visible = true;

            game.iconP1.visible = true;
            game.iconP2.visible = true;

            game.scoreTxt.visible = true;

            game.camHUD.y = 0;
            game.camGame.y = 0;
        ]])
    end, true}

    perframe { 80, 92, function(b)
        local sinFunc = math.abs(math.sin((b*2)*(math.pi*0.5)))
        runHaxeCode([[
            game.camHUD.y = ]] .. -20*sinFunc .. [[;
            game.camGame.y = ]] .. -10*sinFunc .. [[;
        ]])

        local sineyfunc = math.sin((b*0.5)*(math.pi*0.5))
        local cosyfunc = math.cos((b*0.5)*(math.pi*0.5))
        setdefault((200*100)*sineyfunc, "x", 1)
        setdefault((200*100)*cosyfunc, "z", 1)

        setdefault((-200*100)*sineyfunc, "x", 2)
        setdefault((-200*100)*cosyfunc, "z", 2)
    end }
    perframe { 96, 128, function(b)
        local sinFunc = math.abs(math.sin((b*2)*(math.pi*0.5)))
        runHaxeCode([[
            game.camHUD.y = ]] .. -50*sinFunc .. [[;
            game.camGame.y = ]] .. -25*sinFunc .. [[;
        ]])

        local sineyfunc = math.sin((b*0.5)*(math.pi*0.5))
        local cosyfunc = math.cos((b*0.5)*(math.pi*0.5))
        setdefault((200*100)*sineyfunc, "x", 1)
        setdefault((200*100)*cosyfunc, "z", 1)

        setdefault((-200*100)*sineyfunc, "x", 2)
        setdefault((-200*100)*cosyfunc, "z", 2)
    end }

    eventsetup()
end

function InitCommand()
    callmods()
    modactions()
    setup()
    if debug then debugSetup() end

    for b = 0, 64 do
        if b < 32 or b >= 48 then
            me { b, 0.25, "quadOut", 50 * (b % 2 == 0 and 1 or -1), "tipsy" }
            me { b, 0.25, "quadOut", 12 * (b % 2 == 0 and 1 or -1), "flip", p = 1 }
            me { b, 0.25, "quadOut", -12 * (b % 2 == 0 and 1 or -1), "flip", p = 2 }
            me { b + 0.25, 0.75, "quadOut", 0, "tipsy" }

            me { b + 0.25, 0.75, "quadOut", 0, "flip", p = 1 }
            me { b + 0.25, 0.75, "quadOut", 0, "flip", p = 2 }
        end
    end

    me{
        32, 1, "sineOut",
        50, "opponentSwap"
    }
    me{
        32, 1, "linear",
        50, "stealth",
        100, "reverse",
        p=2
    }

    me{
        48, 1, "sineOut",
        0, "reverse",
        p=2
    }
    me{
        48, 1, "sineOut",
        100, "reverse",
        p=1
    }
    
    me{
        64, 1, "sineOut",
        0, "reverse",
        0, "beatx",
        p=1
    }
    me{
        64, 1, "linear",
        0, "stealth",
        0, "beatx",
        p=2
    }
    me{
        64, 1, "quadInout",
        0, "opponentSwap",
        100, "brake",
        100, "wiggle"
    }

    simple_mod{ 80,
        0, "brake",
        0, "wiggle"
    }
    me{
        80, 1, "quadOut",
        50, "opponentSwap"
    }
    simple_mod{80,
        50, "stealth",
        p=2
    }

    for b = 80, 128 do
        if b < 92 or b >= 96 then
            me { b, 0.25, "quadOut", 100 * (b % 2 == 0 and 1 or -1), "tipsy" }
            me { b + 0.25, 0.75, "quadOut", 0, "tipsy" }
        end
    end

    for i = 0, 7 do
        local change = ((i > 1 and i <= 3 or i > 4 and i < 5 or i >= 6 and i <= 7) and 0 or 1)
        me{96+(i*4), 1, "quadOut", 100*change, "reverse", p=(i%2==0 and 2 or 1)}
    end

    me{128, 144, "quadOut", 0, "z", 0, "x", p=1, mode=e}
    me{128, 144, "quadOut", 0, "z", 0, "x", 0, "stealth", p=2, mode=e}
    me{128, 144, "quadOut", 0, "opponentSwap", mode=e}

    me{144, 148, "linear", 100, "stealth", mode=e}

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
    if debug then debugUpdate(elapsed) end
end

function onDestroy()
    -- clearing everything up
end

-- template
local eases = {}
local sets = {}

pf = {}
event, curevent = {}, 1

function me(t)
    table.insert(eases, t)
end

function simple_mod(t)
    table.insert(sets, t)
end

function setdefault(val, mod, pn)
    local pl = { plr, op }
    local p = (pn ~= 0) and pl[pn] or ""
    setMod(p .. mod, val * 0.01)
end

function setsubdefault(val, mod, sub, pn)
    local pl = { plr, op }
    local p = (pn ~= 0) and pl[pn] or ""
    setSubMod(p .. mod, sub, val * 0.01)
end

function run_events()
    if #sets > 0 then
        local si = 1
        while si <= #sets do
            local s = sets[si]
            local pl = { plr, op }
            local p = s.p
            local pn = (p ~= 0) and pl[p] or ""
            for i = 2, #s, 2 do
                local mod = s[i + 1]
                set(s[1], (s[i] * 0.01) .. ", " .. pn .. mod)
            end

            si = si + 1
        end
    end
    if #eases > 0 then
        local ei = 1
        while ei <= #eases do
            local e = eases[ei]

            local pl = { plr, op }
            local p = e.p
            local pn = (p ~= 0) and pl[p] or ""

            local mode = e.mode
            local len = (mode == "end") and (e[2] - e[1]) or e[2]

            for i = 4, #e, 2 do
                local mod = e[i + 1]
                ease(e[1], len, e[3], (e[i] * 0.01) .. ", " .. pn .. mod)
            end

            ei = ei + 1
        end
    end
end

function eventsetup()
    function modtable_compare(a, b)
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
    table.insert(event, t)
end

function perframe(t)
    table.insert(pf, t)
end

function eventUpdate(elapsed)
    beat = (getSongPosition() / 1000) * (bpm / 60)
    while curevent <= #event and beat >= event[curevent][1] do
        if event[curevent][3] or beat < event[curevent][1] + 2 then
            event[curevent][2]()
        end
        curevent = curevent + 1;
    end
    curevent = 1

    if #pf > 0 then
        for i = 1, #pf do
            local e = pf[i]
            local len = (e.mode == "len") and (e[1] + e[2]) or e[2]
            if beat > e[1] and beat < len then
                e[3](beat)
            end
        end
    end
end

-- helper funcs

function math.clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

-- debug
function debugSetup()
    makeLuaText("debug", "", 0, (screenWidth / 2) - (screenWidth / 10) - 500, screenHeight / 2 - 390 / 1.5)
    setObjectCamera("debug", "other")
    setTextAlignment('debug', 'left')
    addLuaText("debug")
end

function debugUpdate(elapsed)
    setTextString("debug", "CurBeat: " .. curDecBeat .. "\n" .. "CurStep: " .. curDecStep.."\n#Ease Events: "..#eases.."\n#Set Events: "..#sets.."\n#M2: "..#event.."\n#Perframe: "..#pf)
    if keyboardJustPressed("H") then
        setProperty("debug.visible", not getProperty("debug.visible"))
    end
end