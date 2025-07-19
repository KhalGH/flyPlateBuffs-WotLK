local AddonName, fPB = ...

if not C_NamePlate then 
	DEFAULT_CHAT_FRAME:AddMessage(" |cFFFFA500" .. tostring(AddonName) .. "|r requires AwesomeWotlk to function. For more information, visit:")
	DEFAULT_CHAT_FRAME:AddMessage("                    |cff00ccffhttps://github.com/KhalGH/flyPlateBuffs-WotLK|r")
	fPB.disabled = true
	return
end

local	C_NamePlate_GetNamePlateForUnit, C_NamePlate_GetNamePlates, CreateFrame, UnitDebuff, UnitBuff, UnitName, UnitIsUnit, UnitIsPlayer, UnitPlayerControlled, UnitIsEnemy, UnitIsFriend, GetSpellInfo, table_sort, table_insert, table_remove, strmatch, format, wipe, pairs, GetTime, math_floor, math_min, math_max, tostring =
		C_NamePlate.GetNamePlateForUnit, C_NamePlate.GetNamePlates, CreateFrame, UnitDebuff, UnitBuff, UnitName, UnitIsUnit, UnitIsPlayer, UnitPlayerControlled, UnitIsEnemy, UnitIsFriend, GetSpellInfo, table.sort, table.insert, table.remove, strmatch, format, wipe, pairs, GetTime, math.floor, math.min, math.max, tostring

local C_NamePlate_GetDistanceForNamePlate = C_NamePlate.GetDistanceForNamePlate -- by Khal
local C_NamePlate_GetNamePlateForGUID = C_NamePlate.GetNamePlateForGUID -- by Khal
local textVisibilityDistance = 80 -- by Khal

local defaultSpells1, defaultSpells2, defaultSpells3, defaultSpells4, CheckIDSpells = fPB.defaultSpells1, fPB.defaultSpells2, fPB.defaultSpells3, fPB.defaultSpells4, fPB.CheckIDSpells

L = fPB.L
local LSM = LibStub("LibSharedMedia-3.0")
fPB.LSM = LSM
local MSQ, Group

local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

fPB.db = {}
local db

local fPBMainOptions
local fPBSpellsList
local fPBProfilesOptions

fPB.chatColor = "|cFFFFA500"
fPB.linkColor = "|cff71d5ff"
local chatColor = fPB.chatColor
local linkColor = fPB.linkColor

local cachedSpells = {}
local PlatesBuffs = {}

local DefaultSettings = {
	profile = {
		showDebuffs = 3,		-- 1 = all, 2 = mine + spellList, 3 = only spellList, 4 = only mine, 5 = none
		showBuffs = 3,			-- 1 = all, 2 = mine + spellList, 3 = only spellList, 4 = only mine, 5 = none
		hidePermanent = true,
		notHideOnPersonalResource = true,

		showInterrupts = true,
		interruptsScale = 1.25,
		interruptsDurationSize = 13,

		showOnPlayers = true,
		showOnPets = false,
		showOnNPC = true,

		showOnEnemy = true,
		showOnFriend = false,
		showOnNeutral = true,

		showOnlyInCombat = false,
		showUnitInCombat = false,

		parentWorldFrame = false,

		baseWidth = 28,
		baseHeight = 28,
		myScale = 0,
		cropTexture = true,

		buffAnchorPoint = "BOTTOM",
		plateAnchorPoint = "TOP",

		xInterval = 2,
		yInterval = 2,

		xOffset = 0,
		yOffset = 2,

		buffPerLine = 4,
		numLines = 3,

		showStdCooldown = false,
		showStdSwipe = false,

		showDuration = true,
		showDecimals = false,
		durationPosition = 2, -- 1 - under, 2 - on icon, 3 - above icon
		font = "Friz Quadrata TT", --durationFont
		durationSize = 11,
		colorTransition = true,
		colorSingle = {1.0,1.0,1.0},

		stackPosition = 1,  -- 1 - on icon, 2 - under, 3 - above icon
		stackFont = "Friz Quadrata TT",
		stackSize = 11,
		stackColor = {1.0,1.0,1.0},

		blinkFadeMinDuration = 6,
		blinkThreshold = 3,
		fadeThreshold = 3,
		blinkTargetOnly = true,
		fadeTargetOnly = false,

		borderStyle = 2,	-- 1 = \\texture\\border.tga, 2 = Blizzard, 3 = none
		colorizeBorder = true,
		colorTypes = {
			Magic 		= {0.20,0.60,1.00},
			Curse 		= {0.60,0.00,1.00},
			Disease 	= {0.60,0.40,0.00},
			Poison 		= {0.00,0.60,0.00},
			none 		= {0.80,0.00,0.00},
			Buff 		= {0.83,0.83,0.83},
			Interrupt	= {0.20,0.80,0.60} -- by Khal
		},

		disableSort = false,
		sortMode = {
			"my", -- [1]
			"scale", -- [2]
			"type", -- [3]
			"disable", -- [4]
			[2.5] = true, -- by Khal
		},

		Spells = {},
		ignoredDefaultSpells = {},

		showSpellID = false,
	},
}

