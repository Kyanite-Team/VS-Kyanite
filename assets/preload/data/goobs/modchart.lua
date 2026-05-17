local dirs = { "x", "y", "z" }
local ddirs = { "x", "y" }
local op, plr = "opponent", "player"

local l, e = "len", "end"

local debug = false

local mods = {
    "reverse", "Reverse",
    "scale", "Scale",
    "scalex", "ScaleX",
    "scaley", "ScaleY",
    "split", "Split",
    "cross", "Cross",
    "alternate", "Alternate",
    "sudden", "Sudden",
    "hidden", "Hidden",
    "boomerang", "Boomerang",
    "vanish", "Vanish",
    "stealth", "Stealth",
    "notestealth", "NoteStealth",
    "skew", "Skew",
    "skewx", "SkewX",
    "skewy", "SkewY",
    "dizzy", "Dizzy",
    "blink", "Blink",
    "twirl", "Twirl",
    "roll", "Roll",
    "tornado", "Tordnado",
    "drunk", "DrunkX",
    "drunky", "DrunkY",
    "drunkz", "DrunkZ",
    "xmod", "Speed",
    "x", "X",
    "y", "Y",
    "yd", "YD",
    "z", "Z",
    "tipsy", "TipsyY",
    "tipsyx", "TipsyX",
    "tipsyz", "TipsyZ",
    "tandrunk", "TanDrunkX",
    "tandrunky", "TanDrunkY",
    "tandrunkz", "TanDrunkZ",
    "tantipsy", "TanTipsyY",
    "tantipsyx", "TanTipsyX",
    "tantipsyz", "TanTipsyZ",
    "beat", "BeatX",
    "beaty", "BeatY",
    "beatz", "BeatZ",
    "flip", "Flip",
    "invert", "Invert",
    "invertsine", "InvertSine"
}

--[[ local dirmods = {
    "beat",
    "transform",
    "drunk",
    "tipsy",
    "tandrunk",
    "tantipsy"
}

local ddirmods = {
    "skew",
    "scale"
} ]]

function callmods()
    for i = 1, #mods, 2 do
        local modClass = mods[i + 1]
        local mod = mods[i]
        startMod(mod, modClass, "all")
        startMod(op .. mod, modClass, "opponent")
        startMod(plr .. mod, modClass, "player")
    end
end

function setup()
    setsubdefault(8 * 100, "sudden", "offset")
end

function modactions()
    local mult = 200
    local xmult = 200
    local timer = 4
    perframe { 32, 160, function(b)
        local sinewave = math.sin((b / timer) * (math.pi * 0.5))
        local coswave = math.cos((b / timer) * (math.pi * 0.5))

        setMod("opponentx", -xmult * sinewave)
        setMod("opponentz", -mult * coswave)
        setMod("playerx", xmult * sinewave)
        setMod("playerz", mult * coswave)
    end }
    perframe { 156, 160, function(b)
        local progression = (b - 160) / (160 - 156)
        mult = math.lerp(100, 0, progression)
        xmult = math.lerp(200, 0, progression)
    end }

    perframe { 64, 128, function(b)
        local sinewave = math.sin((b / 4) * (math.pi * 0.5))
        local fastsine = math.sin((b / 2) * (math.pi * 0.5))

        setProperty("camHUD.angle", 5 * sinewave)
        setProperty("camHUD.y", 10 * fastsine)
    end }

    m2 {128, function()
        setProperty("camHUD.angle", 0)
        setProperty("camHUD.y", 0)
    end}

    perframe { 64, 2, function(b)
        local progression = (b - 64) / ((64 + 2) - 64)
        mult = math.lerp(200, 100, progression)

        local alphaease = math.lerp(1, 0, progression)

        runHaxeCode([[
            game.healthBar.alpha = ]] .. alphaease .. [[;
            game.healthBarBG.alpha = ]] .. alphaease .. [[;
            game.healthSprite.alpha = ]] .. alphaease .. [[;

            game.iconP1.alpha = ]] .. alphaease .. [[;
            game.iconP2.alpha = ]] .. alphaease .. [[;

            game.scoreTxt.alpha = ]] .. alphaease .. [[;
        ]])
    end, mode = "len" }
    m2 { 64+2, function()
        runHaxeCode([[
            game.healthBar.alpha = 0;
            game.healthBarBG.alpha = 0;
            game.healthSprite.alpha = 0;

            game.iconP1.alpha = 0;
            game.iconP2.alpha = 0;

            game.scoreTxt.alpha = 0;
        ]])
    end, true}

    m2{96, function ()
        runHaxeCode([[
            game.healthBar.alpha = 1;
            game.healthBarBG.alpha = 1;
            game.healthSprite.alpha = 1;

            game.iconP1.alpha = 1;
            game.iconP2.alpha = 1;

            game.scoreTxt.alpha = 1;
        ]])
    end, true}
    m2{96, function()
        cameraFlash("hud", "0xFFFFFF", 0.5)
    end}
