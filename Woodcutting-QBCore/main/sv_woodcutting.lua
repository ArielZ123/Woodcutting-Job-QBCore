local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('Woodcutting:Wood:Cut')
AddEventHandler('Woodcutting:Wood:Cut', function()
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local WoodCutQuantity = xPlayer.Functions.GetItemByName('wood')
    if WoodCutQuantity ~= nil then 
	    if WoodCutQuantity.amount >= 15 then
	   	   TriggerClientEvent("pNotify:SendNotification", source, {
             text = "You can carry only 15 wood logs, Please go to the process station and come back after.",
             type = "success",
             queue = "lmao",
             timeout = 7000,
             layout = "Centerleft"
           })
	    else
           xPlayer.Functions.AddItem('wood', 1)
	       TriggerClientEvent("pNotify:SendNotification", source, {
             text = "You harvested <b style=color:#8B4513> -> A wood log",
             type = "success",
             queue = "lmao",
             timeout = 7000,
             layout = "Centerleft"
           })
	    end
    else
       xPlayer.Functions.AddItem('wood', 1)
	   TriggerClientEvent("pNotify:SendNotification", source, {
         text = "You harvested <b style=color:#8B4513> -> A wood log",
         type = "success",
         queue = "lmao",
         timeout = 7000,
         layout = "Centerleft"
       })
    end
end)

RegisterServerEvent('Woodcutting:Wood:Process')
AddEventHandler('Woodcutting:Wood:Process', function()
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local WoodQuantity = xPlayer.Functions.GetItemByName('wood')
    if WoodQuantity ~= nil then 
	    if WoodQuantity.amount >= 15 then
           xPlayer.Functions.AddItem('processed_wood', 15)
           xPlayer.Functions.RemoveItem('wood', 15)
	       TriggerClientEvent("pNotify:SendNotification", source, {
             text = "Your wood logs have been processed",
             type = "success",
             queue = "lmao",
             timeout = 7000,
             layout = "Centerleft"
           })
	    else
           TriggerClientEvent("pNotify:SendNotification", source, {
             text = "15 of Wood Logs are needed for sale",
             type = "success",
             queue = "lmao",
             timeout = 7000,
             layout = "Centerleft"
           })
	    end
    else
       TriggerClientEvent("pNotify:SendNotification", source, {
         text = "15 of Wood Logs are needed for sale",
         type = "success",
         queue = "lmao",
         timeout = 7000,
         layout = "Centerleft"
       })
    end
end)

RegisterServerEvent('Woodcutting:Wood:Sell')
AddEventHandler('Woodcutting:Wood:Sell', function()
   local _source = source
   local xPlayer = QBCore.Functions.GetPlayer(_source)
   local processed_wood_Quantity = xPlayer.Functions.GetItemByName('processed_wood')
   local Addmoney = math.random (6000, 7000) -- change here the price of the wood sell
   if processed_wood_Quantity ~= nil then 
       if processed_wood_Quantity.amount >= 15 then
          xPlayer.Functions.RemoveItem('processed_wood', 15)
          xPlayer.Functions.AddMoney('cash', Addmoney)
          TriggerClientEvent("pNotify:SendNotification", source, {
            text = "<b style=color:#d1d1d1> You sold processed wood for <b style=color:#1588d4>"  .. Addmoney .. " <b style=color:#d1d1d1> keep working</b>",
            type = "success",
            queue = "lmao",
            timeout = 7000,
            layout = "Centerleft"
          })
       else
      	 TriggerClientEvent("pNotify:SendNotification", source, {
           text = "15 of processed Wood are needed for sale",
           type = "success",
           queue = "lmao",
           timeout = 7000,
           layout = "Centerleft"
         })
       end
   else
     TriggerClientEvent("pNotify:SendNotification", source, {
        text = "15 of processed Wood are needed for sale",
        type = "success",
        queue = "lmao",
        timeout = 7000,
        layout = "Centerleft"
     })
   end
end)
