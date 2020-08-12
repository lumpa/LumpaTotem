-- local LumpaTotem = LibStub("AceAddon-3.0"):NewAddon("LumpaTotem")
local LumpaTotem = LibStub("AceAddon-3.0"):NewAddon("LumpaTotem", "AceTimer-3.0")
local addonName, addon = ...

local macroName = "LumpaTotem"
local sel_totems = {}
local combat = false

local rootFrame = nil;

local buttons = {}
-- local btnMissing = nil;

-- local totemIndex_rev = {
-- 	fire = 1,
-- 	earth = 2,
-- 	water = 3,
-- 	air = 4
-- }
-- local  = {"fire", "earth", "water", "air"}

local elements = {"fire", "earth", "water", "air"} -- do not change order
local element_colors = {
	fire  = {r=191/255, g=64/255, b=64/255},
	earth = {r=191/255, g=110/255, b=64/255},
	water = {r=64/255, g=87/255, b=191/255},
	air   = {r=149/255, g=64/255, b=191/255}
}

local dragging = nil
-- local dragStart_x = nil
-- local dragStart_y = nil
-- local dragRelative_x = nil
-- local dragRelative_y = nil

local buffs = {
	["Stoneskin"] = false,
	["Strength of Earth"] = false,

	["Frost Resistance"] = false,

	["Healing Stream"] = false,
	["Mana Spring"] = false,
	["Fire Resistance"] = false,

	["Grace of Air"] = false,
	["Grounding Totem Effect"] = false,
	["Nature Resistance"] = false,
	["Sentry Totem"] = false,
	["Windwall"] = false
}

local activeTotems = {
	earth = {
		-- name = "",
		-- timeleft = 0,
		btn = nil,
		-- f_timeLeft = nil
	},
	fire = {
		-- name = "",
		-- timeleft = 0,
		btn = nil,
		-- f_timeLeft = nil
	},
	water = {
		-- name = "",
		-- timeleft = 0,
		btn = nil,
		-- f_timeLeft = nil
	},
	air = {
		-- name = "",
		-- timeleft = 0,
		btn = nil,
		-- f_timeLeft = nil
	}
}
local revlookup = {
	earth = {
		["Earthbind Totem"] = 1,
		["Stoneskin Totem"] = 2,
		["Stoneclaw Totem"] = 3,
		["Strength of Earth Totem"] = 4,
		["Tremor Totem"] = 5,
		["Earth Elemental Totem"] = 6
	},
	fire = {
		["Searing Totem"] = 1,
		["Fire Elemental Totem"] = 2,
		["Fire Nova Totem"] = 3,
		["Flametongue Totem"] = 4,
		["Frost Resistance Totem"] = 5,
		["Magma Totem"] = 6,
		["Totem of Wrath"] = 7
	},
	water = {
		["Healing Stream Totem"] = 1,
		["Mana Spring Totem"] = 2,
		["Poison Cleansing Totem"] = 3,
		["Disease Cleansing Totem"] = 4,
		["Mana Tide Totem"] = 5,
		["Fire Resistance Totem"] = 6
	},
	air = {
		["Grace of Air Totem"] = 1,
		["Windfury Totem"] = 2,
		["Grounding Totem"] = 3,
		["Windwall Totem"] = 4,
		["Sentry Totem"] = 5,
		["Nature Resistance Totem"] = 6,
		["Tranquil Air Totem"] = 7,
		["Wrath of Air Totem"] = 8
	}
}
local tbl = {
	earth = {
		{
			name = "Earthbind Totem",
			short = "earthbind",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_earthbind.tga"
		},
		{
			name = "Stoneskin Totem",
			short = "stoneskin",
			buff = "Stoneskin",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_stoneskin.tga"
		},
		{
			name = "Stoneclaw Totem",
			short = "stoneclaw",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_stoneclaw.tga"
		},
		{
			name = "Strength of Earth Totem",
			short = "strength",
			buff = "Strength of Earth",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_strengthofearth.tga"
		},
		{
			name = "Tremor Totem",
			short = "tremor",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_tremor.tga"
		},
		{
			name = "Earth Elemental Totem",
			short = "earth el",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_earthelemental.tga"
		}
	},
	fire = {
		{
			name = "Searing Totem",
			short = "searing",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_searing.tga"
		},
		{
			name = "Fire Elemental Totem",
			short = "fire el",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_fireelemental.tga"
		},
		{
			name = "Fire Nova Totem",
			short = "nova",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_firenova.tga"
		},
		{
			name = "Flametongue Totem",
			short = "flame",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_flametongue.tga"
		},
		{
			name = "Frost Resistance Totem",
			short = "frost res",
			buff = "Frost Resistance",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_frostres.tga"
		},
		{
			name = "Magma Totem",
			short = "magma",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_magma.tga"
		},
		{
			name = "Totem of Wrath",
			short = "ToW",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_totemofwrath.tga"
		}
	},
	water = {
		{
			name = "Healing Stream Totem",
			short = "healing",
			buff = "Healing Stream",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_healingstream.tga"
		},
		{
			name = "Mana Spring Totem",
			short = "spring",
			buff = "Mana Spring",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_manaspring.tga"
		},
		{
			name = "Poison Cleansing Totem",
			short = "poison",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\water_poison.tga"
		},
		{
			name = "Disease Cleansing Totem",
			short = "disease",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\water_disease.tga"
		},
		{
			name = "Mana Tide Totem",
			short = "tide",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\water_manatide.tga"
		},
		{
			name = "Fire Resistance Totem",
			short = "fire res",
			buff = "Fire Resistance",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_fireres.tga"
		}
	},
	air = {
		{
			name = "Grace of Air Totem",
			short = "grace",
			buff = "Grace of Air",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_grace.tga"
		},
		{
			name = "Windfury Totem",
			short = "wf",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\air_windfury.tga"
		},
		{
			name = "Grounding Totem",
			short = "grounding",
			buff = "Grounding Totem Effect",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_grounding.tga"
		},
		{
			name = "Windwall Totem",
			short = "windwall",
			buff = "Windwall",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_windwall.tga"
		},
		{
			name = "Sentry Totem",
			short = "sentry",
			buff = "Sentry Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_sentry.tga"
		},
		{
			name = "Nature Resistance Totem",
			short = "nat res",
			buff = "Nature Resistance",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_natureres.tga"
		},
		{
			name = "Tranquil Air Totem",
			short = "tranquil",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\air_tranquil.tga"
		},
		{
			name = "Wrath of Air Totem",
			short = "WoA",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\air_wrathofair.tga"
		}
	}
}
-- local earth_index = 0

