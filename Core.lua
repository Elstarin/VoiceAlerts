--------------------------------------------------------------------------------
-- Sound File Format
--------------------------------------------------------------------------------
--[[
Format should be:
Delay -- This is the seconds it should be announced before bar expires. Must be 0 if it triggers at 0 seconds.
Name -- One word that is contained in the bar, doesn't matter what one, but can't be used by another file on the same fight
Count -- This matches the number in ( ) if it is on the bar. If this is irrelevant for your sound file, make it 0.
Role -- If you want it for a specific role. Different roles are "D", "H", and "T". Ignore otherwise.
If you want it to exclude one role, like play for tank and healer but not DPS, just duplicate the file, making one "T" and one "H".
]]

--------------------------------------------------------------------------------
-- Locals, Frames, and Tables
--------------------------------------------------------------------------------
if not BigWigsLoader then return end

VoiceAlerts = {}
local VA = VoiceAlerts
VA.events = CreateFrame("Frame")
VA.events:RegisterEvent("ENCOUNTER_START")
VA.events:RegisterEvent("ENCOUNTER_END")
VA.events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
VA.events:RegisterEvent("PLAYER_ENTERING_WORLD")
VA.events:RegisterEvent("ZONE_CHANGED")
VA.events:RegisterEvent("VARIABLES_LOADED")
VA.events:RegisterEvent("PLAYER_LOGIN")

VA.CLEU = CreateFrame("Frame")
VA.CLEU:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

VA.onUpdate = CreateFrame("Frame")
VA.boss = {}
VA.boss.data = {}
VA.registerBoss = {}
VA.boss.text = {}
VA.bossIndex = {}
VA.plugins = {}
local timerBars = {}
local textTable = {}
local queuedSound = {}
local bossID = {}

local DB, charDB, spellDB, barDB, buttonDB

local disableMessages = true
-- local stopMessagesAfter = 5
local disableBarSounds = true
local disablePremadeSound = true
-- local testMode = true
-- local testName = "Kilrogg Deadeye"
-- local testName = false
local diagnostics = false

local Jocys = "<message group=%q volume=%q command=%q><part>%s</part></message>"

local args = {}

local class, CLASS, classID = UnitClass("player")
local pName = GetUnitName("player", false)
local pNameRealm = GetUnitName("player", true)
local pGUID = UnitGUID("player")
local defaultVolume = 0
local volumeOnPlayer = 0

local channel = "Master"

local dispels = {
	["MONK"] = 115450, -- Detox (Monk)
	["SHAMAN"]	=	77130, -- 51886, -- Purify Spirit, Cleanse Spirit
	["PRIEST"] = 527, -- Purify
	["PALADIN"] = 4987, -- Cleanse
}

local purges = {
	["PRIEST"] = 528, -- Dispel Magic
	["HUNTER"] = 19801, -- Tranquilizing Shot
	["SHAMAN"] = 370, -- Purge
}

local interrupts = {
	["HUNTER"] = 147362, -- Counter Shot
	["PALADIN"] = 96231, -- Rebuke
}

local format = format
--------------------------------------------------------------------------------
-- General Functions
--------------------------------------------------------------------------------
local function registerBoss(bossName, instanceName, instanceType)
	VA.trashName = instanceName .. " Trash"

  if not VA.registerBoss[bossName] then
		if bossName ~= "Trash" then
			print(bossName)
			print("Failed to find registry function for", bossName .. "!")
		end

		bossName = VA.trashName
	end

  if VA.registerBoss[bossName] then
		VA.registerBoss[bossName]() -- Loads up the spell list
	end

  VA.filePath = ("CustomSound\\%s\\%s\\%s%s%s.mp3"):format(instanceName, bossName, "%s", "%s", "%s")
  VA.filePathRole = ("CustomSound\\%s\\%s\\%s%s%s%s.mp3"):format(instanceName, bossName, "%s", "%s", "%s", VA.role)

  VA.filePathEvent = ("CustomSound\\%s\\%s\\%s.mp3"):format(instanceName, bossName, "%s")
  VA.filePathEventRole = ("CustomSound\\%s\\%s\\%s%s.mp3"):format(instanceName, bossName, "%s", VA.role)

	if VA.boss.data[bossName] then
		VA.populateContent(VA.boss.data[bossName], bossName)
	end

	if testName and VA.registerBoss[bossName] then testName = bossName end
end

local function updateRole()
	local _, _, _, _, _, role = GetSpecializationInfo(GetSpecialization())
	VA.role = strmatch(role, "%a") -- Get the first letter of role (T, D, or H)
end

local function canInterrupt()
	if interrupts[CLASS] then
		local CD = GetSpellCooldown(interrupts[CLASS])

    if CD < 0.5 then
      return true
    end
	end
end

local function canDispel()
	if dispels[CLASS] then
		local CD = GetSpellCooldown(dispels[CLASS])

    if CD < 0.5 then
      return true
    end
	end
