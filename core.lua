local LumpaTotem = LibStub("AceAddon-3.0"):NewAddon("LumpaTotem")
local addonName, addon = ...

local macroName = "LumpaTotem"
local sel_totems = {}
local combat = false

local tbl = {
	earth = {
		{
			name = "Earthbind Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_earthbind.tga"
		},
		{
			name = "Stoneskin Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_stoneskin.tga"
		},
		{
			name = "Stoneclaw Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_stoneclaw.tga"
		},
		{
			name = "Strength of Earth Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_strengthofearth.tga"
		},
		{
			name = "Tremor Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_tremor.tga"
		},
		{
			name = "Earth Elemental Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\earth_earthelemental.tga"
		}
	},
	fire = {
		{
			name = "Searing Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_searing.tga"
		},
		{
			name = "Fire Elemental Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_fireelemental.tga"
		},
		{
			name = "Fire Nova Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_firenova.tga"
		},
		{
			name = "Flametongue Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_flametongue.tga"
		},
		{
			name = "Frost Resistance Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_frostres.tga"
		},
		{
			name = "Magma Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_magma.tga"
		},
		{
			name = "Totem of Wrath",
			img = "Interface\\Addons\\LumpaTotem\\img\\fire_totemofwrath.tga"
		}
	},
	water = {
		{
			name = "Healing Stream Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_healingstream.tga"
		},
		{
			name = "Mana Spring Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_manaspring.tga"
		},
		{
			name = "Poison Cleansing Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_poison.tga"
		},
		{
			name = "Disease Cleansing Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_disease.tga"
		},
		{
			name = "Mana Tide Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_manatide.tga"
		},
		{
			name = "Fire Resistance Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\water_fireres.tga"
		}
	},
	air = {
		{
			name = "Grace of Air Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_grace.tga"
		},
		{
			name = "Windfury Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_windfury.tga"
		},
		{
			name = "Grounding Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_grounding.tga"
		},
		{
			name = "Windwall Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_windwall.tga"
		},
		{
			name = "Sentry Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_sentry.tga"
		},
		{
			name = "Nature Resistance Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_natureres.tga"
		},
		{
			name = "Tranquil Air Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_tranquil.tga"
		},
		{
			name = "Wrath of Air Totem",
			img = "Interface\\Addons\\LumpaTotem\\img\\air_wrathofair.tga"
		}
	}
}
local earth_index = 0

local function addEventListeners(self)
	print("adding event listeners")
	addon.core.frame:RegisterEvent("WHO_LIST_UPDATE")
	addon.core.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	addon.core.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function onEvent(self, event, ...)
	local args = {...}

	-- if event == "WHO_LIST_UPDATE" then
	-- 	print("WHO_LIST_UPDATE");
	-- 	SetMacro(macroName, "test")
	-- end
	if event == "PLAYER_REGEN_DISABLED" then
		combat = true
		print("enter combat")
	elseif event == "PLAYER_REGEN_ENABLED" then
		combat = false
		print("leave combat")
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
		Storage = {
			earth = {
				idx = 0,
				name = "a"
			},
			fire = {
				idx = 0,
				name = "a"
			},
			water = {
				idx = 0,
				name = "a"
			},
			air = {
				idx = 0,
				name = "a"
			}
		}
	end
	CreateTotemBarFrame()

end

function LumpaTotem_OnLoad()
	print("on load");
end
function CreateTotemBarFrame()
	local f = CreateFrame("Frame",nil,UIParent)
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(256)
	f:SetHeight(64)

	local elements = {"earth", "water", "fire", "air"}
	-- local elements_idx = {"earth_index", "water_index", "fire_index", "air_index"}

	-- for i=1,4 do
	for i,v in ipairs(elements) do
		local btn = CreateFrame("Button", f, UIParent)
		btn:SetFrameStrata("BACKGROUND")
		btn:SetWidth(64)
		btn:SetHeight(64)
		btn:SetPoint("TOPLEFT", 64*(i-1), 0)
		btn:Show()

		local t = btn:CreateTexture(nil, "BACKGROUND")
		-- local stored_name = Storage[v]["name"]
		local stored_idx = Storage[v]["idx"]

		t:SetTexture(tbl[v][stored_idx+1]["img"])
		t:SetAllPoints(btn)
		btn.texture = t

		btn:SetScript("OnMouseWheel", function(self, delta)
			if combat == false then
				el = v
				-- print("   el", el)
				local ub = table.getn(tbl[el])
				-- Storage[el_idx] = Storage[el_idx] + delta
				Storage[el]["idx"] = Storage[el]["idx"] + delta
				-- Storage[el_idx] = math.fmod(Storage[el_idx] + ub, ub)
				Storage[el]["idx"] = math.fmod(Storage[el]["idx"] + ub, ub)
				-- idx = Storage[el_idx] + 1
				idx = Storage[el]["idx"] + 1
				-- sel_img = tbl[el][idx]["img"]
				sel_img = tbl[el][idx]["img"]
				-- sel_name = tbl[el][idx]["name"]
				sel_name = tbl[el][idx]["name"]
				-- print("sel_name ", sel_name)

				t:SetTexture(sel_img)
				-- sel_totems[i] = sel_name
				-- Storage[el]["idx"] = 
				Storage[el]["name"] = sel_name

				SetMacro(macroName)
			end
		end)
	end


	f:SetPoint("CENTER",0,0)
	f:Show()
end

-- function SetMacro(name, earthTotem, fireTotem, airTotem, waterTotem)
function SetMacro(name)
	_name, _, _, _ = GetMacroInfo(name)
	local body = "/startattack\n/castsequence " .. Storage["earth"]["name"] .. ", " .. Storage["water"]["name"] .. ", " .. Storage["fire"]["name"] .. ", " .. Storage["air"]["name"];
	if _name == nil then -- macro do not exist, create it
		local macroId = CreateMacro(name, "INV_MISC_QUESTIONMARK", body, 1);
	else
		EditMacro(name, nil, nil, body);
	end
end