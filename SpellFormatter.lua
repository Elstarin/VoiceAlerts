local currentFile
local bossName
local bossID

local http = require "socket.http"
local json = require "json"
local website = "http://www.wowhead.com/spell="

local types = {}
local paths = {}

local files = {
  "C:\\Program Files (x86)\\World of Warcraft\\Interface\\addons\\BigWigs_MistsOfPandaria\\SiegeOfOrgrimmar\\",
  "C:\\Program Files (x86)\\World of Warcraft\\Interface\\addons\\BigWigs_Highmaul\\",
  "C:\\Program Files (x86)\\World of Warcraft\\Interface\\addons\\BigWigs_BlackrockFoundry\\",
  "C:\\Program Files (x86)\\World of Warcraft\\Interface\\addons\\BigWigs_HellfireCitadel\\",
}

local order = {
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_SUMMON",
	"UNIT_DIED",
  "Bars",
	-- "SPELL_PERIODIC_DAMAGE",
	-- "SPELL_PERIODIC_MISSED",
	-- "SPELL_PERIODIC_HEAL",
}

local L = {}
do -- BigWigs Locales
  L.you = "%s on YOU!"
  L.underyou = "%s under YOU!"
  L.other = "%s: %s"
  L.onboss = "%s on BOSS!"
  L.on = "%s on %s"
  L.stack = "%dx %s on %s"
  L.stackyou = "%dx %s on YOU"
  L.cast = "<Cast: %s>"
  L.casting = "Casting %s!"
  L.soon = "%s soon!"
  L.count = "%s (%d)"
  L.count_icon = "%s (%d\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d.blp:0\124t)"
  L.count_rticon = "%s (%d{rt%d})"
  L.near = "%s near YOU!"

  L.phase = "Phase %d"
  L.stage = "Stage %d"
  L.normal = "Normal mode"
  L.heroic = "Heroic mode"
  L.hard = "Hard mode"
  L.mythic = "Mythic mode"
  L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

  L.duration = "%s for %s sec"
  L.over = "%s Over!"
  L.removed = "%s Removed"
  L.incoming = "%s Incoming!"
  L.interrupted = "%s Interrupted"
  L.no = "No %s!"
  L.intermission = "Intermission"

  -- Add related
  L.add_spawned = "Add Spawned!"
  L.spawned = "%s Spawned"
  L.spawning = "%s Spawning!"
  L.next_add = "Next Add"
  L.add_killed = "Add killed! (%d/%d)"
  L.add_remaining = "Add killed, %d remaining"
  L.add = "Add"
  L.adds = "Adds"
  L.big_add = "Big Add"
  L.small_adds = "Small Adds"

  -- Mob related
  L.mob_killed = "%s killed! (%d/%d)"
  L.mob_remaining = "%s killed, %d remaining"

  -- Localizers note:
  -- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
  L.custom_start = "%s engaged - %s in %d min"
  L.custom_start_s = "%s engaged - %s in %d sec"
  L.custom_end = "%s goes %s!"
  L.custom_min = "%s in %d min"
  L.custom_sec = "%s in %d sec!"

  L.focus_only = "|cffff0000Focus target alerts only.|r "
  L.trash = "Trash"

  L.fate_root_you = "Shared Fate - You are rooted!"
  L.fate_you = "Shared Fate on YOU! - Root on %s"
end

