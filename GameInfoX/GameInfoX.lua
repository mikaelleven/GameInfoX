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
if not GameInfoX then GameInfoX = {} end 

GameInfoX.Addon = {
	Name = "GameInfoX",
	Title = "GameInfo eXtended",
	Version = "1.3",
	Author = "@w33zl",
	Description = ""
}

GameInfoX.DefaultSettings = {
	SpaceInfo = true,
	LockWindowPosition = false,
	InventoryTransparency = 80,
	InventoryColor = "C5C29EFF",
}
 
function GameInfoX.MoveStop()
end

function GameInfoX.WarnNumberAndColorizeText(text, number, warnTreshold, criticalTreshold)
end

function GameInfoX.Update()
	

	if (GI.loaded == true) then
		if (GI.UpdateThrottle("UpdateX", 800) == true) then
			GI.Update()
			local usedSlots, maxSlots=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BACKPACK)
			--local usedBankSlots, maxBankSlots2=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BANK)
			local maxBankSlots = GetBagSize(BAG_BANK)

			local numberOfUsedBankSlots = GetNumBagUsedSlots(BAG_BANK)
			-- local itemCounter=0
			-- while (itemCounter < maxBankSlots) do
			-- 	if GetItemName(BAG_BANK, itemCounter) ~= "" then
			-- 		numberOfUsedBankSlots = numberOfUsedBankSlots + 1
			-- 	end
			-- 	itemCounter = itemCounter + 1
			-- end

-- v1.3 fix
-- GetNumBagFreeSlots
-- GetNumBagUsedSlots
-- GetItemLinkName
-- GetBagSize


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
				bankSlotText =  GI.ColorStart(bankColor) .. numberOfUsedBankSlots .. "|r"
			end

			local bagSlotText
			if bagColor == nil then
				bagSlotText = usedSlots
			else
				bagSlotText =  GI.ColorStart(bagColor) .. usedSlots .. "|r"
			end

			GameInfoXDisplayBankCount:SetText(bankSlotText .. " / ".. maxBankSlots)
			GameInfoDisplayCount:SetText(bagSlotText .. " / ".. maxSlots)

			GameInfoXDisplay:SetAlpha(0.5)
			GameInfoDisplay:SetAlpha(0.5)

		end
	end
end

-- Next we create a function that will initialize our addon
function GameInfoX:Initialize()
	-- Initialize bank icon
 	GameInfoXDisplayBank:SetTexture("ESOUI/art/icons/servicemappins/servicepin_bank.dds")

 	-- Override original update handler from GameInfo to be able to adjust some behaviors
 	GameInfoDisplay:SetHandler("OnUpdate", GameInfoX.Update)

 	-- We are all set!
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

