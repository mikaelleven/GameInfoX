-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
GameInfoX = {}
 
-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
GameInfoX.name = "GameInfoTweak"
GameInfoX.version = "1.0"



function GameInfoX.sendMessage(message)
	if(CHAT_SYSTEM)	then
		CHAT_SYSTEM:AddMessage(message)
	end
end


function GameInfoX.MoveStop()
	-- -- der Anwender hat das Fenster verschoben - das merken wir uns
	-- GI.vars.offsetX = GameInfoXDisplay:GetLeft()
	-- GI.vars.offsetY = GameInfoXDisplay:GetTop()
end


function GameInfoX.SpaceInfoFade()
	-- if (GI.vars.SpaceInfo==false) then
	-- 	GameInfoXDisplayBag:SetAlpha(0)
	-- 	GameInfoXDisplayCount:SetAlpha(0)
	-- else
	-- 	GameInfoXDisplayBag:SetAlpha(1)
	-- 	GameInfoXDisplayCount:SetAlpha(1)
	-- end
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

--GI.Update2 = GI.Update


function GameInfoX.Update()
	--GI.Update2()

	--d(GetBagInfo(BAG_BANK))
	-- -- Nur ausführen, wenn Das AddON schon geladen ist
	if (GI.loaded == true) then
	-- 	-- Die Frequenz ein wenig herunterbremsen, sonst behindern wir das gesamte Spiel
		if (GI.UpdateThrottle("UpdateX", 400) == true) then
	-- 		local keybindIsHidden=ZO_KeybindStripControl:IsHidden()
	-- 		-- Das Fenster ausblenden, wenn die Oberfläche wegfaded
	-- 		if (keybindIsHidden == false) then
	-- 			GameInfoXDisplay:SetAlpha(0.0)
	-- 		else
	-- 			GameInfoXDisplay:SetAlpha(GI.vars.BuffTransparency)
	-- 		end
			local usedSlots, maxSlots=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BACKPACK)
			local usedBankSlots, maxBankSlots2=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BANK)
			local bankIcon, maxBankSlots = GetBagInfo(BAG_BANK)

			--[[
			local usedBankSlotsLabel = GameInfoX.vars.usedBankSlots

			if GameInfoX.vars.usedBankSlots == nil then
				usedBankSlotsLabel = "?"
			end

			if maxBankSlots2 > 0 then
				GameInfoX.vars.usedBankSlots = usedBankSlots
				--usedBankSlotsLabel = GameInfoX.vars.usedBankSlots
			end
			--]]
			
--local x = GetItemTotalCount(INVENTORY_BANK, 1)
--local x = GetItemName(BAG_BANK, 1)
local nUsed = 0
local itemCounter=0
		while (itemCounter < maxBankSlots) do
			if GetItemName(BAG_BANK, itemCounter) ~= "" then
				nUsed = nUsed + 1
			end
			itemCounter = itemCounter + 1
		end
--local x = GetSlotStackSize(INVENTORY_BANK, 2)


			--GameInfoDisplayCount:SetText(usedSlots.." / "..maxSlots)
			GameInfoXDisplayBankCount:SetText(nUsed .." / ".. maxBankSlots)
--GameInfoXDisplayBankCount:SetText(usedBankSlotsLabel .." / ".. maxBankSlots .. " / " .. nUsed)

			--GameInfoXDisplayBankCount:SetText("|cFFFFFF" .. usedBankSlotsLabel .." / ".. maxBankSlots .. "|r" .. " / " .. x)


							GameInfoDisplay:SetAlpha(GI.vars.BuffTransparency)
				GameInfoXDisplay:SetAlpha(0.5)
			--GameInfoXDisplayBankCount:SetAlpha(0.5)
			GameInfoDisplayBag:SetAlpha(0.5)
			GameInfoDisplayCount:SetAlpha(0.5)

			
	-- 		-- Kampfnachricht einblenden, wenn im Kampf und das auch gewünscht war
	-- 		if (IsUnitInCombat("player")==true) then
	-- 			if (GI.vars.ReportInCombat==true) then
	-- 				GameInfoXDisplayCombat:SetAlpha(1)
	-- 			end
	-- 		else
	-- 			GameInfoXDisplayCombat:SetAlpha(0)
	-- 		end
	-- 		-- Nachsehen, ob zeitgesteuerte Nachrichten in den Chat geschrieben werden sollen...
	-- 		GI.ProcessTimer()
	-- 		-- Loot ausgeben, wenn etwas aufgenommen wurde
	-- 		GI.sendQueuedLoot()
		end
	end
