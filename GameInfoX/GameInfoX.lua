-------------------------------------------------------------------------------
-- Title: GameInfo eXtended													  -
-- Author: @w33zl															  -
-- Description: Extends and tweaks the behavior of the GameInfo addon		  -
-------------------------------------------------------------------------------
-- This Add-on is not created by, affiliated with or sponsored by ZeniMax 	  -
-- Media Inc. or its affiliates. The Elder Scrolls® and related logos are 	  -
-- registered trademarks or trademarks of ZeniMax Media Inc. in the United	  - 
-- States and/or other countries. All rights reserved.						  -
-------------------------------------------------------------------------------

-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
GameInfoX = {}

GameInfoX.Addon = {
	Name = "GameInfoX",
	Title = "GameInfo eXtended",
	Version = "1.0",
	Author = "@w33zl",
	Description = ""
}

GameInfoX.DefaultSettings = {
	SpaceInfo = true,
	LockWindowPosition = false,
	InventoryTransparency = 80,
	InventoryColor = "C5C29EFF",
}
 
--[[
GameInfoX.name = "GameInfoX"
GameInfoX.version = "1.0"
GameInfoX.description = ""
GameInfoX.author = "@w33zl"
--]]



function GameInfoX.MoveStop()
end

function GameInfoX.LootMessage(eventId, bagId, slotId, isNewItem, itemSoundCategory, updateReason)
	-- if (GI.loaded == true) then
	-- 	if(GI.vars.LootMsg==true) then
	-- 		if (isNewItem==true) then
	-- 			GI.QueuedLootindex=GI.QueuedLootindex+1
	-- 			GI.QueuedLoot[GI.QueuedLootindex]=GI.strStrip(GetItemLink(bagId, slotId,LINK_STYLE_BRACKETS))
	-- 		end
	-- 	end
	-- end
end

function GameInfoX.WarnNumberAndColorizeText(text, number, warnTreshold, criticalTreshold)
end

function GameInfoX.Update()
	if (GI.loaded == true) then
		if (GI.UpdateThrottle("UpdateX", 400) == true) then
			local usedSlots, maxSlots=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BACKPACK)
			local usedBankSlots, maxBankSlots2=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BANK)
			local bankIcon, maxBankSlots = GetBagInfo(BAG_BANK)

			local numberOfUsedBankSlots = 0
			local itemCounter=0
			while (itemCounter < maxBankSlots) do
				if GetItemName(BAG_BANK, itemCounter) ~= "" then
					numberOfUsedBankSlots = numberOfUsedBankSlots + 1
				end
				itemCounter = itemCounter + 1
			end
			GameInfoXDisplayBankCount:SetText(numberOfUsedBankSlots .." / ".. maxBankSlots)
			--GameInfoXDisplayBankCount:SetText(usedBankSlotsLabel .." / ".. maxBankSlots .. " / " .. nUsed)
			--GameInfoXDisplayBankCount:SetText("|cFFFFFF" .. usedBankSlotsLabel .." / ".. maxBankSlots .. "|r" .. " / " .. x)

			GameInfoXDisplay:SetAlpha(0.5)
			GameInfoDisplayBag:SetAlpha(0.5)
			GameInfoDisplayCount:SetAlpha(0.5)

		end
	end
end

-- Next we create a function that will initialize our addon
function GameInfoX:Initialize()
 	GameInfoXDisplayBank:SetTexture("ESOUI/art/icons/servicemappins/servicepin_bank.dds")


	d(GameInfoX.Addon.Name .. " " .. GameInfoX.Addon.Version .. " loaded!")
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function GameInfoX.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == GameInfoX.Addon.Name then
    GameInfoX:Initialize()
  end
end
 
-- Finally, we'll register our event handler functions to be called when the proper events occurs.
EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_ADD_ON_LOADED, GameInfoX.OnAddOnLoaded)
--EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, GameInfoX.LootMessage)