-- see if the file exists
local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file
local function lines_from(table, file)
  if not file_exists(file) then return end

  for line in io.lines(file) do
    local line = string.match(line, 'file="(.+)"%/')

    if line then
      table[#table + 1] = currentFile .. line
    end
  end
end

local bossFiles = {}
local boss

do
  for index = 1, #files do -- Create list of all file the paths
    currentFile = files[index]
    lines_from(paths, files[index] .. "modules.xml")

    local raid = files[index]:match("BigWigs_%a+\\(%a+)\\") or files[index]:match("BigWigs_(%a+)\\")
    local raid = string.gsub(raid, "(%l)(%u)", "%1 %2")

    bossFiles[raid] = {}

		for i, v in ipairs(paths) do
			if not file_exists(paths[i]) then return end

			for line in io.lines(paths[i]) do
				local name, instanceID, bossID = string.match(line, ':NewBoss%("(.+)", (%d+), (%d+)%)')
				if name then
          local num = #bossFiles[raid] + 1
          bossFiles[raid][num] = {}
          boss = bossFiles[raid][num]
          boss.name = name
          bossName = name
          boss.instanceID = instanceID
          boss.bossID = bossID
        end

				local ID = string.match(line, ':RegisterEnableMob%((%d+)')
				if ID then bossID = ID end

				local data = string.match(line, "(self:Log%(.+)")
				if data then
					local event, name = string.match(line, '"(.-)"%s?, "(.-)"')

          if not name then print(line) end
					local name = string.gsub(name, "(%l)(%u)", "%1 %2")

          if not boss[event] then boss[event] = {} end

					local comment = string.match(line, "%-%-%s(.+)")

					local spells = {}
					for spellID in string.gmatch(line, ", (%d+)") do
						spells[#spells + 1] = spellID

            if not boss[event][spellID] then
              if comment then
                boss[event][spellID] = name .. " <comment " .. comment .. ">"
              else
                boss[event][spellID] = name
              end
            end
					end
				end

        -- self:Bar(args.spellId, 8.5)
        -- self:CDBar(args.spellId, 8)
        -- self:TargetBar(args.spellId, 7, args.destName)
        -- CL.count:format(self:SpellName(179406), cleaveCount)

        -- local func = string.match(line, " CL.(.-):format")

        -- local bar = line:match("self:%a*Bar%(.+%)")
        -- if bar then
        --   if not boss["Bars"] then boss["Bars"] = {} end
        --
        --   local format = line:match(" CL.(.-):format")
        --   if format and L[format] then
        --
        --     for word in line:gmatch() do
        --
        --     end
        --   end
        --
        --   boss["Bars"][#boss["Bars"] + 1] = bar
        -- end

        -- if func and bossData[bossName].event then
        --   local t = bossData[bossName]
        --   t.formattedFunc = L[func]
        --   -- print(t.event, t.name, t.spells, t.bossName, t.formattedFunc)
        -- end

				paths[i] = nil
			end
		end
  end
end

local function sortEvents(table)
  local sortTable = {}

	for event, table in pairs(table) do

		for i, v in ipairs(order) do
			if v == event then
        sortTable[i] = event
				break
			end
		end
	end

  return sortTable
end

local raidName
local line = "--------------------------------------------------------------------------------\n-- %s\n--------------------------------------------------------------------------------\n"
local function formatText()
	local str = "local VA = VoiceAlerts\nif not VA then return end\n\n"

  for raid in pairs(bossFiles) do
    if raid ~= raidName then
      str = str .. line:format(raid)
      raidName = raid
    end

    for index, bossTable in ipairs(bossFiles[raid]) do
      local bossName = bossTable.name
      if bossName == "Oregorger" then bossName = "Oregorger the Devourer" end -- Stupid hidden part of the name
      local instanceID = bossTable.instanceID
      local bossID = bossTable.bossID
      local s = "VA.bossIndex[#VA.bossIndex + 1] = %q\nVA.registerBoss[%q] = function()\n\tVA.instanceID = %s\n\tVA.bossID = %s\n\tVA.boss.data[%q] = {}\n\tlocal boss = VA.boss.data[%q]\n\t\n\t"
      str = str .. s:format(bossName, bossName, bossTable.instanceID, bossTable.bossID, bossName, bossName)
      local sorted = sortEvents(bossTable)

      for _, event in pairs(sorted) do
        str = str .. ("if not boss[%q] then\n\t\tboss[%q] = {"):format(event, event)

        for spellID, name in pairs(bossTable[event]) do
          local comment = name:match("<comment (.+)>")

          if comment then
            name = name:gsub(" <comment .+>", "")

            str = str .. ("\n\t\t\t[%s] = %q, -- %s"):format(spellID, name, comment)
          else
            str = str .. ("\n\t\t\t[%s] = %q,"):format(spellID, name)
          end
        end

        str = str .. ("\n\t\t}\n\tend\n\t\n\t"):format(event, event)
      end

      str = str .. "end\n\n"

      str = str:gsub("end\n\t\n\tend", "end\nend")
    end
  end

  local file, msg = io.open("C:\\Program Files (x86)\\World of Warcraft\\Interface\\addons\\VoiceAlerts\\BossList.lua", "w+")
  file:write(str)
  file:close()
end

formatText()


-- do
--   for index = 1, #files do -- Create list of all file the paths
--     currentFile = files[index]
--     lines_from(paths, files[index] .. "modules.xml")
--
-- 		for i, v in ipairs(paths) do
-- 			if not file_exists(paths[i]) then return end
--
-- 			for line in io.lines(paths[i]) do
--         local funcName
-- 				local name = string.match(line, ':NewBoss%("(.+)",')
-- 				if name then bossName = name end
--
-- 				local ID = string.match(line, ':RegisterEnableMob%((%d+)')
-- 				if ID then bossID = ID end
--
-- 				local data = string.match(line, "(self:Log%(.+)")
-- 				if data then
-- 					local event, name = string.match(line, '"(.-)", "(.-)"')
-- 					local name = string.gsub(name, "(%l)(%u)", "%1 %2")
--           funcName = name
--
-- 					local comment = string.match(line, "%-%-%s(.+)")
--
-- 					local spells = {}
-- 					for spellID in string.gmatch(line, ", (%d+)") do
-- 						spells[#spells + 1] = spellID
-- 					end
--
-- 					format(event, name, bossID, spells, bossName, comment)
-- 				end
--
--         local func = string.match(line, " CL.(.-):format")
--
--         if func then
--           print(L[func])
--         end
--
-- 				paths[i] = nil
-- 			end
-- 		end
--   end
-- end