end
--------------------------------------------------------------------------------
-- Boss Functions
--------------------------------------------------------------------------------
local brackets = {}
local recentStrings = {}
local function chatMessage(group, volume, command, text, originalText, frame, onPlayer, remaining)
	if frame and frame.button and frame.button:GetChecked() then return end -- Stop it from playing if checked

	if text:find("Interrupt") and not canInterrupt() then return end -- If it's interrupt and I can't, don't play any sound
	if text:find("Dispel") and not canDispel() then return end -- If it's dispel and I can't, don't play any sound

	if onPlayer or text:match("on YOU!") then volume = (volume or 0) + volumeOnPlayer end -- NOTE: Set to 0

	local string

	if text:find("%b[]") then -- Text has [brackets]
		wipe(brackets)

		for bracket in text:gmatch("(%b[])") do
			brackets[#brackets + 1] = bracket
		end

		for i, bracket in ipairs(brackets) do
			local l1, l2, l3, l4 = bracket:match("^%[(%u?)(%u?)(%u?)(%u?):") -- Find all the letter flags
			brackets[i] = nil

			local P, R, D, H, T
			local cR = VA.role or "None"
			if l1 == "P" or l2 == "P" or l3 == "P" or l4 == "P" then P = true end
			if l1 == cR or l2 == cR or l3 == cR or l4 == cR then R = true end
			if l1 == "D" or l2 == "D" or l3 == "D" or l4 == "D" then D = true end
			if l1 == "H" or l2 == "H" or l3 == "H" or l4 == "H" then H = true end
			if l1 == "T" or l2 == "T" or l3 == "T" or l4 == "T" then T = true end
			local letter = D or H or T

			if onPlayer and P and R then -- Player and role matched
				if not brackets[110] then brackets[110] = bracket end
			elseif onPlayer and P and not R and not letter then -- Player matched and no role or letter
				if not brackets[108] then brackets[108] = bracket end
			elseif P and letter and not R then -- Player matched, but invalid role
				if not brackets[100] then brackets[100] = bracket end
			elseif R and not P then -- Role matched, no player flag
				if not brackets[107] then brackets[107] = bracket end
			elseif not P and not R and letter then -- Only matched an invalid role
				if not brackets[100] then brackets[100] = bracket end
			else -- Unknown combination
				if not brackets[100] then brackets[100] = bracket end
			end
		end

		local highest = 100
		for priority, text in pairs(brackets) do
			if priority > highest then
				highest = priority
				string = text
			end
		end

		if string then string = string:match("%[.+:%s?(.+)%]") end -- Grab the [FLAG: text]
	end

	if not string then string = text end

	local count = string:match("%((.+)%)")
	if count and originalText then
		local originalCount = originalText:match("%((.+)%)") or 0

		if originalCount then
			if count == "all" or count == "All" or count == "ALL" then
				string = string .. " " .. originalCount
			else
				local success

				for num in count:gmatch("%d+") do
					if num == originalCount then
						success = true
						print("Success!", num, originalCount)
						string = string .. " " .. num
					end
				end
			end
		end
	end

	string = string:gsub("%s?%b()", "") -- Remove (text)
	string = string:gsub("(%b[])%s?", "") -- Remove [Text: text]

	do -- Handle remaining number
		if remaining and string:find("<(.+)>") then
			local success

			for num in string:gmatch("[<?,?]+%s?(%d+)") do
				if (num + 0) == remaining then
					success = true
				end
			end

			if not success then
				return diagnostics and print("Remaining time was sent, but couldn't match <numbers>.")
			elseif success and remaining > 0 then
				string = string .. " in " .. remaining -- Makes sure "in X" is only added if that part of the string had <text>
			end
		elseif remaining then
			return diagnostics and print("Had remaining time, but no <numbers>")
		end
	end

	string = string:gsub("%s?<.+>", "") -- Remove <text>

	if not string or string == "" then return end

	if diagnostics and not volume or volume == 0 then return end

	local cTime = GetTime()
	if recentStrings[string] and (recentStrings[string] + 2) >= cTime then
		return -- diagnostics and print("Cancelling message because it happened", floor(cTime - recentStrings[string]), "seconds ago.")
	else
		recentStrings[string] = cTime
	end

	SendChatMessage(Jocys:format((group or ""), (volume or 40), command, string), "WHISPER", "Common", pNameRealm)
	_G["ChatFrame1"].tellTimer = GetTime() + 0.5 -- Should stop the whisper sound

	if diagnostics then print("Final:", string) end
end

local function stopMessages(group)
	if group then
		SendChatMessage('<message command="Stop" group="' .. group .. '" />', "WHISPER", "Common", pNameRealm)
	else
		SendChatMessage('<message command="Stop" />', "WHISPER", "Common", pNameRealm)
	end
end

C_Timer.NewTicker(60, function() -- Clears out the recent strings table every 60 seconds to stop it from getting too big
	local cTime = GetTime()

	for text, time in pairs(recentStrings) do
		if cTime >= (time + 30) then
			recentStrings[text] = nil
		end
	end
end)

if testMode then
  -- C_Timer.After(2, function()
  --   -- VA.role = "H" -- Set fake role
  --   local bossName = testName
  --   local raidName = "Hellfire Citadel"
  --   registerBoss(bossName, raidName, "raid")
  --   VA.bossName = bossName
  -- end)

  -- C_Timer.After(3, function()
  --   -- local event = "SPELL_CAST_START"
  --   -- local event = "SPELL_CAST_SUCCESS"
  --   local event = "SPELL_AURA_APPLIED"
  --   -- local event = "SPELL_AURA_APPLIED_DOSE"
  --   -- local event = "SPELL_AURA_REMOVED"
	-- 	-- print("Sending sound")
  --   -- CLEU(nil, nil, nil, event, nil, nil, nil, nil, nil, nil, "Elstari", nil, nil, 184369, nil)
	--
	-- 	-- C_Timer.After(2, function()
	-- 	-- 	local event = "SPELL_AURA_REMOVED"
	--   --   CLEU(nil, nil, nil, event, nil, nil, nil, nil, nil, nil, "dstName", nil, nil, 184369, nil)
	-- 	-- end)
  -- end)
end
--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------
local function CLEU(_, _, time, event, hide, srcGUID, srcName, _, _, dstGUID, dstName, _, _, spellID, spellName)
	local boss = VA.boss.data[VA.bossName or VA.trashName]

	if VA.contentFrame.frames and VA.contentFrame.frames[event] and VA.contentFrame.frames[event][spellID] then
		local frame = VA.contentFrame.frames[event][spellID]
		local text = frame.editBox:GetText()

		if dstName and dstName:match(pName) then
			chatMessage(group, 20, "Play", text, frame.baseText, frame, true)
		else
			chatMessage(group, 20, "Play", text, frame.baseText, frame)
		end
	end
end

VA.CLEU:SetScript("OnEvent", CLEU)

VA.events:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED" then
		if IsLoggedIn() then
			updateRole()
			registerBoss("Trash", GetInstanceInfo())
		end
	elseif event == "PLAYER_LOGIN" then
		if testMode then VA.base:Show() end
	elseif event == "VARIABLES_LOADED" then
		if not VoiceAlertsDB then VoiceAlertsDB = {} end
		if not VoiceAlertsDB.buttonStatus then VoiceAlertsDB.buttonStatus = {} end
		if not VoiceAlertsDB.spells then VoiceAlertsDB.spells = {} end
		if not VoiceAlertsDB.bars then VoiceAlertsDB.bars = {} end
		if not VoiceAlertsCharDB then VoiceAlertsCharDB = {} end

		DB = VoiceAlertsDB
		charDB = VoiceAlertsCharDB
		spellDB = VoiceAlertsDB.spells
		barDB = VoiceAlertsDB.bars
		buttonDB = VoiceAlertsDB.buttonStatus
		-- wipe(barDB)
		-- wipe(spellDB)
		-- wipe(buttonDB)
  elseif (event == "ENCOUNTER_START") then
    local encounterID, bossName, difficultyID, raidSize = ...
    VA.bossName = bossName
    registerBoss(bossName, GetInstanceInfo())
	elseif (event == "ENCOUNTER_END") then
    local encounterID, bossName, difficultyID, raidSize, result = ...
    VA.bossName = nil
    registerBoss(bossName, GetInstanceInfo())
	end
end)
--------------------------------------------------------------------------------
-- BigWigs Event Functions
--------------------------------------------------------------------------------
local function addBarSVar(bossName, key, text, time, icon, isApprox)
	if not bossName or not text then return end

	local string = text
	string = string:gsub("(%b[])%s?", "") -- Remove: [Text: text]
	string = string:gsub("%s?%b()", "") -- Remove: (text)
	string = string:gsub("%s?<.+>", "") -- Remove: <text>
	string = string:gsub(" on YOU!", "") -- Remove: on YOU!
	string = string:trim()
	local stringNL = string
	string = string:lower()
	if not string or string == "" then return end

	if not barDB[bossName] then barDB[bossName] = {} end

	if not barDB[bossName][string] then
		barDB[bossName][string] = {
			["timer"] = {time},
			["text"] = text,
			["string"] = string,
			["stringNL"] = stringNL,
			["icon"] = icon,
			["key"] = key,
			["isApprox"] = isApprox,
		}
	else
		local bar = barDB[bossName][string]
		local matched

		for i = 1, #bar.timer do
			if bar.timer[i] == time then
				matched = true
			end
		end

		if not matched then
			bar.timer[#bar.timer + 1] = time

			sort(bar.timer, function(a, b)
				return b > a
			end)
		end
	end

	return barDB[bossName][string], string, stringNL
end

local function testBars(mod) -- Force BigWigs bars to spawn
	-- args.sourceGUID, args.sourceName, args.sourceFlags, args.sourceRaidFlags = sourceGUID, sourceName, sourceFlags, sourceRaidFlags
	-- args.destGUID, args.destName, args.destFlags, args.destRaidFlags = destGUID, destName, destFlags, destRaidFlags
	-- args.spellId, args.spellName, args.extraSpellId, args.extraSpellName, args.amount = spellId, spellName, extraSpellId, amount, amount

	function mod:Log(event, func, ...)
		args.spellId = ...
		args.spellName = string.gsub(func, "(%l)(%u)", "%1 %2")
		args.sourceName = pName
		args.destName = pName
		args.sourceGUID = pGUID
		args.destGUID = pGUID
		args.amount = 0

		if self[func] then
			local bool, msg = pcall(self[func], self, args)

			if not bool then
				print("Failed:", "|cff00ccff" .. args.spellName .. "|r", msg)
			end
		end
	end

	C_Timer.After(0.1, function()
		if mod.OnEngage then mod:OnEngage() end
		mod:OnBossEnable()
	end)
end

local function formatTimer(timer)
  if timer then
    local mins = floor(timer / 60)
    local secs = timer - (mins * 60)
    timer = format("%d:%02d", mins, secs)
    return timer
  end
end

local infinity = math.huge
local function round(num, decimals)
  if (num == infinity) or (num == -infinity) then num = 0 end

  if (decimals or 0) == 0 then -- Decimals wasn't set, use 0
    return ("%.0f"):format(num) + 0
  elseif decimals == 1 then
    return ("%.1f"):format(num) + 0
  elseif decimals == 2 then
    return ("%.2f"):format(num) + 0
  elseif decimals == 3 then
    return ("%.3f"):format(num) + 0
  elseif decimals == 4 then
    return ("%.4f"):format(num) + 0
  elseif decimals == 5 then
    return ("%.5f"):format(num) + 0
  elseif decimals == 6 then
    return ("%.6f"):format(num) + 0
  elseif decimals == 7 then
    return ("%.7f"):format(num) + 0
  elseif decimals == 8 then
    return ("%.8f"):format(num) + 0
  elseif decimals == 9 then
    return ("%.9f"):format(num) + 0
  elseif decimals == 10 then
    return ("%.10f"):format(num) + 0
  else
		print("No match for " .. decimals .. " in round function. Returning 0 decimals.")
    return ("%.0f"):format(num) + 0
  end
end

local count = 0
local function BigWigs_BarCreated(message, plugin, bar, module, key, text, time, icon, isApprox)
	local bossName = VA.bossName or VA.trashName

	local barDB, string = addBarSVar(bossName, key, text, time, icon, isApprox)
	if not barDB then return end

	local group
	local name = GetSpellInfo(key)
	group = name

	if not group then
		group = text:gsub("on YOU!", "")
	end

	if testName then
		count = count + 1

		local str
		if isApprox then
			str = format("%s: |c%s%s|r (|c%s%s|r) -- |c%s%s|r", count, "ff00C78C", text, "FFFFFF00", formatTimer(time), "ffFF4500", "true")
		else
			str = format("%s: |c%s%s|r (|c%s%s|r)", count, "ff00C78C", text, "FFFFFF00", formatTimer(time))
		end

		-- print(str)
	end

	if diagnostics then print("Starting ticker for", string) end
	local index, callbackTime
	C_Timer.NewTicker(0.1, function(ticker)
		local remaining = barDB.remaining

		if remaining then
			if not callbackTime then -- Advances to the next callback time in barDB.remaining
				index = (index or 0) + 1
				callbackTime = remaining[index] or ticker:Cancel() bar.ticker = nil return -- Cancels and returns if it can't find one
			end

			if callbackTime then
				if (callbackTime + 0.15) >= (bar.remaining - 0.5) and callbackTime < (bar.remaining - 0.5) then -- Subtracting 0.5 makes it happen 0.5 seconds sooner
					chatMessage(group, 20, "Play", barDB.text, text, VA.contentFrame.frames["Bars"][string], nil, floor(bar.remaining))
					callbackTime = nil
				elseif callbackTime > (bar.remaining - 0.5) then
					callbackTime = nil
				end
			end
		end
	end)
end

local count = 0
local function BigWigs_Message(event, mod, key, text, alert, icon, isOnMe)
	if disableMessages then return end

	if text:match("|cff.+(%u%a+)|r") then -- Text has a color string, remove it
		if text:match(pName) then
			text = string.gsub(text, "|cff.+(%u%a+)|r", "on YOU!")
		else
			text = string.gsub(text, "|cff.+(%u%a+)|r", "on %1")
		end
	elseif text:match("Damage under YOU!") then
		return
	elseif text:match("engaged %p Berserk in %d min") then
		return
	elseif text:match("goes Berserk!") then
		return
	end

	if (VA.lastMessage or GetTime()) == GetTime() then
		count = count + 1

		C_Timer.After(count / 20, function()
			chatMessage("Quest", defaultVolume, "Play", text, nil)
		end)

		if stopMessagesAfter then
			C_Timer.After(stopMessagesAfter, function()
				stopMessages()
			end)
		end
	else
		chatMessage("Quest", defaultVolume, "Play", text, nil)
	end

	VA.lastMessage = GetTime()

	-- print(text)

	-- local name = GetSpellInfo(key)
	--
	-- if name and (alert == "Personal") or (alert == "Urgent") then -- (alert == "Personal") or (alert == "Urgent
	-- 	local b = timerBars[text]
	-- 	if not b then
	-- 		timerBars[text] = {}
	-- 		b = timerBars[text]
	-- 		b.text = {}
	-- 	else
	-- 		wipe(b.text)
	-- 	end
	--
	-- 	b.count = countText or 0
	-- 	b.time = time
	-- 	b.expireTime = 0
	--
	-- 	local _, _, count = strfind(text, "%((.-)%)")
	-- 	local count = count or 0
	-- 	local time = 0
	-- 	gsub(key, "(%a+)", function(word)
	-- 		b.text[#b.text + 1] = word
	-- 	end)
	--
	-- 	trySound(b.text, b.expireTime, b.count)
	-- end
end

local function BigWigs_StopBar(event, module, bestTime) -- Triggers when fight ends and bars are cancelled, also returned Best Time
	-- local time = GetTime()
	-- print("Stop bar")
	--
	-- for k, v in pairs(timerBars) do
	-- 	if time >= v.expireTime then
	-- 		print("Passed", time - v.expireTime)
	-- 	end
	-- end
end

local function BigWigs_PluginRegistered(message, name, mod) -- Need to enable plugins for them to work, only necessary for testing
	VA.plugins[name] = mod

	if testName then
		if name == "Bars"
		-- or name == "Messages"
		-- or name == "Sounds"
		or name == "Proximity" then
			-- mod:Enable()
		end
	end
end

local modList
function VA.createBarSVars()
	local function startBar(message, mod, key, text, time, icon, isApprox)
		addBarSVar(mod.moduleName, key, text, time, icon, isApprox)
	end

	BigWigsLoader:RegisterMessage("BigWigs_StartBar", startBar)

	-- wipe(barDB)

	for bossName, func in pairs(VA.registerBoss) do
		func()

		if not barDB[bossName] then barDB[bossName] = {} end

		local boss = VA.boss.data[bossName]
		local mod = modList[bossName]

		if boss and mod then
			function mod:Say(key, msg, directPrint)

			end

			mod:Enable()
			testBars(mod)
		end
	end
end

local function BigWigs_BossModuleRegistered(message, bossName, mod) -- When a boss mod is registered
	if not modList then modList = {} end

	modList[bossName] = mod

	if testName and bossName == testName then
		C_Timer.After(0.1, function()
			-- mod:Enable()
			-- testBars(mod)
		end)
	end
end

if testName then -- Loading everything on login to spawn bars
	C_Timer.After(1, function()
		LoadAddOn("BigWigs_Core")
		LoadAddOn("BigWigs_Highmaul")
		LoadAddOn("BigWigs_BlackrockFoundry")
		LoadAddOn("BigWigs_HellfireCitadel")

		VA.createBarSVars()
	end)
end
--------------------------------------------------------------------------------
-- Registered Messages
--------------------------------------------------------------------------------
BigWigsLoader:RegisterMessage("BigWigs_BarCreated", BigWigs_BarCreated)
BigWigsLoader:RegisterMessage("BigWigs_StopBar", BigWigs_StopBar)
BigWigsLoader:RegisterMessage("BigWigs_Message", BigWigs_Message)

BigWigsLoader:RegisterMessage("BigWigs_PluginRegistered", BigWigs_PluginRegistered)
BigWigsLoader:RegisterMessage("BigWigs_BossModuleRegistered", BigWigs_BossModuleRegistered)
BigWigsLoader:RegisterMessage("BigWigs_OnBossDisable", BigWigs_OnBossDisable)
--------------------------------------------------------------------------------
-- Create Input Frame
--------------------------------------------------------------------------------
local function createTitleLine(event)
	if not VA.contentFrame.title then VA.contentFrame.title = {} end

	local f = VA.contentFrame.title[event]

	if not f then
		VA.contentFrame.title[event] = CreateFrame("Frame", "ContentFrameTitle_" .. event, VA.contentFrame)
		f = VA.contentFrame.title[event]
		f:SetSize(VA.contentFrame:GetWidth() - 5, 19)
		f.texture = f:CreateTexture(nil, "BACKGROUND")
		f.texture:SetTexture(0.05, 0.05, 0.05, 1)
		f.texture:SetAllPoints()

		f.text = f:CreateFontString(nil, "ARTWORK")
		f.text:SetPoint("CENTER", f, 0, 0)
		f.text:SetFont("Fonts\\FRIZQT__.TTF", 20)
		f.text:SetTextColor(0.8, 0.8, 0, 1)
	end

	f.text:SetText(event)

	return f
end

local function createSmallButton(b, indexed, checked)
  b:SetSize(180, 20)
  b:SetPoint("LEFT", 0, 0)

  b.normal = b:CreateTexture(nil, "BACKGROUND")
  b.normal:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
  b.normal:SetTexCoord(0.00195313, 0.58789063, 0.87304688, 0.92773438)
  b.normal:SetAllPoints(b)
  b:SetNormalTexture(b.normal)

  b.highlight = b:CreateTexture(nil, "BACKGROUND")
  b.highlight:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
  b.highlight:SetTexCoord(0.00195313, 0.58789063, 0.87304688, 0.92773438)
  b.highlight:SetVertexColor(0.7, 0.7, 0.7, 1.0)
  b.highlight:SetAllPoints(b)
  b:SetHighlightTexture(b.highlight)

  b.disabled = b:CreateTexture(nil, "BACKGROUND")
  b.disabled:SetTexture("Interface\\PetBattles\\PetJournal")
  b.disabled:SetTexCoord(0.49804688, 0.90625000, 0.12792969, 0.17285156)
  b.disabled:SetAllPoints(b)
  b:SetDisabledTexture(b.disabled)

  b.pushed = b:CreateTexture(nil, "BACKGROUND")
  b.pushed:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
  b.pushed:SetTexCoord(0.00195313, 0.58789063, 0.92968750, 0.98437500)
  b.pushed:SetAllPoints(b)
  b:SetPushedTexture(b.pushed)

  if b:GetObjectType() == "CheckButton" then
    b.checked = b:CreateTexture(nil, "BACKGROUND")
    b.checked:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
    b.checked:SetTexCoord(0.00195313, 0.58789063, 0.92968750, 0.98437500)
    b.checked:SetAllPoints(b)
    b:SetCheckedTexture(b.checked)
  end

  if indexed then
    b.index = b:CreateFontString(nil, "ARTWORK")
    b.index:SetPoint("LEFT", 5, 0)
    b.index:SetFont("Fonts\\FRIZQT__.TTF", 12)
    b.index:SetTextColor(1, 1, 1, 1)
    b.index:SetJustifyH("LEFT")
  end

  b.title = b:CreateFontString(nil, "ARTWORK")
  b.title:SetPoint("CENTER", 0, 0)
  b.title:SetFont("Fonts\\FRIZQT__.TTF", 12)
  b.title:SetTextColor(0.93, 0.86, 0.01, 1.0)

  return b
end

local function getTooltipInfo(spellName)
	if not spellName then return end
	-- VA.instanceID
	-- VA.bossID
	local name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfo(VA.bossID)

	if rootSectionID then
		local ID = rootSectionID
		local next1
		local next2

		while ID do
			local title, desc, depth, icon, model, siblingID, nextID, filteredByDifficulty, link, startsOpen, f1, f2, f3, f4 = EJ_GetSectionInfo(ID)
			ID = siblingID
			next1 = nextID

			if title:find(spellName) then
				return title, desc, icon, f1, f2, f3, f4
			end

			while next1 do
				title, desc, depth, icon, model, siblingID, nextID, filteredByDifficulty, link, startsOpen, f1, f2, f3, f4 = EJ_GetSectionInfo(next1)
				next1 = siblingID
				next2 = nextID

				if title:find(spellName) then
					return title, desc, icon, f1, f2, f3, f4
				end

				while next2 do
					title, desc, depth, icon, model, siblingID, nextID, filteredByDifficulty, link, startsOpen, f1, f2, f3, f4 = EJ_GetSectionInfo(next2)
					next2 = siblingID

					if title:find(spellName) then
						return title, desc, icon, f1, f2, f3, f4
					end
				end
			end
		end
	end
end

local function createContentLine(parent, spellID, text, bossName, event)
	parent[spellID] = CreateFrame("Frame", "ContentFrame" .. spellID, VA.contentFrame)
	local f = parent[spellID]
	f.texture = f:CreateTexture(nil, "BACKGROUND")
	f.texture:SetTexture(0.05, 0.05, 0.05, 1)
	f.texture:SetAllPoints()
	f.baseText = text

	do -- Create the check button
		f.button = CreateFrame("CheckButton", "VA_CheckButton", f)
		local b = createSmallButton(f.button, true)

		if not buttonDB[event] then buttonDB[event] = {} end
		if buttonDB[event][spellID] then b:SetChecked(true) end

		b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		b:SetScript("OnClick", function(self, click)
			if click == "LeftButton" then
				if self:GetChecked() then
					buttonDB[event][spellID] = true
				else
					buttonDB[event][spellID] = nil
				end
			elseif click == "RightButton" then
				-- VA.populateContent(table) -- Refresh list
			end
		end)

		b:SetScript("OnEnter", function()
			local name, rank, icon, castTime, minRange, maxRange, ID = GetSpellInfo(spellID)

			local title, desc, icon, f1, f2, f3, f4 = getTooltipInfo(name or spellID)

			if title then
				b.info = ""

				for sentence in desc:gmatch("%u.-%.") do
					b.info = b.info .. sentence .. "\n"
				end

				b.info = b.info:trim()

				VA.createInfoTooltip(b, title, icon, nil, nil)
			end
		end)

		b:SetScript("OnLeave", function()
			VA.createInfoTooltip()
		end)
	end

	do -- Create the sound test button
		f.testSound = CreateFrame("Button", "VA_TestButton", f)
		local b = f.testSound

		b:SetSize(20, 20)
		b:SetPoint("RIGHT", -5, 0)

		b.texture1 = b:CreateTexture(nil, "BACKGROUND")
		b.texture1:SetTexture("Interface\\Common\\VoiceChat-Speaker")
		b.texture1:SetAllPoints()

		b.texture2 = b:CreateTexture(nil, "BACKGROUND")
		b.texture2:SetTexture("Interface\\Common\\VoiceChat-On")
		b.texture2:SetAllPoints()

		b:SetScript("OnClick", function(self, click)
			if click == "LeftButton" then
				chatMessage("test", 30 or volume, "Play", f.editBox:GetText(), text, f)
				f.editBox:ClearFocus()
			end
		end)
	end

	do -- Create edit box
		f.editBox = CreateFrame("EditBox", "VA_EditBox", f)
		local e = f.editBox
		e:SetPoint("RIGHT", f.testSound, "LEFT")
		e:SetPoint("LEFT", f.button, "RIGHT")
		e:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
		e:SetTextColor(0.9, 0.9, 0.9, 1)

		e:SetMultiLine(true)
		e:SetMaxLetters(100)
		e:SetAutoFocus(false)

		do -- Scripts
			e:SetScript("OnEscapePressed", function(self)
			  e:ClearFocus()
			end)

			e:SetScript("OnEnterPressed", function(self)
			  e:ClearFocus()
			end)

			-- e:SetScript("OnEditFocusGained", function(self)
			--   self:HighlightText()
			-- end)

			e:SetScript("OnEditFocusLost", function(self)
				if event == "Bars" then
					local string = f.editBox:GetText()
					local numTable = {}

					do -- Check for <numbers> for bar duration announcements
						if string:find("<.+>") then
							string:gsub("[%p%s](%d+)[%p%s]", function(num)
								numTable[#numTable + 1] = (num + 0)
							end)
						end

						sort(numTable, function(a, b)
							return b < a
						end)
					end

					do -- Check for (numbers) for stack ammounts
						-- local numTable = {}
						-- if string:match("<.+>") then
						-- 	string:gsub("[%p%s](%d+)[%p%s]", function(num)
						-- 		numTable[#numTable + 1] = (num + 0)
						-- 	end)
						-- end
						--
						-- sort(numTable, function(a, b)
						-- 	return b < a
						-- end)
					end

					barDB[bossName][text].text = string:trim()
					barDB[bossName][text].remaining = numTable
				else
					if not spellDB[event] then spellDB[event] = {} end
					spellDB[event][spellID] = f.editBox:GetText()
				end
			end)
		end
	end

	return f
end

VA.indexedFrames = {}
function VA.populateContent(bossData, bossName)
	wipe(VA.indexedFrames)
	VA.base.title:SetText(bossName)
	local content = VA.contentFrame
	if not content.frames then content.frames = {} end
	local height = 0
	local width = content:GetWidth()
	local y = 0
	local num = 0

	do -- Hide all previously visible frames
		for event, table in pairs(content.frames) do

			if content.title[event] then
				content.title[event]:Hide()
			end

			if content.frames[event] then
				for k, v in pairs(content.frames[event]) do
					if type(v) == "table" and v.button then
						v:Hide()
					end
				end
			end

		end
	end

	if barDB[bossName] then
		local event = "Bars"
		if not content.frames[event] then content.frames[event] = {} end

		if event ~= content.frames.currentEvent then
			local title = createTitleLine(event)
			title:SetPoint("TOPLEFT", content, 0, y)
			title:SetPoint("TOPRIGHT", content, 0, y)
			title:Show()
			y = y - 20
			VA.indexedFrames[#VA.indexedFrames + 1] = title
			height = height + 20
		end

		for text, t in pairs(barDB[bossName]) do
			local timer = t.stringNL .. " " .. table.concat(t.timer, ", ")
			-- local timer = table.concat(t.timer, ", ")
			local f = content.frames[event][spellID]

			if not f then
				f = createContentLine(content.frames[event], text, text, bossName, event)
			end

			f.button.title:SetText(timer)
			f.editBox:SetText(t.text or text)

			f:Show()
			f:SetSize(width - 5, 19)
			f:SetPoint("TOPLEFT", content, 0, y)
			f:SetPoint("TOPRIGHT", content, 0, y)

			y = y - 20
			num = num + 1
			height = height + 20
			VA.indexedFrames[#VA.indexedFrames + 1] = f
		end
	end

	for event, spells in pairs(bossData) do
		if not content.frames[event] then content.frames[event] = {} end

		if event ~= content.frames.currentEvent then
			local title = createTitleLine(event)
			title:SetPoint("TOPLEFT", content, 0, y)
			title:SetPoint("TOPRIGHT", content, 0, y)
			title:Show()
			y = y - 20
			VA.indexedFrames[#VA.indexedFrames + 1] = title
			height = height + 20
		end

		for spellID, text in pairs(spells) do
			local f = content.frames[event][spellID]

			if not f then
				f = createContentLine(content.frames[event], spellID, text, bossName, event)
			end

			local name = GetSpellInfo(spellID) or "No name"
			f.button.title:SetText(name .. " (" .. spellID .. ")")
			f.editBox:SetText((spellDB[event] and spellDB[event][spellID]) or text)

			f:Show()
			f:SetSize(width - 5, 19)
			f:SetPoint("TOPLEFT", content, 0, y)
			f:SetPoint("TOPRIGHT", content, 0, y)

			y = y - 20
			num = num + 1
			height = height + 20
			VA.indexedFrames[#VA.indexedFrames + 1] = f
		end

		content.frames.currentEvent = event
	end

	content.frames.currentEvent = nil
	DB.lastBoss = bossName -- The last active boss in SVars
	VA.base.bossLoaded = bossName
	VA.scrollBar:SetMinMaxValues(0, max(height - VA.scrollBar:GetHeight(), 0))
end

local function adjustTooltipSize()
  local f = VA.infoTooltip
  local parent = f.parent
  local text = f.info:GetText()
  if not text then return end

  f:SetSize(200, 200)

  local height = f.info:GetStringHeight() + 34
  local width = f.info:GetStringWidth()
  if width > 400 then width = 400 end
  if width < 150 then width = 150 end

  f:SetSize(f.info:GetWrappedWidth() + 50, height)
end

function VA.createInfoTooltip(parent, title, icon, func, textTable)
  local f = VA.infoTooltip
  local created

  if not f then
    VA.infoTooltip = CreateFrame("Frame", "VA_InfoTooltip", UIParent)
    f = VA.infoTooltip
    created = true

    f.resize = adjustTooltipSize
    f.text = textTable or {}

    do -- Create Tooltip Borders
      f.border = {}

      for i = 1, 4 do
        local border = f:CreateTexture(nil, "BORDER")
        f.border[i] = border
        border:SetTexture(0.2, 0.2, 0.2, 1.0)
        border:SetSize(2, 2)

        if i == 1 then
          border:SetPoint("TOPRIGHT", f, 0, 0)
          border:SetPoint("TOPLEFT", f, 0, 0)
        elseif i == 2 then
          border:SetPoint("BOTTOMRIGHT", f, 0, 0)
          border:SetPoint("BOTTOMLEFT", f, 0, 0)
        elseif i == 3 then
          border:SetPoint("TOPLEFT", f, 0, 0)
          border:SetPoint("BOTTOMLEFT", f, 0, 0)
        else
          border:SetPoint("TOPRIGHT", f, 0, 0)
          border:SetPoint("BOTTOMRIGHT", f, 0, 0)
        end
      end
    end

    do -- Background and Icon
      f.background = f:CreateTexture(nil, "BACKGROUND")
      f.background:SetTexture(0.075, 0.075, 0.075, 1.00)
      f.background:SetAllPoints()

      f.icon = f:CreateTexture(nil, "ARTWORK")
      f.icon:SetAlpha(0.9)
      f.icon:SetSize(40, 40)
      f.icon:SetPoint("TOPRIGHT", f, -5, -5)
    end

    do -- Text
      f.title = f:CreateFontString(nil, "ARTWORK")
      f.title:SetHeight(20)
      f.title:SetPoint("TOPLEFT", f, 5, -2)
      f.title:SetPoint("TOPRIGHT", f, -2, -2)
      f.title:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
      f.title:SetTextColor(1, 1, 0, 1)
      f.title:SetJustifyH("LEFT")
      f.title:SetText("Title")

      f.infoFrame = CreateFrame("Frame", nil, f)
      f.infoFrame:SetSize(100, 10)
      f.infoFrame:SetPoint("BOTTOM", f.title, "TOP")
      f.infoFrame:SetPoint("BOTTOM", f)
      f.infoFrame:SetPoint("LEFT", f)
      f.infoFrame:SetPoint("RIGHT", f)
      f.info = f.infoFrame:CreateFontString(nil, "ARTWORK")
      f.info:SetPoint("BOTTOMLEFT", f.infoFrame, 5, 10)

      f.info:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
      f.info:SetTextColor(1, 1, 1, 1)
      f.info:SetJustifyH("LEFT")
      -- f.info:SetJustifyV("TOP")
      f.info:SetText("Info text.")

      C_Timer.After(0.01, function()
        f.resize()
      end)
    end

    do -- Fade in/out animation
      f.fadeIn = f:CreateAnimationGroup()
      f.fadeIn.fade = f.fadeIn:CreateAnimation("Alpha")
      f.fadeIn.fade:SetToAlpha(1)
      f.fadeIn.fade:SetDuration(0.2)
      f.fadeIn.fade:SetSmoothing("IN")

      f.fadeOut = f:CreateAnimationGroup()
      f.fadeOut.fade = f.fadeOut:CreateAnimation("Alpha")
      f.fadeOut.fade:SetFromAlpha(1)
      f.fadeOut.fade:SetDuration(0.2)
      f.fadeOut.fade:SetSmoothing("OUT")

      f.fadeOut:SetScript("OnFinished", function(self, requested)
        f:Hide()
      end)
    end

    C_Timer.After(0.1, f.resize) -- Without this, it gets screwed up the first time it shows

    local oldNumLines
    local timer = 0
    local delay = 0.05
    f:SetScript("OnUpdate", function(self, elapsed)
      timer = timer + elapsed

      if timer >= delay then
        if f.func then
          f.func(f.info, f.text)
        elseif f.parent and f.parent.info then
          f.info:SetText(f.parent.info)
        end

        local numLines = f.info:GetNumLines()

        if oldNumLines and oldNumLines ~= numLines then
          f.resize()
        end

        oldNumLines = numLines
        timer = 0
      end
    end)
  end

  if not parent then
    f.fadeIn:Stop()
    f.fadeOut:Play()
    return
  else
    f:Show()
    f.fadeOut:Stop()
    f.fadeIn:Play()
  end

  -- f:SetParent(parent)
  f.parent = parent
  f:SetPoint("BOTTOMLEFT", parent, "TOPRIGHT", -25, 5)

  if title then
    f.title:SetText(title)

    if func then
      func(f.info, f.text)
    elseif parent.info then
      f.info:SetText(parent.info)
    end
  end

  f.func = func
  f.icon:SetTexture(icon)

  if icon then
    SetPortraitToTexture(f.icon, f.icon:GetTexture())
    f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
  else
    f.title:ClearAllPoints()
    f.title:SetPoint("TOPLEFT", f, 5, -2)
    f.title:SetPoint("TOPRIGHT", f, -2, -2)
  end

  f:resize()
	f:SetFrameStrata("HIGH")
end

local function createDropDownButtons(menu, table, registeredBosses)
  if not menu then return end

  local height = 0
  local width = menu:GetWidth()
  local y = 0

  for i = 1, max(#menu, #table) do
    local b = menu[i]

    if table[i] then
			local t = table[i]

      if not b then
        menu[i] = CreateFrame("CheckButton", nil, menu)
        b = createSmallButton(menu[i], true, true)
				-- b:SetWidth(200)
        b:RegisterForClicks("LeftButtonUp", "RightButtonUp")

        b:SetScript("OnClick", function(self, click)
          if click == "LeftButton" then
            if self:GetChecked() then
              for i = 1, #menu do
                if menu[i] ~= self and menu[i]:GetChecked() then
                  menu[i]:SetChecked(false)
                end
              end

							registerBoss(t, GetInstanceInfo())
            else

            end
          elseif click == "RightButton" then
            createDropDownButtons(menu, table, registeredBosses) -- Refresh list
          end
        end)
      end

      b:Show()
      b.index:SetFormattedText("%s.", i)
      b.title:SetText(t)

      b:SetSize(width - 5, 20)
      b:SetPoint("TOP", menu, 0, y)
      y = y - 20

      height = height + 20
    elseif b then
      b:Hide()
    end
  end

  menu:SetHeight(height)
end

do -- Create Base Frame
	local f

	do
	  VA.base = CreateFrame("Frame", "VA_Base", UIParent)
	  f = VA.base
	  f:SetPoint("CENTER")
	  f:SetSize(750, 556)
		f:SetFrameStrata("HIGH")

	  local backdrop = {
	  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	  tileSize = 32,
	  edgeSize = 16,}

	  f:SetBackdrop(backdrop)
	  f:SetBackdropColor(0.15, 0.15, 0.15, 1)
	  f:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.7)

	  f:SetMovable(true)
	  f:EnableMouse(true)
	  f:EnableKeyboard(true)
	  f:SetResizable(true)

	  f:SetScript("OnMouseDown", function(self, button)
	    if button == "LeftButton" and not self.isMoving then
	      self:StartMoving()
	      self.isMoving = true
	    end
	  end)
	  f:SetScript("OnMouseUp", function(self, button)
	    if button == "LeftButton" and self.isMoving then
	      self:StopMovingOrSizing()
	      self.isMoving = false
	    end
	  end)
	  f:SetScript("OnShow", function(self) -- Load in the previously shown boss by default if possible
			if DB.lastBoss and not VA.base.bossLoaded then
				if VA.registerBoss[DB.lastBoss] then
					VA.registerBoss[DB.lastBoss]()
					VA.populateContent(VA.boss.data[DB.lastBoss], DB.lastBoss)
					VA.base.bossLoaded = DB.lastBoss
				end
			end
	  end)
	end

  do -- Close button
    f.closeButton = CreateFrame("Button", nil, f)
    f.closeButton:SetSize(40, 40)
    f.closeButton:SetPoint("TOPRIGHT", -10, -10)
    f.closeButton:SetNormalTexture("Interface\\RaidFrame\\ReadyCheck-NotReady.png")
    f.closeButton:SetHighlightTexture("Interface\\RaidFrame\\ReadyCheck-NotReady.png")

    f.closeButton.BG = f.closeButton:CreateTexture(nil, "BORDER")
    f.closeButton.BG:SetAllPoints()
    f.closeButton.BG:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMaskSmall.png")
    f.closeButton.BG:SetVertexColor(0, 0, 0, 0.3)

    f.closeButton:SetScript("OnClick", function()
      VA.base:Hide()
    end)
  end

  do -- Main size dragger
    f:SetMaxResize(800, 700)
    f:SetMinResize(350, 556)

    f.dragger = CreateFrame("Button", nil, f)
    f.dragger:SetSize(20, 20)
    f.dragger:SetPoint("BOTTOMRIGHT", -1, 2)
    f.dragger:SetNormalTexture("Interface/CHATFRAME/UI-ChatIM-SizeGrabber-Up.png")
    f.dragger:SetPushedTexture("Interface/CHATFRAME/UI-ChatIM-SizeGrabber-Down.png")
    f.dragger:SetHighlightTexture("Interface/CHATFRAME/UI-ChatIM-SizeGrabber-Highlight.png")

    -- NOTE: Need to get resolution properly
    f.dragger:SetScript("OnMouseDown", function(self)
      VA.base:StartSizing()
    end)

    f.dragger:SetScript("OnMouseUp", function(self)
      VA.base:StopMovingOrSizing()
			VA.contentFrame:SetSize(VA.scrollFrame:GetWidth(), VA.scrollFrame:GetHeight())
    end)
  end

  do -- Scroll Frame, Main Content Frame, and Scroll Bar
	  VA.scrollFrame = CreateFrame("ScrollFrame", "VA_ScrollFrame", VA.base)
	  VA.scrollFrame:SetPoint("TOPLEFT", VA.base, 10, -50)
	  VA.scrollFrame:SetPoint("BOTTOMRIGHT", VA.base, -10, 65)

    VA.scrollBar = CreateFrame("Slider", "VA_ScrollBar", VA.scrollFrame, "UIPanelScrollBarTemplate")
    VA.scrollBar:SetPoint("TOPRIGHT", VA.scrollFrame, 20, 0)
    VA.scrollBar:SetPoint("BOTTOMRIGHT", VA.scrollFrame, 20, 0)
    local c1, c2 = VA.scrollBar:GetChildren()
      c1:Hide()
      c2:Hide()
    VA.scrollBar:SetAlpha(0)
    VA.scrollBar:SetMinMaxValues(0, 200)
    VA.scrollBar:SetValueStep(46)
    VA.scrollBar.scrollStep = 1
    VA.scrollBar:SetWidth(16)
    VA.scrollBar:SetScript("OnValueChanged", function(self, value)
      VA.scrollFrame:SetVerticalScroll(value)
    end)

    VA.contentFrame = CreateFrame("Frame", "VA_MainContent", VA.base)
    VA.scrollFrame:SetScrollChild(VA.contentFrame)
    VA.contentFrame:SetSize(VA.scrollFrame:GetWidth(), VA.scrollFrame:GetHeight())
    -- VA.contentFrame:SetAllPoints(VA.base)
    VA.contentFrame:SetAllPoints(VA.scrollFrame)
    -- VA.contentFrame:SetPoint("RIGHT", VA.scrollFrame)
    -- VA.contentFrame:SetPoint("LEFT", VA.scrollFrame)

    VA.scrollFrame:SetScript("OnMouseWheel", function(self, value)
			VA.contentFrame:SetSize(VA.scrollFrame:GetWidth(), VA.scrollFrame:GetHeight())
      local cur = VA.scrollBar:GetValue()
      local minVal, maxVal = VA.scrollBar:GetMinMaxValues()

      if value < 0 and cur < maxVal then
        cur = min(maxVal, cur + 40)
        VA.scrollBar:SetValue(cur)
      elseif value > 0 and cur > minVal then
        cur = max(minVal, cur - 40)
        VA.scrollBar:SetValue(cur)
      end
    end)
  end

  do -- Button Container Frame and Button 1 and 2
    local width = f:GetWidth()
    f.buttonFrame = CreateFrame("Frame", nil, f)
    f.buttonFrame:SetPoint("BOTTOMLEFT", 0, 5)
    f.buttonFrame:SetPoint("BOTTOMRIGHT", 0, 5)
    f.buttonFrame:SetHeight(60)
    f.buttonFrame.texture = f.buttonFrame:CreateTexture(nil, "ARTWORK")
    f.buttonFrame.texture:SetAllPoints()
    f.buttonFrame.texture:SetTexture(0.05, 0.05, 0.05, 0)

    do -- Button 1
      f.buttonFrame.button1 = CreateFrame("Button", nil, f.buttonFrame)
      local b1 = f.buttonFrame.button1
      b1:SetSize(174, f.buttonFrame:GetHeight() - 10)
      b1:SetPoint("RIGHT", -(f.buttonFrame:GetWidth() / 2 + 5), 0)
      b1:SetPoint("LEFT", 10, 0)
      b1.normal = b1:CreateTexture(nil, "BACKGROUND")
      b1.normal:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
      b1.normal:SetTexCoord(0.00195313, 0.34179688, 0.42871094, 0.52246094)
      b1.normal:SetAllPoints()
      b1:SetNormalTexture(b1.normal)

      b1.highlight = b1:CreateTexture(nil, "BACKGROUND")
      b1.highlight:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
      b1.highlight:SetTexCoord(0.00195313, 0.34179688, 0.42871094, 0.52246094)
      b1.highlight:SetVertexColor(0.5, 0.5, 0.5, 1)
      b1.highlight:SetAllPoints()
      b1:SetHighlightTexture(b1.highlight)

      b1.pushed = b1:CreateTexture(nil, "BACKGROUND")
      b1.pushed:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
      b1.pushed:SetTexCoord(0.00195313, 0.34179688, 0.33300781, 0.42675781)
      b1.pushed:SetAllPoints()
      b1:SetPushedTexture(b1.pushed)

      b1.title = b1:CreateFontString(nil, "ARTWORK")
      b1.title:SetPoint("CENTER", 0, 0)
      b1.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
      b1.title:SetTextColor(0.8, 0.8, 0, 1)
      b1.title:SetShadowOffset(3, -3)
      b1.title:SetText("Load Boss")

      b1:SetScript("OnClick", function(self, button)
				local b = self

				if not b.popup then
					b.popup = CreateFrame("Frame", nil, b)
					b.popup:SetFrameStrata("HIGH")
					b.popup:SetSize(230, 20)
					b.popup:SetPoint("TOPLEFT", b, "TOPRIGHT", 0, 0)
					b.popup.bg = b.popup:CreateTexture(nil, "ARTWORK")
					b.popup.bg:SetAllPoints()
					b.popup.bg:SetTexture(0.05, 0.05, 0.05, 1.0)
					b.popup:Hide()

					b.popup:SetScript("OnShow", function()
						b.popup.exitTime = GetTime() + 1

						if not b.popup.ticker then
							b.popup.ticker = C_Timer.NewTicker(0.1, function(ticker)
								if not MouseIsOver(b.popup) and not MouseIsOver(b) then
									if GetTime() > b.popup.exitTime then
										b.popup:Hide()
										b.popup.ticker:Cancel()
										b.popup.ticker = nil
									end
								else
									b.popup.exitTime = GetTime() + 1
								end
							end)
						end
					end)
				end

				if b.popup:IsShown() then
					b.popup:Hide()
				else
					createDropDownButtons(b.popup, VA.bossIndex, VA.registerBoss)
					b.popup:Show()

					b.popup:SetPoint("TOPLEFT", b, "TOPRIGHT", 0, 0)

					local bottom = b.popup:GetBottom()

					if 0 > bottom then
						b.popup:SetPoint("TOPLEFT", b, "TOPRIGHT", 0, abs(bottom))
					end
				end
      end)
    end

    do -- Button 2
      f.buttonFrame.button2 = CreateFrame("Button", nil, f.buttonFrame)
      local b2 = f.buttonFrame.button2
      b2:SetSize(174, f.buttonFrame:GetHeight() - 10)
      b2:SetPoint("LEFT", (f.buttonFrame:GetWidth() / 2 + 5), 0)
      b2:SetPoint("RIGHT", -10, 0)
      b2.normal = b2:CreateTexture(nil, "BACKGROUND")
      b2.normal:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
      b2.normal:SetTexCoord(0.00195313, 0.34179688, 0.42871094, 0.52246094)
      b2.normal:SetAllPoints()
      b2:SetNormalTexture(b2.normal)

      b2.highlight = b2:CreateTexture(nil, "BACKGROUND")
      b2.highlight:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
      b2.highlight:SetTexCoord(0.00195313, 0.34179688, 0.42871094, 0.52246094)
      b2.highlight:SetVertexColor(0.5, 0.5, 0.5, 1)
      b2.highlight:SetAllPoints()
      b2:SetHighlightTexture(b2.highlight)

      b2.pushed = b2:CreateTexture(nil, "BACKGROUND")
      b2.pushed:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
      b2.pushed:SetTexCoord(0.00195313, 0.34179688, 0.33300781, 0.42675781)
      b2.pushed:SetAllPoints()
      b2:SetPushedTexture(b2.pushed)

      b2.title = b2:CreateFontString(nil, "ARTWORK")
      b2.title:SetPoint("CENTER", 0, 0)
      b2.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
      b2.title:SetTextColor(0.8, 0.8, 0, 1)
      b2.title:SetShadowOffset(3, -3)
      b2.title:SetText("Button 2")

      b2:SetScript("OnClick", function(self, button)
				print(button)
      end)
    end
  end

  do -- Combat Tracker Title Text
    f.title = f:CreateFontString(nil, "ARTWORK")
    f.title:SetPoint("TOPLEFT", f, 15, -10)
    f.title:SetFont("Fonts\\FRIZQT__.TTF", 30)
    f.title:SetTextColor(0.8, 0.8, 0, 1)
    f.title:SetShadowOffset(3, -3)
    f.title:SetText("Voice \n  Alerts")
  end

	VA.base:Hide()
end

do -- Hides whispers sent from player to themselves
	local names = {}

	function FCFManager_GetNumDedicatedFrames(type, name) -- Hides whisper if player whispers themselves
		local newName

		if name and not names[name] then
			names[name] = true
			newName = true
		end

		if type == "WHISPER" and name:match(pName) then -- Should mean player whispered themselves
			return true and 1
		else -- Otherwise allow it to create a tab for the first time, but not for the rest
			if newName then
				return true and 0
			else
				return true and 1
			end
		end
	end

	do -- Filter whispers sent to player from player
		local function whisperFilter(self, event, msg, author, _, _, dest)
			 -- If it's a message from the addon, filter it out
			if msg:match("<message.+command=%p.+%p") then --  or msg:match("<message command=%p.+%p%s?/>")
				return true
			end
		end

		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", whisperFilter) -- Player sending a whisper
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", whisperFilter) -- Player recieving a whisper
	end
end
--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------
SLASH_VoiceAlert1 = "/va"
function SlashCmdList.VoiceAlert(msg, editbox)
	if VA.base:IsVisible() then
		VA.base:Hide()
	else
		VA.base:Show()
	end
end
--------------------------------------------------------------------------------
-- Extra notes, things to test, etc
--------------------------------------------------------------------------------
-- BigWigsLoader.RegisterMessage(addon, "BigWigs_Voice", handler)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_StartBar", BigWigs_StartBar)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_Flash", BigWigs_Flash)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossReboot", BigWigs_OnBossReboot)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossWipe", BigWigs_OnBossWipe)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossEngage", BigWigs_OnBossEngage)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossWin", BigWigs_OnBossWin)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_PluginRegistered", BigWigs_PluginRegistered)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_ProfileUpdate", BigWigs_ProfileUpdate)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_CoreEnabled", BigWigs_CoreEnabled)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_CoreDisabled", BigWigs_CoreDisabled)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_BossModuleRegistered", BigWigs_BossModuleRegistered)
-- BigWigsLoader.RegisterMessage(plugin, "BigWigs_OnBossDisable", BigWigs_OnBossDisable)

-- BigWigsLoader:RegisterMessage("BigWigs_StartBar", BigWigs_StartBar)
-- BigWigsLoader:RegisterMessage("BigWigs_Sound", BigWigs_Sound)
-- BigWigsLoader:RegisterMessage("BigWigs_ModulePackLoaded", BigWigs_ModulePackLoaded)

-- function boss:BarTimeLeft(text)
-- 	local bars = core:GetPlugin("Bars")
-- 	if bars then
-- 		return bars:GetBarTimeLeft(self, type(text) == "number" and spells[text] or text)
-- 	end
-- 	return 0
-- end

-- print("Extra Print", BigWigs.TimeLeft)
-- NOTE: Self/plugin mean the module. I should be able to do Bars:RegisterMessage(etc), since that's the global name
-- NOTE: Just like how my global name is CustomVoiceWarnings, but the local name is plugin
-- self:RegisterMessage("BigWigs_StartBar")
-- self:RegisterMessage("BigWigs_PauseBar", "PauseBar")
-- self:RegisterMessage("BigWigs_ResumeBar", "ResumeBar")
-- self:RegisterMessage("BigWigs_StopBar", "StopSpecificBar")
-- self:RegisterMessage("BigWigs_StopBars", "StopModuleBars")
-- self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleBars")
-- self:RegisterMessage("BigWigs_OnBossReboot", "StopModuleBars")
-- self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleBars")
-- self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
-- self:RegisterMessage("BigWigs_SetConfigureTarget")
-- self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
-- self:RegisterMessage("BigWigs_ResetPositions", resetAnchors)
-- self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
-- plugin:SendMessage("BigWigs_SilenceOption", k:Get("bigwigs:option"), k.remaining + 0.3)
-- self:SendMessage("BigWigs_BarCreated", self, bar, module, key, text, time, icon, isApprox)
-- plugin:SendMessage("BigWigs_StopBar", plugin, nick..": "..barText)
-- plugin:CancelTimer(timers[id])
-- plugin:SendMessage("BigWigs_StopBar", plugin, L.pull)
-- plugin:SendMessage("BigWigs_StopPull", plugin, seconds, nick, isDBM)
-- plugin:SendMessage("BigWigs_Message", plugin, nil, L.pullIn:format(timeLeft), "Attention")
-- plugin:SendMessage("BigWigs_Sound", plugin, nil, "Long")
-- plugin:SendMessage("BigWigs_StartBar", plugin, nil, L.pull, seconds, "Interface\\Icons\\ability_warrior_charge")
-- plugin:SendMessage("BigWigs_StartPull", plugin, seconds, nick, isDBM)
-- plugin:SendMessage("BigWigs_StopBar", plugin, L.breakBar)
-- plugin:SendMessage("BigWigs_StopBreak", plugin, seconds, nick, isDBM, reboot)
-- plugin:SendMessage("BigWigs_Message", plugin, nil, L.breakMinutes:format(seconds/60), "Attention", "Interface\\Icons\\inv_misc_fork&knife")
-- plugin:SendMessage("BigWigs_Sound", plugin, nil, "Long")
-- plugin:SendMessage("BigWigs_StartBar", plugin, nil, L.breakBar, seconds, "Interface\\Icons\\inv_misc_fork&knife")
-- plugin:SendMessage("BigWigs_StartBreak", plugin, seconds, nick, isDBM, reboot)

--[[
CancelTimer = function
TimeLeft = func
GetName = func
GetBossModule = func
ScheduleTimer = func
db = tbl
ENCOUNTER_START = func
defaultModuleLibraries = tbl
		tbl = empty?
orderedModules = tbl
		1 = BigWigs_Bosses
				GetName = func
		2 = BigWigs_Plugins
		3 = BigWigs_Options
C = tbl
GetPlugin = func
RegisterPlugin = func
Test = func
--]]

-- print(BigWigs.TimeLeft(text))
-- local barsMod = BigWigs.GetName(module)
-- local barsPlugin = BigWigs:GetPlugin(barsMod)
-- print(barsMod)
-- local opts = module:GetOptions()
-- print(barsPlugin)
-- print(BigWigs.TimeLeft(module))
-- print(BigWigs.TimeLeft(text))
-- local time = BigWigs:TimeLeft()
-- GetName = func
-- plugin.defaultDB -- NOTE: Default bar table?
-- plugin.pluginOptions -- Table
-- local function barStopped(event, bar)
-- 	local a = bar:Get("bigwigs:anchor")
-- 	if a and a.bars and a.bars[bar] then
-- 		currentBarStyler.BarStopped(bar)
-- 		a.bars[bar] = nil
-- 		rearrangeBars(a)
-- 	end
-- end
--
-- local function findBar(module, key)
-- 	for k in next, normalAnchor.bars do
-- 		if k:Get("bigwigs:module") == module and k:Get("bigwigs:option") == key then
-- 			return k
-- 		end
-- 	end
-- 	for k in next, emphasizeAnchor.bars do
-- 		if k:Get("bigwigs:module") == module and k:Get("bigwigs:option") == key then
-- 			return k
-- 		end
-- 	end
-- end

-- for word in gmatch(text, "%a+") do print(word) end
-- print("..."..cleanedText.."...")
-- local path = string.match(debugstack(1,1,0), "AddOns\\(.+)LibGraph%-2%.0%.lua")

-- local _, wordCount = gsub(text, "%a+", " ") -- Counts number of words
-- local val1, val2 = string.gsub(startText, "(%w+)", function(w) return string.len(w) end)

-- if string:find("%b[]") then -- String has [brackets]
-- 	for bracket in string:gmatch("(%b[])") do
-- 		if breaker then break end
--
-- 		local role =
-- 		if bracket:find("(P)") and (VA.role or "") == "P" then
--
--
-- 		for r, breaker in bracket:gmatch("(%u%l*)(:?)") do
-- 			roleText = nil
-- 			playerText = nil
--
-- 			local role
-- 			if r == "H" or r == "Heal" or r == "Healer" or r == "Heals" then
-- 				role = "H"
-- 			elseif r == "D" or r == "Damage" or r == "Dps" or r == "Damager" then
-- 				role = "D"
-- 			elseif r == "T" or r == "Tank" then
-- 				role = "T"
-- 			end
--
-- 			if r == "P" or r == "Player" or r == "Play" then
-- 				playerText = bracket:match("%[.+:%s?(.+)%]")
-- 			else
-- 				playerText = nil
-- 			end
--
-- 			if (VA.role or "") == role then
-- 				roleText = bracket:match("%[.+:%s?(.+)%]")
-- 				-- print("Passing role check", roleText)
-- 			else
-- 				roleText = nil
-- 			end
--
-- 			if playerText and roleText then
-- 				string = playerText
-- 				breaker = true
-- 				break
-- 			elseif playerText and not role then
-- 				string = playerText
-- 				breaker = true
-- 				break
-- 			elseif roleText then
-- 				string = roleText
-- 				breaker = true
-- 				break
-- 			end
--
-- 			if breaker ~= "" then breaker = true break end -- Reached the : so stop searching
-- 			-- if playerText and roleText then break end
-- 		end
-- 	end
-- end

-- VA.registerBoss["Hellfire Assault"] = function()
-- 	if not VA.boss.data["Hellfire Assault"] then VA.boss.data["Hellfire Assault"] = {} end
-- 	local boss = VA.boss.data["Hellfire Assault"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[184394] = "Shockwave", -- Shockwave
-- 			[184238] = "Cower",
-- 			[185816] = "Repair",
-- 			[181968] = "KillMeta", -- Metamorphosis
-- 			[180945] = "SiegeNova", -- SiegeNova
-- 			[188101] = "BelchFlame",
-- 			[186883] = "BelchFlame",
-- 			[180184] = "Crush",
-- 			[190748] = "Cannonball",
-- 			[185021] = "AddsIncoming", -- Probably adds
-- 			[183452] = "Interrupt", -- FelfireVolley -- Pretty sure this is the interruptable one
-- 			[180417] = "Interrupt", -- FelfireVolley
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[-184369] = "AxeRunOutP", -- Howling Axe
-- 			[184369] = "Axe", -- Howling Axe
-- 			[184243] = "Slam", -- Slam? TANK ONLY
-- 			[185806] = "Dispel", -- ConductedShockPulse HEALER ONLY
-- 			[186737] = "Bomb" -- Boom
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[184243] = "SlamStack", -- Slam? TANK ONLY
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[-184369] = "AxeSafeP", -- HowlingAxeRemoved
-- 		}
-- 	end
--
-- 	-- if not boss["UNIT_DIED"] then
-- 	-- 	boss["UNIT_DIED"] = {
-- 	-- 		-- "Deaths", 93023, 95653, 93435
-- 	-- 	}
-- 	-- end
-- end
--
-- VA.registerBoss["Iron Reaver"] = function()
-- 	if not VA.boss.data["Iron Reaver"] then VA.boss.data["Iron Reaver"] = {} end
-- 	local boss = VA.boss.data["Iron Reaver"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[185282] = "Barrage", -- Barrage
-- 			[182066] = "Falling", -- FallingSlam
-- 			[179889] = "Blitz", -- Blitz
-- 			[182055] = "Phase2", -- FullCharge
-- 			[181999] = "Bombs", -- Firebomb
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[182066] = "FallingSlamSuccess",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[182020] = "Pounding",
-- 			[-182001] = "OrbP", -- UnstableOrb
-- 			[182001] = "Orb", -- UnstableOrb
-- 			[182074] = "ImmolationDamage",
-- 			[-182280] = "ArtilleryP", -- Artillery if on me
-- 			[182280] = "Artillery", -- Artillery
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[182001] = "UnstableOrb",
-- 			[182074] = "ImmolationDamage",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REFRESH"] then
-- 		boss["SPELL_AURA_REFRESH"] = {
-- 			[182280] = "Artillery",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[182280] = "ArtilleryRemoved",
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Kormrok"] = function()
-- 	if not VA.boss.data["Kormrok"] then VA.boss.data["Kormrok"] = {} end
-- 	local boss = VA.boss.data["Kormrok"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[181305] = "Swat", -- Swat TANK ONLY
-- 			[181292] = "Outpouring", -- FelOutpouring
-- 			[181296] = "Runes", -- ExplosiveRunes
-- 			[181299] = "Hands", -- GraspingHands
-- 			[181293] = "EmpOutpouring", -- Empowered FelOutpouring
-- 			[181297] = "EmpRunes", -- Empowered ExplosiveRunes
-- 			[181300] = "EmpHands", -- Empowered GraspingHands
-- 			[180244] = "Pound", -- Pound
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[181307] = "FoulCrush", -- FoulCrush
-- 			[181306] = "ExplosiveBurst", -- ExplosiveBurst
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[180115] = "ShadowPhase", -- Normal ShadowEnergy
-- 			[180116] = "ExplosivePhase", -- Normal ExplosiveEnergy
-- 			[180117] = "FoulEnergy", -- Normal FoulEnergy
--
-- 			[186879] = "ShadowPhase", -- Enraged ShadowEnergy
-- 			[186880] = "ExplosivePhase", -- Enraged ExplosiveEnergy
-- 			[186881] = "FoulPhase", -- Enraged FoulEnergy
--
-- 			[189197] = "ShadowPhase", -- Normal (LFR) ShadowEnergy
-- 			[189198] = "ExplosivePhase", -- Normal (LFR) ExplosiveEnergy
-- 			[189199] = "FoulPhase", -- Normal (LFR) FoulEnergy
--
-- 			[186882] = "Enrage",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[181306] = "ExplosiveBurstRemoved",
-- 			[180244] = "PoundOver",
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Hellfire High Council"] = function()
-- 	if not VA.boss.data["Hellfire High Council"] then VA.boss.data["Hellfire High Council"] = {} end
-- 	local boss = VA.boss.data["Hellfire High Council"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[184476] = "Reap", -- Reap
-- 			[184657] = "Visage", -- NightmareVisage TANK ONLY
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[184449] = "MarkOfTheNecromancer",
-- 			[184476] = "ReapOver",
-- 			[183885] = "MirrorImages", -- MirrorImages
-- 			[184366] = "Leap", -- DemolishingLeapStart
-- 			[183703] = "Storm", -- FelStorm -- CUSTOM, unsure about
-- 			[183226] = "Blade", -- FelBlade -- CUSTOM, unsure about
-- 			[183210] = "Blade", -- FelBlade -- CUSTOM, unsure about
-- 			[184681] = "Wail", -- Wailing Horror
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[184652] = "ReapDamage",
-- 			[-184360] = "FixateP", -- FelRage on player
-- 			[184360] = "Fixate", -- FelRage
-- 			[184355] = "Bloodboil",
-- 			[184365] = "DemolishingLeapStart",
-- 			[184450] = "MarkOfTheNecromancerApplied", -- Purple MarkOfTheNecromancer
-- 			[185065] = "MarkOfTheNecromancerApplied", -- Green MarkOfTheNecromancer
-- 			[185066] = "DispelRed", -- Red MarkOfTheNecromancer HEALER ONLY
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[184847] = "AcidicWound",
-- 			[184355] = "BloodboilDose",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[184365] = "LeapStop", -- DemolishingLeapStop
-- 			[184360] = "FixateStop", -- FelRageRemoved
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Kilrogg Deadeye"] = function()
-- 	if not VA.boss.data["Kilrogg Deadeye"] then VA.boss.data["Kilrogg Deadeye"] = {} end
-- 	local boss = VA.boss.data["Kilrogg Deadeye"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[182428] = "VisionOfDeath", -- VisionOfDeath
-- 			[180224] = "DeathThroes", -- DeathThroes
-- 			[180199] = "Shred", -- ShreddedArmor, get AM UP TANK ONLY
-- 			[183917] = "RendingHowl", -- RendingHowl
-- 			[180163] = "SavageStrikes",
-- 			[180618] = "FelBlaze",
-- 			[180033] = "CinderBreath",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[180200] = "ShreddedArmor",
-- 			[187089] = "CleansingAura",
-- 			[-188929] = "HeartSeekerP", -- HeartSeeker on player
-- 			[188929] = "HeartSeeker", -- HeartSeeker
-- 			[180313] = "Possessed", -- Demonic Possession
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[180200] = "ShreddedArmor",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[188929] = "KillBlood", -- HeartSeeker
-- 			[-181528] = "DefyingDeathP", -- DefyingDeath
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Gorefiend"] = function()
-- 	if not VA.boss.data["Gorefiend"] then VA.boss.data["Gorefiend"] = {} end
-- 	local boss = VA.boss.data["Gorefiend"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[181582] = "BellowingShout",
-- 			[187814] = "RagingCharge",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[180017] = "CrushingDarkness", -- Unsure about this
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[-189434] = "TouchOfDoomP", -- LFR
-- 			[-179977] = "TouchOfDoomP", -- All others
-- 			[189434] = "TouchOfDoom", -- LFR
-- 			[179977] = "TouchOfDoom", -- All others
-- 			[-179909] = "SharedFateRootP",
-- 			[-179908] = "SharedFateRunP",
-- 			[181973] = "FeastOfSoulsStart",
-- 			[181295] = "Digest",
-- 			[-179864] = "ShadowOfDeathP",
-- 			[-180148] = "HungerForLifeP",
-- 			[179995] = "DoomWellDamage",
-- 			[182601] = "FelFuryDamage",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[185189] = "FelFlames",
-- 			[182601] = "FelFuryDamage",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[179909] = "SharedFateRootRemoved",
-- 			[181973] = "FeastOfSoulsOver",
-- 			[179908] = "SharedFateRunRemoved",
-- 			[189434] = "TouchOfDoomRemoved", -- LFR
-- 			[179977] = "TouchOfDoomRemoved", -- all others
-- 			[181295] = "DigestRemoved",
-- 			[180148] = "HungerForLifeOver",
-- 			[185982] = "GoreboundFortitude", -- Add spawning on the 'real' realm
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Socrethar the Eternal"] = function()
-- 	if not VA.boss.data["Sorcethar the Eternal"] then VA.boss.data["Sorcethar the Eternal"] = {} end
-- 	local boss = VA.boss.data["Sorcethar the Eternal"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[183331] = "ExertDominance",
-- 			[183329] = "Apocalypse",
-- 			[182392] = "ShadowBoltVolley",
-- 			[182051] = "FelblazeCharge",
-- 			[180008] = "ReverberatingBlow",
-- 			[181288] = "FelPrison",
-- 			[188693] = "ApocalypticFelburst", -- P1
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[183023] = "EjectSoul", -- Phase 2
-- 			[190651] = "ApocalypticFelburstConstruct", -- Construct Ability
-- 			[182769] = "GhastlyFixationSuccess",
-- 			[190776] = "SocretharsContingency", -- add spawning
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[188692] = "UnstoppableTenacity",
-- 			[182038] = "ShatteredDefense",
-- 			[189627] = "VolatileFelOrb",
-- 			[182769] = "GhastlyFixation",
-- 			[184053] = "FelBarrier",
-- 			[184124] = "GiftOfTheManari",
-- 			[183017] = "FelPrisonApplied",
-- 			[182218] = "FelblazeResidueDamage",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[182038] = "ShatteredDefense",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[183329] = "ApocalypseEnd",
-- 			[184053] = "FelBarrierRemoved",
-- 			[184124] = "GiftOfTheManariRemoved",
-- 			[190466] = "IncompleteBindingRemoved", -- Phase 1
-- 		}
-- 	end
--
-- 	-- do -- Misc extra stuff
-- 	-- 	"SPELL_PERIODIC_DAMAGE", "FelblazeResidueDamage", 182218
-- 	-- 	"SPELL_PERIODIC_MISSED", "FelblazeResidueDamage", 182218
-- 	-- end
-- end
--
-- VA.registerBoss["Shadow-Lord Iskar"] = function()
-- 	if not VA.boss.data["Shadow-Lord Iskar"] then VA.boss.data["Shadow-Lord Iskar"] = {} end
-- 	local boss = VA.boss.data["Shadow-Lord Iskar"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[181912] = "FocusedBlast",
-- 			[181827] = "Interrupt",
-- 			[187998] = "Interrupt",
-- 			[181873] = "Stage2", -- Shadow Escape
-- 			[185345] = "ShadowRiposte",
-- 			[185456] = "DarkBindingsCast", -- Chains of Despair
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[181956] = "PhantasmalWinds",
-- 			[181306] = "ExplosiveBurst",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[-179202] = "EyeOfAnzuP",
-- 			[179202] = "EyeOfAnzu",
-- 			[185757] = "PhantasmalWindsApplied",
-- 			[181957] = "PhantasmalWindsApplied",
-- 			[182325] = "PhantasmalWounds",
-- 			[181824] = "PhantasmalCorruption",
-- 			[187990] = "PhantasmalCorruption",
-- 			[-181753] = "FelBombP",
-- 			[181753] = "FelBomb",
-- 			[-182200] = "FelChakramP",
-- 			[-182178] = "FelChakramP",
-- 			[182200] = "FelChakram",
-- 			[182178] = "FelChakram",
-- 			[182600] = "FelFireDamage",
-- 			[185510] = "DarkBindings",
-- 			[-185747] = "FelBeamP",
-- 			[185747] = "FelBeam",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[185757] = "PhantasmalWindsRemoved",
-- 			[181957] = "PhantasmalWindsRemoved",
-- 			[181824] = "PhantasmalCorruptionRemoved",
-- 			[187990] = "PhantasmalCorruptionRemoved",
-- 			[185510] = "DarkBindingsRemoved",
-- 		}
-- 	end
--
-- 	--[[ CURRENT SOUNDS
-- 		60Berserk0
-- 		30Berserk0
-- 		3Winds0
-- 		3Wounds0
-- 		3Corruption0
-- 		3Bomb0
-- 		3Blast0
-- 		3Conduit0
-- 		3Chakram0
-- 		3Bindings0
-- 		3Phase0
-- 		3Riposte0
-- 		FocusedBlast
-- 		Interrupt
-- 		ShadowRiposte
-- 		DarkBindingsCast
-- 		PhantasmalWinds
-- 		ExplosiveBurst
-- 		EyeOfAnzuP
-- 		EyeOfAnzu
-- 		PhantasmalWindsApplied
-- 		PhantasmalWounds
-- 		FelChakramP
-- 		FelChakram
-- 		FelBeamP
-- 		FelBeam
-- 		FelBombP
-- 		FelBomb
-- 	]]
--
-- 	-- do -- Misc extra stuff
-- 	-- 	"SPELL_PERIODIC_DAMAGE", "FelFireDamage", 182600
-- 	-- 	"SPELL_PERIODIC_MISSED", "FelFireDamage", 182600
-- 	-- 	"RAID_BOSS_WHISPER"
-- 	-- 	"TalonpriestDeath", 91543, 93985 -- Bossfight, Trash
-- 	-- 	"WardenDeath", 91541, 93968 -- Bossfight, Trash
-- 	-- 	"RavenDeath", 91539, 93952 -- Bossfight, Trash
-- 	-- 	"ResonanceDeath", 93625 -- Phantasmal Resonance
-- 	-- end
-- end
--
-- VA.registerBoss["Tyrant Velhari"] = function()
-- 	if not VA.boss.data["Tyrant Velhari"] then VA.boss.data["Tyrant Velhari"] = {} end
-- 	local boss = VA.boss.data["Tyrant Velhari"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[180608] = "GavelOfTheTyrant",
-- 			[180004] = "EnforcersOnslaught",
-- 			[180260] = "AnnihilatingStrike",
-- 			[180300] = "InfernalTempestStart",
-- 			[180025] = "HarbingersMending",
-- 			[181990] = "HarbingersMending",
-- 			[180533] = "TaintedShadows",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[180600] = "BulwarkOfTheTyrant",
-- 			[179986] = "AuraOfContempt",
-- 			[179991] = "AuraOfMalice",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[180526] = "FontOfCorruption",
-- 			[179987] = "ContemptApplied",
-- 			[180025] = "HarbingersMendingApplied",
-- 			[181990] = "HarbingersMendingApplied",
-- 			[181718] = "AuraOfOppression",
-- 			[180040] = "SovereignsWard",
-- 			[180604] = "DespoiledGroundDamage",
-- 			[180000] = "SealOfDecay",
-- 			[185237] = "TouchOfHarm", -- Mythic
-- 			[180166] = "TouchOfHarm", -- Heroic/Normal
-- 			[185238] = "TouchOfHarmDispelled", -- Mythic
-- 			[180164] = "TouchOfHarmDispelled", -- Heroic/Normal
-- 			[182459] = "EdictOfCondemnation",
-- 			[185241] = "EdictOfCondemnation",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[180000] = "SealOfDecay",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[180300] = "InfernalTempestEnd",
-- 			[182459] = "EdictOfCondemnationRemoved",
-- 			[185241] = "EdictOfCondemnationRemoved",
-- 			[180040] = "SovereignsWardRemoved",
-- 			[179987] = "ContemptRemoved",
-- 			[180526] = "FontOfCorruptionRemoved",
-- 		}
-- 	end
--
-- 	-- do -- Misc extra stuff
-- 	-- 	"SPELL_PERIODIC_DAMAGE", "DespoiledGroundDamage", 180604
-- 	-- 	"SPELL_PERIODIC_MISSED", "DespoiledGroundDamage", 180604
-- 	-- 	"Deaths", 90270, 90271, 90272 -- Ancient Enforcer, Ancient Harbinger, Ancient Sovereign
-- 	-- end
-- end
--
-- VA.registerBoss["Fel Lord Zakuun"] = function()
-- 	if not VA.boss.data["Fel Lord Zakuun"] then VA.boss.data["Fel Lord Zakuun"] = {} end
-- 	local boss = VA.boss.data["Fel Lord Zakuun"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[179406] = "SoulCleave",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[189009] = "Cavitation",
-- 			[179583] = "RumblingFissures",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[189030] = "Befouled", -- red
-- 			[189031] = "Befouled", -- yellow
-- 			[189032] = "Befouled", -- green
-- 			[179407] = "Disembodied",
-- 			[181508] = "SeedOfDestruction",
-- 			[181515] = "SeedOfDestruction",
-- 			[179681] = "Enrage",
-- 			[179667] = "DisarmedApplied", -- phase 2 trigger, could also use Throw Axe _success, but throw axe doesn't have cleu event for phase ending?
-- 			[181653] = "FelCrystalDamage",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[1000] = "blank",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[181508] = "SeedOfDestructionRemoved",
-- 			[181515] = "SeedOfDestructionRemoved",
-- 			[189030] = "BefouledRemovedCheck",
-- 			[189031] = "BefouledRemovedCheck",
-- 			[189032] = "BefouledRemovedCheck",
-- 			[179667] = "DisarmedRemoved",
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Xhul'horac"] = function()
-- 	if not VA.boss.data["Xhul'horac"] then VA.boss.data["Xhul'horac"] = {} end
-- 	local boss = VA.boss.data["Xhul'horac"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[190223] = "FelStrike",
-- 			[190224] = "VoidStrike",
-- 			[186546] = "BlackHole", -- Normal
-- 			[189779] = "BlackHole", -- Empowered
-- 			[186532] = "FelOrb",
-- 			[188939] = "Voidstep",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[186453] = "FelblazeFlurry",
-- 			[186783] = "WitheringGaze",
-- 			[186271] = "Striked", -- Fel
-- 			[186292] = "Striked", -- Void
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[186073] = "Felsinged_WastingVoid", -- Felsinged
-- 			[186063] = "Felsinged_WastingVoid", -- Wasting Void
-- 			[186407] = "Surge", -- Fel Surge
-- 			[186333] = "Surge", -- Void Surge
-- 			[186500] = "ChainsOfFel", -- Normal
-- 			[189775] = "ChainsOfFel", -- Empowered
-- 			[187204] = "OverwhelmingChaos",
-- 			[186134] = "Touched", -- Feltouched
-- 			[186135] = "Touched", -- Voidtouched
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[186073] = "Felsinged_WastingVoid", -- Felsinged
-- 			[186063] = "Felsinged_WastingVoid", -- Wasting Void
-- 			[187204] = "OverwhelmingChaos",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REFRESH"] then
-- 		boss["SPELL_AURA_REFRESH"] = {
-- 			[186134] = "Touched", -- Feltouched
-- 			[186135] = "Touched", -- Voidtouched
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[186407] = "SurgeRemoved", -- Fel Surge
-- 			[186333] = "SurgeRemoved", -- Void Surge
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Mannoroth"] = function()
-- 	if not VA.boss.data["Mannoroth"] then VA.boss.data["Mannoroth"] = {} end
-- 	local boss = VA.boss.data["Mannoroth"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[181597] = "MannorothsGazeCast",
-- 			[182006] = "MannorothsGazeCast",
-- 			[181799] = "Shadowforce",
-- 			[182084] = "Shadowforce",
-- 			[181793] = "Felseeker", -- 10 yds
-- 			[181792] = "Felseeker", -- 20 yds
-- 			[181738] = "Felseeker", -- 30 yds
-- 			[183377] = "GlaiveThrust",
-- 			[185831] = "GlaiveThrust",
-- 			[182077] = "EmpoweredFelseeker",
-- 			[182076] = "EmpoweredFelseeker",
-- 			[182040] = "EmpoweredFelseeker",
-- 			[181099] = "MarkOfDoomCast",
-- 			[181126] = "ShadowBoltVolley",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[181557] = "FelHellstorm",
-- 			[181275] = "CurseOfTheLegionSuccess", -- APPLIED can miss
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[181597] = "MannorothsGaze",
-- 			[182006] = "MannorothsGaze",
-- 			[181841] = "ShadowforceApplied",
-- 			[182088] = "ShadowforceApplied",
-- 			[181275] = "CurseOfTheLegion",
-- 			[181099] = "MarkOfDoom",
-- 			[181359] = "MassiveBlast",
-- 			[185821] = "MassiveBlast",
-- 			[186362] = "WrathOfGuldan",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[181119] = "DoomSpike",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[181597] = "MannorothsGazeRemoved",
-- 			[182006] = "MannorothsGazeRemoved",
-- 			[181275] = "CurseOfTheLegionRemoved",
-- 			[181099] = "MarkOfDoomRemoved",
-- 			[185147] = "P1PortalClosed", -- Doom Lords
-- 			[185175] = "P1PortalClosed", -- Imps
-- 			[182212] = "P1PortalClosed", -- Infernals
-- 		}
-- 	end
--
-- 	if not boss["SPELL_SUMMON"] then
-- 		boss["SPELL_SUMMON"] = {
-- 			[181255] = "FelImplosion",
-- 			[181180] = "Inferno",
-- 		}
-- 	end
-- end
--
-- VA.registerBoss["Archimonde"] = function()
-- 	if not VA.boss.data["Archimonde"] then VA.boss.data["Archimonde"] = {} end
-- 	local boss = VA.boss.data["Archimonde"]
-- 	-- if not boss.spells then boss.spells = {} end
--
-- 	if not boss["SPELL_CAST_START"] then
-- 		boss["SPELL_CAST_START"] = {
-- 			[183817] = "ShadowfelBurst", -- 5 and 0
-- 			[185590] = "Desecrate", -- 5 and 0
-- 			[183828] = "DeathBrandCast", -- 5 and 0
-- 			[187180] = "DemonicFeedback",
-- 			[183254] = "AllureOfFlamesCast",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_CAST_SUCCESS"] then
-- 		boss["SPELL_CAST_SUCCESS"] = {
-- 			[1000] = "blank",
-- 			[1000] = "blank",
-- 			[1000] = "blank",
-- 			[1000] = "blank",
-- 			[1000] = "blank",
-- 			[1000] = "blank",
-- 			[1000] = "blank",
-- 			[1000] = "blank",
-- 		}
-- 	end
--
-- 	-- do -- Cast Success
-- 	--   "SPELL_CAST_SUCCESS", "AllureOfFlames", 183254 -- 5 and 0
-- 	-- 	"SPELL_CAST_SUCCESS", "WroughtChaosCast", 184265
-- 	--   "SPELL_CAST_SUCCESS", "TwistedDarkness", 190821
-- 	--   "SPELL_CAST_SUCCESS", "SeethingCorruption", 190506
-- 	--   "SPELL_CAST_SUCCESS", "SummonSourceOfChaos", 190686
-- 	--   "SPELL_CAST_SUCCESS", "MarkOfTheLegion", 188514
-- 	--   "SPELL_CAST_SUCCESS", "DarkConduit", 190394
-- 	--   "SPELL_CAST_SUCCESS", "RainOfChaos", 182225
-- 	-- end
--
-- 	if not boss["SPELL_AURA_APPLIED"] then
-- 		boss["SPELL_AURA_APPLIED"] = {
-- 			[183634] = "ShadowfelBurstApplied",
-- 			[183828] = "DeathBrand",
-- 			[183963] = "LightOfTheNaaru",
-- 			[183864] = "ShadowBlast", -- Tank
-- 			[184964] = "ShackledTorment",
-- 			[183586] = "DoomfireDamage",
-- 			[182879] = "DoomfireFixate",
-- 			[185014] = "FocusedChaos",
-- 			[183865] = "DemonicHavoc",
-- 			[186662] = "HeartOfArgus", -- Overfiend spawned (phase warning
-- 			[189895] = "VoidStarFixate",
-- 			[186961] = "TankNetherBanish",
-- 			[186952] = "NetherBanishApplied",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_APPLIED_DOSE"] then
-- 		boss["SPELL_AURA_APPLIED_DOSE"] = {
-- 			[183864] = "ShadowBlast", -- Tank
-- 			[183586] = "DoomfireDamage",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_AURA_REMOVED"] then
-- 		boss["SPELL_AURA_REMOVED"] = {
-- 			[182879] = "DoomfireFixateRemoved",
-- 			[184964] = "ShackledTormentRemoved",
-- 			[185014] = "FocusedChaosRemoved",
-- 			[189895] = "VoidStarFixateRemoved",
-- 			[186961] = "TankNetherBanishRemoved",
-- 			[186952] = "NetherBanishRemoved",
-- 		}
-- 	end
--
-- 	if not boss["SPELL_SUMMON"] then
-- 		boss["SPELL_SUMMON"] = {
-- 			[182826] = "Doomfire",
-- 			[187108] = "InfernalSpawn",
-- 		}
-- 	end
-- end