SLASH_LUMPATOTEM1 = "/lumpatotem"
SlashCmdList["LUMPATOTEM"] = function(msg)
	argv = {}
	for arg in string.gmatch(string.lower(msg), '[%a%d%-%.%/]+') do
		table.insert(argv, arg);
	end

	if argv[1] == "x" then
		if table.getn(argv) >= 2 then
			Storage["x"] = tonumber(argv[2]);
			MoveRootFrame();
		end
		print("LumpaTotem rootFrame x:", Storage["x"])

	elseif argv[1] == "y" then
		if table.getn(argv) >= 2 then
			Storage["y"] = tonumber(argv[2]);
			MoveRootFrame();
		end
		print("LumpaTotem rootFrame y:", Storage["y"])

	elseif argv[1] == "reset" then
		if table.getn(argv) >= 2 then
			Storage["reset"] = argv[2];
			SetMacro(macroName)
		end
		print("LumpaTotem reset (for castsequence):", Storage["reset"]);

	elseif argv[1] == "endwithnil" then
		if table.getn(argv) >= 2 then
			Storage["endwithnil"] = tonumber(argv[2])
			SetMacro(macroName)
		end
		print("LumpaTotem castsequence ending with nil:", Storage["endwithnil"]);

	elseif argv[1] == "anchor" then
		if table.getn(argv) >= 2 then
			Storage["anchor"] = argv[2]
			MoveRootFrame()
		end
		print("LumpaTotem anchor:", Storage["anchor"]);

	elseif argv[1] == "startattack" then
		if table.getn(argv) >= 2 then
			Storage["startattack"] = tonumber(argv[2])
			SetMacro(macroName)
		end
		print("LumpaTotem startattack:", Storage["startattack"]);

	else
		print("/lumpatotem x")
		print("/lumpatotem y")
		print("/lumpatotem reset")
		print("/lumpatotem endwithnil TRUE|FALSE")
		print("/lumpatotem anchor CENTER|BOTTOMLEFT|TOPLEFT|BOTTOMRIGHT|TOPRIGHT")
		print("/lumpatotem startattack TRUE|FALSE")
	end
end

function MoveRootFrame()
	-- print("Moving root frame to", Storage["anchor"], Storage["x"], Storage["y"])
	rootFrame:ClearAllPoints();
	rootFrame:SetPoint(Storage["anchor"], UIParent, Storage["x"], Storage["y"])