do --add default spells
	for i=1, #defaultSpells1 do
		local spellID = defaultSpells1[i]
		local name = GetSpellInfo(spellID)
		if name then
			DefaultSettings.profile.Spells[spellID] = {
				name = name,
				spellID = spellID,
				scale = 1.75,
				durationSize = 16,
				show = 1,	-- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
				stackSize = 13,
			}
		end
	end

	for i=1, #defaultSpells2 do
		local spellID = defaultSpells2[i]
		local name = GetSpellInfo(spellID)
		if name then
			DefaultSettings.profile.Spells[spellID] = {
				name = name,
				spellID = spellID,
				scale = 1.5,
				durationSize = 15,
				show = 1,	-- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
				stackSize = 12,
			}
		end
	end

	---------------------- Extra default spell categories, by Khal ------------------------
	for i=1, #defaultSpells3 do
		local spellID = defaultSpells3[i]
		local name = GetSpellInfo(spellID)
		if name then
			DefaultSettings.profile.Spells[spellID] = {
				name = name,
				spellID = spellID,
				scale = 1.25,
				durationSize = 13,
				show = 1,	-- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
				stackSize = 10,
			}
		end
	end

	for i=1, #defaultSpells4 do
		local spellID = defaultSpells4[i]
		local name = GetSpellInfo(spellID)
		if name then
			DefaultSettings.profile.Spells[spellID] = {
				name = name,
				spellID = spellID,
				scale = 1,
				durationSize = 11,
				show = 2,	-- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
				stackSize = 8,
			}
		end
	end

	for i = 1, #CheckIDSpells do
		local spellID = CheckIDSpells[i]
		if DefaultSettings.profile.Spells[spellID] then
			DefaultSettings.profile.Spells[spellID].checkID = true
		end
	end

end

--timeIntervals
local minute, hour, day = 60, 3600, 86400
local aboutMinute, aboutHour, aboutDay = 59.5, 60 * 59.5, 3600 * 23.5

--local function round(x) return floor(x + 0.5) end
local function round(x) return ceil(x) end ----- by Khal

local function FormatTime(seconds)
	if seconds < 10 and db.showDecimals then -- CHECK THIS KHAL, used to be 10 seconds(10->1)
		return "%.1f", seconds
	elseif seconds < aboutMinute then
		local seconds = round(seconds)
		return seconds ~= 0 and seconds or ""
	elseif seconds < aboutHour then
		return "%dm", round(seconds/minute)
	elseif seconds < aboutDay then
		return "%dh", round(seconds/hour)
	else
		return "%dd", round(seconds/day)
	end
end

--[[ local function GetColorByTime(current, max)
	if max == 0 then max = 1 end
	local percentage = (current/max)*100
	local red,green = 0,0
	if percentage >= 50 then
		--green to yellow
		green		= 1
		red			= ((100 - percentage) / 100) * 2
	else
		--yellow to red
		red	= 1
		green		= ((100 - (100 - percentage)) / 100) * 2
	end
	return red, green, 0
end ]]

local function GetColorByTime(current, max) ----- by Khal
	if max == 0 then max = 1 end
	local red,green = 0,0
	if current >= 7 then
		green	= 1;
		red	= 1;
	elseif current >= 3 then
		red	= 1;
		green	= (current - 2) / 4;
	else 
		red	= 1;
		green	= 0;
	end
	return red, green, 0
end

local function SortFunc(a,b)
	local i = 1
	while db.sortMode[i] do
		local mode, rev = db.sortMode[i],db.sortMode[i+0.5]
		if mode ~= "disable" and a[mode] ~= b[mode] then
			if mode == "my" and not rev then -- self first
				return (a.my and 1 or 0) > (b.my and 1 or 0)
			elseif mode == "my" and rev then
				return (a.my and 1 or 0) < (b.my and 1 or 0)
			elseif mode == "expiration" and not rev then
				return (a.expiration > 0 and a.expiration or 5000000) < (b.expiration > 0 and b.expiration or 5000000)
			elseif mode == "expiration" and rev then
				return (a.expiration > 0 and a.expiration or 5000000) > (b.expiration > 0 and b.expiration or 5000000)
			elseif (mode == "type" or mode == "scale") and not rev then
				return a[mode] > b[mode]
			else
				return a[mode] < b[mode]
			end
		end
		i = i+1
	end
end

