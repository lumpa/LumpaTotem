local LumpaTotem = LibStub("AceAddon-3.0"):GetAddon("LumpaTotem", "AceTimer-3.0")
if LumpaTotem == nil then
	LumpaTotem = LibStub("AceAddon-3.0"):NewAddon("LumpaTotem", "AceTimer-3.0")
end

local addonName, addon = ...

local macroName = "LumpaTotem"
local sel_totems = {}
local combat = false

local rootFrame = nil;
local iconWidth = 64;
local iconHeight = 64;
local iconFont = "Fonts\\ARIALN.ttf";

local buttons = {}
local miniScale = 0.5

local elements = {"fire", "earth", "water", "air"} -- do not change order
local element_colors = {
	fire  = {r=191/255, g=64/255, b=64/255},
	earth = {r=128/255, g=191/255, b=64/255},
	water = {r=64/255, g=128/255, b=191/255},
	air   = {r=128/255, g=64/255, b=191/255}
}

local c_act = {r=0/255, g=255/255, b=0/255}
local c_actm= {r=32/255, g=96/255, b=32/255}
local c_oom = {r=64/255, g=64/255, b=64/255}
local c_oor = {r=255/255, g=0/255, b=0/255}
local c_oomr= {r=96/255, g=32/255, b=32/255}
local c_non = {r=1, g=1, b=1}

local pc = {
	addon 		= "|cFF40bfbf",
	-- helpOpt 	= "|cFFbfbf40",
	opt_format 	= "|cFF80bf40",
	opt_ex	 	= "|cFF4080bf",
	opt_set	 	= "|cFFbf40bf",
	slash		= "|cFF40bfbf",
	cmd 		= "|cFFbfbf40",
	value 		= "|cFFbf4040",
	sep			= "|cFF40bfbf",
}