end

local function addEventListeners(self)
	addon.core.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	addon.core.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	addon.core.frame:RegisterEvent("UNIT_AURA")
end

local function onDragStart(self, mousebutton, ...)
	if mousebutton == "LeftButton" and combat == false then
		dragging = self
		DraggingLoop();
	end
end

local function onDragStop(self, mousebutton, ...)
	dragging = nil
end

function DraggingLoop()
	if dragging == nil then
		return
	end

	local scale = UIParent:GetEffectiveScale()
	local x, y = GetCursorPosition();
	local left = rootFrame:GetLeft()
	local relX = x/scale - left
	local overBin = math.max(math.min(math.floor(relX/64),3),0) + 1
	local currentBin = dragging.btnSlot

	if overBin ~= currentBin then
		b = table.remove(buttons, currentBin)
		table.insert(buttons, overBin, b)
		RedrawButtonLocations();

		local newOrder = {}
		for i, btn in pairs(buttons) do
			newOrder[i] = btn.totemElement
		end
		Storage["order"] = newOrder;
		SetMacro(macroName)
	end

	C_Timer.After(0.01, DraggingLoop)
end

function RedrawButtonLocations()
	for i=1,4 do
		btn = buttons[i];
		btn.btnSlot = i;
		btn:SetPoint("BOTTOMLEFT", rootFrame, "BOTTOMLEFT", 64*(i-1), 0)
	end
end

local function onEvent(self, event, ...)
	local args = {...}
	if event == "PLAYER_REGEN_DISABLED" then
		combat = true
	elseif event == "PLAYER_REGEN_ENABLED" then
		combat = false
	elseif event == "UNIT_AURA" then
		local unit = ...
		if unit == "player" then
			CountBuffs()
		end
	end
end

function CountBuffs()
	for buff in pairs(buffs) do -- clear all recorded buffs
		buffs[buff] = false
	end

	for i=1,16 do
		name = UnitBuff("player", i)
		if buffs[name] ~= nil then
			buffs[name] = true
		end
	end
end

function LumpaTotem:OnInitialize()
	print("init");
	
	addon.core = {};
	addon.core.frame = CreateFrame("Frame");
	addon.core.frame:SetScript("OnEvent", onEvent);
	addEventListeners();

	print(Storage)
	if (Storage == nil) then
		print("storage was nil")
		Storage = {}
		-- Storage = {
		-- 	earth = {
		-- 		idx = 0,
		-- 		name = "",
		-- 		short = "",
		-- 		enabled = true
		-- 	},
		-- 	fire = {
		-- 		idx = 0,
		-- 		name = "",
		-- 		short = "",
		-- 		enabled = true
		-- 	},
		-- 	water = {
		-- 		idx = 0,
		-- 		name = "",
		-- 		short = "",
		-- 		enabled = true
		-- 	},
		-- 	air = {
		-- 		idx = 0,
		-- 		name = "",
		-- 		short = "",
		-- 		enabled = true
		-- 	},
		-- 	order = {"air", "earth", "fire", "water"},
		-- 	x = 0,
		-- 	y = 0,
		-- 	reset = "combat",
		-- 	startattack = true,
		-- 	endwithnil = true,
		-- 	anchor = "CENTER"
		-- }
	end
	if (Storage["earth"] == nil) then 		Storage["earth"] = 			{idx = 0, name = "", short = "", enabled = true} end
	if (Storage["fire"] == nil) then 		Storage["fire"] = 			{idx = 0, name = "", short = "", enabled = true} end
	if (Storage["water"] == nil) then 		Storage["water"] = 			{idx = 0, name = "", short = "", enabled = true} end
	if (Storage["air"] == nil) then			Storage["air"] = 			{idx = 0, name = "", short = "", enabled = true} end
	if (Storage["order"] == nil) then 		Storage["order"] = 			{"air", "earth", "fire", "water"} end
	if (Storage["startattack"] == nil) then Storage["startattack"] = 	1 end
	if (Storage["endwithnil"] == nil) then 	Storage["endwithnil"] = 	1 end
	if (Storage["anchor"] == nil) then 		Storage["anchor"] = 		"CENTER" end
	if (Storage["reset"] == nil) then 		Storage["reset"] = 			"combat/10" end
	if (Storage["x"] == nil) then 			Storage["x"] = 				0 end
	if (Storage["y"] == nil) then 			Storage["y"] =				0 end
	CreateTotemBarFrame()
	LumpaTotem_Loop()