local function DrawOnPlate(frame)

	if not (#frame.fPBiconsFrame.iconsFrame > 0) then return end

	local maxWidth = 0
	local sumHeight = 0
	local buffIcon = frame.fPBiconsFrame.iconsFrame
	local breaked = false

	for l = 1, db.numLines do
		if breaked then break end

		local lineWidth = 0
		local lineHeight = 0

		for k = 1, db.buffPerLine do

			local i = db.buffPerLine*(l-1)+k
			if not buffIcon[i] or not buffIcon[i]:IsShown() then breaked = true; break end
			buffIcon[i]:ClearAllPoints()
			if l == 1 and k == 1 then
				buffIcon[i]:SetPoint("BOTTOMLEFT", frame.fPBiconsFrame, "BOTTOMLEFT", 0, 0)
			elseif k == 1 then
				buffIcon[i]:SetPoint("BOTTOMLEFT", buffIcon[i-db.buffPerLine], "TOPLEFT", 0, db.yInterval)
			else
				buffIcon[i]:SetPoint("BOTTOMLEFT", buffIcon[i-1], "BOTTOMRIGHT", db.xInterval, 0)
			end

			lineWidth = lineWidth + buffIcon[i].width + db.xInterval
			lineHeight = (buffIcon[i].height > lineHeight) and buffIcon[i].height or lineHeight
		end
		maxWidth = max(maxWidth, lineWidth)
		sumHeight = sumHeight + lineHeight + db.yInterval
	end
	if #PlatesBuffs[frame] > db.numLines * db.buffPerLine then
		for i = db.numLines * db.buffPerLine + 1, #PlatesBuffs[frame] do
			buffIcon[i]:Hide()
		end
	end
	frame.fPBiconsFrame:SetWidth(maxWidth-db.xInterval)
	frame.fPBiconsFrame:SetHeight(sumHeight - db.yInterval)
	frame.fPBiconsFrame:ClearAllPoints()
	frame.fPBiconsFrame:SetPoint(db.buffAnchorPoint,frame,db.plateAnchorPoint,db.xOffset,db.yOffset)
	if MSQ then
		Group:ReSkin()
	end
end

local function AddBuff(frame, type, icon, stack, debufftype, duration, expiration, my, scale, durationSize, stackSize)
	if not PlatesBuffs[frame] then PlatesBuffs[frame] = {} end
	PlatesBuffs[frame][#PlatesBuffs[frame] + 1] = {
		type = type,
		icon = icon,
		stack = stack,
		debufftype = debufftype,
		duration = duration,
		expiration = expiration,
		scale = (my and db.myScale + 1 or 1) * (scale or 1),
		durationSize = durationSize,
		stackSize = stackSize,
	}
end

local function FilterBuffs(isAlly, frame, type, name, icon, stack, debufftype, duration, expiration, caster, spellID)
	if type == "HARMFUL" and db.showDebuffs == 5 then return end
	if type == "HELPFUL" and db.showBuffs == 5 then return end

	local Spells = db.Spells
	local listedSpell
	local my = caster == "player"
	local cachedID = cachedSpells[name]

	if Spells[spellID] and not db.ignoredDefaultSpells[spellID] then
		listedSpell = Spells[spellID]
	elseif cachedID then
		if cachedID == "noid" then
			listedSpell = Spells[name]
		else
			listedSpell = Spells[cachedID]
		end
	end

	-- showDebuffs  1 = all, 2 = mine + spellList, 3 = only spellList, 4 = only mine, 5 = none
	-- listedSpell.show  -- 1 = always, 2 = mine, 3 = never, 4 = on ally, 5 = on enemy
	if not listedSpell then
		if db.hidePermanent and duration == 0 then
			return
		end
		if (type == "HARMFUL" and (db.showDebuffs == 1 or ((db.showDebuffs == 2 or db.showDebuffs == 4) and my)))
		or (type == "HELPFUL"   and (db.showBuffs   == 1 or ((db.showBuffs   == 2 or db.showBuffs   == 4) and my))) then
			AddBuff(frame, type, icon, stack, debufftype, duration, expiration, my)
			return
		else
			return
		end
	else --listedSpell
		if (type == "HARMFUL" and (db.showDebuffs == 4 and not my))
		or (type == "HELPFUL" and (db.showBuffs == 4 and not my)) then
			return
		end
		if(listedSpell.show == 1)
		or(listedSpell.show == 2 and my)
		or(listedSpell.show == 4 and isAlly)
		or(listedSpell.show == 5 and not isAlly) then
			AddBuff(frame, type, icon, stack, debufftype, duration, expiration, my, listedSpell.scale, listedSpell.durationSize, listedSpell.stackSize)
			return
		end
	end
end

local function ScanUnitBuffs(nameplateID, frame)
	if PlatesBuffs[frame] then
		wipe(PlatesBuffs[frame])
	end
	local isAlly = UnitIsFriend(nameplateID,"player")
	local i = 1
	while UnitDebuff(nameplateID, i) do
		local name, _, icon, stack, debufftype, duration, expiration, caster, _, _, spellID = UnitDebuff(nameplateID, i)
		FilterBuffs(isAlly, frame, "HARMFUL", name, icon, stack, debufftype, duration, expiration, caster, spellID)
		i = i + 1
	end
	i = 1
	while UnitBuff(nameplateID, i) do
		local name, _, icon, stack, debufftype, duration, expiration, caster, _, _, spellID = UnitBuff(nameplateID, i)
		FilterBuffs(isAlly, frame, "HELPFUL", name, icon, stack, debufftype, duration, expiration, caster, spellID)
		i = i + 1
	end
end

local function FilterUnits(nameplateID)

	if db.showOnlyInCombat and not UnitAffectingCombat("player") then return true end -- InCombatLockdown()
	if db.showUnitInCombat and not UnitAffectingCombat(nameplateID) then return true end

	-- filter units
	if UnitIsUnit(nameplateID,"player") then return true end
	if UnitIsPlayer(nameplateID) and not db.showOnPlayers then return true end
	if UnitPlayerControlled(nameplateID) and not UnitIsPlayer(nameplateID) and not db.showOnPets then return true end
	if not UnitPlayerControlled(nameplateID) and not UnitIsPlayer(nameplateID) and not db.showOnNPC then return true end
	if UnitIsEnemy(nameplateID,"player") and not db.showOnEnemy then return true end
	if UnitIsFriend(nameplateID,"player") and not db.showOnFriend then return true end
	if not UnitIsFriend(nameplateID,"player") and not UnitIsEnemy(nameplateID,"player") and not db.showOnNeutral then return true end

	return false
end

local function iconOnUpdate(self, elapsed)
	if self.expiration and self.expiration > 0 then
		local timeLeft = self.expiration - GetTime()
		------------------- Vertical Swipe, by Khal -------------------
		if db.showStdSwipe then
			self.cooldown:SetHeight(max(0.00001, (1 - timeLeft / self.duration) * self.height))
			self.cooldown:Show()
		end
		--------- Hides interrupt icon on expiration, by Khal ---------
		if timeLeft < 0 then
			if self.debufftype == "Interrupt" and self.nameplate then
				local plate = self.nameplate.RealPlate or self.nameplate
				local unit = plate.namePlateUnitToken
				if unit then fPB.UpdateUnitAuras(unit) end
			end
			return
		end
		---------------------------------------------------------------
		if db.showDuration then
			self.durationtext:SetFormattedText(FormatTime(timeLeft))
			if db.colorTransition then
				self.durationtext:SetTextColor(GetColorByTime(timeLeft,self.duration))
			end
			if db.durationPosition == 1 or db.durationPosition == 3 then
				self.durationBg:SetWidth(self.durationtext:GetStringWidth())
				self.durationBg:SetHeight(self.durationtext:GetStringHeight())
			end
		end
		-------------- Blink + Fade Animation by Khal ---------------
		if self.duration > db.blinkFadeMinDuration then
			local bth, fth = 1, 1
			local blinkAllowed = not db.blinkTargetOnly
			local fadeAllowed = not db.fadeTargetOnly
			if db.blinkTargetOnly or db.fadeTargetOnly then
				local plate = self.nameplate.RealPlate or self.nameplate
				local unit = plate.namePlateUnitToken
				if unit then
					if db.blinkTargetOnly then
						blinkAllowed = UnitIsUnit(unit, "target")
					end
					if db.fadeTargetOnly then
						fadeAllowed = UnitIsUnit(unit, "target")
					end
				end
			end
			if blinkAllowed and timeLeft < (db.blinkThreshold + 1/3) then
				bth = timeLeft % 1 
				if bth > 0.5 then
					bth = 1 - bth
				end
				bth = math_min(math_max(bth * 3, 0), 1)
			end
			if fadeAllowed and timeLeft < db.fadeThreshold then
				fth = (timeLeft / db.fadeThreshold) * 0.7 + 0.3
			end
			self:SetAlpha(bth * fth)
		end
		-------------------------------------------------------------
	end
end

local function GetTexCoordFromSize(frame,size,size2)
	local arg = size/size2
	local abj
	if arg > 1 then
		abj = 1/size*((size-size2)/2)

		frame:SetTexCoord(0 ,1,(0+abj),(1-abj))
	elseif arg < 1 then
		abj = 1/size2*((size2-size)/2)

		frame:SetTexCoord((0+abj),(1-abj),0,1)
	else
		frame:SetTexCoord(0, 1, 0, 1)
	end
end

local function UpdateBuffIcon(self)
	self:SetAlpha(1)
	self.stacktext:Hide()
	self.border:Hide()
	self.cooldown:Hide()
	self.durationtext:Hide()
	self.durationBg:Hide()
	self.stackBg:Hide()

	self:SetWidth(self.width)
	self:SetHeight(self.height)

	self.texture:SetTexture(self.icon)
	if db.cropTexture then
		GetTexCoordFromSize(self.texture,self.width,self.height)
	else
		self.texture:SetTexCoord(0, 1, 0, 1)
	end

	if db.borderStyle ~= 3 then
		local color
		if self.type == "HELPFUL" then
			color = db.colorTypes.Buff
		else
			if db.colorizeBorder then
				color = self.debufftype and db.colorTypes[self.debufftype] or db.colorTypes.none
			else
				color = db.colorTypes.none
			end
		end
		self.border:SetVertexColor(color[1], color[2], color[3])
		self.border:Show()
	end
	------------------------ Old Radial Swipe, bugs when anchored to nameplates ---------------------
	--[[ if (db.showStdCooldown or db.showStdSwipe) and self.expiration > 0 then
 		local start = self.expiration - self.duration
		local duration = self.duration
		self.cooldown:SetCooldown(self.expiration - self.duration, self.duration)
		self.cooldown:Show()
	end ]]
	-------------------------------------------------------------------------------------------------
	local nameplate = self:GetParent():GetParent().RealPlate
	local distanceCheck = true
	if C_NamePlate_GetDistanceForNamePlate and nameplate then -- by Khal
		local distance = C_NamePlate_GetDistanceForNamePlate(nameplate)
		distanceCheck = distance and distance < textVisibilityDistance
	end
	if db.showDuration and self.expiration > 0 then
		if db.durationPosition == 1 or db.durationPosition == 3 then
			self.durationtext:SetFont(fPB.font, (self.durationSize or db.durationSize), "OUTLINE")
			self.durationBg:Show()
		else
			self.durationtext:SetFont(fPB.font, (self.durationSize or db.durationSize), "OUTLINE")
		end
		if distanceCheck then -- by Khal
			self.durationtext:Show()
		end
	end
	if self.stack and self.stack > 1 then
		self.stacktext:SetText(tostring(self.stack))
		if db.stackPosition == 2 or db.stackPosition == 3 then
			self.stacktext:SetFont(fPB.stackFont, (self.stackSize or db.stackSize), "OUTLINE")
			self.stackBg:SetWidth(self.stacktext:GetStringWidth())
			self.stackBg:SetHeight(self.stacktext:GetStringHeight())
			self.stackBg:Show()
		else
			self.stacktext:SetFont(fPB.stackFont, (self.stackSize or db.stackSize), "OUTLINE")
		end
		if distanceCheck then -- by Khal
			self.stacktext:Show()
		end
	end
end

-------------- Distance check to control icon text visibility, by Khal -------------
if C_NamePlate_GetDistanceForNamePlate then
	local elapsedTotal = 0
	CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		elapsedTotal = elapsedTotal + elapsed
		if elapsedTotal >= 1 then
			elapsedTotal = 0
			local nameplates = C_NamePlate_GetNamePlates()
			for i = 1, #nameplates do
				local nameplate = nameplates[i]
				local frame = nameplate.VirtualPlate or nameplate
				if PlatesBuffs[frame] and #PlatesBuffs[frame] > 0 then
					if frame.fPBiconsFrame and frame.fPBiconsFrame.iconsFrame then
						local distanceCheck = C_NamePlate_GetDistanceForNamePlate(nameplate) < textVisibilityDistance
						for _, buffIcon in ipairs(frame.fPBiconsFrame.iconsFrame) do
							if buffIcon:IsShown() then
								if db.showDuration and buffIcon.expiration > 0 then
									if distanceCheck then
										buffIcon.durationtext:Show()
									else
										buffIcon.durationtext:Hide()
									end
								else
									buffIcon.durationtext:Hide()
								end
								if buffIcon.stack and buffIcon.stack > 1 then
									if distanceCheck then
										buffIcon.stacktext:Show()
									else
										buffIcon.stacktext:Hide()
									end
								else
									buffIcon.stacktext:Hide()
								end			
							end
						end
					end
				end
			end
		end
	end)