local dragging = nil

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
		btn = nil
	},
	fire = {
		btn = nil
	},
	water = {
		btn = nil
	},
	air = {
		btn = nil
	}
}
-- local revlookup = {
-- 	earth = {
-- 		["Earthbind Totem"] = 1,
-- 		["Stoneskin Totem"] = 2,
-- 		["Stoneclaw Totem"] = 3,
-- 		["Strength of Earth Totem"] = 4,
-- 		["Tremor Totem"] = 5,
-- 		["Earth Elemental Totem"] = 6
-- 	},
-- 	fire = {
-- 		["Searing Totem"] = 1,
-- 		["Fire Elemental Totem"] = 2,
-- 		["Fire Nova Totem"] = 3,
-- 		["Flametongue Totem"] = 4,
-- 		["Frost Resistance Totem"] = 5,
-- 		["Magma Totem"] = 6,
-- 		["Totem of Wrath"] = 7
-- 	},
-- 	water = {
-- 		["Healing Stream Totem"] = 1,
-- 		["Mana Spring Totem"] = 2,
-- 		["Poison Cleansing Totem"] = 3,
-- 		["Disease Cleansing Totem"] = 4,
-- 		["Mana Tide Totem"] = 5,
-- 		["Fire Resistance Totem"] = 6
-- 	},
-- 	air = {
-- 		["Grace of Air Totem"] = 1,
-- 		["Windfury Totem"] = 2,
-- 		["Grounding Totem"] = 3,
-- 		["Windwall Totem"] = 4,
-- 		["Sentry Totem"] = 5,
-- 		["Nature Resistance Totem"] = 6,
-- 		["Tranquil Air Totem"] = 7,
-- 		["Wrath of Air Totem"] = 8
-- 	}
-- }
local tbl = {
	earth = {
		{
			name = "Earthbind Totem",
			short = "Earthbind",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_earthbind.tga"
		},
		{
			name = "Stoneskin Totem",
			short = "Stoneskin",
			buff = "Stoneskin",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_stoneskin.tga"
		},
		{
			name = "Stoneclaw Totem",
			short = "Stoneclaw",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_stoneclaw.tga"
		},
		{
			name = "Strength of Earth Totem",
			short = "Strength",
			buff = "Strength of Earth",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_strengthofearth.tga"
		},
		{
			name = "Tremor Totem",
			short = "Tremor",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_tremor.tga"
		},
		{
			name = "Earth Elemental Totem",
			short = "EarthEl",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_earthelemental.tga"
		}
	},
	fire = {
		{
			name = "Searing Totem",
			short = "Searing",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_searing.tga"
		},
		{
			name = "Fire Elemental Totem",
			short = "FireEl",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_fireelemental.tga"
		},
		{
			name = "Fire Nova Totem",
			short = "Nova",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_firenova.tga"
		},
		{
			name = "Flametongue Totem",
			short = "Flame",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_flametongue.tga"
		},
		{
			name = "Frost Resistance Totem",
			short = "FrostRes",
			buff = "Frost Resistance",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_frostres.tga"
		},
		{
			name = "Magma Totem",
			short = "Magma",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_magma.tga"
		},
		{
			name = "Totem of Wrath",
			short = "ToW",
			buff = "Totem of Wrath",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_totemofwrath.tga"
		}
	},
	water = {
		{
			name = "Healing Stream Totem",
			short = "Healing",
			buff = "Healing Stream",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_healingstream.tga"
		},
		{
			name = "Mana Spring Totem",
			short = "Spring",
			buff = "Mana Spring",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_manaspring.tga"
		},
		{
			name = "Poison Cleansing Totem",
			short = "Poison",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\water_poison.tga"
		},
		{
			name = "Disease Cleansing Totem",
			short = "Disease",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\water_disease.tga"
		},
		{
			name = "Mana Tide Totem",
			short = "Tide",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\water_manatide.tga"
		},
		{
			name = "Fire Resistance Totem",
			short = "FireRes",
			buff = "Fire Resistance",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_fireres.tga"
		}
	},
	air = {
		{
			name = "Grace of Air Totem",
			short = "Grace",
			buff = "Grace of Air",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_grace.tga"
		},
		{
			name = "Windfury Totem",
			short = "WF",
			buff = nil,
			img = "Interface\\Addons\\LumpaTotem\\img\\air_windfury.tga"
		},
		{
			name = "Grounding Totem",
			short = "Grounding",
			buff = "Grounding Totem Effect",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_grounding.tga"
		},
		{
			name = "Windwall Totem",
			short = "Windwall",
			buff = "Windwall",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_windwall.tga"
		},
		{
			name = "Sentry Totem",
			short = "Sentry",
			buff = "Sentry Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_sentry.tga"
		},
		{
			name = "Nature Resistance Totem",
			short = "NatRes",
			buff = "Nature Resistance",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_natureres.tga"
		},
		{
			name = "Tranquil Air Totem",
			short = "Tranquil",
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

function CreateReverseLookup_shorts() 
	rlShorts = {}
	for el, el_x in pairs(tbl) do
		for t, t_x in pairs(el_x) do
			rlShorts[string.lower(t_x["short"])] = t_x["name"]
		end
	end
	return rlShorts
end
local revLookup_shorts = CreateReverseLookup_shorts(); -- ex: ask for "earthbind", return "Earthbind Totem"


function CreateReverseLookup_totemIds()
	rlTotemids = {}
	for el, el_x in pairs(tbl) do
		rlTotemids[el] = {}
		for i, t_x in ipairs(el_x) do
			rlTotemids[el][t_x["name"]] = i
		end
	end
	return rlTotemids	
end
local revLookup_totemIds = CreateReverseLookup_totemIds() -- ex: ask for ["earth"]["Tremor Totem"], return 5


function ShortsStringWithSeparatorsColored()
	local out = ""
	for k,v in pairs(revLookup_shorts) do
		out = out .. pc["cmd"] .. k .. "|r" .. pc["sep"] .. "|||r"
	end
	out = out:sub(1,-5)
	out = out .. "|r"
	return out
end

local cmd_help = {
	anchor = {
		help = "anchor point of root frame",
		format_cmd = "anchor",
		format_val = 
			pc["value"].."CENTER"..pc["sep"].."||"..
			pc["value"].."BOTTOMLEFT"..pc["sep"].."||"..
			pc["value"].."TOPLEFT"..pc["sep"].."||".. 
			pc["value"].."BOTTOMRIGHT"..pc["sep"].."||"..
			pc["value"].."TOPRIGHT|r",
		ex_cmd = "anchor",
		ex_val = "CENTER"
	},
	x = {
		help = "x coordinate of root frame",
		format_cmd = "x",
		format_val = "<any number>",
		ex_cmd = "x",
		ex_val = "200"
	},
	y = {
		help = "y coordinate of root frame",
		format_cmd = "y",
		format_val = "<any number>",
		ex_cmd = "y",
		ex_val = "-300"
	},
	reset = {
		help = "reset value of castsequence",
		format_cmd = "reset",
		format_val = "<any reset string without spaces>",
		ex_cmd = "reset",
		ex_val = "combat/10"
	},
	endwithnil = {
		help = "end castsequence with nil",
		format_cmd = "endwithnil",
		format_val = pc["value"] .. "0" .. pc["sep"] .."||" .. pc["value"] .. "1|r",
		ex_cmd = "endwithnil",
		ex_val = "1"
	},
	startattack = {
		help = "include startattack in macro",
		format_cmd = "startattack",
		format_val = pc["value"] .. "0" .. pc["sep"] .."||" .. pc["value"] .. "1|r",
		ex_cmd = "startattack",
		ex_val = "1"
	},
	scale = {
		help = "scale of root frame",
		format_cmd = "scale",
		format_val = "<any number>",
		ex_cmd = "scale",
		ex_val = "1.25"
	},
	examples = {
		help = "show list of examples",
		format_cmd = "examples",
		format_val = "",
		ex_cmd = "examples",
		ex_val = ""
	},
	included = {
		help = "Which totems that can be scrolled through",
		-- format = "searing|magma|ground 0|1",
		format_cmd = ShortsStringWithSeparatorsColored(),
		format_val = pc["value"] .. "0" .. pc["sep"] .. "||" .. pc["value"] .. "1|r",
		ex_cmd = "searing",
		ex_val = "0"
	}
}
function PrintFormats()
	for help_key,v in pairs(cmd_help) do
		print(
			pc["addon"] .. "LumpaTotem|r " .. 
			pc["opt_format"] .. "FORMAT|r:    " .. 
			pc["slash"] .. "/lt " ..
			pc["cmd"] .. cmd_help[help_key]["format_cmd"] .. "|r " .. 
			pc["value"] .. cmd_help[help_key]["format_val"] .. "|r"
		)
	end
end
function PrintExamples()
	for help_key,v in pairs(cmd_help) do
		print(
			pc["addon"] .. "LumpaTotem|r " .. 
			pc["opt_ex"] .. "EXAMPLE|r:    " .. 
			pc["slash"] .. "/lt " ..
			pc["cmd"] .. cmd_help[help_key]["ex_cmd"] .. "|r " .. 
			pc["value"] .. cmd_help[help_key]["ex_val"] .. "|r"
		)
	end
end
function PrintSet(key, value)
	print(
		pc["addon"] .. "LumpaTotem|r " .. 
		pc["opt_set"] .. "SET|r:    " ..
		pc["slash"] .. "/lt|r " ..
		pc["cmd"] .. key .. "|r " .. 
		pc["value"] .. value .. "|r"
	)
end
function PrintGet(key)
	print(
		pc["addon"] .. "LumpaTotem|r " .. 
		pc["opt_set"] .. "CURRENT|r:    " ..
		pc["slash"] .. "/lt|r " ..
		pc["cmd"] .. key .. "|r " .. 
		pc["value"] .. Storage[key] .. "|r"
	)
end
-- function PrintHelp(help_key, stored_key) -- obsolete
-- 	-- stored_key = stored_key and stored_key or help_key -- if stored_key is nil, set it to help_key instead
-- 	if cmd_help[help_key] ~= nil then
-- 		print()
-- 		print(
-- 			pc["addon"] .. "LumpaTotem|r " .. 
-- 			pc["helpOpt"] .. "FORMAT|r:    " .. 
-- 			pc["slash"] .. "/lt " ..
-- 			pc["cmd"] .. cmd_help[help_key]["format_cmd"] .. "|r " .. 
-- 			pc["value"] .. cmd_help[help_key]["format_val"] .. "|r"
-- 		)
-- 		print(
-- 			pc["addon"] .. "LumpaTotem|r " .. 
-- 			pc["helpOpt"] .. "EXAMPLE|r:   " .. 
-- 			pc["slash"] .. "/lt " ..
-- 			pc["cmd"] .. cmd_help[help_key]["ex_cmd"] .. " |r" .. 
-- 			pc["value"] .. cmd_help[help_key]["ex_val"] .. "|r"
-- 		)
-- 		print(
-- 			pc["addon"] .. "LumpaTotem|r " .. 
-- 			pc["helpOpt"] .. "CURRENT|r:    " .. 
-- 			pc["slash"] .. "/lt " ..
-- 			pc["cmd"] .. stored_key .. "|r " .. 
-- 			pc["value"] .. Storage[stored_key] .. "|r"
-- 		)
-- 		print()
-- 	end
-- end




SLASH_LUMPATOTEM1 = "/lt"
SlashCmdList["LUMPATOTEM"] = function(msg)
	argv = {}
	for arg in string.gmatch(string.lower(msg), '[%a%d%-%.%/]+') do
		table.insert(argv, arg);
	end

	-- print("/lt", table.concat(argv, " "))
	-- if cmd_help[argv[1]] ~= nil and argv[2] == nil then -- valid argv1 but no argv2
	-- 	PrintHelp(argv[1])
	-- 	return
	-- end

	-- local current = 
	-- 	pc["addon"] .. "LumpaTotem|r " .. 
	-- 	pc["helpOpt"] .. "CURRENT     |r " .. 
	-- 	pc["cmd"] .. "/lt " .. argv[1] .. " " .. 
	-- 	pc["value"] .. " ";

	if argv[1] == "x" then
		-- if table.getn(argv) >= 2 then
		if argv[2] ~= nil then
			Storage["x"] = tonumber(argv[2]);
			MoveRootFrame();
			PrintSet(argv[1], argv[2]);
		else 
			-- PrintHelp(argv[1], argv[1]);
			PrintGet(argv[1]);
		end

	elseif argv[1] == "y" then
		if argv[2] ~= nil then
			Storage["y"] = tonumber(argv[2]);
			MoveRootFrame();
			PrintSet(argv[1], argv[2]);
		else PrintGet(argv[1]); end

	elseif argv[1] == "reset" then
		if argv[2] ~= nil then
			Storage["reset"] = argv[2];
			SetMacro(macroName)
			PrintSet(argv[1], argv[2]);
		else
			PrintGet(argv[1]);
		end

	elseif argv[1] == "endwithnil" then
		if argv[2] ~= nil then
			Storage["endwithnil"] = tonumber(argv[2])
			SetMacro(macroName)
			PrintSet(argv[1], argv[2]);
		else
			PrintGet(argv[1]);
		end

	elseif argv[1] == "anchor" then
		if argv[2] ~= nil then
			Storage["anchor"] = argv[2]
			MoveRootFrame()
			PrintSet(argv[1], argv[2]);
		else
			PrintGet(argv[1]);
		end

	elseif argv[1] == "startattack" then
		if argv[2] ~= nil then
			Storage["startattack"] = tonumber(argv[2])
			SetMacro(macroName)
			PrintSet(argv[1], argv[2]);
		else
			PrintGet(argv[1]);
		end

	elseif argv[1] == "stand" then
		if argv[2] ~= nil then
			Storage["stand"] = tonumber(argv[2])
			SetMacro(macroName)
			PrintSet(argv[1], argv[2]);
		else
			PrintGet(argv[1]);
		end

	elseif argv[1] == "scale" then
		if argv[2] ~= nil then
			Storage["scale"] = tonumber(argv[2])
			ResizeFrames();
			PrintSet(argv[1], argv[2]);
		else
			PrintGet(argv[1]);
		end

	elseif argv[1] == "examples" then
		PrintExamples();

	elseif revLookup_shorts[argv[1]] ~= nil then
		local short = string.lower(argv[1])
		local b = argv[2]
		if b ~= nil then
			b = tonumber(b);
			Storage[short] = b;
			PrintSet(short, b);
		else
			-- PrintHelp("included", short)
			PrintGet(short);
		end

	else
		-- for k,v in pairs(cmd_help) do
		-- 	print("/lt", k, "   ", cmd_help[k]["help"])
		-- end
		PrintFormats();
	end
end

function ResizeFrames()
	local scale = Storage["scale"]
	rootFrame:SetWidth(iconWidth*scale*4)
	rootFrame:SetHeight(iconWidth*scale)

	for i,v in ipairs(Storage["order"]) do
		local btn = buttons[i]
		btn:SetWidth(iconWidth * scale)
		btn:SetHeight(iconHeight * scale)
		-- btn:SetBackdrop({
		-- 	edgeFile = [[Interface\Buttons\WHITE8x8]],
		-- 	edgeSize = 5 * scale,
		-- })
		btn.border:SetBackdrop({
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 5 * scale,
		})
		c = element_colors[v]
		-- btn:SetBackdropBorderColor(c.r, c.g, c.b)
		btn.border:SetBackdropBorderColor(c.r, c.g, c.b)

		btn.text_name:SetWidth(iconWidth * scale)
		btn.text_name:SetFont(iconFont, 13 * scale, "OUTLINE")
		btn.text_name:SetPoint("BOTTOMLEFT", 0, 5 * scale)

		btn.text_timeLeft:SetWidth(iconWidth * scale)
		btn.text_timeLeft:SetHeight(iconHeight * scale)
		btn.text_timeLeft:SetFont(iconFont, 25 * scale, "OUTLINE")
	end

	RedrawButtonLocations()
end

function MoveRootFrame()
	-- print("Moving root frame to", Storage["anchor"], Storage["x"], Storage["y"])
	-- rootFrame:SetScale(Storage["scale"])
	rootFrame:ClearAllPoints();
	rootFrame:SetPoint(Storage["anchor"], UIParent, Storage["x"], Storage["y"])
end

local function addEventListeners(self)
	addon.core.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	addon.core.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	addon.core.frame:RegisterEvent("UNIT_AURA")
	addon.core.frame:RegisterEvent("PLAYER_TOTEM_UPDATE")
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
	-- local overBin = math.max(math.min(math.floor(relX/64),3),0) + 1
	local overBin = math.max(math.min(math.floor(relX/(iconWidth*Storage["scale"])),3),0) + 1
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
		-- btn:SetPoint("BOTTOMLEFT", rootFrame, "BOTTOMLEFT", 64*(i-1), 0)
		btn:SetPoint("BOTTOMLEFT", rootFrame, "BOTTOMLEFT", (iconWidth*Storage["scale"])*(i-1), 0)
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
	elseif event == "PLAYER_TOTEM_UPDATE" then
		-- print("PLAYER_TOTEM_UPDATE")
		LumpaTotem_LoopTick()
	end
end

function CountBuffs()
	for buff in pairs(buffs) do -- clear all recorded buffs
		buffs[buff] = false
	end

	for i=1,32 do
		-- name = UnitBuff("player", i)
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player", i, "PLAYER")
		if buffs[name] ~= nil then
			buffs[name] = true
		end
	end
end

function LumpaTotem:OnInitialize()
	print("LumpaTotem TBCC fulhack loaded.");

	-- CreateReverseLookupShorts();
	
	addon.core = {};
	addon.core.frame = CreateFrame("Frame");
	-- addon.core.frame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate");
	addon.core.frame:SetScript("OnEvent", onEvent);
	addEventListeners();

	-- print(Storage)
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
	if (Storage["earth"] == nil) then 		Storage["earth"] = 			{idx = 0, name = tbl["earth"][1]["name"], short = tbl["earth"][1]["short"], enabled = true} end
	if (Storage["fire"] == nil) then 		Storage["fire"] = 			{idx = 0, name = tbl["fire"][1]["name"], short = tbl["fire"][1]["short"], enabled = true} end
	if (Storage["water"] == nil) then 		Storage["water"] = 			{idx = 0, name = tbl["water"][1]["name"], short = tbl["water"][1]["short"], enabled = true} end
	if (Storage["air"] == nil) then			Storage["air"] = 			{idx = 0, name = tbl["air"][1]["name"], short = tbl["air"][1]["short"], enabled = true} end
	-- if (Storage["earth"] == nil) then 		Storage["earth"] = 			{idx = 0, name = "", short = "", enabled = true} end
	-- if (Storage["fire"] == nil) then 		Storage["fire"] = 			{idx = 0, name = "", short = "", enabled = true} end
	-- if (Storage["water"] == nil) then 		Storage["water"] = 			{idx = 0, name = "", short = "", enabled = true} end
	-- if (Storage["air"] == nil) then			Storage["air"] = 			{idx = 0, name = "", short = "", enabled = true} end

	if (Storage["order"] == nil) then 		Storage["order"] = 			{"air", "earth", "fire", "water"} end
	if (Storage["startattack"] == nil) then Storage["startattack"] = 	1 end
	if (Storage["endwithnil"] == nil) then 	Storage["endwithnil"] = 	1 end
	if (Storage["anchor"] == nil) then 		Storage["anchor"] = 		"CENTER" end
	if (Storage["reset"] == nil) then 		Storage["reset"] = 			"combat/10" end
	if (Storage["x"] == nil) then 			Storage["x"] = 				0 end
	if (Storage["y"] == nil) then 			Storage["y"] =				0 end
	if (Storage["scale"] == nil) then 		Storage["scale"] =			1 end
	-- if (Storage["included"] == nil) then	Storage["included"] = 		{} end

	for k,v in pairs(revLookup_shorts) do
		-- if (Storage["included"][k] == nil) then Storage["included"][k] = 1 end
		if (Storage[k] == nil) then Storage[k] = 1 end
	end
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
	
	-- if totemAlive then
		-- C_Timer.After(1, TotemUpdateText_timeLeft(idx))
	-- end
end

-- function TotemUpdateText_timeLeft(idx)
-- 	print("TotemUpdateText_timeLeft idx =",idx)
-- 	local btn = buttons[idx]
-- 	local arg1, totemActual, startTime, duration = GetTotemInfo(idx)
-- 	local timeLeft = GetTotemTimeLeft(idx)

-- 	local totemSelected = Storage[el]["name"]

-- 	totemSelected = TrimTotemString(totemSelected)
-- 	totemActual = TrimTotemString(totemActual)

-- 	local totemAlive = totemActual ~= nil and totemActual ~= "";

-- 	local otherTotem = false;
-- 	if totemActual ~= nil and totemActual ~= "" then
-- 		otherTotem = totemActual ~= totemSelected;
-- 	end

-- 	if otherTotem then
-- 		btn.mini.text_timeLeft:SetText(timeLeft)
-- 	else
-- 		btn.text_timeLeft:SetText(timeLeft)
-- 	end

-- 	if totemAlive then
-- 		C_Timer.After(1, TotemUpdateText_timeLeft(idx))
-- 	else
-- 		btn.text_timeLeft:SetText("")
-- 		btn.mini.text_timeLeft:SetText("")
-- 	end
-- end

function LumpaTotem_LoopTick()
	-- placedElements = {
	-- 	["earth"] = false,
	-- 	["fire"] = false,
	-- 	["water"] = false,
	-- 	["air"] = false
	-- }
	-- print()
	for i=1,4 do
		local arg1, totemActual, startTime, duration = GetTotemInfo(i)
		-- print("totem_actual", totem_actual)
		timeLeft = GetTotemTimeLeft(i)
		el = elements[i]
		-- print(totemName, el)

		btn = activeTotems[el]["btn"]
		-- btn = buttons[i]


		local totemSelected = Storage[el]["name"]
		local sel_start, sel_duration = GetSpellCooldown(totemSelected)
		local sel_usable, sel_oom = IsUsableSpell(totemSelected)
		if sel_start ~= nil and sel_duration ~= nil then
			btn.cd:SetCooldown(sel_start, sel_duration)
		end

		-- local act_start, act_duration, act_usable, act_oom = nil, nil, nil, nil;
		-- if totemActual ~= nil and totemActual ~= "" then
		-- 	act_start, act_duration = GetSpellCooldown(totemActual)
		-- 	act_usable, act_oom = IsUsableSpell(totemActual)
		-- 	if act_start ~= nil and act_duration ~= nil then
		-- 		btn.mini.cd:SetCooldown(act_start, act_duration)
		-- 	end
		-- end



		btn.texture:SetVertexColor(1,1,1) -- temp test
		btn.mini.texture:SetVertexColor(1,1,1) -- temp test

		totemSelected = TrimTotemString(totemSelected)
		totemActual = TrimTotemString(totemActual)

		-- print(totemSelected, totemActual)

		local totemAlive = totemActual ~= nil and totemActual ~= "";

		local sel_id = nil;
		local act_id = nil;
		local sel_auraName = nil;
		local act_auraName = nil;


		local otherTotem = false;
		if totemActual ~= nil and totemActual ~= "" and totemActual ~= "Unknown" then
			otherTotem = totemActual ~= totemSelected;
		end


		if totemSelected ~= "" and totemSelected ~= nil and totemSelected ~= "Unknown" then
			sel_id = revLookup_totemIds[el][totemSelected]
			sel_auraName = tbl[el][sel_id]["buff"]
		end


		-- if totemActual ~= "" and totemActual ~= nil then
		if totemActual ~= "" and totemActual ~= nil and totemActual ~= "Unknown" then
			-- print("totemActual:",totemActual, "      el:",el)
			act_id = revLookup_totemIds[el][totemActual]
			act_auraName = tbl[el][act_id]["buff"]

			local act_start, act_duration = GetSpellCooldown(totemActual)
			local act_usable, act_oom = IsUsableSpell(totemActual)
			-- print(Storage[el]["name"], start, duration)
			if act_start ~= nil and act_duration ~= nil then
				btn.mini.cd:SetCooldown(act_start, act_duration)
			end

		end

		-- print("totemActual", totemActual, "    totemSelected", totemSelected, "     otherTotem", otherTotem)

		-- if timeLeft == 0 then
		if totemAlive == false then
			CountBuffs()
			btn.text_timeLeft:SetText("")
			btn.mini.text_timeLeft:SetText("")
			-- btn.mini:Hide()
		else
			if otherTotem then
				btn.mini.text_timeLeft:SetText(timeLeft)
				btn.text_timeLeft:SetText("")
			else
				btn.text_timeLeft:SetText(timeLeft)
			end
		end

		-- local c_act = {r=38/255, g=217/255, b=38/255}
		-- local c_oom = {r=38/255, g=38/255, b=38/255}
		-- local c_oor = {r=217/255, g=38/255, b=38/255}
		-- local c_non = {r=1, g=1, b=1}

		-- local c_act = {r=0/255, g=255/255, b=0/255}
		-- local c_actm= {r=32/255, g=96/255, b=32/255}
		-- local c_oom = {r=64/255, g=64/255, b=64/255}
		-- local c_oor = {r=255/255, g=0/255, b=0/255}
		-- local c_oomr= {r=96/255, g=32/255, b=32/255}
		-- local c_non = {r=1, g=1, b=1}

		-- print("totemSelected", totemSelected, "     totemActual", totemActual)
		-- print("otherTotem", otherTotem)

		-- local t_alive = timeLeft > 0
		-- local t_hasAura = auraName ~= nil
		-- local t_auraReachingMe = buffs[auraName]

		-- if t_alive and t_hasAura and t_auraReachingMe then
		-- 	if oom then
		-- 		btn.texture:SetVertexColor(c_actm.r, c_actm.g, c_actm.b)
		-- 	else
		-- 		btn.texture:SetVertexColor(c_act.r, c_act.g, c_act.b)
		-- 	end
		-- local otherAura
		-- if timeLeft > 0 then -- totem is alive
		if totemAlive then

			-- if sel_auraName ~= nil then -- totem has aura
			-- 	if buffs[sel_auraName] == true then -- aura reaching me
			-- 		if oom==true then
			-- 			btn.texture:SetVertexColor(c_actm.r, c_actm.g, c_actm.b)
			-- 		else
			-- 			btn.texture:SetVertexColor(c_act.r, c_act.g, c_act.b)
			-- 		end
			-- 	else -- aura not reaching me
			-- 		if oom==true then
			-- 			btn.texture:SetVertexColor(c_oomr.r, c_oomr.g, c_oomr.b)
			-- 		else
			-- 			btn.texture:SetVertexColor(c_oor.r, c_oor.g, c_oor.b)
			-- 		end
			-- 	end
			-- else -- totem is alive, but has no aura
			-- 	if oom==true then
			-- 		btn.texture:SetVertexColor(c_actm.r, c_actm.g, c_actm.b)
			-- 	else
			-- 		btn.texture:SetVertexColor(c_act.r, c_act.g, c_act.b)
			-- 	end
			-- end

			if otherTotem then
				-- btn.mini.text_timeLeft:SetText(timeLeft)
				if act_auraName ~= nil then -- totem has aura
					if buffs[act_auraName] == true then -- aura reaching me
						if act_oom==true then
							btn.mini.texture:SetVertexColor(c_actm.r, c_actm.g, c_actm.b)
						else
							btn.mini.texture:SetVertexColor(c_act.r, c_act.g, c_act.b)
						end
					else -- aura not reaching me
						if act_oom==true then
							btn.mini.texture:SetVertexColor(c_oomr.r, c_oomr.g, c_oomr.b)
						else
							btn.mini.texture:SetVertexColor(c_oor.r, c_oor.g, c_oor.b)
						end
					end
				else -- totem is alive, but has no aura
					if act_oom==true then
						btn.mini.texture:SetVertexColor(c_actm.r, c_actm.g, c_actm.b)
					else
						btn.mini.texture:SetVertexColor(c_act.r, c_act.g, c_act.b)
					end
				end
			else
				-- btn.text_timeLeft:SetText(timeLeft)
				if sel_auraName ~= nil then -- totem has aura
					if buffs[sel_auraName] == true then -- aura reaching me
						if sel_oom==true then
							btn.texture:SetVertexColor(c_actm.r, c_actm.g, c_actm.b)
						else
							btn.texture:SetVertexColor(c_act.r, c_act.g, c_act.b)
						end
					else -- aura not reaching me
						if sel_oom==true then
							btn.texture:SetVertexColor(c_oomr.r, c_oomr.g, c_oomr.b)
						else
							btn.texture:SetVertexColor(c_oor.r, c_oor.g, c_oor.b)
						end
					end
				else -- totem is alive, but has no aura
					if sel_oom==true then
						btn.texture:SetVertexColor(c_actm.r, c_actm.g, c_actm.b)
					else
						btn.texture:SetVertexColor(c_act.r, c_act.g, c_act.b)
					end
				end
			end



		else -- totem is dead
			btn.mini:Hide()
			if sel_oom==true then
				btn.texture:SetVertexColor(c_oom.r, c_oom.g, c_oom.b)
			else
				btn.texture:SetVertexColor(c_non.r, c_non.g, c_non.b)
			end
		end

		if otherTotem then
			btn.mini.texture:SetTexture(tbl[el][act_id]["img"])
			btn.mini:Show()
		else
			btn.mini:Hide()
		end
	end
end



function LumpaTotem_OnLoad()
	-- print("on load");
end

function CreateTotemBarFrame()
	local f = CreateFrame("Frame","LumpaTotemRootFrame",UIParent)
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(256)
	f:SetHeight(64)

	-- f:SetBackdrop({
	-- 	edgeFile = [[Interface\Buttons\WHITE8x8]],
	-- 	edgeSize = 3,
	-- })
	-- f:SetBackdropBorderColor(0, 0, 0)

	for i,v in ipairs(Storage["order"]) do
	-- for i,v in ipairs(elements) do
		-- local btn = CreateFrame("Button", f, UIParent, "SecureActionButtonTemplate")
		local btn = CreateFrame("Button", f, UIParent, BackdropTemplateMixin and "SecureActionButtonTemplate")
		-- local btn = CreateFrame("Button", f, UIParent, BackdropTemplateMixin and "BackdropTemplate")
		-- local btn = CreateFrame("Button", f, UIParent, BackdropTemplateMixin and "BackdropTemplate")
		btn:SetAttribute("type", "spell"); -- Unmodified left click.

		-- btn:SetWidth(64)
		-- btn:SetHeight(64)

		-- btn:SetBackdrop({
		-- 	edgeFile = [[Interface\Buttons\WHITE8x8]],
		-- 	edgeSize = 5,
		-- })
		-- c = element_colors[v]
		-- btn:SetBackdropBorderColor(c.r, c.g, c.b)

		btn:RegisterForDrag("LeftButton");
		btn:SetScript("OnDragStart", onDragStart);
		btn:SetScript("OnDragStop", onDragStop);

		btn.btnSlot = i;
		btn.totemElement = v;
		
		activeTotems[v]["btn"] = btn
		
		btn.text_name = btn:CreateFontString(nil, "ARTWORK")
		btn.text_name:SetFont(iconFont, 13, "OUTLINE")
		-- btn.text_name:SetPoint("BOTTOMLEFT", 0, 5)
		-- btn.text_name:SetWidth(64)
		local short = Storage[v]["short"]
		btn.text_name:SetText(short)

		btn.text_timeLeft = btn:CreateFontString(nil, "ARTWORK")
		btn.text_timeLeft:SetFont(iconFont, 25, "OUTLINE")
		btn.text_timeLeft:SetPoint("CENTER", 0, 0)
		-- btn.text_timeLeft:SetWidth(64)
		-- btn.text_timeLeft:SetHeight(64)

		btn:Show()

		btn.cd = CreateFrame("Cooldown", "btn_cooldown", btn, "CooldownFrameTemplate")
		btn.cd:SetAllPoints()
		btn.cd:SetDrawEdge(false)
		btn.cd:Show()

		-- BORDER
		btn.border = CreateFrame("Frame", "btn_border", btn, BackdropTemplateMixin and "BackdropTemplate")
		btn.border:SetAllPoints()
		-- btn.border:SetDrawEdge(false)
		btn.border:Show()

		-- MINI
		btn.mini = CreateFrame("Frame", btn, UIParent);
		local t_mini = btn.mini:CreateTexture(nil, "ARTWORK")
		t_mini:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions.blp")
		t_mini:SetAllPoints()
		btn.mini:SetPoint("TOPRIGHT", btn)
		btn.mini:SetWidth(iconWidth*Storage["scale"] * miniScale)
		btn.mini:SetHeight(iconHeight*Storage["scale"] * miniScale)
		btn.mini.texture = t_mini

		btn.mini.cd = CreateFrame("Cooldown", "mini_cooldown", btn.mini, "CooldownFrameTemplate")
		btn.mini.cd:SetAllPoints()
		btn.mini.cd:SetDrawEdge(false)
		btn.mini.cd:Show()

		btn.mini.text_timeLeft = btn.mini:CreateFontString(nil, "ARTWORK")
		btn.mini.text_timeLeft:SetFont(iconFont, 25 * miniScale, "OUTLINE")
		btn.mini.text_timeLeft:SetPoint("CENTER", 0, 0)


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
				local idx = nil;
				local sel_img = nil;
				local sel_name = nil;
				local sel_short = nil;
				local temp_idx = Storage[el]["idx"]

				local count = 0

				repeat
					count = count + 1
					temp_idx = temp_idx + delta
					temp_idx = math.fmod(temp_idx + ub, ub)
				until (Storage[string.lower(tbl[el][temp_idx+1]["short"])] == 1 or count > 10)
				if count > ub then -- inf loop detected!
					Storage[el]["idx"] = math.fmod(Storage[el]["idx"] + delta + ub, ub)
				else
					Storage[el]["idx"] = math.fmod(temp_idx + ub, ub)
				end

				sel_img = tbl[el][Storage[el]["idx"]+1]["img"]
				sel_name = tbl[el][Storage[el]["idx"]+1]["name"]
				sel_short = string.lower(tbl[el][Storage[el]["idx"]+1]["short"])

				btn:SetAttribute("spell", sel_name);

				t:SetTexture(sel_img)
				Storage[el]["name"] = sel_name
				Storage[el]["short"] = sel_short
				btn.text_name:SetText(sel_short)

				SetMacro(macroName)
				LumpaTotem_LoopTick()
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
				-- 	print("left button click")
				-- 	LumpaTotem_LoopTick()
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
	rootFrame = f;
	ResizeFrames()
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

	if Storage["stand"] == 1 then
		body = body .. "/stand\n"
	end

	if Storage["startattack"] == 1 then
		body = body .. "/startattack\n"
	end

	body = body .. "/castsequence "
	if Storage["reset"] ~= "" then
		body = body .. "reset=" .. Storage["reset"] .. " "
	end

	-- body = body .. "Stormstrike, "

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