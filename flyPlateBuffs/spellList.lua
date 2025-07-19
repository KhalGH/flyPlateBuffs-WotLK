local _, fPB = ...

-- 1.75x Scaled Icons
local defaultSpells1 = {
	34976,	-- Netherstorm Flag (EotS flag)
	23335,	-- Silverwing Flag (Alliance WSG flag)
	23333,	-- Warsong Flag (Horde WSG flag)
}

-- 1.50x Scaled Icons
local defaultSpells2 = {
	46393,	-- Brutal Assault
	33786,	-- Cyclone
	19263,	-- Deterrence
	47585,	-- Dispersion
	642,	-- Divine Shield
	45438,	-- Ice Block
	46392,	-- Focused Assault
	6615,	-- Free Action
}

-- 1.25x Scaled Icons
local defaultSpells3 = {
	13750,	-- Adrenaline Rush
	49050,	-- Aimed Shot
	48707,	-- Anti-Magic Shell
	31821,	-- Aura Mastery
	12042,	-- Arcane Power
	31884,	-- Avenging Wrath
	18647,	-- Banish
	22812,	-- Barkskin
	53563,	-- Beacon of Light
	50334,	-- Berserk (CheckIDSpells)
	37587,	-- Bestial Wrath
	46924,	-- Bladestorm
	2094,	-- Blind
	2825,	-- Bloodlust
	52418,	-- Carrying Seaforium
	45182,	-- Cheating Death
	31224,	-- Cloak of Shadows
	12292,	-- Death Wish
	54428,	-- Divine Plea
	498,	-- Divine Protection
	64205,	-- Divine Sacrifice	
	42950,	-- Dragon's Breath
	49284,	-- Earth Shield
	26669,	-- Evasion (CheckIDSpells)
	6215,	-- Fear
	14309,	-- Freezing Trap Effect
	60210,	-- Frost Arrow Effect
	1776,	-- Gouge
	8178,	-- Grounding Totem Effect
	1044,	-- Hand of Freedom
	10278,	-- Hand of Protection
	6940,	-- Hand of Sacrifice
	32182,	-- Heroism
	51514,	-- Hex
	18658,	-- Hibernate
	17928,	-- Howl of Terror
	49203,	-- Hungering Cold
	48792,	-- Icebound Fortitude
	12472,	-- Icy Veins
	20511,	-- Intimidating Shout
	48451,	-- Lifebloom
	53271,	-- Master's Call
	605,	-- Mind Control
	47486,	-- Mortal Strike
	16689,	-- Nature's Grasp
	33206,	-- Pain Suppression
	12826,	-- Polymorph
	10060,	-- Power Infusion
	48066,	-- Power Word: Shield
	41635,	-- Prayer of Mending
	69369,	-- Predator's Swiftness
	9913,	-- Prowl
	10890,	-- Psychic Scream
	1719,	-- Recklessness
	48441,	-- Rejuvenation
	20066,	-- Repentance
	20230,	-- Retaliation (CheckIDSpells)
	61301,	-- Riptide
	53480,	-- Roar of Sacrifice
	53601,	-- Sacred Shield
	51724,	-- Sap
	14327,	-- Scare Beast
	19503,	-- Scatter Shot
	6358,	-- Seduction (Succubus)
	10955,	-- Shackle Undead
	51713,	-- Shadow Dance
	2565,	-- Shield Block
	871,	-- Shield Wall
	53908,	-- Speed (CheckIDSpells)
	23920,	-- Spell Reflection
	1784,	-- Stealth
	61336,	-- Survival Instincts
	12328,	-- Sweeping Strikes
	10326,	-- Turn Evil
	64850,	-- Unrelenting Assault
	57975,	-- Wound Poison VII
	49012,	-- Wyvern Sting
}

-- 1.00x Scaled Icons (Own Spells)
local defaultSpells4 = {
}

