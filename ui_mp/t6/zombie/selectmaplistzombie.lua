require("T6.Lobby")
require("T6.Menus.PopupMenus")
require("T6.ListBox")

CoD.SelectMapListZombie = {}
CoD.SelectMapListZombie.GameModes = {}
CoD.SelectMapListZombie.GameModes[1] = {
	ui_zm_gamemodegroup = "zclassic",
	ui_gametype = "zclassic",
}
CoD.SelectMapListZombie.GameModes[2] = {
	ui_zm_gamemodegroup = "zsurvival",
	ui_gametype = "zstandard",
}
CoD.SelectMapListZombie.GameModes[3] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zgrief",
}
CoD.SelectMapListZombie.GameModes[4] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zmeat",
}
CoD.SelectMapListZombie.GameModes[5] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zturned",
}
CoD.SelectMapListZombie.Maps = {}
CoD.SelectMapListZombie.Maps[1] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "transit",
}
CoD.SelectMapListZombie.Maps[2] = {
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "rooftop",
}
CoD.SelectMapListZombie.Maps[3] = {
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "processing",
}
CoD.SelectMapListZombie.Maps[4] = {
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "prison",
}
CoD.SelectMapListZombie.Maps[5] = {
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "tomb",
}
-- Which game modes each start location actually supports. Taken from the
-- add_map_location_gamemode calls in scripts/zm/replaced/*_gamemodes.gsc,
-- which are what decide at runtime whether a location will load at all.
--
-- Meat registers nothing of its own: zencounter_reimagined redirects
-- zmeat::main to zgrief::main, so Meat runs exactly where Grief runs.
-- Turned is the reverse - Buried Street is the only place it is wired up.
local SurvivalModes = {
	zstandard = true,
	zgrief = true,
	zmeat = true,
}
local EncounterModes = {
	zgrief = true,
	zmeat = true,
	zturned = true,
}
CoD.SelectMapListZombie.Locations = {}
CoD.SelectMapListZombie.Locations[1] = {
	ui_mapname = "zm_nuked",
	ui_zm_mapstartlocation = "nuked",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[2] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "transit",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[3] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "diner",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[4] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "farm",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[5] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "power",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[6] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "town",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[7] = {
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "shopping_mall",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[8] = {
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "dragon_rooftop",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[9] = {
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "street",
	gametypes = EncounterModes,
}
CoD.SelectMapListZombie.Locations[10] = {
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "cellblock",
	gametypes = SurvivalModes,
}
CoD.SelectMapListZombie.Locations[11] = {
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "church",
	gametypes = SurvivalModes,
}

CoD.SelectMapListZombie.locationsByGametype = {}

CoD.SelectMapListZombie.GetLocationsForGametype = function(gametype)
	local cached = CoD.SelectMapListZombie.locationsByGametype[gametype]
	if cached ~= nil then
		return cached
	end

	local list = {}

	for i, v in ipairs(CoD.SelectMapListZombie.Locations) do
		if v.gametypes[gametype] == true then
			list[#list + 1] = v
		end
	end

	if #list == 0 then
		list = CoD.SelectMapListZombie.Locations
	end

	CoD.SelectMapListZombie.locationsByGametype[gametype] = list

	return list
end

CoD.SelectMapListZombie.GetKeyValueIndex = function(table, key, value)
	for i, v in ipairs(table) do
		if v[key] == value then
			return i
		end
	end

	return 1
end

local function gameModeListSelectionClickedEventHandler(self, event)
	local index = self.listBox:getFocussedIndex()

	if index ~= nil then
		local prevTeamCount = Engine.GetGametypeSetting("teamCount")

		local gameTable = CoD.SelectMapListZombie.GameModes

		Engine.SetDvar("ui_zm_gamemodegroup", gameTable[index].ui_zm_gamemodegroup)
		Engine.SetGametype(gameTable[index].ui_gametype)

		if gameTable[index].ui_zm_gamemodegroup ~= "zencounter" then
			Engine.SetDvar("ui_gametype_pro", 0)
		end

		-- Nothing is written to this profile key until a map has been picked at
		-- least once, so it can come back empty. Both lookups below treat a nil
		-- as "not in the list" and fall through to the first entry.
		local profileMap = UIExpression.ProfileValueAsString(self.controller, CoD.profileKey_map)
		local map, location

		if type(profileMap) == "string" then
			map, location = string.match(profileMap, "(.*) (.*)")
		end

		local mapTable = {}
		local mapIndex = 1

		if gameTable[index].ui_gametype == "zclassic" then
			mapTable = CoD.SelectMapListZombie.Maps
			mapIndex = CoD.SelectMapListZombie.GetKeyValueIndex(mapTable, "ui_mapname", map)
		else
			-- The new mode may not support the location that was selected under the
			-- old one, in which case GetKeyValueIndex drops us on its first entry.
			mapTable = CoD.SelectMapListZombie.GetLocationsForGametype(gameTable[index].ui_gametype)
			mapIndex = CoD.SelectMapListZombie.GetKeyValueIndex(mapTable, "ui_zm_mapstartlocation", location)
		end

		Engine.SetDvar("ui_mapname", mapTable[mapIndex].ui_mapname)
		Engine.SetDvar("ui_zm_mapstartlocation", mapTable[mapIndex].ui_zm_mapstartlocation)

		Engine.SetProfileVar(self.controller, CoD.profileKey_gametype, gameTable[index].ui_gametype)

		Engine.CommitProfileChanges(self.controller)

		local currTeamCount = Engine.GetGametypeSetting("teamCount")

		if currTeamCount ~= prevTeamCount then
			Engine.PartyHostReassignTeams()
		end
	end

	Engine.PartyHostClearUIState()

	self.occludedMenu:swapMenu("PrivateOnlineGameLobby", self.controller)
	self:goBack(self.controller)
end

local function gameModeListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function gameModeListGetButtonData(controller, index, mutables, self)
	if CoD.SelectMapListZombie.GameModes[index].ui_gametype == "zclassic" then
		mutables.text:setText(UIExpression.ToUpper(nil, Engine.Localize("MPUI_ZCLASSIC")))
	else
		mutables.text:setText(Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 0, 1, CoD.SelectMapListZombie.GameModes[index].ui_gametype, 2)))
	end
end

function LUI.createMenu.SelectGameModeListZM(controller)
	local self = CoD.Menu.New("SelectGameModeListZM")
	self.controller = controller

	self:addLargePopupBackground()
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_CHANGE_GAME_MODE_CAPS"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, gameModeListCreateButtonMutables, gameModeListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()

	local index = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.GameModes, "ui_gametype", UIExpression.DvarString(nil, "ui_gametype"))

	listBox:setTotalItems(#CoD.SelectMapListZombie.GameModes, index)

	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("click", gameModeListSelectionClickedEventHandler)

	return self
end

local function mapListSelectionClickedEventHandler(self, event)
	local index = self.listBox:getFocussedIndex()

	if index ~= nil then
		local mapTable = CoD.SelectMapListZombie.Maps

		if UIExpression.DvarString(nil, "ui_gametype") ~= "zclassic" then
			mapTable = CoD.SelectMapListZombie.GetLocationsForGametype(UIExpression.DvarString(nil, "ui_gametype"))
		end

		Engine.SetDvar("ui_mapname", mapTable[index].ui_mapname)
		Engine.SetDvar("ui_zm_mapstartlocation", mapTable[index].ui_zm_mapstartlocation)

		Engine.SetProfileVar(self.controller, CoD.profileKey_map, mapTable[index].ui_mapname .. " " .. mapTable[index].ui_zm_mapstartlocation)

		Engine.CommitProfileChanges(self.controller)
	end

	Engine.PartyHostClearUIState()

	self.occludedMenu:swapMenu("PrivateOnlineGameLobby", self.controller)
	self:goBack(self.controller)
end

local function mapListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function mapListGetButtonData(controller, index, mutables, self)
	if UIExpression.DvarString(nil, "ui_gametype") == "zclassic" then
		mutables.text:setText(CoD.GetZombieGameTypeDescription(CoD.Zombie.GAMETYPE_ZCLASSIC, CoD.SelectMapListZombie.Maps[index].ui_mapname))
	else
		local locations = CoD.SelectMapListZombie.GetLocationsForGametype(UIExpression.DvarString(nil, "ui_gametype"))
		mutables.text:setText(Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 5, 3, locations[index].ui_zm_mapstartlocation, 4)))
	end
end

function LUI.createMenu.SelectMapListZM(controller)
	local self = CoD.Menu.New("SelectMapListZM")
	self.controller = controller

	self:addLargePopupBackground()
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_CHANGE_MAP_CAPS"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, mapListCreateButtonMutables, mapListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()

	if UIExpression.DvarString(nil, "ui_gametype") == "zclassic" then
		local index = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.Maps, "ui_mapname", UIExpression.DvarString(nil, "ui_mapname"))
		listBox:setTotalItems(#CoD.SelectMapListZombie.Maps, index)
	else
		local locations = CoD.SelectMapListZombie.GetLocationsForGametype(UIExpression.DvarString(nil, "ui_gametype"))
		local index = CoD.SelectMapListZombie.GetKeyValueIndex(locations, "ui_zm_mapstartlocation", UIExpression.DvarString(nil, "ui_zm_mapstartlocation"))
		listBox:setTotalItems(#locations, index)
	end

	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("click", mapListSelectionClickedEventHandler)

	return self
end
