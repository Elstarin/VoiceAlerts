local VA = VoiceAlerts
if not VA then return end

--------------------------------------------------------------------------------
-- Highmaul
--------------------------------------------------------------------------------
VA.bossIndex[#VA.bossIndex + 1] = "Kargath Bladefist"
VA.registerBoss["Kargath Bladefist"] = function()
	VA.instanceID = 994
	VA.bossID = 1128
	VA.boss.data["Kargath Bladefist"] = {}
	local boss = VA.boss.data["Kargath Bladefist"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[159113] = "Impale",
			[158986] = "Berserker Rush Cast",
			[160521] = "Vile Breath",
			[159947] = "Chain Hurl",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[181113] = "Cat Spawn", -- Encounter Spawn
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[162497] = "On The Hunt",
			[158986] = "Berserker Rush Applied Fallback",
			[159947] = "Chain Hurl Applied",
			[159202] = "Fire Pillar", -- Flame Jet
			[159413] = "Mauling Brew Damage",
			[159311] = "Flame Jet Damage",
			[159250] = "Blade Dance",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[158986] = "Berserker Rush Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "The Butcher"
VA.registerBoss["The Butcher"] = function()
	VA.instanceID = 994
	VA.bossID = 971
	VA.boss.data["The Butcher"] = {}
	local boss = VA.boss.data["The Butcher"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[156293] = "Cleave",
			[156157] = "Cleave",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[156257] = "Bounding Cleave",
			[163051] = "Add Spawn", -- Paleobomb
			[156197] = "Bounding Cleave",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[156151] = "Tenderizer",
			[156598] = "Frenzy",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[156151] = "Tenderizer",
			[156152] = "Gushing Wounds",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[156152] = "Gushing Wounds Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Tectus"
VA.registerBoss["Tectus"] = function()
	VA.instanceID = 994
	VA.bossID = 1195
	VA.boss.data["Tectus"] = {}
	local boss = VA.boss.data["Tectus"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[162894] = "Gift Of Earth",
			[162475] = "Tectonic Upheaval",
			[162968] = "Earthen Flechettes",
			[163312] = "Raving Assault",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[181089] = "Boss Unit Killed", -- Encounter Event
			[181113] = "Adds Spawn", -- Encounter Spawn
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[162346] = "Crystalline Barrage",
			[162892] = "Petrification",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[162288] = "Accretion",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[162346] = "Crystalline Barrage Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Brackenspore"
VA.registerBoss["Brackenspore"] = function()
	VA.instanceID = 994
	VA.bossID = 1196
	VA.boss.data["Brackenspore"] = {}
	local boss = VA.boss.data["Brackenspore"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[159219] = "Necrotic Breath",
			[160013] = "Decay",
			[159996] = "Infesting Spores",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[163594] = "Spore Shooter", -- Small Adds
			[177820] = "Rejuvenating Mushroom", -- XXX Thanks to our IDIOTIC screwup in asking for the wrong id to be shown, this somehow didn't make 6.1
			[163142] = "Summon Fungal Flesh Eater", -- Big Add
			[163794] = "Exploding Fungus",
			[163141] = "Summon Mind Fungus",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[164125] = "Creeping Moss Heal",
			[163755] = "Call Of The Tides",
			[163241] = "Rot",
			[165494] = "Creeping Moss Heal",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[163241] = "Rot",
		}
	end
	
	if not boss["SPELL_SUMMON"] then
		boss["SPELL_SUMMON"] = {
			[160022] = "Living Mushroom",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Twin Ogron"
VA.registerBoss["Twin Ogron"] = function()
	VA.instanceID = 994
	VA.bossID = 1148
	VA.boss.data["Twin Ogron"] = {}
	local boss = VA.boss.data["Twin Ogron"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[158521] = "Double Slash",
			[158415] = "Pulverize Cast",
			[157943] = "Whirlwind",
			[143834] = "Shield Bash",
			[158134] = "Shield Charge",
			[158057] = "Enfeebling Roar",
			[158200] = "Quake",
			[158093] = "Interrupting Shout",
			[158419] = "Pulverize Cast",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[158200] = "Quake Channel",
			[163372] = "Arcane Volatility",
			[158385] = "Pulverize",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[163297] = "Arcane Twisted",
			[158026] = "Enfeebling Roar Applied",
			[158241] = "Blaze Applied",
			[167200] = "Arcane Wound", -- Mythic
			[163372] = "Arcane Volatility Applied",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[167200] = "Arcane Wound", -- Mythic
			[158241] = "Blaze Applied",
		}
	end
	
	if not boss["SPELL_AURA_REFRESH"] then
		boss["SPELL_AURA_REFRESH"] = {
			[163372] = "Arcane Volatility Applied",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[163372] = "Arcane Volatility Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Ko'ragh"
VA.registerBoss["Ko'ragh"] = function()
	VA.instanceID = 994
	VA.bossID = 1153
	VA.boss.data["Ko'ragh"] = {}
	local boss = VA.boss.data["Ko'ragh"]
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[161242] = "Caustic Energy",
			[156803] = "Barrier Applied",
			[163472] = "Dominating Power",
			[172917] = "Expel Magic Fel Damage",
			[172895] = "Expel Magic Fel Applied",
			[160734] = "Vulnerability",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[162186] = "Expel Magic Arcane Applied", -- Faster than _APPLIED
			[161328] = "Suppression Field Cast",
			[162185] = "Expel Magic Fire",
			[161612] = "Overwhelming Energy",
		}
	end
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[162186] = "Expel Magic Arcane Start",
			[172895] = "Expel Magic Fel Cast",
			[162184] = "Expel Magic Shadow",
			[172747] = "Expel Magic Frost",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[162186] = "Expel Magic Arcane Removed",
			[156803] = "Barrier Removed",
			[172895] = "Expel Magic Fel Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Imperator Mar'gok"
VA.registerBoss["Imperator Mar'gok"] = function()
	VA.instanceID = 994
	VA.bossID = 1197
	VA.boss.data["Imperator Mar'gok"] = {}
	local boss = VA.boss.data["Imperator Mar'gok"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[163989] = "Arcane Wrath",
			[156467] = "Destructive Resonance",
			[164301] = "Arcane Aberration",
			[164235] = "Force Nova",
			[163988] = "Arcane Wrath",
			[157349] = "Force Nova",
			[165243] = "Glimpse Of Madness",
			[164076] = "Destructive Resonance",
			[164191] = "Mark Of Chaos",
			[163990] = "Arcane Wrath",
			[164303] = "Arcane Aberration",
			[164299] = "Arcane Aberration",
			[164240] = "Force Nova",
			[158605] = "Mark Of Chaos",
			[178607] = "Dark Star",
			[164075] = "Destructive Resonance",
			[165876] = "Enveloping Night",
			[164232] = "Force Nova",
			[164176] = "Mark Of Chaos",
			[156238] = "Arcane Wrath",
			[164077] = "Destructive Resonance",
			[164178] = "Mark Of Chaos",
			[156471] = "Arcane Aberration",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[181113] = "Chogall Spawn", -- Encounter Spawn
			[181089] = "Phase End", -- Encounter Event
			[158563] = "Kick To The Face",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[176537] = "Eyes Of The Abyss Applied",
			[164004] = "Branded",
			[166200] = "Arcane Volatility",
			[175636] = "Rune Of Destruction",
			[164006] = "Branded",
			[157964] = "Phase Start", -- Power of Fortification, Replication
			[172066] = "Radiating Poison",
			[173827] = "Bad Stuff Under You", -- Rune of Disintegration, Wild Flames
			[157801] = "Slow",
			[165116] = "Entropy",
			[174404] = "Frozen Core",
			[157763] = "Fixate Applied",
			[164191] = "Mark Of Chaos Applied",
			[175654] = "Bad Stuff Under You", -- Rune of Disintegration, Wild Flames
			[158012] = "Phase Start", -- Power of Fortification, Replication
			[158013] = "Displacement Phase Start", -- Power of Displacement
			[176525] = "Growing Darkness Damage",
			[158605] = "Mark Of Chaos Applied",
			[165102] = "Infinite Darkness",
			[174057] = "Intermission Start", -- Arcane Protection
			[157289] = "Intermission Start", -- Arcane Protection
			[164005] = "Branded",
			[164176] = "Mark Of Chaos Applied",
			[165595] = "Gaze Of The Abyss Applied",
			[164178] = "Mark Of Chaos Applied",
			[156225] = "Branded",
			[158553] = "Crush Armor",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[159515] = "Accelerated Assault",
			[165595] = "Gaze Of The Abyss Applied",
			[178468] = "Nether Energy",
			[158553] = "Crush Armor",
		}
	end
	
	if not boss["SPELL_AURA_REFRESH"] then
		boss["SPELL_AURA_REFRESH"] = {
			[157763] = "Fixate Applied",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[164004] = "Branded Removed",
			[164006] = "Branded Removed",
			[174404] = "Frozen Core Removed",
			[157763] = "Fixate Removed",
			[164191] = "Mark Of Chaos Removed",
			[175636] = "Rune Of Destruction Removed",
			[172066] = "Radiating Poison Removed",
			[158605] = "Mark Of Chaos Removed",
			[174057] = "Intermission End",
			[164005] = "Branded Removed",
			[157289] = "Intermission End",
			[176537] = "Eyes Of The Abyss Removed",
			[164176] = "Mark Of Chaos Removed",
			[165595] = "Gaze Of The Abyss Removed",
			[164178] = "Mark Of Chaos Removed",
			[156225] = "Branded Removed",
			[166200] = "Arcane Volatility Removed",
		}
	end
end

--------------------------------------------------------------------------------
-- Blackrock Foundry
--------------------------------------------------------------------------------
VA.bossIndex[#VA.bossIndex + 1] = "Beastlord Darmac"
VA.registerBoss["Beastlord Darmac"] = function()
	VA.instanceID = 988
	VA.bossID = 1122
	VA.boss.data["Beastlord Darmac"] = {}
	local boss = VA.boss.data["Beastlord Darmac"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[159043] = "Epicenter",
			[159045] = "Epicenter",
			[155198] = "Savage Howl",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[155399] = "Conflagration",
			[155365] = "Pin Down",
			[154975] = "Call The Pack",
			[155247] = "Stampede",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[162283] = "Rend And Tear",
			[155061] = "Rend And Tear",
			[155321] = "Unstoppable",
			[155236] = "Crush Armor",
			[154981] = "Conflagration Applied",
			[154960] = "Pinned Down",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[155030] = "Seared Flesh",
			[155061] = "Rend And Tear",
			[155321] = "Unstoppable",
			[162283] = "Rend And Tear",
			[155236] = "Crush Armor",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[154981] = "Conflagration Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Gruul"
VA.registerBoss["Gruul"] = function()
	VA.instanceID = 988
	VA.bossID = 1161
	VA.boss.data["Gruul"] = {}
	local boss = VA.boss.data["Gruul"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[155080] = "Inferno Slice",
			[155301] = "Overhead Smash",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[155080] = "Inferno Slice Success",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[155323] = "Petrifying Slam",
			[155539] = "Destructive Rampage",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[155078] = "Overwhelming Blows",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[155539] = "Destructive Rampage Over",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Oregorger the Devourer"
VA.registerBoss["Oregorger the Devourer"] = function()
	VA.instanceID = 988
	VA.bossID = 1202
	VA.boss.data["Oregorger the Devourer"] = {}
	local boss = VA.boss.data["Oregorger the Devourer"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[173459] = "Blackrock Barrage", -- Heroic & Mythic (1.5s), Normal & LFR (2s)
			[156240] = "Acid Torrent",
			[156179] = "Retched Blackrock",
			[159958] = "Start Berserk", -- Earthshaking Stomp
			[156877] = "Blackrock Barrage", -- Heroic & Mythic (1.5s), Normal & LFR (2s)
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[156834] = "Blackrock Spines",
			[156390] = "Explosive Shard",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[155898] = "Rolling Fury Applied",
			[156203] = "Retched Blackrock Damage",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[173471] = "Acid Maw",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[155819] = "Hunger Drive Removed",
			[155898] = "Rolling Fury Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Hans'gar and Franzok"
VA.registerBoss["Hans'gar and Franzok"] = function()
	VA.instanceID = 988
	VA.bossID = 1155
	VA.boss.data["Hans'gar and Franzok"] = {}
	local boss = VA.boss.data["Hans'gar and Franzok"]
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[162124] = "Smart Stampers",
			[155818] = "Scorching Burns Damage",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[162124] = "Smart Stampers Removed",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[157139] = "Shattered Vertebrae",
		}
	end
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[156938] = "Crippling Suplex",
			[160848] = "Disrupting Roar",
			[160847] = "Disrupting Roar",
			[160838] = "Disrupting Roar",
			[160845] = "Disrupting Roar",
			[153470] = "Skullcracker",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Flamebender Ka'graz"
VA.registerBoss["Flamebender Ka'graz"] = function()
	VA.instanceID = 988
	VA.bossID = 1123
	VA.boss.data["Flamebender Ka'graz"] = {}
	local boss = VA.boss.data["Flamebender Ka'graz"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[156018] = "Devastating Slam",
			[156040] = "Drop The Hammer",
			[155064] = "Rekindle",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[155074] = "Charring Breath Cast",
			[181089] = "Wolf Dies", -- Encounter Event
			[155776] = "Cinder Wolves",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[155074] = "Charring Breath",
			[154952] = "Fixate",
			[155277] = "Blazing Radiance",
			[154932] = "Molten Torrent Applied",
			[154950] = "Overheated",
			[163284] = "Rising Flames",
			[155314] = "Lava Slash Damage",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[163284] = "Rising Flames",
			[155074] = "Charring Breath",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[154932] = "Molten Torrent Removed",
			[154952] = "Fixate Over",
			[155277] = "Blazing Radiance Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Operator Thogar"
VA.registerBoss["Operator Thogar"] = function()
	VA.instanceID = 988
	VA.bossID = 1147
	VA.boss.data["Operator Thogar"] = {}
	local boss = VA.boss.data["Operator Thogar"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[160140] = "Cauterizing Bolt",
			[159481] = "Delayed Siege Bomb",
			[163753] = "Iron Bellow",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[155864] = "Pulse Grenade",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[160140] = "Cauterizing Bolt Applied",
			[165195] = "Pulse Grenade Damage",
			[155921] = "Enkindle",
			[159481] = "Delayed Siege Bomb Applied",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[155921] = "Enkindle",
			[165195] = "Pulse Grenade Damage",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[159481] = "Delayed Siege Bomb Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Kromog"
VA.registerBoss["Kromog"] = function()
	VA.instanceID = 988
	VA.bossID = 1162
	VA.boss.data["Kromog"] = {}
	local boss = VA.boss.data["Kromog"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[157060] = "Grasping Earth",
			[157054] = "Thundering Blows",
			[173813] = "Rippling Smash", -- Standard smash, Mythic Call of the Mountain smash
			[158217] = "Call Of The Mountain Start",
			[156704] = "Slam",
			[157592] = "Rippling Smash", -- Standard smash, Mythic Call of the Mountain smash
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[173917] = "Trembling Earth",
			[156852] = "Stone Breath",
			[158217] = "Call Of The Mountain Success",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[156766] = "Warped Armor",
			[156861] = "Frenzy",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[156766] = "Warped Armor",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[157054] = "Thundering Blows Over",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "The Iron Maidens"
VA.registerBoss["The Iron Maidens"] = function()
	VA.instanceID = 988
	VA.bossID = 1203
	VA.boss.data["The Iron Maidens"] = {}
	local boss = VA.boss.data["The Iron Maidens"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[158692] = "Deadly Throw",
			[158708] = "Earthen Barrier",
			[156109] = "Convulsive Shadows",
			[158599] = "Deploy Turret",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[155794] = "Blade Dash",
			[157886] = "Bombardment Omega",
			[181089] = "Ship Phase", -- XXX 6.1
			[157854] = "Bombardment Alpha",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[159724] = "Blood Ritual",
			[156601] = "Sanguine Strikes",
			[156631] = "Rapid Fire",
			[158315] = "Dark Hunt",
			[158010] = "Heartseeker Applied",
			[159336] = "Iron Will",
			[164271] = "Penetrating Shot",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[159724] = "Blood Ritual Removed",
			[158010] = "Heartseeker Removed",
			[164271] = "Penetrating Shot Removed",
			[156631] = "Rapid Fire Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "The Blast Furnace"
VA.registerBoss["The Blast Furnace"] = function()
	VA.instanceID = 988
	VA.bossID = 1154
	VA.boss.data["The Blast Furnace"] = {}
	local boss = VA.boss.data["The Blast Furnace"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[155179] = "Repair",
			[176133] = "Slag Bomb",
			[155186] = "Cauterize Wounds",
			[156937] = "Pyroclasm",
		}
	end
	
	if not boss["SPELL_AURA_REFRESH"] then
		boss["SPELL_AURA_REFRESH"] = {
			[155192] = "Bomb",
			[159558] = "Bomb",
			[174716] = "Bomb",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[176121] = "Volatile Fire Removed",
			[176141] = "Hardened Slag Removed", -- Mythic
			[155196] = "Fixate Removed",
			[174716] = "Bomb Removed",
			[155192] = "Bomb Removed",
			[159558] = "Bomb Removed",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[175104] = "Melt Armor",
			[155242] = "Heat",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[175104] = "Melt Armor",
			[155176] = "Damage Shield",
			[158345] = "Shields Down",
			[163776] = "Superheated",
			[155225] = "Melt",
			[159558] = "Bomb", -- Bomb, Cluster of Lit Bombs, MC'd Engineer Bomb
			[176121] = "Volatile Fire Applied",
			[155181] = "Loading", -- Bellows Operator
			[155196] = "Fixate",
			[174716] = "Bomb", -- Bomb, Cluster of Lit Bombs, MC'd Engineer Bomb
			[155242] = "Heat",
			[156934] = "Rupture",
			[155173] = "Reactive Earth Shield",
			[155192] = "Bomb", -- Bomb, Cluster of Lit Bombs, MC'd Engineer Bomb
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Blackhand"
VA.registerBoss["Blackhand"] = function()
	VA.instanceID = 988
	VA.bossID = 959
	VA.boss.data["Blackhand"] = {}
	local boss = VA.boss.data["Blackhand"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[158054] = "Massive Shattering Smash",
			[159142] = "Shattering Smash",
			[163008] = "Massive Explosion",
			[156928] = "Slag Eruption",
			[155992] = "Shattering Smash",
			[175583] = "Living Blaze Cast",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[162579] = "Falling Debris",
			[171613] = "Inferno Totem",
			[156667] = "Siegemaker", -- Blackiron Plating
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[18501] = "Enrage", -- Enrage, Held to Task
			[175765] = "Overhead Smash",
			[157000] = "Attach Slag Bombs",
			[177806] = "Furnace Flame Fun",
			[159632] = "Insatiable Hunger",
			[163121] = "Enrage", -- Enrage, Held to Task
			[156096] = "Marked For Death Applied",
			[175583] = "Living Blaze",
			[175993] = "Lumbering Strength",
			[175624] = "Grievous Mortal Wounds",
			[160260] = "Bad Stuff Under You", -- Spinning Blade, Electrical Storm, Fire Bomb, Exhaust Fumes
			[175643] = "Bad Stuff Under You", -- Spinning Blade, Electrical Storm, Fire Bomb, Exhaust Fumes
			[174773] = "Bad Stuff Under You", -- Spinning Blade, Electrical Storm, Fire Bomb, Exhaust Fumes
			[156653] = "Fixate",
			[162663] = "Bad Stuff Under You", -- Spinning Blade, Electrical Storm, Fire Bomb, Exhaust Fumes
			[159179] = "Attach Slag Bombs",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[175594] = "Burning",
			[175624] = "Grievous Mortal Wounds",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[157000] = "Attach Slag Bombs Over",
			[175594] = "Burning Removed",
			[159632] = "Insatiable Hunger Removed",
			[156096] = "Marked For Death Removed",
			[156667] = "Blackiron Plating Removed", -- Blackiron Plating
			[175583] = "Living Blaze Removed",
			[175765] = "Overhead Smash Removed",
			[175624] = "Grievous Mortal Wounds Removed",
			[159179] = "Attach Slag Bombs Over",
		}
	end
end

--------------------------------------------------------------------------------
-- Siege Of Orgrimmar
--------------------------------------------------------------------------------
VA.bossIndex[#VA.bossIndex + 1] = "Immerseus"
VA.registerBoss["Immerseus"] = function()
	VA.instanceID = 953
	VA.bossID = 852
	VA.boss.data["Immerseus"] = {}
	local boss = VA.boss.data["Immerseus"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[143309] = "Swirl",
			[143436] = "Corrosive Blast", -- not tank only so people know when to not walk in front of the boss
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[143436] = "Corrosive Blast Stack",
			[143574] = "Swelling Corruption",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[143574] = "Swelling Corruption",
			[143579] = "Sha Corruption",
			[143436] = "Corrosive Blast Stack",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "The Fallen Protectors"
VA.registerBoss["The Fallen Protectors"] = function()
	VA.instanceID = 953
	VA.bossID = 849
	VA.boss.data["The Fallen Protectors"] = {}
	local boss = VA.boss.data["The Fallen Protectors"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[143962] = "Inferno Strike",
			[144396] = "Vengeful Strikes",
			[143497] = "Heal",
			[143491] = "Calamity",
			[143330] = "Gouge",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[143007] = "Corruption Kick",
			[143027] = "Clash",
			[143446] = "Bane",
			[143958] = "Corruption Shock",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[143292] = "Fixate",
			[143546] = "Sun Intermission", -- Dark Meditation
			[143423] = "Sha Sear",
			[143955] = "Rook Intermission", -- Misery, Sorrow, and Gloom
			[143434] = "Bane Applied",
			[143812] = "He Intermission", -- Mark of Anguish
			[143840] = "Mark Of Anguish",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[144176] = "Lingering Anguish",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[143955] = "Rook Intermission End",
			[143546] = "Sun Intermission End",
			[143812] = "He Intermission End",
			[143434] = "Bane Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Norushen"
VA.registerBoss["Norushen"] = function()
	VA.instanceID = 953
	VA.bossID = 866
	VA.boss.data["Norushen"] = {}
	local boss = VA.boss.data["Norushen"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[144649] = "Hurl Corruption",
			[144628] = "Titanic Smash",
			[145216] = "Unleashed Anger",
			[144482] = "Tear Reality",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[145769] = "Unleash Corruption", -- Spawns big adds in phase 2
			[144514] = "Lingering Corruption",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[144851] = "Look Within Applied", -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
			[146124] = "Self Doubt",
			[145132] = "Fusion",
			[145226] = "Blind Hatred",
			[144850] = "Look Within Applied", -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
			[144849] = "Look Within Applied", -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
			[146179] = "Phase2", -- Phase 2, "Frayed"
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[146124] = "Self Doubt",
			[145132] = "Fusion",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[144851] = "Look Within Removed", -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
			[144850] = "Look Within Removed", -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
			[144849] = "Look Within Removed", -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Sha of Pride"
VA.registerBoss["Sha of Pride"] = function()
	VA.instanceID = 953
	VA.bossID = 867
	VA.boss.data["Sha of Pride"] = {}
	local boss = VA.boss.data["Sha of Pride"]
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[145215] = "Banishment",
			[144683] = "Imprison Applied",
			[147207] = "Weakened Resolve Begin",
			[144636] = "Imprison Applied",
			[144359] = "Titan Gift Applied",
			[144684] = "Imprison Applied",
			[146594] = "Titan Gift Applied",
			[146817] = "Aura Of Pride Applied",
			[144574] = "Imprison Applied",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[144359] = "Titan Gift Removed",
			[146594] = "Titan Gift Removed",
			[146817] = "Aura Of Pride Removed",
			[147207] = "Weakened Resolve Over",
		}
	end
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[144563] = "Imprison",
			[144832] = "Unleashed Start",
			[144400] = "Swelling Pride",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[144800] = "Self Reflection",
			[144351] = "Mark Of Arrogance",
			[146595] = "Titan Gift Success",
			[144358] = "Wounded Pride",
			[144832] = "Unleashed",
			[144400] = "Swelling Pride Success",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Galakras"
VA.registerBoss["Galakras"] = function()
	VA.instanceID = 953
	VA.bossID = 868
	VA.boss.data["Galakras"] = {}
	local boss = VA.boss.data["Galakras"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[146728] = "Chain Heal",
			[146757] = "Chain Heal",
			[146769] = "Crushers Call",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[147711] = "Curse Of Venom",
			[146722] = "Healing Totem",
			[146849] = "Shattering Cleave",
			[146753] = "Healing Totem",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[146765] = "Flame Arrows",
			[146899] = "Fracture",
			[147200] = "Fracture",
			[147328] = "Warbanner",
			[147068] = "Flames Of Galakrond Applied",
			[147705] = "Poison Cloud",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[147029] = "Flames Of Galakrond Stacking",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[147068] = "Flames Of Galakrond Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Iron Juggernaut"
VA.registerBoss["Iron Juggernaut"] = function()
	VA.instanceID = 953
	VA.bossID = 864
	VA.boss.data["Iron Juggernaut"] = {}
	local boss = VA.boss.data["Iron Juggernaut"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[144485] = "Shock Pulse",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[144718] = "Mine Arming", -- Detonation Sequence
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[144467] = "Ignite Armor",
			[146325] = "Cutter Laser Applied",
			[144459] = "Laser Burn",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[144467] = "Ignite Armor",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[146325] = "Cutter Laser Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Kor'kron Dark Shaman"
VA.registerBoss["Kor'kron Dark Shaman"] = function()
	VA.instanceID = 953
	VA.bossID = 856
	VA.boss.data["Kor'kron Dark Shaman"] = {}
	local boss = VA.boss.data["Kor'kron Dark Shaman"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[144090] = "Foul Stream", -- SUCCESS has destName but is way too late, and "boss1target" should be reliable for it
			[144005] = "Toxic Storm",
			[144070] = "Ashen Wall",
			[144328] = "Iron Tomb",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[144302] = "Bloodlust",
			[143990] = "Foul Geyser",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[144330] = "Iron Prison",
			[144089] = "Toxic Mist Applied",
			[144215] = "Froststorm Strike",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[144215] = "Froststorm Strike",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[144089] = "Toxic Mist Removed",
			[143990] = "Foul Geyser Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "General Nazgrim"
VA.registerBoss["General Nazgrim"] = function()
	VA.instanceID = 953
	VA.bossID = 850
	VA.boss.data["General Nazgrim"] = {}
	local boss = VA.boss.data["General Nazgrim"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[143473] = "Chain Heal",
			[143638] = "Bone Cracker",
			[143432] = "Arcane Shock",
			[143502] = "Execute",
			[143503] = "War Song",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[143475] = "Earth Shield",
			[143474] = "Healing Tide Totem",
			[143872] = "Ravager", -- _START has no destName but boss has target, so that could be better, but since this can target pets, and it takes 2 sec before any damage is done after _SUCCESS I guess we can live with using _SUCCESS over _START here
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[143431] = "Magistrike",
			[143594] = "Stances", -- Battle, Berserker, Defensive
			[143589] = "Stances", -- Battle, Berserker, Defensive
			[143480] = "Fixate",
			[143593] = "Stances", -- Battle, Berserker, Defensive
			[143484] = "Cooling Off",
			[143494] = "Sundering Blow",
			[143882] = "Hunters Mark",
			[143638] = "Bone Cracker Applied",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[143494] = "Sundering Blow",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[143638] = "Bone Cracker Removed",
		}
	end
	
	if not boss["SPELL_SUMMON"] then
		boss["SPELL_SUMMON"] = {
			[143501] = "Banner",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Malkorok"
VA.registerBoss["Malkorok"] = function()
	VA.instanceID = 953
	VA.bossID = 846
	VA.boss.data["Malkorok"] = {}
	local boss = VA.boss.data["Malkorok"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[143199] = "Expel Miasma", -- spell used at the end of rage phase
			[142879] = "Blood Rage",
			[142842] = "Breath Of YShaarj",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[142826] = "Arcing Smash",
			[142851] = "Seismic Slam",
			[142913] = "Displaced Energy",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[142913] = "Displaced Energy Applied",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[142990] = "Fatal Strike",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[142913] = "Displaced Energy Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Spoils of Pandaria"
VA.registerBoss["Spoils of Pandaria"] = function()
	VA.instanceID = 953
	VA.bossID = 870
	VA.boss.data["Spoils of Pandaria"] = {}
	local boss = VA.boss.data["Spoils of Pandaria"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[146222] = "Breath Of Fire",
			[145288] = "Matter Scramble",
			[145786] = "Residue Start",
			[142947] = "Crimson Reconstitution",
			[145461] = "Mogu Rune Of Power",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[142765] = "Spark Of Life", -- Pulse
			[149277] = "Spark Of Life Death", -- Nova
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[145716] = "Blazing Charge",
			[145747] = "Bubbling Amber",
			[145790] = "Residue",
			[145692] = "Warcaller Enrage",
			[146217] = "Keg Toss",
			[145987] = "Set To Blow Applied",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[145987] = "Set To Blow Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Thok the Bloodthirsty"
VA.registerBoss["Thok the Bloodthirsty"] = function()
	VA.instanceID = 953
	VA.bossID = 851
	VA.boss.data["Thok the Bloodthirsty"] = {}
	local boss = VA.boss.data["Thok the Bloodthirsty"]
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[143428] = "Tail Lash",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[143445] = "Fixate Applied",
			[148145] = "Yet Charge",
			[145974] = "Enrage",
			[143777] = "Frozen Solid",
			[146589] = "Skeleton Key",
			[143773] = "Tank Debuff", -- Panic, Acid Breath, Freezing Breath, Scorching Breath
			[143766] = "Tank Debuff", -- Panic, Acid Breath, Freezing Breath, Scorching Breath
			[143411] = "Acceleration",
			[143767] = "Tank Debuff", -- Panic, Acid Breath, Freezing Breath, Scorching Breath
			[143780] = "Tank Debuff", -- Panic, Acid Breath, Freezing Breath, Scorching Breath
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[143442] = "Blood Frenzy",
			[143773] = "Tank Debuff",
			[143766] = "Tank Debuff",
			[143780] = "Tank Debuff",
			[143767] = "Tank Debuff",
			[143411] = "Acceleration",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[143440] = "Blood Frenzy Over",
			[143445] = "Fixate Removed",
			[146589] = "Skeleton Key Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Siegecrafter Blackfuse"
VA.registerBoss["Siegecrafter Blackfuse"] = function()
	VA.instanceID = 953
	VA.bossID = 865
	VA.boss.data["Siegecrafter Blackfuse"] = {}
	local boss = VA.boss.data["Siegecrafter Blackfuse"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[143265] = "Sawblade",
			[144210] = "Death From Above Applied",
			[144208] = "Death From Above",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[143385] = "Electrostatic Charge",
			[143265] = "Sawblade Fallback",
			[145269] = "Add Marked Mob", -- break in
			[145774] = "Overcharge",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[143385] = "Electrostatic Charge Applied",
			[144466] = "Magnetic Crush",
			[145444] = "Overload",
			[146479] = "Drillstorm",
			[144236] = "Pattern Recognition Applied",
			[145365] = "Protective Frenzy",
			[143856] = "Superheated",
			[143639] = "Shockwave Missile Over",
			[145269] = "Crawler Mine",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[145444] = "Overload",
			[143856] = "Superheated",
			[143385] = "Electrostatic Charge Applied",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[144236] = "Pattern Recognition Removed",
			[146479] = "Drillstorm Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Paragons of the Klaxxi"
VA.registerBoss["Paragons of the Klaxxi"] = function()
	VA.instanceID = 953
	VA.bossID = 853
	VA.boss.data["Paragons of the Klaxxi"] = {}
	local boss = VA.boss.data["Paragons of the Klaxxi"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[143974] = "Shield Bash",
			[142729] = "Catalysts", -- blue red yellow purple green orange
			[142727] = "Catalysts", -- blue red yellow purple green orange
			[142728] = "Catalysts", -- blue red yellow purple green orange
			[143243] = "Rapid Fire",
			[143709] = "Store Kinetic Energy",
			[148677] = "Reave",
			[142725] = "Catalysts", -- blue red yellow purple green orange
			[143280] = "Bloodletting",
			[142726] = "Catalysts", -- blue red yellow purple green orange
			[143339] = "Injection Cast",
			[142730] = "Catalysts", -- blue red yellow purple green orange
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[142232] = "Death From Above", -- this is not so reliable but still good to have it as a backup to our timers
			[142729] = "Catalysts Success", -- blue red yellow purple green orange
			[142727] = "Catalysts Success", -- blue red yellow purple green orange
			[142728] = "Catalysts Success", -- blue red yellow purple green orange
			[143939] = "Gouge",
			[144286] = "Prey",
			[142564] = "Encase In Ember",
			[142725] = "Catalysts Success", -- blue red yellow purple green orange
			[142730] = "Catalysts Success", -- blue red yellow purple green orange
			[142726] = "Catalysts Success", -- blue red yellow purple green orange
			[142528] = "Toxic Injection",
			[143735] = "Caustic Amber", -- this is half a sec faster than _DAMAGE
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[142948] = "Aim",
			[143337] = "Mutate",
			[142534] = "Toxic Injections Applied", -- blue red yellow
			[142533] = "Toxic Injections Applied", -- blue red yellow
			[148589] = "Faulty Mutation Applied",
			[143358] = "Parasite Fixate",
			[142532] = "Toxic Injections Applied", -- blue red yellow
			[142671] = "Mesmerize",
			[143339] = "Injection",
			[143759] = "Hurl Amber",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[142931] = "Exposed Veins",
			[143339] = "Injection",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[143605] = "Calculation Removed",
			[142948] = "Aim Removed",
			[148589] = "Faulty Mutation Removed",
			[142532] = "Toxic Injections Removed", -- blue red yellow
			[142534] = "Toxic Injections Removed", -- blue red yellow
			[142533] = "Toxic Injections Removed", -- blue red yellow
			[143339] = "Injection Removed",
			[143542] = "Ready To Fight",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Garrosh Hellscream"
VA.registerBoss["Garrosh Hellscream"] = function()
	VA.instanceID = 953
	VA.bossID = 869
	VA.boss.data["Garrosh Hellscream"] = {}
	local boss = VA.boss.data["Garrosh Hellscream"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[144583] = "Chain Heal",
			[147120] = "Bombardment",
			[144584] = "Add Marked Mob", -- Chain Lightning
			[145037] = "Whirling Corruption",
			[144821] = "Warsong",
			[144969] = "Annihilate",
			[144985] = "Whirling Corruption",
			[147011] = "Manifest Rage",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[144616] = "Power Iron Star",
			[145171] = "Mind Control",
			[145065] = "Mind Control",
			[144749] = "Desecrate",
			[144748] = "Desecrate",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[147235] = "Malicious Blast Applied",
			[148994] = "Hope", -- Hope, Courage, Faith
			[147665] = "Iron Star Fixate Applied",
			[149004] = "Hope", -- Hope, Courage, Faith
			[145195] = "Gripping Despair",
			[144585] = "Add Marked Mob", -- Ancestral Fury
			[148983] = "Hope", -- Hope, Courage, Faith
			[145183] = "Gripping Despair",
			[147209] = "Malice Applied",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[147235] = "Malicious Blast Applied",
			[145183] = "Gripping Despair",
			[145195] = "Gripping Despair",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[144945] = "YShaarjs Protection",
			[147665] = "Iron Star Fixate Removed",
			[147209] = "Malice Removed",
		}
	end
	
	if not boss["SPELL_SUMMON"] then
		boss["SPELL_SUMMON"] = {
			[145033] = "Summon Empowered Add",
		}
	end
end

--------------------------------------------------------------------------------
-- Hellfire Citadel
--------------------------------------------------------------------------------
VA.bossIndex[#VA.bossIndex + 1] = "Hellfire Assault"
VA.registerBoss["Hellfire Assault"] = function()
	VA.instanceID = 1026
	VA.bossID = 1426
	VA.boss.data["Hellfire Assault"] = {}
	local boss = VA.boss.data["Hellfire Assault"]
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[184369] = "Howling Axe",
			[184243] = "Slam",
			[185806] = "Conducted Shock Pulse",
			[185090] = "Inspiring Presence",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[184369] = "Howling Axe Removed",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[184243] = "Slam",
		}
	end
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[185816] = "Repair",
			[180184] = "Crush",
			[180945] = "Siege Nova",
			[184394] = "Shockwave",
			[181968] = "Metamorphosis",
			[184238] = "Cower",
			[190748] = "Cannonball",
			[183452] = "Felfire Volley",
			[185021] = "Call To Arms",
			[186845] = "Flameorb",
			[188101] = "Belch Flame",
			[180417] = "Felfire Volley",
			[186883] = "Belch Flame",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Iron Reaver"
VA.registerBoss["Iron Reaver"] = function()
	VA.instanceID = 1026
	VA.bossID = 1425
	VA.boss.data["Iron Reaver"] = {}
	local boss = VA.boss.data["Iron Reaver"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[181999] = "Firebomb",
			[185282] = "Barrage",
			[182066] = "Falling Slam",
			[182055] = "Full Charge",
			[179889] = "Blitz",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[182066] = "Falling Slam Success",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[182074] = "Immolation Damage",
			[182020] = "Pounding",
			[182001] = "Unstable Orb",
			[182280] = "Artillery",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[182074] = "Immolation Damage",
			[182001] = "Unstable Orb",
		}
	end
	
	if not boss["SPELL_AURA_REFRESH"] then
		boss["SPELL_AURA_REFRESH"] = {
			[182280] = "Artillery", -- Very rarely casted on the same person, usually due to deaths
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[182280] = "Artillery Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Kormrok"
VA.registerBoss["Kormrok"] = function()
	VA.instanceID = 1026
	VA.bossID = 1392
	VA.boss.data["Kormrok"] = {}
	local boss = VA.boss.data["Kormrok"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[181297] = "Explosive Runes", -- Normal, Empowered
			[181296] = "Explosive Runes", -- Normal, Empowered
			[181300] = "Grasping Hands", -- Normal, Empowered
			[181293] = "Fel Outpouring", -- Normal, Empowered
			[181292] = "Fel Outpouring", -- Normal, Empowered
			[181299] = "Grasping Hands", -- Normal, Empowered
			[180244] = "Pound",
			[181305] = "Swat",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[181307] = "Foul Crush",
			[181306] = "Explosive Burst",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[189199] = "Foul Energy", -- Normal, Enraged, Normal (LFR)
			[180117] = "Foul Energy", -- Normal, Enraged, Normal (LFR)
			[186879] = "Shadow Energy", -- Normal, Enraged, Normal(LFR)
			[186880] = "Explosive Energy", -- Normal, Enraged, Normal (LFR)
			[186882] = "Enrage",
			[180115] = "Shadow Energy", -- Normal, Enraged, Normal(LFR)
			[186881] = "Foul Energy", -- Normal, Enraged, Normal (LFR)
			[180116] = "Explosive Energy", -- Normal, Enraged, Normal (LFR)
			[189198] = "Explosive Energy", -- Normal, Enraged, Normal (LFR)
			[189197] = "Shadow Energy", -- Normal, Enraged, Normal(LFR)
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[180244] = "Pound Over",
			[181306] = "Explosive Burst Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Hellfire High Council"
VA.registerBoss["Hellfire High Council"] = function()
	VA.instanceID = 1026
	VA.bossID = 1432
	VA.boss.data["Hellfire High Council"] = {}
	local boss = VA.boss.data["Hellfire High Council"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[184476] = "Reap",
			[184657] = "Nightmare Visage",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[184476] = "Reap Over",
			[183885] = "Mirror Images",
			[184366] = "Demolishing Leap Start",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[184676] = "Mark Of The Necromancer", -- 184676: 30% Mark of the Necromancer
			[184355] = "Bloodboil",
			[184450] = "Mark Of The Necromancer Applied",
			[184449] = "Mark Of The Necromancer", -- 184676: 30% Mark of the Necromancer
			[185066] = "Mark Of The Necromancer Applied",
			[184365] = "Demolishing Leap Start",
			[185065] = "Mark Of The Necromancer Applied",
			[184360] = "Fel Rage",
			[184652] = "Reap Damage",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[184847] = "Acidic Wound",
			[184355] = "Bloodboil Dose",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[184360] = "Fel Rage Removed",
			[184365] = "Demolishing Leap Stop",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Kilrogg Deadeye"
VA.registerBoss["Kilrogg Deadeye"] = function()
	VA.instanceID = 1026
	VA.bossID = 1396
	VA.boss.data["Kilrogg Deadeye"] = {}
	local boss = VA.boss.data["Kilrogg Deadeye"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[180618] = "Fel Blaze",
			[183917] = "Rending Howl",
			[180224] = "Death Throes",
			[180033] = "Cinder Breath",
			[180199] = "Shred Armor",
			[182428] = "Vision Of Death",
			[180163] = "Savage Strikes",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[180200] = "Shredded Armor",
			[188852] = "Blood Splatter Damage",
			[188929] = "Heart Seeker",
			[187089] = "Cleansing Aura",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[180200] = "Shredded Armor",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Gorefiend"
VA.registerBoss["Gorefiend"] = function()
	VA.instanceID = 1026
	VA.bossID = 1372
	VA.boss.data["Gorefiend"] = {}
	local boss = VA.boss.data["Gorefiend"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[181582] = "Bellowing Shout",
			[187814] = "Raging Charge",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[181295] = "Digest",
			[181973] = "Feast Of Souls Start",
			[182601] = "Fel Fury Damage",
			[179995] = "Doom Well Damage",
			[189434] = "Touch Of Doom", -- LFR, all others
			[180148] = "Hunger For Life",
			[179909] = "Shared Fate Root",
			[179864] = "Shadow Of Death",
			[179977] = "Touch Of Doom", -- LFR, all others
			[179908] = "Shared Fate Run",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[182601] = "Fel Fury Damage",
			[185189] = "Fel Flames",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[179908] = "Shared Fate Run Removed",
			[181973] = "Feast Of Souls Over",
			[180148] = "Hunger For Life Over",
			[179909] = "Shared Fate Root Removed",
			[185982] = "Gorebound Fortitude", -- Add spawning on the 'real' realm
			[179977] = "Touch Of Doom Removed", -- LFR, all others
			[189434] = "Touch Of Doom Removed", -- LFR, all others
			[181295] = "Digest Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Shadow-Lord Iskar"
VA.registerBoss["Shadow-Lord Iskar"] = function()
	VA.instanceID = 1026
	VA.bossID = 1433
	VA.boss.data["Shadow-Lord Iskar"] = {}
	local boss = VA.boss.data["Shadow-Lord Iskar"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[185456] = "Dark Bindings Cast", -- Chains of Despair
			[181873] = "Stage2", -- Shadow Escape
			[181827] = "Fel Conduit",
			[187998] = "Fel Conduit",
			[185345] = "Shadow Riposte",
			[181912] = "Focused Blast",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[181956] = "Phantasmal Winds",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[181753] = "Fel Bomb",
			[185757] = "Phantasmal Winds Applied",
			[179202] = "Eye Of Anzu",
			[187990] = "Phantasmal Corruption",
			[182600] = "Fel Fire Damage",
			[185510] = "Dark Bindings",
			[181957] = "Phantasmal Winds Applied",
			[182200] = "Fel Chakram",
			[182178] = "Fel Chakram",
			[182325] = "Phantasmal Wounds",
			[181824] = "Phantasmal Corruption",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[185510] = "Dark Bindings Removed",
			[185757] = "Phantasmal Winds Removed",
			[181957] = "Phantasmal Winds Removed",
			[187990] = "Phantasmal Corruption Removed",
			[181824] = "Phantasmal Corruption Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Socrethar the Eternal"
VA.registerBoss["Socrethar the Eternal"] = function()
	VA.instanceID = 1026
	VA.bossID = 1427
	VA.boss.data["Socrethar the Eternal"] = {}
	local boss = VA.boss.data["Socrethar the Eternal"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[188693] = "Apocalyptic Felburst", -- P1
			[183331] = "Exert Dominance",
			[183329] = "Apocalypse",
			[182392] = "Shadow Bolt Volley",
			[181288] = "Fel Prison",
			[180008] = "Reverberating Blow",
			[182051] = "Felblaze Charge",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[190776] = "Socrethars Contingency", -- add spawning
			[190651] = "Apocalyptic Felburst Construct", -- Construct Ability
			[183023] = "Eject Soul", -- Phase 2
			[182769] = "Ghastly Fixation Success",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[182218] = "Felblaze Residue Damage",
			[182038] = "Shattered Defense",
			[189627] = "Volatile Fel Orb",
			[183017] = "Fel Prison Applied",
			[188692] = "Unstoppable Tenacity",
			[182769] = "Ghastly Fixation",
			[184053] = "Fel Barrier",
			[184124] = "Gift Of The Manari",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[182038] = "Shattered Defense",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[190466] = "Incomplete Binding Removed", -- Phase 1
			[184124] = "Gift Of The Manari Removed",
			[184053] = "Fel Barrier Removed",
			[183329] = "Apocalypse End",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Fel Lord Zakuun"
VA.registerBoss["Fel Lord Zakuun"] = function()
	VA.instanceID = 1026
	VA.bossID = 1391
	VA.boss.data["Fel Lord Zakuun"] = {}
	local boss = VA.boss.data["Fel Lord Zakuun"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[179406] = "Soul Cleave",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[189009] = "Cavitation",
			[179583] = "Rumbling Fissures",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[181515] = "Seed Of Destruction",
			[181653] = "Fel Crystal Damage",
			[189030] = "Befouled", -- 189030 = red, 31 = yellow, 32 = green
			[181508] = "Seed Of Destruction",
			[179407] = "Disembodied",
			[189032] = "Befouled", -- 189030 = red, 31 = yellow, 32 = green
			[179681] = "Enrage",
			[31] = "Befouled", -- 189030 = red, 31 = yellow, 32 = green
			[179667] = "Disarmed Applied", -- phase 2 trigger, could also use Throw Axe _success, but throw axe doesn't have cleu event for phase ending?
			[32] = "Befouled", -- 189030 = red, 31 = yellow, 32 = green
			[189031] = "Befouled", -- 189030 = red, 31 = yellow, 32 = green
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[189032] = "Befouled Removed Check",
			[189030] = "Befouled Removed Check",
			[179667] = "Disarmed Removed", -- phase 2 untrigger
			[181515] = "Seed Of Destruction Removed",
			[181508] = "Seed Of Destruction Removed",
			[189031] = "Befouled Removed Check",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Xhul'horac"
VA.registerBoss["Xhul'horac"] = function()
	VA.instanceID = 1026
	VA.bossID = 1447
	VA.boss.data["Xhul'horac"] = {}
	local boss = VA.boss.data["Xhul'horac"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[189779] = "Black Hole", -- Normal, Empowered
			[186490] = "Chains Of Fel Cast", -- Normal, Empowered
			[190224] = "Void Strike",
			[186546] = "Black Hole", -- Normal, Empowered
			[188939] = "Voidstep",
			[186532] = "Fel Orb",
			[190223] = "Fel Strike",
			[189775] = "Chains Of Fel Cast", -- Normal, Empowered
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[186783] = "Withering Gaze",
			[186292] = "Striked", -- Fel, Void
			[186271] = "Striked", -- Fel, Void
			[186453] = "Felblaze Flurry",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[186063] = "Felsinged_Wasting Void", -- Felsinged, Wasting Void
			[186073] = "Felsinged_Wasting Void", -- Felsinged, Wasting Void
			[186135] = "Touched", -- Feltouched, Voidtouched
			[187204] = "Overwhelming Chaos",
			[186500] = "Chains Of Fel", -- Normal, Empowered
			[186134] = "Touched", -- Feltouched, Voidtouched
			[186407] = "Surge", -- Fel Surge, Void Surge
			[186333] = "Surge", -- Fel Surge, Void Surge
			[189777] = "Chains Of Fel", -- Normal, Empowered
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[186063] = "Felsinged_Wasting Void", -- Felsinged, Wasting Void
			[186073] = "Felsinged_Wasting Void", -- Felsinged, Wasting Void
			[187204] = "Overwhelming Chaos",
		}
	end
	
	if not boss["SPELL_AURA_REFRESH"] then
		boss["SPELL_AURA_REFRESH"] = {
			[186134] = "Touched", -- Feltouched, Voidtouched
			[186135] = "Touched", -- Feltouched, Voidtouched
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[186333] = "Surge Removed", -- Fel Surge, Void Surge
			[186407] = "Surge Removed", -- Fel Surge, Void Surge
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Tyrant Velhari"
VA.registerBoss["Tyrant Velhari"] = function()
	VA.instanceID = 1026
	VA.bossID = 1394
	VA.boss.data["Tyrant Velhari"] = {}
	local boss = VA.boss.data["Tyrant Velhari"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[180608] = "Gavel Of The Tyrant",
			[180533] = "Tainted Shadows",
			[180300] = "Infernal Tempest Start",
			[181990] = "Harbingers Mending",
			[180260] = "Annihilating Strike",
			[180004] = "Enforcers Onslaught",
			[180025] = "Harbingers Mending",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[179986] = "Aura Of Contempt",
			[179991] = "Aura Of Malice",
			[180600] = "Bulwark Of The Tyrant",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[180000] = "Seal Of Decay",
			[185238] = "Touch Of Harm Dispelled", -- Mythic, Heroic/Normal
			[181990] = "Harbingers Mending Applied",
			[180166] = "Touch Of Harm", -- Mythic, Heroic/Normal
			[181718] = "Aura Of Oppression",
			[180604] = "Despoiled Ground Damage",
			[185237] = "Touch Of Harm", -- Mythic, Heroic/Normal
			[180040] = "Sovereigns Ward",
			[180025] = "Harbingers Mending Applied",
			[182459] = "Edict Of Condemnation",
			[180164] = "Touch Of Harm Dispelled", -- Mythic, Heroic/Normal
			[180526] = "Font Of Corruption",
			[185241] = "Edict Of Condemnation",
			[179987] = "Contempt Applied",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[180000] = "Seal Of Decay",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[180040] = "Sovereigns Ward Removed",
			[180526] = "Font Of Corruption Removed",
			[180300] = "Infernal Tempest End",
			[182459] = "Edict Of Condemnation Removed",
			[185241] = "Edict Of Condemnation Removed",
			[179987] = "Contempt Removed",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Mannoroth"
VA.registerBoss["Mannoroth"] = function()
	VA.instanceID = 1026
	VA.bossID = 1395
	VA.boss.data["Mannoroth"] = {}
	local boss = VA.boss.data["Mannoroth"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[183377] = "Glaive Thrust",
			[182084] = "Shadowforce",
			[181793] = "Felseeker", -- 10, 20, 30 yds
			[182040] = "Empowered Felseeker",
			[181099] = "Mark Of Doom Cast",
			[181792] = "Felseeker", -- 10, 20, 30 yds
			[185831] = "Glaive Thrust",
			[182006] = "Mannoroths Gaze Cast",
			[181126] = "Shadow Bolt Volley",
			[182076] = "Empowered Felseeker",
			[181597] = "Mannoroths Gaze Cast",
			[181738] = "Felseeker", -- 10, 20, 30 yds
			[20] = "Felseeker", -- 10, 20, 30 yds
			[30] = "Felseeker", -- 10, 20, 30 yds
			[182077] = "Empowered Felseeker",
			[181799] = "Shadowforce",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[181557] = "Fel Hellstorm",
			[181275] = "Curse Of The Legion Success", -- APPLIED can miss
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[181841] = "Shadowforce Applied",
			[181099] = "Mark Of Doom",
			[181275] = "Curse Of The Legion",
			[182006] = "Mannoroths Gaze",
			[186362] = "Wrath Of Guldan",
			[181359] = "Massive Blast",
			[185821] = "Massive Blast",
			[190482] = "Gripping Shadows",
			[182088] = "Shadowforce Applied",
			[181597] = "Mannoroths Gaze",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[190482] = "Gripping Shadows",
			[181119] = "Doom Spike",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[186362] = "Wrath Of Guldan Removed",
			[182212] = "P1Portal Closed", -- Doom Lords, Imps, Infernals
			[181597] = "Mannoroths Gaze Removed",
			[181099] = "Mark Of Doom Removed",
			[185175] = "P1Portal Closed", -- Doom Lords, Imps, Infernals
			[181275] = "Curse Of The Legion Removed",
			[185147] = "P1Portal Closed", -- Doom Lords, Imps, Infernals
			[182006] = "Mannoroths Gaze Removed",
		}
	end
	
	if not boss["SPELL_SUMMON"] then
		boss["SPELL_SUMMON"] = {
			[181255] = "Fel Implosion",
			[181180] = "Inferno",
		}
	end
end

VA.bossIndex[#VA.bossIndex + 1] = "Archimonde"
VA.registerBoss["Archimonde"] = function()
	VA.instanceID = 1026
	VA.bossID = 1438
	VA.boss.data["Archimonde"] = {}
	local boss = VA.boss.data["Archimonde"]
	
	if not boss["SPELL_CAST_START"] then
		boss["SPELL_CAST_START"] = {
			[188476] = "Bad Breath Casting",
			[189595] = "Protocol Crowd Control",
			[189470] = "Sleep",
			[183254] = "Allure Of Flames Cast",
			[189538] = "Doom Start",
			[189491] = "Summon Towering Infernal",
			[185590] = "Desecrate",
			[189612] = "Rending Howl",
			[183817] = "Shadowfel Burst",
			[187180] = "Demonic Feedback",
			[183828] = "Death Brand Cast",
			[190050] = "Touch Of Shadows",
		}
	end
	
	if not boss["SPELL_CAST_SUCCESS"] then
		boss["SPELL_CAST_SUCCESS"] = {
			[190821] = "Twisted Darkness",
			[184265] = "Wrought Chaos Cast",
			[188514] = "Mark Of The Legion Cast",
			[183254] = "Allure Of Flames",
			[190394] = "Dark Conduit",
			[186127] = "Void Blast",
			[190686] = "Summon Source Of Chaos",
			[189464] = "Carrion Swarm",
			[189504] = "War Stomp",
			[182225] = "Rain Of Chaos",
			[190506] = "Seething Corruption",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED"] then
		boss["SPELL_AURA_APPLIED"] = {
			[187110] = "Focused Fire",
			[188476] = "Bad Breath",
			[179219] = "Phantasmal Fel Bomb",
			[189895] = "Void Star Fixate",
			[182644] = "Dark Fate",
			[183586] = "Doomfire Damage",
			[186952] = "Nether Banish Applied",
			[189533] = "Sever Soul",
			[184964] = "Shackled Torment",
			[189512] = "Mark Of Kazrogal",
			[187050] = "Mark Of The Legion",
			[186197] = "Demonic Sacrifice",
			[189550] = "Rain Of Fire",
			[188510] = "Graggra Smash",
			[185014] = "Focused Chaos",
			[183865] = "Demonic Havoc",
			[186961] = "Tank Nether Banish",
			[184621] = "Hellfire Blast",
			[184587] = "Touch Of Mortality",
			[189538] = "Doom",
			[186662] = "Heart Of Argus", -- Overfiend spawned (phase warning)
			[183963] = "Light Of The Naaru",
			[183634] = "Shadowfel Burst Applied",
			[183828] = "Death Brand",
			[182879] = "Doomfire Fixate",
			[188448] = "Blazing Fel Touch",
			[183864] = "Shadow Blast",
		}
	end
	
	if not boss["SPELL_AURA_APPLIED_DOSE"] then
		boss["SPELL_AURA_APPLIED_DOSE"] = {
			[183586] = "Doomfire Damage",
			[188476] = "Bad Breath",
			[184986] = "Seal Of Decay",
			[183864] = "Shadow Blast",
			[184621] = "Hellfire Blast",
			[190043] = "Felblood Strike",
		}
	end
	
	if not boss["SPELL_AURA_REFRESH"] then
		boss["SPELL_AURA_REFRESH"] = {
			[183963] = "Light Of The Naaru",
		}
	end
	
	if not boss["SPELL_AURA_REMOVED"] then
		boss["SPELL_AURA_REMOVED"] = {
			[187110] = "Focused Fire Removed",
			[179219] = "Phantasmal Fel Bomb Removed",
			[185014] = "Focused Chaos Removed",
			[189512] = "Mark Of Kazrogal Removed",
			[189895] = "Void Star Fixate Removed",
			[182644] = "Dark Fate Removed",
			[184587] = "Touch Of Mortality Removed",
			[189538] = "Doom Removed",
			[186952] = "Nether Banish Removed",
			[189533] = "Sever Soul Removed",
			[184964] = "Shackled Torment Removed",
			[186961] = "Tank Nether Banish Removed",
			[182879] = "Doomfire Fixate Removed",
			[188448] = "Blazing Fel Touch Removed",
			[187050] = "Mark Of The Legion Removed",
		}
	end
	
	if not boss["SPELL_SUMMON"] then
		boss["SPELL_SUMMON"] = {
			[187108] = "Infernal Spawn",
			[182826] = "Doomfire",
		}
	end
end

