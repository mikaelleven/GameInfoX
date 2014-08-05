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
	Version = "1.2",
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

--[[function GameInfoX.LootMessage(eventId, bagId, slotId, isNewItem, itemSoundCategory, updateReason)
	if (GI.loaded == true) then
		if(GI.vars.LootMsg==true) then
			d("Looot!")
			--d("LootMsg EventID:" .. eventId .. ", isNewItem:" .. isNewItem .. ", updateReason:" .. updateReason)
			d("event:" .. eventId)
			d(isNewItem)
			d("reason:" .. updateReason)
			if (isNewItem==true) then
				GI.QueuedLootindex=GI.QueuedLootindex+1
				GI.QueuedLoot[GI.QueuedLootindex]=GI.strStrip(GetItemLink(bagId, slotId,LINK_STYLE_BRACKETS))
			end
		end
	end
end--]]

function GameInfoX.WarnNumberAndColorizeText(text, number, warnTreshold, criticalTreshold)
end

function GameInfoX.Update()
	

	if (GI.loaded == true) then
		if (GI.UpdateThrottle("UpdateX", 800) == true) then
			GI.Update()
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

			local warnThreshold = 5
			local defaultColor = "FFFFFF" --GI.vars.ColorLoot
			
			local bankColor
			if numberOfUsedBankSlots == maxBankSlots then
				--bankColor = "DD8C8C"
				bankColor = "C08C8B"
			elseif (maxBankSlots - numberOfUsedBankSlots ) <= warnThreshold then
				--bankColor = "D9C66F"
				bankColor = "B5AB7B"
			end

			local bagColor
			if usedSlots == maxSlots then
				--bagColor = "DD8C8C"
				bagColor = "C08C8B"
			elseif (maxSlots - usedSlots ) <= warnThreshold then
				--bagColor = "D9C66F"
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


bagSlotText = usedSlots
GameInfoDisplayCount:SetTextColor("FFFFFF")



			GameInfoXDisplayBankCount:SetText(bankSlotText .. " / ".. maxBankSlots)
			--GameInfoXDisplayBankCount:SetText(usedBankSlotsLabel .." / ".. maxBankSlots .. " / " .. nUsed)
			--GameInfoXDisplayBankCount:SetText("|cFFFFFF" .. usedBankSlotsLabel .." / ".. maxBankSlots .. "|r" .. " / " .. x)
			GameInfoDisplayCount:SetText(bagSlotText .. " / ".. maxSlots)

			GameInfoXDisplay:SetAlpha(0.5)
			--GameInfoDisplayBag:SetAlpha(0.5)
			--GameInfoXDisplayBankCount:SetAlpha(0.7)
			--GameInfoDisplayCount:SetAlpha(0.7)
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


--[[

EVENT_MANAGER:RegisterForEvent(wykkydsFramework.AddonID, EVENT_LOOT_RECEIVED, function(numID, lootedBy, itemName, quantity, itemSound, lootType, self)
	if WF_SavedVars.LootNotice["Enabled"] then
		if self then
			d( "|c32DF41Loot Received: [ |r" .. itemName:gsub("%^%a+","") .. "|c32DF41 ] x " .. quantity .."|r" )
		end
	end
end)
EVENT_MANAGER:RegisterForEvent(wykkydsFramework.AddonID, EVENT_MONEY_UPDATE, function()
	if WF_SavedVars.GoldNotice["Enabled"] then
		local nowMoney = GetCurrentMoney()
		if WF_SavedVars.GoldNotice["Scroll"] then
			if nowMoney > wykkydsFramework.Money then
				wykkydsFramework.ScrollFrames.Add( "+ " .. (nowMoney - wykkydsFramework.Money) .. " gold", "CENTER", {.5, 1, .5, 1} )
			elseif wykkydsFramework.Money > nowMoney then
				wykkydsFramework.ScrollFrames.Add( "- " .. (wykkydsFramework.Money - nowMoney) .. " gold", "CENTER", {1, .5, .5, 1} )
			end
		else
			if nowMoney > wykkydsFramework.Money then
				d( "|c32DF41Received Gold: " .. (nowMoney - wykkydsFramework.Money) .."|r" )
			elseif wykkydsFramework.Money > nowMoney then
				d( "|cDF3241Spent Gold: " .. (wykkydsFramework.Money - nowMoney) .."|r" )
			end
		end
	end
	wykkydsFramework.Money = GetCurrentMoney()
end)


--]]