end

function InitCommand()
    callmods()
    modactions()
    setup()

    for b = 0, 32 - 1 do
        local mult = (b % 2 == 0) and 1 or -1
        me { b, 0.25, "quadOut", (50 * mult) * 100, "x", 120, "scale", 10, "flip" }
        me { b + 0.25, 0.5, "quadIn", 0, "x", 100, "scale", 0, "flip" }
    end

    me { 28, 32, "sineInOut", 200, "xmod", mode = "end" }

    me { 32, 1, "expoOut", 40, "xmod", 100, "sudden", 50, "tipsy", 50, "tipsyz", 50, "opponentSwap" }
    me { 32, 1, "linear", 50, "stealth", p = 2 }

    me { 48, 1, "quadOut", 200, "beat" }

    me { 64, 2, "circOut", 100, "reverse" }

    simple_mod{96, 0, "reverse", 0, "sudden"}

    me { 124, 128, "sineInOut", 0, "tipsy", 0, "tipsyz", 200, "wiggle", 50, "wiggle:freq", mode = "end" }

    me { 156, 160, "quadOut", 0, "opponentSwap", 0, "beat", 0, "wiggle", mode = "end" }
    me { 156, 160, "quadOut", 0, "stealth", mode = "end", p=2 }

    me{164, 168, "quadOut", 0, "x", 0, "z", mode = "end", p=1}
    me{164, 168, "quadOut", 0, "x", 0, "z", mode = "end", p=2}

    me{164, 168, "linear", 100, "stealth", mode = "end"}

    eventsetup()
    run_events()
end

function modupdate(elapsed)
    eventUpdate(elapsed)
end

-- initializing the modchart
function onCreatePost()
    luaDebugMode = debug
    if debug then debugSetup() end
    InitCommand()
end

function onUpdate(elapsed)
    if debug then debugUpdate(elapsed) end
    modupdate(elapsed)
end

function onDestroy()
    -- clearing everything up
end

-- template
local eases = {}

local func, curfunc = {}, 1
local perframes = {}

function m2(t)
    table.insert(func, t)
end

function perframe(t)
    table.insert(perframes, t)
end

function me(t)
    table.insert(eases, t)
end

function simple_mod(t)
    table.insert(t, 2, 0)
    table.insert(t, 3, "")
    table.insert(eases, t)
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

function eventsetup()
    function modtable_compare(a, b)
        return a[1] < b[1]
    end

    if #func > 1 then
        table.sort(func, modtable_compare)
    end
    if #perframes > 1 then
        table.sort(perframes, modtable_compare)
    end
end

function run_events()
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

function eventUpdate(elapsed)
    beat = curDecBeat
    while curfunc <= #func and beat >= func[curfunc][1] do
        if func[curfunc][3] or beat < func[curfunc][1] + 2 then
            func[curfunc][2]()
        end
        curfunc = curfunc + 1;
    end

    if #perframes > 0 then
        for i = 1, #perframes do
            local e = perframes[i]
            local len = (e.mode == "len") and (e[1] + e[2]) or e[2]

            if beat >= e[1] and beat <= len then
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

function math.lerp(a, b, t)
    return a + (b - a) * t
end

-- debug
function debugSetup()
    makeLuaText("debug", "", 0, (screenWidth / 2) - (screenWidth / 10) - 500, screenHeight / 2 - 390 / 1.5)
    setObjectCamera("debug", "other")
    setTextAlignment('debug', 'left')
    addLuaText("debug")
end

function debugUpdate(elapsed)
    setTextString("debug",
        "CurBeat: " ..
        curDecBeat ..
        "\n" ..
        "CurStep: " ..
        curDecStep ..
        "\n#Mod Events: " ..
        #eases .. "\n#M2: " .. #func ..
        "\n#Perframe: " .. #perframes)
    if keyboardJustPressed("H") then
        setProperty("debug.visible", not getProperty("debug.visible"))
    end
end