end

function TrimTotemString(s)
	if s == nil then
		return ""
	end
	s = s:gsub("% III", "") -- jävla fulhack
	s = s:gsub("% II", "")
	s = s:gsub("% IV", "")
	s = s:gsub("% I", "")
	s = s:gsub("% VIII", "")
	s = s:gsub("% VII", "")
	s = s:gsub("% VI", "")
	s = s:gsub("% V", "")
	return s
end

function LumpaTotem_Loop()
	LumpaTotem_LoopTick()
	C_Timer.After(0.1, LumpaTotem_Loop)
end

function LumpaTotem_LoopTick()
	-- placedElements = {
	-- 	["earth"] = false,
	-- 	["fire"] = false,
	-- 	["water"] = false,
	-- 	["air"] = false
	-- }

	for i=1,4 do
		local arg1, totemName, startTime, duration = GetTotemInfo(i)
		timeLeft = GetTotemTimeLeft(i)
		el = elements[i]

		btn = activeTotems[el]["btn"]
		if timeLeft == 0 then
			CountBuffs()
			btn.text_timeLeft:SetText("")
		else
			btn.text_timeLeft:SetText(timeLeft)
		end

		local start, duration = GetSpellCooldown(Storage[el]["name"])
		-- print(Storage[el]["name"], start, duration)
		if start ~= nil and duration ~= nil then
			btn.cd:SetCooldown(start, duration)
		end

		btn.texture:SetVertexColor(1,1,1) -- temp test

		totemName = TrimTotemString(totemName)
		if totemName ~= "" then
			local id = revlookup[el][totemName]
			auraName = tbl[el][id]["buff"]
			if timeLeft > 0 then -- if totem is alive
				-- placedElements[el] = true
				if auraName ~= nil then -- only if totem has aura
					if buffs[auraName] == true then
						btn.texture:SetVertexColor(0,1,0)
					else
						btn.texture:SetVertexColor(1,0,0)
					end
				else -- totem is alive, but has no aura
					btn.texture:SetVertexColor(0,1,0)
				end
			else -- totem is dead
				btn.texture:SetVertexColor(1,1,1)
			end
		end
	end

	-- local firstUnplaced = nil
	-- -- print()
	-- for element,b in pairs(placedElements) do
	-- 	-- print(element,b)
	-- 	if b == false then
	-- 		firstUnplaced = element
	-- 		break
	-- 	end
	-- end

	-- if firstUnplaced ~= nil then
	-- 	-- print("firstUnplaced", firstUnplaced)
	-- 	-- btnMissing:SetAttribute("spell", Storage[firstUnplaced]["name"])
	-- 	-- buttons[1]:Click("LeftButton")
	-- else
	-- 	-- btnMissing:SetAttribute("spell", nil)
	-- end
end



function LumpaTotem_OnLoad()
	print("on load");
end

