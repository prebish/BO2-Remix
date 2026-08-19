require("T6.Menus.PrivateGameLobby")
CoD.PrivateOnlineGameLobby = {}
LUI.createMenu.PrivateOnlineGameLobby = function(f1_arg0)
	local f1_local0 = CoD.PrivateGameLobby.New("PrivateOnlineGameLobby", f1_arg0)

	if CoD.isMultiplayer then
		f1_local0:setPreviousMenu("MainLobby")
	end

	local f1_local1 = Engine.Localize("MPUI_CUSTOM_GAMES_CAPS")

	if CoD.isZombie and UIExpression.DvarBool(nil, "party_solo") == 1 then
		f1_local1 = Engine.Localize("ZMUI_SOLO_PLAY_CAPS")
	end

	f1_local0:addTitle(f1_local1)
	f1_local0.panelManager.panels.buttonPane.titleText = f1_local1

	if UIExpression.DvarString(nil, "ui_gametype_pro_lobby") ~= "" then
		Engine.SetDvar("ui_gametype_pro", UIExpression.DvarString(nil, "ui_gametype_pro_lobby"))
		Engine.SetDvar("ui_gametype_pro_lobby", "")
	end

	-- Solo used to be snapped back to Survival here whenever the selected mode was
	-- an encounter one, which would have quietly undone any Grief, Meat or Turned
	-- pick on the way back into the lobby. The mode list offers them to a solo
	-- player, so the lobby keeps whatever was chosen.
	if UIExpression.DvarBool(nil, "party_solo") == 1 then
		Engine.PartySetMaxPlayerCount(1)
	end

	return f1_local0
end

CoD.PrivateGameLobby.PopulateButtonPrompts = function(PrivateGameLobbyWidget)
	if PrivateGameLobbyWidget.friendsButton ~= nil then
		PrivateGameLobbyWidget.friendsButton:close()
		PrivateGameLobbyWidget.friendsButton = nil
	end

	if PrivateGameLobbyWidget.partyPrivacyButton ~= nil then
		PrivateGameLobbyWidget.partyPrivacyButton:close()
		PrivateGameLobbyWidget.partyPrivacyButton = nil
	end

	if UIExpression.SessionMode_IsSystemlinkGame() == 0 and Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
		PrivateGameLobbyWidget:addFriendsButton()
	end

	if Engine.GameModeIsMode(CoD.GAMEMODE_THEATER) == false then
		CoD.PrivateGameLobby.PopulateButtonPrompts_Project(PrivateGameLobbyWidget)
	end

	if UIExpression.SessionMode_IsSystemlinkGame() == 0 then
		if UIExpression.DvarBool(nil, "party_solo") == 0 then
			PrivateGameLobbyWidget:addPartyPrivacyButton()
		end

		PrivateGameLobbyWidget:addNATType()
	end
end

CoD.PrivateGameLobby.ShouldDisableStartButton_Zombie = function(StartMatchButton, ClientInstance)
	local DisableStartButton = false
	local GamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
	local Gametype = UIExpression.DvarString(nil, "ui_gametype")
	local PartyPlayerCount = Engine.PartyGetPlayerCount()

	-- Not every game mode fills in all of these limits - the team pair in particular
	-- is missing for some - and the unguarded lookups this replaced took the lobby
	-- down with "nil < number" the moment such a mode was picked. Read them once.
	local Limits = CoD.Zombie.GameTypeGroups[Gametype] or {}
	local MaxPlayers = Limits.maxPlayers or 8
	local MaxTeamPlayers = Limits.maxTeamPlayers or 4

	-- The minimums are deliberately not taken from the table. Grief, Meat and Turned
	-- ask for two players, which would leave the start button permanently dead for a
	-- solo host now that every mode is offered. Solo means no opponent to play
	-- against, not a match the lobby should refuse to start.
	local MinPlayers = 1
	local MinTeamPlayers = 0

	local TeamCount = Engine.GetGametypeSetting("teamCount") or 1

	if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == true and PartyPlayerCount > 2 then
		if true == Dvar.r_dualPlayEnable:get() then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_DUALVIEW_DISABLED_DESC", MaxPlayers)
		elseif true == Dvar.r_stereo3DOn:get() then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_STEREOSCOPIC3D_DISABLED_DESC", MaxPlayers)
		else
			StartMatchButton.hintText = Engine.Localize("MPUI_START_MATCH_DESC")
		end

		if DisableStartButton == true then
			return DisableStartButton
		end
	end

	if TeamCount > 1 then
		local PartyTeamAlliesCount = Engine.PartyGetTeamMemberCount(CoD.TEAM_ALLIES)
		local PartyTeamAxisCount = Engine.PartyGetTeamMemberCount(CoD.TEAM_AXIS)

		if PartyTeamAlliesCount > MaxTeamPlayers or PartyTeamAxisCount > MaxTeamPlayers then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MAX_TEAM_PLAYERS_DESC", MaxTeamPlayers)
		elseif PartyTeamAlliesCount < MinTeamPlayers or PartyTeamAxisCount < MinTeamPlayers then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MIN_TEAM_PLAYERS_DESC")
		else
			StartMatchButton.hintText = Engine.Localize("MPUI_START_MATCH_DESC")
		end
	elseif PartyPlayerCount > MaxPlayers then
		DisableStartButton = true
		StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MAX_TOTAL_PLAYERS_DESC", MaxPlayers)
	elseif PartyPlayerCount < MinPlayers then
		DisableStartButton = true
		StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MIN_TOTAL_PLAYERS_DESC", MinPlayers)
	else
		StartMatchButton.hintText = Engine.Localize("MPUI_START_MATCH_DESC")
	end

	return DisableStartButton
end