end



function GameInfoX.OnPlayerCombatState(event, inCombat)
  -- -- The ~= operator is "not equal to" in Lua.
  -- if inCombat ~= GameInfoX.inCombat then
  --   -- The player's state has changed. Update the stored state...
  --   GameInfoX.inCombat = inCombat
 
  --   -- ...and then announce the change.
  --   if inCombat then
  --     d("Entering combat.")
  --   else
  --     d("Exiting combat.")
  --   end
 
  -- end
end


-- Next we create a function that will initialize our addon
function GameInfoX:Initialize()
  -- ...but we don't have anything to initialize yet. We'll come back to this.
    --self.inCombat = IsUnitInCombat("player")


 GameInfoXDisplayBank:SetTexture("ESOUI/art/icons/servicemappins/servicepin_bank.dds")
 --GameInfoXDisplayBank:SetTexture("ESOUI/art/mappins/minimap_bank.dds")
 --GameInfoXDisplayBank:SetTexture("/esoui/art/menubar/menubar_inventory_over.dds")


GameInfoX.defaults = {
			SpaceInfo=true,
			LockWindowPosition=false,
			InventoryTransparency=80,
			InventoryColor="C5C29EFF",
		}

--GameInfoX.vars = ZO_SavedVars:NewAccountWide("GIXVars", 2, nil, GameInfoX.defaults)



--  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)

  d(GameInfoX.name .. " " .. GameInfoX.version .. " loaded!")

--  CHAT_SYSTEM:AddMessage('GameInfoX " .. GameInfoX.version .. " loaded!')

  --d(GetBagInfo(BAG_BANK))

local usedBankSlots, maxBankSlots=PLAYER_INVENTORY:GetNumSlots(INVENTORY_BANK)
 
--d("BANK INFO: " .. usedBankSlots .. " / " .. maxBankSlots)
  

  --CHAT_SYSTEM:AddMessage(GetMaxBags())



--[[
	ZO_PreHookHandler(ZO_GameMenu_InGame, 'OnShow', function()
        self.control:SetHidden(true)
    end)
    ZO_PreHookHandler(ZO_GameMenu_InGame, 'OnHide', function()
        self.control:SetHidden(false)
    end)
    ZO_PreHookHandler(ZO_InteractWindow, 'OnShow', function()
        self.control:SetHidden(true)
    end)
    ZO_PreHookHandler(ZO_InteractWindow, 'OnHide', function()
        self.control:SetHidden(false)
    end)
    ZO_PreHookHandler(ZO_KeybindStripControl, 'OnShow', function()
        self.control:SetHidden(true)
    end)
    ZO_PreHookHandler(ZO_KeybindStripControl, 'OnHide', function()
        self.control:SetHidden(false)
    end)
--]]


end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function GameInfoX.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == GameInfoX.name then
    GameInfoX:Initialize()
  end
end
 
-- Finally, we'll register our eventsent handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_ADD_ON_LOADED, GameInfoX.OnAddOnLoaded)
--EVENT_MANAGER:RegisterForEvent(GameInfoX.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, GameInfoX.LootMessage)



--[[
--Регистрация эвентов
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_OPEN_BANK, MB.PL_Opened)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_CLOSE_BANK, MB.PL_Closed)
	-- EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_OPEN_GUILD_BANK, MB.GB_Opened)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_GUILD_BANK_ITEMS_READY, MB.GB_Ready)
	
	

	-- Registering Events 

	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_LOOT_RECEIVED, MB.LootRecieved)
  EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, MB.SavePlayerInvent)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_CLOSE_BANK, MB.SavePlayerInvent)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_CLOSE_STORE,  MB.SavePlayerInvent)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_MONEY_UPDATE , MB.SavePlayerInvent)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_CLOSE_GUILD_BANK, MB.SavePlayerInvent)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_END_CRAFTING_STATION_INTERACT, MB.SavePlayerInvent)
	EVENT_MANAGER:RegisterForEvent("MobileBank", EVENT_MAIL_CLOSE_MAILBOX , MB.SavePlayerInvent)

--]]