end
----------------------------------------------------------------------------------

local function UpdateBuffIconOptions(self)
	self.texture:SetAllPoints(self)

	self.border:SetAllPoints(self)
	if db.borderStyle == 1 then
		self.border:SetTexture("Interface\\Addons\\flyPlateBuffs\\texture\\border.tga")
		self.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92) -- CHECK THIS KHAL
		--self.border:SetTexCoord(0,0,0,1,1,0,1,1)
	elseif db.borderStyle == 2 then
		self.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		self.border:SetTexCoord(0.296875,0.5703125,0,0.515625)		-- if "Interface\\Buttons\\UI-Debuff-Overlays"
	end

	-------------- Old Radial Swipe, bugs when anchored to nameplates ------------
  	--[[ if db.showStdSwipe then
		self.cooldown:SetDrawEdge(true)
		self.cooldown:SetEdgeColor(0, 0, 0, 0.6)
	else
		self.cooldown:SetDrawEdge(false)
	end
	if db.showStdCooldown then
		self.cooldown:SetHideCountdownNumbers(false)
	else
		self.cooldown:SetHideCountdownNumbers(true)
	end ]]
	-----------------------------------------------------------------------------

	if db.showDuration then
		self.durationtext:ClearAllPoints()
		self.durationBg:ClearAllPoints()
		if db.durationPosition == 1 then
			-- under icon
			self.durationtext:SetFont(fPB.font, (self.durationSize or db.durationSize), "OUTLINE")
			self.durationtext:SetPoint("TOP", self, "BOTTOM", 0, 0)
			self.durationBg:SetPoint("CENTER", self.durationtext)
		elseif db.durationPosition == 3 then
			-- above icon
			self.durationtext:SetFont(fPB.font, (self.durationSize or db.durationSize), "OUTLINE")
			self.durationtext:SetPoint("BOTTOM", self, "TOP", 0, 1)
			self.durationBg:SetPoint("CENTER", self.durationtext)
		else
			-- on icon
			self.durationtext:SetFont(fPB.font, (self.durationSize or db.durationSize), "OUTLINE")
			self.durationtext:SetPoint("CENTER", self, "CENTER", 0, 0)
		end
		if not colorTransition then
			self.durationtext:SetTextColor(db.colorSingle[1],db.colorSingle[2],db.colorSingle[3],1)
		end
	end

	self.stacktext:ClearAllPoints()
	self.stackBg:ClearAllPoints()
	self.stacktext:SetTextColor(db.stackColor[1],db.stackColor[2],db.stackColor[3],1)
	if db.stackPosition == 1 then
		-- on icon
		self.stacktext:SetFont(fPB.stackFont, (self.stackSize or db.stackSize), "OUTLINE")
		self.stacktext:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, 1)
	elseif db.stackPosition == 2 then
		-- under icon
		self.stacktext:SetFont(fPB.stackFont, (self.stackSize or db.stackSize), "OUTLINE")
		self.stacktext:SetPoint("TOP", self, "BOTTOM", 0, -1)
		self.stackBg:SetPoint("CENTER", self.stacktext)
	else
		-- above icon
		self.stacktext:SetFont(fPB.stackFont, (self.stackSize or db.stackSize), "OUTLINE")
		self.stacktext:SetPoint("BOTTOM", self, "TOP", 0, 1)
		self.stackBg:SetPoint("CENTER", self.stacktext)
	end

	self:EnableMouse(false)

