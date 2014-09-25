-------------------------------------------------------------------------------
-- Title: w33zl's GameInfo (former 'GameInfo eXtended'						  -
-- Author: @w33zl															  -
-- Description: Extends and tweaks the behavior of the GameInfo addon		  -
-------------------------------------------------------------------------------
-- This Add-on is not created by, affiliated with or sponsored by ZeniMax 	  -
-- Media Inc. or its affiliates. The Elder Scrolls® and related logos are 	  -
-- registered trademarks or trademarks of ZeniMax Media Inc. in the United	  - 
-- States and/or other countries. All rights reserved.						  -
-------------------------------------------------------------------------------


-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
if not GameInfoX then GameInfoX = {} end 

GameInfoX.Addon = {
	Name = "GameInfoX",
	Title = "w33zl's GameInfo",
	Version = "1.6.1",
	Author = "@w33zl",
	Description = ""
}

GameInfoX.DefaultSettings = {
	SpaceInfo = true,
	LockWindowPosition = false,
	InventoryTransparency = 50,
	InventoryColor = "C5C29EFF",
	PositionX = 20,
	PositionY = 200
}
 
function GameInfoX.MoveStop()
	GameInfoX.Settings.PositionX = GameInfoXDisplay:GetLeft()
	GameInfoX.Settings.PositionY = GameInfoXDisplay:GetTop()
end

function GameInfoX.WarnNumberAndColorizeText(text, number, warnTreshold, criticalTreshold)
end

function GameInfoX:HideUI()
	if not GameInfoXDisplay:IsHidden() then
		GameInfoXDisplay:SetHidden(true)
	end
end

function GameInfoX:ShowUI()
	if GameInfoXDisplay:IsHidden() then
		GameInfoXDisplay:SetHidden(false)
	end
end

function GameInfoX:DoRefresh()
	
	if GameInfoX.ShouldBeHidden() then
		GameInfoX:HideUI()
		return
	else
		GameInfoX:ShowUI()
	end

	local usedSlots, maxSlots=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BACKPACK)
	local maxBankSlots = GetBagSize(BAG_BANK)
	local numberOfUsedBankSlots = GetNumBagUsedSlots(BAG_BANK)

	local warnThreshold = 5
	local defaultColor = "FFFFFF" --GI.vars.ColorLoot
	
	local bankColor
	if numberOfUsedBankSlots == maxBankSlots then
		bankColor = "C08C8B"
	elseif (maxBankSlots - numberOfUsedBankSlots ) <= warnThreshold then
		bankColor = "B5AB7B"
	end

	local bagColor
	if usedSlots == maxSlots then
		bagColor = "C08C8B"
	elseif (maxSlots - usedSlots ) <= warnThreshold then
		bagColor = "B5AB7B"
	end

	local bankSlotText
	if bankColor == nil then
		bankSlotText = numberOfUsedBankSlots
	else
		bankSlotText =  "|c" .. bankColor .. numberOfUsedBankSlots .. "|r"
	end

	local bagSlotText
	if bagColor == nil then
		bagSlotText = usedSlots
	else
		bagSlotText =  "|c" .. bagColor .. usedSlots .. "|r"
	end

	GameInfoXDisplayBankCount:SetText(bankSlotText .. " / ".. maxBankSlots)
	GameInfoXDisplayCount:SetText(bagSlotText .. " / ".. maxSlots)

	GameInfoXDisplay:SetAlpha(0.5)
end

function GameInfoX:Initialize()

	GameInfoX.Settings = ZO_SavedVars:New("GIX_Config", 1, nil, GameInfoX.DefaultSettings)

	if GameInfoX.Settings.PositionX and GameInfoX.Settings.PositionY then
		GameInfoXDisplay:ClearAnchors()
		GameInfoXDisplay:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, GameInfoX.Settings.PositionX, GameInfoX.Settings.PositionY)
		GameInfoXDisplay:SetMovable(true)
	end

 	-- We are all set!
	d(GameInfoX.Addon.Name .. " " .. GameInfoX.Addon.Version .. " loaded!")

	EVENT_MANAGER:RegisterForUpdate("GameInfoX_Update",500,function() GameInfoX:DoRefresh() end)
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function GameInfoX.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == GameInfoX.Addon.Name then
    GameInfoX:Initialize()
  end
end

--- Check to see if lockpicking window is enabled
function GameInfoX.ShouldBeHidden()
	if not LOCK_PICK["control"]:IsHidden() then return true end
	return false
end

function GameInfoX.OnGuiHidden(eventCode, guiName, hidden)
	--d("Gui hidden")
end

 
-- Finally, we'll register our event handler functions to be called when the proper events occurs.
EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_ADD_ON_LOADED, GameInfoX.OnAddOnLoaded)
-- EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_GUI_HIDDEN, GameInfoX.OnGuiHidden)
 

-- --EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, GameInfoX.LootMessage)
-- EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_BEGIN_LOCKPICK, function() 
-- 	--d("Begin lockpick")
-- end)

-- Register slash commands
SLASH_COMMANDS["/rl"] = function() ReloadUI("ingame") end
SLASH_COMMANDS["/mem"] = function() d(math.ceil(collectgarbage("count")).." KB") end