local myClass = select(2, UnitClass("player")) 
if myClass == "DEATHKNIGHT" then
	table.insert(defaultSpells4, #defaultSpells4+1, 55078)	-- Blood Plague
	table.insert(defaultSpells4, #defaultSpells4+1, 45524)	-- Chains of Ice
	table.insert(defaultSpells4, #defaultSpells4+1, 68766)	-- Desecration
	table.insert(defaultSpells4, #defaultSpells4+1, 51735)	-- Ebon Plague
	table.insert(defaultSpells4, #defaultSpells4+1, 55095)	-- Frost Fever
	table.insert(defaultSpells4, #defaultSpells4+1, 58617)	-- Glyph of Heart Strike
	table.insert(defaultSpells4, #defaultSpells4+1, 50436)	-- Icy Clutch
	table.insert(defaultSpells3, #defaultSpells3+1, 47476)	-- Strangulate
	table.insert(defaultSpells4, #defaultSpells4+1, 50536)	-- Unholy Blight
end
if myClass == "DRUID" then
	table.insert(defaultSpells3, #defaultSpells3+1, 16882)	-- Detect Greater Invisibility (Not Own)
	table.insert(defaultSpells3, #defaultSpells3+1, 132)	-- Detect Invisibility (Not Own)
	table.insert(defaultSpells3, #defaultSpells3+1, 6512)	-- Detect Lesser Invisibility (Not Own)
	table.insert(defaultSpells4, #defaultSpells4+1, 8983)	-- Bash
	table.insert(defaultSpells4, #defaultSpells4+1, 60433)	-- Earth and Moon
	table.insert(defaultSpells4, #defaultSpells4+1, 53308)	-- Entangling Roots
	table.insert(defaultSpells4, #defaultSpells4+1, 770)	-- Faerie Fire
	table.insert(defaultSpells4, #defaultSpells4+1, 16857)	-- Faerie Fire (Feral)
	table.insert(defaultSpells4, #defaultSpells4+1, 45334)	-- Feral Charge Effect
	table.insert(defaultSpells4, #defaultSpells4+1, 48468)	-- Insect Swarm
	table.insert(defaultSpells4, #defaultSpells4+1, 49803)	-- Pounce
	table.insert(defaultSpells4, #defaultSpells4+1, 49802)	-- Maim
	table.insert(defaultSpells4, #defaultSpells4+1, 48463)	-- Moonfire
end
if myClass == "HUNTER" then
	table.insert(defaultSpells4, #defaultSpells4+1, 53359)	-- Chimera Shot - Scorpid
	table.insert(defaultSpells4, #defaultSpells4+1, 5116)	-- Concussive Shot
	table.insert(defaultSpells4, #defaultSpells4+1, 49050)	-- Aimed Shot
	table.insert(defaultSpells4, #defaultSpells4+1, 64804)	-- Entrapment
	table.insert(defaultSpells4, #defaultSpells4+1, 13810)	-- Frost Trap Aura
	table.insert(defaultSpells4, #defaultSpells4+1, 53338)	-- Hunter's Mark
	table.insert(defaultSpells4, #defaultSpells4+1, 19503)	-- Scatter Shot
	table.insert(defaultSpells4, #defaultSpells4+1, 3043)	-- Scorpid Sting
	table.insert(defaultSpells4, #defaultSpells4+1, 49001)	-- Serpent Sting
	table.insert(defaultSpells4, #defaultSpells4+1, 34490)	-- Silencing Shot
	table.insert(defaultSpells4, #defaultSpells4+1, 3034)	-- Viper Sting
	table.insert(defaultSpells4, #defaultSpells4+1, 2974)	-- Wing Clip
end
if myClass == "MAGE" then
	table.insert(defaultSpells4, #defaultSpells4+1, 42945)	-- Blast Wave
	table.insert(defaultSpells4, #defaultSpells4+1, 7321)	-- Chilled
	table.insert(defaultSpells4, #defaultSpells4+1, 42931)	-- Cone of Cold
	table.insert(defaultSpells4, #defaultSpells4+1, 44572)	-- Deep Freeze
	table.insert(defaultSpells4, #defaultSpells4+1, 12494)	-- Frostbite
	table.insert(defaultSpells4, #defaultSpells4+1, 42842)	-- Frostbolt
	table.insert(defaultSpells4, #defaultSpells4+1, 47610)	-- Frostfire Bolt
	table.insert(defaultSpells4, #defaultSpells4+1, 42917)	-- Frost Nova
	table.insert(defaultSpells4, #defaultSpells4+1, 55360)	-- Living Bomb
	table.insert(defaultSpells4, #defaultSpells4+1, 55080)	-- Shattered Barrier
	table.insert(defaultSpells4, #defaultSpells4+1, 55021)	-- Silenced - Improved Counterspell
	table.insert(defaultSpells4, #defaultSpells4+1, 31589)	-- Slow
end
if myClass == "PALADIN" then
	table.insert(defaultSpells3, #defaultSpells3+1, 49039)	-- Lichborne (Not Own)
	table.insert(defaultSpells4, #defaultSpells4+1, 48827)	-- Avenger's Shield
	table.insert(defaultSpells4, #defaultSpells4+1, 10308)	-- Hammer of Justice
	table.insert(defaultSpells4, #defaultSpells4+1, 48817)	-- Holy Wrath
	table.insert(defaultSpells4, #defaultSpells4+1, 20184)	-- Judgement of Justice
	table.insert(defaultSpells4, #defaultSpells4+1, 20185)	-- Judgement of Light
	table.insert(defaultSpells4, #defaultSpells4+1, 20186)	-- Judgement of Wisdom
	table.insert(defaultSpells4, #defaultSpells4+1, 63529)	-- Silenced - Shield of the Templar
end
if myClass == "PRIEST" then
	table.insert(defaultSpells3, #defaultSpells3+1, 6346)	-- Fear Ward (Not Own)
	table.insert(defaultSpells3, #defaultSpells3+1, 49039)	-- Lichborne (Not Own)
	table.insert(defaultSpells4, #defaultSpells4+1, 48300)	-- Devouring Plague
	table.insert(defaultSpells4, #defaultSpells4+1, 64044)	-- Psychic Horror
	table.insert(defaultSpells4, #defaultSpells4+1, 48125)	-- Shadow Word: Pain
	table.insert(defaultSpells4, #defaultSpells4+1, 15487)	-- Silence
	table.insert(defaultSpells4, #defaultSpells4+1, 48160)	-- Vampiric Touch
end
if myClass == "ROGUE" then
	table.insert(defaultSpells3, #defaultSpells3+1, 16882)	-- Detect Greater Invisibility (Not Own)
	table.insert(defaultSpells3, #defaultSpells3+1, 132)	-- Detect Invisibility (Not Own)
	table.insert(defaultSpells3, #defaultSpells3+1, 6512)	-- Detect Lesser Invisibility (Not Own)
	table.insert(defaultSpells4, #defaultSpells4+1, 31125)	-- Blade Twisting
	table.insert(defaultSpells4, #defaultSpells4+1, 1833)	-- Cheap Shot
	table.insert(defaultSpells4, #defaultSpells4+1, 3409)	-- Crippling Poison
	table.insert(defaultSpells4, #defaultSpells4+1, 57970)	-- Deadly Poison IX
	table.insert(defaultSpells4, #defaultSpells4+1, 48674)	-- Deadly Throw
	table.insert(defaultSpells4, #defaultSpells4+1, 51722)	-- Dismantle
	table.insert(defaultSpells4, #defaultSpells4+1, 8647)	-- Expose Armor
	table.insert(defaultSpells4, #defaultSpells4+1, 1330)	-- Garrote - Silence
	table.insert(defaultSpells4, #defaultSpells4+1, 8643)	-- Kidney Shot
	table.insert(defaultSpells4, #defaultSpells4+1, 48672)	-- Rupture
	table.insert(defaultSpells4, #defaultSpells4+1, 18425)	-- Silenced - Improved Kick
	table.insert(defaultSpells4, #defaultSpells4+1, 51693)	-- Waylay
	table.insert(defaultSpells4, #defaultSpells4+1, 57975)	-- Wound Poison VII
end
if myClass == "SHAMAN" then
	table.insert(defaultSpells4, #defaultSpells4+1, 49231)	-- Earth Shock
	table.insert(defaultSpells4, #defaultSpells4+1, 3600)	-- Earthbind
	table.insert(defaultSpells4, #defaultSpells4+1, 64695)	-- Earthgrab
	table.insert(defaultSpells4, #defaultSpells4+1, 49233)	-- Flame Shock
	table.insert(defaultSpells4, #defaultSpells4+1, 49236)	-- Frost Shock
	table.insert(defaultSpells4, #defaultSpells4+1, 58799)	-- Frostbrand Attack
	table.insert(defaultSpells4, #defaultSpells4+1, 32175)	-- Stormstrike
end
if myClass == "WARLOCK" then
	table.insert(defaultSpells3, #defaultSpells3+1, 6346)	-- Fear Ward (Not Own)
	table.insert(defaultSpells3, #defaultSpells3+1, 49039)	-- Lichborne (Not Own)
	table.insert(defaultSpells4, #defaultSpells4+1, 18118)	-- Aftermath
	table.insert(defaultSpells4, #defaultSpells4+1, 47813)	-- Corruption
	table.insert(defaultSpells4, #defaultSpells4+1, 47864)	-- Curse of Agony
	table.insert(defaultSpells4, #defaultSpells4+1, 18223)	-- Curse of Exhaustion
	table.insert(defaultSpells4, #defaultSpells4+1, 47865)	-- Curse of the Elements
	table.insert(defaultSpells4, #defaultSpells4+1, 11719)	-- Curse of Tongues
	table.insert(defaultSpells4, #defaultSpells4+1, 50511)	-- Curse of Weakness
	table.insert(defaultSpells4, #defaultSpells4+1, 47860)	-- Death Coil
	table.insert(defaultSpells4, #defaultSpells4+1, 63311)	-- Glyph of Shadowflame
	table.insert(defaultSpells4, #defaultSpells4+1, 59164)	-- Haunt
	table.insert(defaultSpells4, #defaultSpells4+1, 47811)	-- Immolate
	table.insert(defaultSpells4, #defaultSpells4+1, 47836)	-- Seed of Corruption
	table.insert(defaultSpells4, #defaultSpells4+1, 61291)	-- Shadowflame
	table.insert(defaultSpells4, #defaultSpells4+1, 47847)	-- Shadowfury
	table.insert(defaultSpells4, #defaultSpells4+1, 47843)	-- Unstable Affliction
end
if myClass == "WARRIOR" then
	table.insert(defaultSpells4, #defaultSpells4+1, 7922)	-- Charge Stun
	table.insert(defaultSpells4, #defaultSpells4+1, 12809)	-- Concussion Blow
	table.insert(defaultSpells4, #defaultSpells4+1, 676)	-- Disarm
	table.insert(defaultSpells4, #defaultSpells4+1, 1715)	-- Hamstring
	table.insert(defaultSpells4, #defaultSpells4+1, 23694)	-- Improved Hamstring
	table.insert(defaultSpells4, #defaultSpells4+1, 20253)	-- Intercept
	table.insert(defaultSpells4, #defaultSpells4+1, 47486)	-- Mortal Strike
	table.insert(defaultSpells4, #defaultSpells4+1, 12323)	-- Piercing Howl
	table.insert(defaultSpells4, #defaultSpells4+1, 47465)	-- Rend
	table.insert(defaultSpells4, #defaultSpells4+1, 46968)	-- Shockwave
	table.insert(defaultSpells4, #defaultSpells4+1, 18498)	-- Silenced - Gag Order
	table.insert(defaultSpells4, #defaultSpells4+1, 7386)	-- Sunder Armor
	table.insert(defaultSpells4, #defaultSpells4+1, 64850)	-- Unrelenting Assault
end

-- Spells that share name
local CheckIDSpells = {
	26669,	-- Evasion
	20230,	-- Retaliation
	50334,	-- Berserk
	53908,	-- Speed
}

fPB.defaultSpells1 = defaultSpells1
fPB.defaultSpells2 = defaultSpells2
fPB.defaultSpells3 = defaultSpells3
fPB.defaultSpells4 = defaultSpells4
fPB.CheckIDSpells  = CheckIDSpells