end

local function iconOnHide(self)
	self.stacktext:Hide()
	self.border:Hide()
	self.cooldown:Hide()
	self.durationtext:Hide()
	self.durationBg:Hide()
	self.stackBg:Hide()
end

local function CreateBuffIcon(frame,i)
	frame.fPBiconsFrame.iconsFrame[i] = CreateFrame("Button")
	frame.fPBiconsFrame.iconsFrame[i]:SetParent(frame.fPBiconsFrame)
	local buffIcon = frame.fPBiconsFrame.iconsFrame[i]

	buffIcon.nameplate = frame

	buffIcon.texture = buffIcon:CreateTexture(nil, "BACKGROUND")

	buffIcon.border = buffIcon:CreateTexture(nil,"BORDER")

	------- Radial Swipe Texture, bugs when anchored to nameplate --------
	--buffIcon.cooldown = CreateFrame("Cooldown", nil, buffIcon, "CooldownFrameTemplate")
	--buffIcon.cooldown:SetReverse(true)
	--buffIcon.cooldown:SetDrawEdge(false)

	--------------- Vertical Swipe Texture, by Khal ----------------
 	buffIcon.cooldown = buffIcon:CreateTexture(nil, "BORDER")
	buffIcon.cooldown:SetPoint("TOPLEFT")
	buffIcon.cooldown:SetPoint("TOPRIGHT")
	buffIcon.cooldown:SetHeight(0.00001)
	buffIcon.cooldown:SetTexture([[Interface\Buttons\WHITE8X8]])
	buffIcon.cooldown:SetVertexColor(0, 0, 0, 0.65)
	----------------------------------------------------------------

	buffIcon.durationtext = buffIcon:CreateFontString(nil, "ARTWORK")
	--buffIcon.durationtext:SetPoint("CENTER", buffIcon, "CENTER")

	buffIcon.durationBg = buffIcon:CreateTexture(nil,"BORDER")
	buffIcon.durationBg:SetVertexColor(0,0,0,0)

	buffIcon.stacktext = buffIcon:CreateFontString(nil, "ARTWORK")

	buffIcon.stackBg = buffIcon:CreateTexture(nil,"BORDER")
	buffIcon.stackBg:SetVertexColor(0,0,0,0)

	UpdateBuffIconOptions(buffIcon)

	buffIcon.stacktext:Hide()
	buffIcon.border:Hide()
	buffIcon.cooldown:Hide()
	buffIcon.durationtext:Hide()
	buffIcon.durationBg:Hide()
	buffIcon.stackBg:Hide()

	buffIcon:SetScript("OnHide", iconOnHide)
	buffIcon:SetScript("OnUpdate", iconOnUpdate)

	if MSQ then
		Group:AddButton(buffIcon,{
			Icon = buffIcon.texture,
			--Cooldown = buffIcon.cooldown,
			Cooldown = false, -- by Khal
			Normal = buffIcon.border,
			Count = false,
			Duration = false,
			FloatingBG = false,
			Flash = false,
			Pushed = false,
			Disabled = false,
			Checked = false,
			Border = false,
			AutoCastable = false,
			Highlight = false,
			HotKey = false,
			Name = false,
			AutoCast = false,
		})
	end
end

