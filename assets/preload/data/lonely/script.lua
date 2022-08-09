--[[
	hi kributs kributis bkirtus kiribts bkits kiributs kirbitus
	
	SCRIPT FROM AND BY RALTYRO
--]]

local keepOGTimebar = false -- be aware with memory leaks if this sets to true

-----------------------------------------------------------------------
-- NO TOUCHIES >:(
-----------------------------------------------------------------------







--[[ EASING ]]--

-- formulas from http://www.robertpenner.com/easing
easing = {
	-- linear
	linear = function(t,b,c,d)
		return c * t / d + b
	end,
	
	-- cubic
	inCubic = function(t, b, c, d)
		return c * math.pow(t / d, 3) + b
	end,
	outCubic = function(t, b, c, d)
		return c * (math.pow(t / d - 1, 3) + 1) + b
	end,
	inOutCubic = function(t, b, c, d)
		t = t / d * 2
		if t < 1 then return c / 2 * t * t * t + b end
		t = t - 2
		return c / 2 * (t * t * t + 2) + b
	end,
	outInCubic = function(t, b, c, d)
		if t < d / 2 then return outCubic(t * 2, b, c / 2, d) end
		return inCubic((t * 2) - d, b + c / 2, c / 2, d)
	end
}

--[[ TWEENNUMBER ]]--
local time = 0
local os = os
function os.clock()
	return time
end

tweenReqs = {}

function tnTick()
	local clock = os.clock()
	--print(songPos, #tweenReqs)
	if #tweenReqs > 0 then
		for i,v in next,tweenReqs do
			if clock>v[5]+v[6] then
				v[1][v[2]] =  v[7](v[6],v[3],v[4]-v[3],v[6])
				table.remove(tweenReqs,i)
				if v[9] then
					v[9]()
				end
			else
				v[1][v[2]] = v[7](clock-v[5],v[3],v[4]-v[3],v[6])
				--if (v[8]) then
				--	v[8] = false
				--	v[1][v[2]] = v[7](0,v[3],v[4]-v[3],v[6])
				--end
			end
		end
	end
end

function tweenNumber(maps, varName, startVar, endVar, time, startTime, easeF, onComplete)
	local clock = os.clock()
	maps = maps or getfenv()
	
	if #tweenReqs > 0 then
		for i2,v2 in next,tweenReqs do
			if v2[2] == varName and v2[1] == maps then
				v2[1][v2[2]] =  v2[7](v2[6],v2[3],v2[4]-v2[3],v2[6])
				table.remove(tweenReqs,i2)
				if v2[9] then
					v2[9]()
				end
				break
			end
		end
	end
	
	--print("Created TweenNumber: "..tostring(varName), startVar, endVar, time, startTime, type(onComplete) == "function")
	local t = {
		maps,
		varName,
		startVar,
		endVar,
		startTime or clock,
		time,
		easeF or easing.linear,
		true,
		onComplete
	}
	
	table.insert(tweenReqs,t)
	t[1][t[2]] = t[7](0,t[3],t[4]-t[3],t[6])
	
	return function()
		maps[varName] = t[7](v[6],t[3],t[4]-t[3],t[6])
		table.remove(tweenReqs,table.find(tweenReqs,t))
		if onComplete then
			onComplete()
		end
		return nil
	end
end

function strthing(s,i)
	local str = ""
	for i = 1,i do
		str = str .. s
	end
	return str
end

function math.clamp(x,min,max)return math.max(min,math.min(x,max))end
function math.lerp(from,to,i)return from+(to-from)*i end

function math.truncate(x, precision, round)
	if (precision == 0) then return math.floor(x) end
	
	precision = type(precision) == "number" and precision or 2
	
	x = x * math.pow(10, precision);
	return (round and math.floor(x + .5) or math.floor(x)) / math.pow(10, precision)
end

function math.snap(x, snap, next, round)
	snap = type(snap) == "number" and snap or 1
	next = type(ntext) == "number" and next or 0
	round = type(round) == "number" and round or .5
	
	return math.floor((x / snap) + round) * snap + (next * snap)
end

function math.toTime(x, includeMS, blankIfNotExist)
	local abs = math.abs(x)
	local int = math.floor(abs)
	
	local ms = tostring(abs - int):sub(2, 5)
	ms = ms .. strthing("0", math.floor(math.clamp(4 - #ms, 0, 3)))
	
	local s = tostring(math.fmod(int, 60))
	if (#s == 1) then s = "0" .. s end
	
	local m = tostring(math.fmod(math.floor(int / 60), 60))
	if (#m == 1 and (blankIfNotExist or int >= 3600)) then m = "0" .. m end
	
	local h = tostring(math.floor(int / 3600))
	
	local r = m .. ":" .. s
	if (int >= 3600) then r = h .. ":" .. r end
	
	return (x < 0 and "-" or "") .. (includeMS and r .. ms or r)
end

function toHexString(red, green, blue, prefix)
	if (prefix == nil) then prefix = true end
	
	return (prefix and "0x" or "") .. (
			string.format("%02X%02X%02X", red, green, blue)
		)
end

function centerOrigin(obj)
	setProperty(obj .. ".origin.x", getProperty(obj .. ".frameWidth") * .5)
	setProperty(obj .. ".origin.y", getProperty(obj .. ".frameHeight") * .5)
end

function getObjectRealClip(spr)
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
	
	return 
		getProperty(spr .. ".frame.frame.x"),
		getProperty(spr .. ".frame.frame.y"),
		getProperty(spr .. ".frame.frame.width"),
		getProperty(spr .. ".frame.frame.height")
end

function getObjectClip(spr)
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
	
	return 
		getProperty(spr .. "._frame.frame.x"),
		getProperty(spr .. "._frame.frame.y"),
		getProperty(spr .. "._frame.frame.width"),
		getProperty(spr .. "._frame.frame.height")
end

function setObjectClip(spr, x, y, width, height, offsetX, offsetY, offsetWidth, offsetHeight)
	-- Check and Fix Arguments
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
	x = (type(x) == "number" and x or getProperty(spr .. ".frame.frame.x")) + (type(offsetX) == "number" and offsetX or 0)
	y = (type(y) == "number" and y or getProperty(spr .. ".frame.frame.y")) + (type(offsetY) == "number" and offsetY or 0)
	width = type(width) == "number" and width >= 0 and width or getProperty(spr .. ".frame.frame.width") + (type(offsetWidth) == "number" and offsetWidth or 0)
	height = type(height) == "number" and height >= 0 and height or getProperty(spr .. ".frame.frame.height") + (type(offsetHeight) == "number" and offsetHeight or 0)
	
	-- ClipRect
	setProperty(spr .. "._frame.frame.x", x)
	setProperty(spr .. "._frame.frame.y", y)
	setProperty(spr .. "._frame.frame.width", width)
	setProperty(spr .. "._frame.frame.height", height)
	
	return x, y, width, height
end

local dFont = "vcr.ttf"

local avZoom = .0375
local cX = -10 + (1280 * avZoom)
local cY = 720 / 2 - (22 * 3) + (22 / 2)

function onCreate()
	precacheImage("NoteCombo")
	
	precacheSound("NoteComboExecute")
end

local texts = {}
local function quickText(name, text, i)
	makeLuaText(name, text, 1, cX, cY + (22 * i))
	setTextAlignment(name, "left")
	setTextFont(name, dFont)
	setTextSize(name, 16)
	
	setProperty(name .. ".wordWrap", false)
	setProperty(name .. ".autoSize", true)
	
	setProperty(name .. ".antialiasing", gAA)
	
	setScrollFactor(name, 0, 0)
	setObjectCamera(name, "hud")
	
	addLuaText(name, true)
	
	texts[name] = {}
	texts[name].text = text
end

local function quickUpdText(name, text)
	local sX = texts[name].sX
	local sY = texts[name].sY
	
	if (text ~= texts[name].text) then
		setTextString(name, text)
		centerOrigin(name)
		texts[name].text = text
	end
	
	setProperty("score.visible", not hideHud)
	setProperty("score.scale.x", sX)
	setProperty("score.scale.y", sY)
	
	if (texts[name].sX ~= sX) then texts[name].sX = sX end
	if (texts[name].sY ~= sY) then texts[name].sY = sY end
end

local function updC()
	gAA = getPropertyFromClass("ClientPrefs", "globalAntialiasing")
	hideHud = getPropertyFromClass("ClientPrefs", "hideHud")
end

function onCreatePost()
	updC()
	
	makeLuaText("kirbScoreTxt", "", 1280, 0, 0)
	setTextAlignment("kirbScoreTxt", "center")
	setTextFont("kirbScoreTxt", dFont)
	
	setProperty("kirbScoreTxt.antialiasing", gAA)
	
	setScrollFactor("kirbScoreTxt", 0, 0)
	setObjectCamera("kirbScoreTxt", "hud")
	
	addLuaText("kirbScoreTxt", true)
	
	quickText("sicks", "Sicks: 0\n", 0)
	quickText("goods", "Goods: 0\n", 1)
	quickText("bads", "Bads: 0\n", 2)
	quickText("shits", "Shits: 0\n", 3)
	quickText("misses", "Misses: 0\n", 4)
	
	makeAnimatedLuaSprite("ntCombo", "NoteCombo", 0, 0)
	addAnimationByPrefix("ntCombo", "anim", " NoteComboTextAppearAndDisappear", 24, false)
	scaleObject("ntCombo", .56, .56)
	
	setObjectCamera("ntCombo", "hud")
	
	setProperty("updateTime", false)
    setProperty("timeBar.parent", nil)
    setProperty("timeBar.parentVariable", nil)
	
	setTextSize("timeTxt", 20)
	setProperty("timeTxt.x", screenWidth / 2 - (400 / 2))
	setProperty("timeTxt.antialiasing", gAA)
	setTextFont("timeTxt", dFont)
	
	setTextSize("botplayTxt", 26)
	setProperty("botplayTxt.antialiasing", gAA)
	setTextFont("botplayTxt", dFont)
	setTextString("botplayTxt", "BOTPLAY\n")
	setBlendMode("botplayTxt", "alpha")
end

local isDead = false
function onGameOverStart()
	isDead = true
end

local wowCombo = 0
local prevCombo = 0
local dontPlayCombo = false
local gDt = 0
local noteComboX = 311
local noteComboY = 223
function onStepHit()
	if (isDead or getProperty("isDead")) then return end
	
	local thing = curBpm <= 140 and math.snap(((-curBpm + 140) / 2.5), 8) + 8 or 8
	
	if (math.fmod(curStep, thing) == 0) then
		local combo = getProperty("combo")
		
		wowCombo = math.clamp(combo - prevCombo, 0, 100)
		
		if (wowCombo >= 5 and not dontPlayCombo) then
			local canPlay = false
			
			local n = 0
			local songPos = getSongPosition() - (gDt * 1000)
			local et = songPos + (stepCrochet * thing)
			for i = 0, getProperty("notes.length") - 1 do
				local pos = getPropertyFromGroup("notes", i, "strumTime")
				if (
					getPropertyFromGroup("notes", i, "mustPress")
					and not getPropertyFromGroup("notes", i, "isSustainNote")
					and pos >= songPos and pos < et
				) then
					n = n + 1
				end
			end
			
			canPlay = n <= 0
			
			if (canPlay) then
				objectPlayAnimation("ntCombo", "anim", true, 13)
				setProperty("ntCombo.animation.curAnim.reversed", true)
				playSound("NoteComboExecute", 1)
				
				setProperty("ntCombo.x", noteComboX - 42)
				setProperty("ntCombo.y", noteComboY + 21)
				
				doTweenX("ntComboX", "ntCombo", noteComboX, .12, "quadout")
				doTweenY("ntComboY", "ntCombo", noteComboY, .12, "quadout")
				
				addLuaSprite("ntCombo")
				runTimer("ntCombo", 14 / 24)
				
				dontPlayCombo = true
				
				prevCombo = combo
			end
		end
		
		if (combo < prevCombo) then
			prevCombo = combo
		end
	end
end

_G["\112\114\105\110\116"]("\106\111\114\100\105\32\97\110\32\97\115\115\104\111\108\101")

function onTimerCompleted(t)
	if (t == "ntCombo") then
		dontPlayCombo = false
		removeLuaSprite("ntCombo", false)
	end
end

function onUpdate(dt)
	gDt = dt
	time = time + dt
end

local totalCombo = 0
local safeCombo = 0

local prevCombo = 0

local timeBarV = 0
local timeText = ""
function onUpdatePost(dt)
	updC()
	tnTick()
	
	if (isDead or getProperty("isDead")) then return end
	
	local combo = getProperty("combo")
	
	if (prevCombo > combo) then safeCombo = totalCombo end
	totalCombo = safeCombo + combo
	prevCombo = combo
	
	--local health = math.clamp(getHealth(), 0, 2)
	local ratingName = getProperty("ratingName")
	
	local scoreTxt = "Score: " .. tostring(getProperty("songScore"))
	local totalComboTxt = "Total Combo: " .. tostring(totalCombo)
	local ratingTxt = "Rating: " .. (
		ratingName == "?" and "?" or
		(
			ratingName ..
			" (" .. tostring(math.truncate(getProperty("ratingPercent") * 100, 2)) .. "%)" ..
			" - " .. getProperty("ratingFC")
		)
	)
	
	local finalTxt = scoreTxt .. " | " .. totalComboTxt .. " | " .. ratingTxt .. "\n"
	
	if (not keepOGTimebar) then setProperty("scoreTxt.visible", false) end
	if (getProperty("scoreTxt.visible") or not keepOGTimebar) then
		if (not keepOGTimebar) then
			getProperty("scoreTxt.width")
			setObjectClip("scoreTxt", 999999, 999999, 1, 1) -- force update
		end
		setProperty("kirbScoreTxt.visible", true)
		
		local width = getTextWidth("scoreTxt")
		local tS = getTextSize("scoreTxt") - 4
		
		if (getTextString("kirbScoreTxt") ~= finalTxt) then setTextString("kirbScoreTxt", finalTxt) end
		if (getTextSize("kirbScoreTxt") ~= tS) then setTextSize("kirbScoreTxt", tS) end
		if (getTextWidth("kirbScoreTxt") ~= width) then setTextWidth("kirbScoreTxt", width) end
		setProperty("kirbScoreTxt.x", getProperty("scoreTxt.x"))
		setProperty("kirbScoreTxt.y", getProperty("scoreTxt.y"))
		setProperty("kirbScoreTxt.angle", getProperty("scoreTxt.angle"))
	else
		setProperty("kirbScoreTxt.visible", false)
	end
	
	quickUpdText("sicks", "Sicks: " .. tostring(getProperty("sicks")) .. "\n", 0)
	quickUpdText("goods", "Goods: " .. tostring(getProperty("goods")) .. "\n", 1)
	quickUpdText("bads", "Bads: " .. tostring(getProperty("bads")) .. "\n", 2)
	quickUpdText("shits", "Shits: " .. tostring(getProperty("shits")) .. "\n", 3)
	quickUpdText("misses", "Misses: " .. tostring(getProperty("songMisses")) .. "\n", 4)
	
	local songPos = getSongPosition() / 1000

	timeText = math.toTime(songPos) .. " / " .. math.toTime(getProperty("songLength") / 1000) .. "\n"
    timeBarV = math.clamp(math.lerp(timeBarV, songPos / (getProperty("songLength") / 1000), math.clamp(dt * 4, 0, 1)), 0, 100)

    if (getProperty("timeBar.value") ~= timeBarV) then setProperty("timeBar.value", timeBarV) end
	
	if (getProperty("timeTxt.text") ~= timeText) then setProperty("timeTxt.text", timeText) end
end