function CreateTotemBarFrame()
	local f = CreateFrame("Frame","LumpaTotemRootFrame",UIParent)
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(256)
	f:SetHeight(64)

	-- btnMissing = CreateFrame("Button", "MyButtonName", UIParent, "SecureActionButtonTemplate")
	-- SetOverrideBindingClick(btnMissing, true, "1", "MyButtonName")
	-- btnMissing:SetWidth(64)
	-- btnMissing:SetHeight(64)
	-- btnMissing:SetPoint("CENTER", -100, -100)
	-- btnMissing:SetBackdrop({
	-- 	edgeFile = [[Interface\Buttons\WHITE8x8]],
	-- 	edgeSize = 5,
	-- })
	-- btnMissing:SetBackdropBorderColor(1,1,1)
	-- btnMissing:SetAttribute("type", "spell");


	-- f:SetBackdrop({
	-- 	edgeFile = [[Interface\Buttons\WHITE8x8]],
	-- 	edgeSize = 3,
	-- })
	-- f:SetBackdropBorderColor(0, 0, 0)

	for i,v in ipairs(Storage["order"]) do
		local btn = CreateFrame("Button", f, UIParent, "SecureActionButtonTemplate")
		btn:SetAttribute("type", "spell"); -- Unmodified left click.

		btn:SetWidth(64)
		btn:SetHeight(64)

		btn:SetBackdrop({
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 5,
		})
		c = element_colors[v]
		btn:SetBackdropBorderColor(c.r, c.g, c.b)

		btn:RegisterForDrag("LeftButton");
		btn:SetScript("OnDragStart", onDragStart);
		btn:SetScript("OnDragStop", onDragStop);

		btn.btnSlot = i;
		btn.totemElement = v;
		
		activeTotems[v]["btn"] = btn
		
		btn.text_name = btn:CreateFontString(nil, "ARTWORK")
		btn.text_name:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
		btn.text_name:SetPoint("BOTTOMLEFT", 0, 5)
		btn.text_name:SetWidth(64)
		local short = Storage[v]["short"]
		btn.text_name:SetText(short)

		btn.text_timeLeft = btn:CreateFontString(nil, "ARTWORK")
		btn.text_timeLeft:SetFont("Fonts\\ARIALN.ttf", 25, "OUTLINE")
		btn.text_timeLeft:SetPoint("CENTER", 0, 0)
		btn.text_timeLeft:SetWidth(64)
		btn.text_timeLeft:SetHeight(64)

		btn:Show()

		btn.cd = CreateFrame("Cooldown", "btn_cooldown", btn, "CooldownFrameTemplate")
		btn.cd:SetAllPoints()
		btn.cd:SetDrawEdge(false)
		btn.cd:Show()


		local t = btn:CreateTexture(nil, "BACKGROUND")
		local stored_idx = Storage[v]["idx"]

		t:SetTexture(tbl[v][stored_idx+1]["img"])
		t:SetAllPoints(btn)
		btn.texture = t

		btn:SetAttribute("spell", Storage[v]["name"]);

		local alpha = Storage[v]["enabled"] and 1.0 or 0.5
		btn:SetAlpha(alpha)

		btn:SetScript("OnMouseWheel", function(self, delta)
			if combat == false then
				el = v
				local ub = table.getn(tbl[el])
				Storage[el]["idx"] = Storage[el]["idx"] + delta
				Storage[el]["idx"] = math.fmod(Storage[el]["idx"] + ub, ub)
				idx = Storage[el]["idx"] + 1
				sel_img = tbl[el][idx]["img"]
				sel_name = tbl[el][idx]["name"]
				sel_short = tbl[el][idx]["short"]

				btn:SetAttribute("spell", sel_name);

				t:SetTexture(sel_img)
				Storage[el]["name"] = sel_name
				Storage[el]["short"] = sel_short
				btn.text_name:SetText(sel_short)

				SetMacro(macroName)
			end
		end)

		btn:SetScript("OnMouseDown", function(self, button)
			if combat == false then
				el = v
				if button == "RightButton" then
					Storage[el]["enabled"] = not Storage[el]["enabled"]

					local alpha = Storage[el]["enabled"] and 1.0 or 0.33
					btn:SetAlpha(alpha)
					-- t:SetVertexColor(1,0,0)

					SetMacro(macroName)

				-- elseif button == "LeftButton" then
				-- 	name = Storage[el]["name"]
				-- 	print(name)
				-- 	-- CastSpellByName(name)
				end
			end
		end)

		-- btn:SetScript("OnDragStart", function(self, x)
		-- 	print("dragging", x)
		-- end)
		buttons[i] = btn;
	end

	f:Show();
	-- f:RegisterForDrag("MiddleButton");
	-- f:SetMovable();
	-- f:SetScript("OnDragStop", f.StopMovingOrSizing)
	-- f:SetScript("OnDragStart", f.StartMoving)
	rootFrame = f;
	MoveRootFrame();
	RedrawButtonLocations();
end

function SetMacro(name)
	if combat then
		print("LumpaTotem: Can't change macro during combat!")
		return
	end
	_name, _, _, _ = GetMacroInfo(name)
	
	local body = ""
	if Storage["startattack"] == 1 then
		body = body .. "/startattack\n"
	end

	-- local body = "/startattack\n/castsequence "
	body = body .. "/castsequence "
	if Storage["reset"] ~= "" then
		body = body .. "reset=" .. Storage["reset"] .. " "
	end

	for i,element in pairs(Storage["order"]) do
		body = AddTotemToMacroString(body, element)
	end

	body = body:sub(1,-3) -- drop last ", "

	if Storage["endwithnil"] == 1 then
		body = body .. ", nil"
	end

	if _name == nil then -- macro do not exist, create it
		local macroId = CreateMacro(name, "INV_MISC_QUESTIONMARK", body, 1);
	else
		EditMacro(name, nil, nil, body);
	end
end

function AddTotemToMacroString(body, element)
	if Storage[element]["enabled"] == true then
		body = body .. Storage[element]["name"] .. ", ";
	end
	return body
end