----------------------- Interrupts Support, by Khal -----------------------
-- Interrupts with 30% duration reduction (assuming worst-case scenario)
local InterruptsInfo = {
    [6552]  = { duration = 4 * 0.7, icon = "Interface\\Icons\\INV_Gauntlets_04" },             -- Warrior: Pummel
    [72]    = { duration = 6 * 0.7, icon = "Interface\\Icons\\Ability_Warrior_ShieldBash" },   -- Warrior: Shield Bash
    [1766]  = { duration = 5 * 0.7, icon = "Interface\\Icons\\Ability_Kick" },                 -- Rogue: Kick
    [47528] = { duration = 4 * 0.7, icon = "Interface\\Icons\\Spell_DeathKnight_MindFreeze" }, -- DK: Mind Freeze
    [57994] = { duration = 2 * 0.7, icon = "Interface\\Icons\\Spell_Nature_Cyclone" },         -- Shaman: Wind Shear
    [19647] = { duration = 6 * 0.7, icon = "Interface\\Icons\\Spell_Shadow_MindRot" },         -- Warlock: Spell Lock (Felhunter)
    [2139]  = { duration = 8 * 0.7, icon = "Interface\\Icons\\Spell_Frost_IceShock" },         -- Mage: Counterspell
    [16979] = { duration = 4 * 0.7, icon = "Interface\\Icons\\Ability_Hunter_Pet_Bear" },      -- Druid: Feral Charge (Bear)
}

local InterruptsActive = {}

local function AddInterrupt(GUID, spellID)
	local data = InterruptsInfo[spellID]
	if not data then return end
	local duration = data.duration
	local expiration = GetTime() + duration
	if not InterruptsActive[GUID] then InterruptsActive[GUID] = {} end
	table_insert(InterruptsActive[GUID], {
		type = "HARMFUL",
		icon = data.icon,
		debufftype = "Interrupt",
		duration = duration,
		expiration = expiration,
		scale = db.interruptsScale,
		durationSize = db.interruptsDurationSize,
	})
end

local function ScanInterrupts(nameplateID, frame)
	local GUID = UnitGUID(nameplateID)
	if not GUID then return end
	local interrupts = InterruptsActive[GUID]
	if not interrupts then return end
	if not PlatesBuffs[frame] then PlatesBuffs[frame] = {} end
	for i = #interrupts, 1, -1 do
		local interrupt = interrupts[i]
		if interrupt.expiration and interrupt.expiration > GetTime() then
			PlatesBuffs[frame][#PlatesBuffs[frame] + 1] = interrupt
		else
			table_remove(interrupts, i)
		end
	end
	if #interrupts == 0 then
		InterruptsActive[GUID] = nil
	end
end
---------------------------------------------------------------

function fPB.UpdateUnitAuras(nameplateID,updateOptions)
	local nameplate = C_NamePlate_GetNamePlateForUnit(nameplateID)
	local frame = nameplate.VirtualPlate or nameplate -- by Khal

	if not frame then return end

	if FilterUnits(nameplateID) then
		if frame.fPBiconsFrame then
			frame.fPBiconsFrame:Hide()
		end
		return
	end

	ScanUnitBuffs(nameplateID, frame)
	ScanInterrupts(nameplateID, frame) -- by Khal
	if not PlatesBuffs[frame] then
		if frame.fPBiconsFrame then
			frame.fPBiconsFrame:Hide()
		end
		return
	end
	if not db.disableSort then
		table_sort(PlatesBuffs[frame],SortFunc)
	end

	if not frame.fPBiconsFrame then
		-- if parent == frame then it will change scale and alpha with nameplates
		-- otherwise use UIParent, but this causes mess of icon/border textures
		frame.fPBiconsFrame = CreateFrame("Frame")

		local parent = db.parentWorldFrame and WorldFrame
		if not parent then
			parent = frame
		end
		frame.fPBiconsFrame:SetParent(parent)
	end

	if not frame.fPBiconsFrame.iconsFrame then
		frame.fPBiconsFrame.iconsFrame = {}
	end

	for i = 1, #PlatesBuffs[frame] do
		if not frame.fPBiconsFrame.iconsFrame[i] then
			CreateBuffIcon(frame,i)
		end

		local buff = PlatesBuffs[frame][i]
		local buffIcon = frame.fPBiconsFrame.iconsFrame[i]
		buffIcon.type = buff.type
		buffIcon.icon = buff.icon
		buffIcon.stack = buff.stack
		buffIcon.debufftype = buff.debufftype
		buffIcon.duration = buff.duration
		buffIcon.expiration = buff.expiration
		buffIcon.durationSize = buff.durationSize
		buffIcon.stackSize = buff.stackSize
		buffIcon.width = db.baseWidth * buff.scale
		buffIcon.height = db.baseHeight * buff.scale
		if updateOptions then
			UpdateBuffIconOptions(buffIcon)
		end
		UpdateBuffIcon(buffIcon)
		buffIcon:Show()
	end
	frame.fPBiconsFrame:Show()

	if #frame.fPBiconsFrame.iconsFrame > #PlatesBuffs[frame] then
		for i = #PlatesBuffs[frame]+1, #frame.fPBiconsFrame.iconsFrame do
			if frame.fPBiconsFrame.iconsFrame[i] then
				frame.fPBiconsFrame.iconsFrame[i]:Hide()
			end
		end
	end

	DrawOnPlate(frame)
end
local UpdateUnitAuras = fPB.UpdateUnitAuras

function fPB.UpdateAllNameplates(updateOptions)
	for i, p in ipairs(C_NamePlate_GetNamePlates()) do
		local unit = p.namePlateUnitToken
		if unit then
			UpdateUnitAuras(unit,updateOptions)
		end
	end
end
local UpdateAllNameplates = fPB.UpdateAllNameplates

local function Nameplate_Added(...)
	local nameplateID = ...
	local nameplate = C_NamePlate_GetNamePlateForUnit(nameplateID)

	local function BaseLogic() --------- by Khal
		local frame = nameplate.VirtualPlate or nameplate
		if frame and not frame.namePlateUnitToken then frame.namePlateUnitToken = nameplateID end
		if frame and frame.BuffFrame then
			if db.notHideOnPersonalResource and UnitIsUnit(nameplateID,"player") then
				frame.BuffFrame:SetAlpha(1)
			else
				frame.BuffFrame:SetAlpha(0)	--Hide terrible standart debuff frame
			end
		end
		UpdateUnitAuras(nameplateID)
	end

	------- Delay first Nameplate_Added by 1 frame to ensure VirtualPlate is created, by Khal -------
	if not nameplate.VirtualPlate then 
		nameplate.fPBdelayFrame = nameplate.fPBdelayFrame or CreateFrame("Frame", nil, nameplate) 
        nameplate.fPBdelayFrame:SetScript("OnUpdate", function(self) 
            self:SetScript("OnUpdate", nil)
            BaseLogic()
        end)
	else
		BaseLogic()
	end
end

local function Nameplate_Removed(...)
	local nameplateID = ...
	local nameplate = C_NamePlate_GetNamePlateForUnit(nameplateID)

	local frame = nameplate.VirtualPlate or nameplate --------- by Khal
	if not frame then return end

	if frame.fPBiconsFrame then
		frame.fPBiconsFrame:Hide()	
	end
	if PlatesBuffs[frame] then
		PlatesBuffs[frame] = nil
	end
end

local function FixSpells()
	for spell,s in pairs(db.Spells) do
		if not s.name then
			local name
			local spellID = tonumber(spell) and tonumber(spell) or spell.spellID
			if spellID then
				name = GetSpellInfo(spellID)
			else
				name = tostring(spell)
			end
			db.Spells[spell].name = name
		end
	end
end

function fPB.CacheSpells() -- spells filtered by names, not checking ID
	cachedSpells = {}
	for spell,s in pairs(db.Spells) do
		if not s.checkID and not db.ignoredDefaultSpells[spell] and s.name then
			if s.spellID then
				cachedSpells[s.name] = s.spellID
			else
				cachedSpells[s.name] = "noid"
			end
		end
	end
end
local CacheSpells = fPB.CacheSpells

function fPB.AddNewSpell(spell)
	local defaultSpell
	if db.ignoredDefaultSpells[spell] then
		db.ignoredDefaultSpells[spell] = nil
		defaultSpell = true
	end
	local spellID = tonumber(spell)
	if db.Spells[spell] and not defaultSpell then
		if spellID then
			DEFAULT_CHAT_FRAME:AddMessage(chatColor..L["Spell with this ID is already in the list. Its name is "]..linkColor.."|Hspell:"..spellID.."|h["..GetSpellInfo(spellID).."]|h|r")
			return
		else
			DEFAULT_CHAT_FRAME:AddMessage(spell..chatColor..L[" already in the list."].."|r")
			return
		end
	end
	local name = GetSpellInfo(spellID)
	if spellID and name then
		if not db.Spells[spellID] then
			db.Spells[spellID] = {
				show = 1,
				name = name,
				spellID = spellID,
				scale = 1,
				stackSize = db.stackSize,
				durationSize = db.durationSize,
			}
		end
	else
		db.Spells[spell] = {
			show = 1,
			name = spell,
			scale = 1,
			stackSize = db.stackSize,
			durationSize = db.durationSize,
		}
	end

	CacheSpells()
	fPB.BuildSpellList()
	UpdateAllNameplates(true)
end
function fPB.RemoveSpell(spell)
	if DefaultSettings.profile.Spells[spell] then
		db.ignoredDefaultSpells[spell] = true
	end
	db.Spells[spell] = nil
	CacheSpells()
	fPB.BuildSpellList()
	UpdateAllNameplates(true)
end
function fPB.ChangeSpellID(oldID, newID)
	if db.Spells[newID] then
		DEFAULT_CHAT_FRAME:AddMessage(chatColor..L["Spell with this ID is already in the list. Its name is "]..linkColor.."|Hspell:"..newID.."|h["..GetSpellInfo(newID).."]|h|r")
		return
	end
	db.Spells[newID] = {}
	for k,v in pairs(db.Spells[oldID]) do
		db.Spells[newID][k] = v
		db.Spells[newID].spellID = newID
	end
	fPB.RemoveSpell(oldID)
	DEFAULT_CHAT_FRAME:AddMessage(GetSpellInfo(newID)..chatColor..L[" ID changed "].."|r"..(tonumber(oldID) or "nil")..chatColor.." -> |r"..newID)
	UpdateAllNameplates(true)
	fPB.BuildSpellList()
end

function fPB.OnProfileChanged()
	db = fPB.db.profile
	fPB.OptionsOnEnable()
	UpdateAllNameplates(true)
end

local function Initialize()
	fPB.db = LibStub("AceDB-3.0"):New("flyPlateBuffsDB", DefaultSettings, true)
	fPB.db.RegisterCallback(fPB, "OnProfileChanged", "OnProfileChanged")
	fPB.db.RegisterCallback(fPB, "OnProfileCopied", "OnProfileChanged")
	fPB.db.RegisterCallback(fPB, "OnProfileReset", "OnProfileChanged")

	db = fPB.db.profile

	fPB.font = fPB.LSM:Fetch("font", db.font)
	fPB.stackFont = fPB.LSM:Fetch("font", db.stackFont)
	FixSpells()
	CacheSpells()

	config:RegisterOptionsTable(AddonName, fPB.MainOptionTable)
	fPBMainOptions = dialog:AddToBlizOptions(AddonName, AddonName)

	config:RegisterOptionsTable(AddonName.." Spells", fPB.SpellsTable)
	fPBSpellsList = dialog:AddToBlizOptions(AddonName.." Spells", L["Specific spells"], AddonName)

	config:RegisterOptionsTable(AddonName.." Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(fPB.db))
	fPBProfilesOptions = dialog:AddToBlizOptions(AddonName.." Profiles", L["Profiles"], AddonName)

	SLASH_FLYPLATEBUFFS1, SLASH_FLYPLATEBUFFS2 = "/fpb", "/pb"
	function SlashCmdList.FLYPLATEBUFFS(msg, editBox)
		InterfaceOptionsFrame_OpenToCategory(fPBMainOptions)
		InterfaceOptionsFrame_OpenToCategory(fPBSpellsList)
		InterfaceOptionsFrame_OpenToCategory(fPBMainOptions)
	end

	DEFAULT_CHAT_FRAME:AddMessage(" |cFFFFA500" .. tostring(AddonName) .. "|r modified v1.1 by |cffc41f3bKhal|r")
end

function fPB.RegisterCombat()
	fPB.Events:RegisterEvent("PLAYER_REGEN_DISABLED")
	fPB.Events:RegisterEvent("PLAYER_REGEN_ENABLED")
end
function fPB.UnregisterCombat()
	fPB.Events:UnregisterEvent("PLAYER_REGEN_DISABLED")
	fPB.Events:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

fPB.Events = CreateFrame("Frame")
fPB.Events:RegisterEvent("ADDON_LOADED")
fPB.Events:RegisterEvent("PLAYER_LOGIN")

------------------------ Optimized CLEU Registration, by Khal ------------------------
-- Registers a lightweight Event to detect interrupts early and manage CLEU afterward
local function RegisterInterruptsEvent()
	local FallbackEventRealms = {
		["Icecrown"] = true,
		["Blackrock [PvP only]"] = true,
		["Lordaeron"] = true,
	}
	-- Event choice depends on the server to ensure it fires before CLEU
	if FallbackEventRealms[GetRealmName()] then
		fPB.Events:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	else
		fPB.Events:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")		
	end
end

-- Interrupt Spell Names for UNIT_SPELLCAST_SUCCEEDED
local InterruptNames = {}
for spellID in pairs(InterruptsInfo) do
    local spellName = GetSpellInfo(spellID)
    if spellName then
        InterruptNames[spellName] = true
    end
end

-- Non-interruptible physical spells that trigger UNIT_SPELLCAST_INTERRUPTED
local InterruptBlacklistID = {
    75,     -- Auto Shot
    845,    -- Cleave
	53385,	-- Divine Storm
    78,     -- Heroic Strike
    6807,   -- Maul
	2643,	-- Multi-Shot
	21651,	-- Opening
    2973,   -- Raptor Strike
    56815,  -- Rune Strike
    50581,  -- Shadow Cleave
	64382,	-- Shattering Throw
	3018,	-- Shoot
	1464,	-- Slam
	56641,	-- Steady Shot
	2764,	-- Throw
	1510,	-- Volley
	20549,	-- War Stomp
}
local InterruptBlacklist = {}
for _, spellID in ipairs(InterruptBlacklistID) do
    local spellName = GetSpellInfo(spellID)
    if spellName then
        InterruptBlacklist[spellName] = true
    end
end

-- Registers CLEU for a short time after the lightweight Event fires
local CLEUTimeoutHandler = CreateFrame("Frame")
local CLEUTimeout = 0.2
local CLEUregistered = false
CLEUTimeoutHandler:Hide()
CLEUTimeoutHandler:SetScript("OnUpdate", function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= CLEUTimeout then
        if CLEUregistered then
            fPB.Events:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            CLEUregistered = false
        end
        self:Hide()
        self.elapsed = 0
    end
end)
local function RegisterTempCLEU()
	if not CLEUregistered then
		fPB.Events:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		CLEUregistered = true
	end
	CLEUTimeoutHandler.elapsed = 0
	CLEUTimeoutHandler:Show() 
end
--------------------------------------------------------------------------------------

fPB.Events:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" and (...) == AddonName then
		Initialize()
	elseif event == "PLAYER_LOGIN" then
		fPB.OptionsOnEnable()
		if db.showSpellID then fPB.ShowSpellID() end
		MSQ = LibStub("Masque", true)
		if MSQ then
			Group = MSQ:Group(AddonName)
			MSQ:Register(AddonName, function(addon, group, skinId, gloss, backdrop, colors, disabled)
				if disabled then
					UpdateAllNameplates(true)
				end
			end)
		end

		fPB.Events:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		fPB.Events:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

		if C_NamePlate_GetNamePlateForGUID then RegisterInterruptsEvent() end -- by Khal

		if db.showOnlyInCombat then
			fPB.RegisterCombat()
		else
			fPB.Events:RegisterEvent("UNIT_AURA")
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		fPB.Events:RegisterEvent("UNIT_AURA")
		UpdateAllNameplates()
	elseif event == "PLAYER_REGEN_ENABLED" then
		fPB.Events:UnregisterEvent("UNIT_AURA")
		UpdateAllNameplates()
	elseif event == "NAME_PLATE_UNIT_ADDED" then
		Nameplate_Added(...)
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		Nameplate_Removed(...)
	elseif event == "UNIT_AURA" then
		local unit = ...
		if unit and unit:sub(1, 9) == "nameplate" then
			UpdateUnitAuras(...)
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and db.showInterrupts then -- by Khal
		local _, spellName = ...
		if InterruptNames[spellName] then
			RegisterTempCLEU()
		end
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" and db.showInterrupts then -- by Khal
		local unit, spellName = ...
		if unit and unit:sub(1, 9) == "nameplate" and UnitIsPlayer(unit) and not InterruptBlacklist[spellName] then
			RegisterTempCLEU()
		end	
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then -- by Khal
		local _, subevent, _, _, _, destGUID, _, _, spellID = ...
		if subevent == "SPELL_INTERRUPT" then
			local nameplate = C_NamePlate_GetNamePlateForGUID(destGUID)
			local unit = nameplate and nameplate.namePlateUnitToken
			if unit and UnitIsPlayer(unit) then
				AddInterrupt(destGUID, spellID)
				UpdateUnitAuras(unit)
			end
		end
	end
end)