--[[
	Script to locate players that use cheats to
	kick other players off their vehicle
--]]

local cancel = true -- set this to true and player wont be removed from vehicle
local kick = true -- kick the player if he gets detected?
local kickreason = "anticheat" -- what will the hacker see when anticheat kicks them
local webhook = 'URL HERE' -- Discord Webhook make it '' for no log

-- Do not edit unless you know what you are doing

-- Intercept the event the cheaters are using
AddEventHandler('clearPedTasksEvent', function(sender, ev)
	-- Cancel check
	if cancel then
		CancelEvent()
	end
	-- Webook check
	if(webhook ~= '') then
		-- Message and send to discord
		local message = "(" ..sender .. ") " .. GetPlayerName(sender) .. " tried to remove someone from their vehicle. 99.9% probability of being a hacker or a badly configured script."
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Vehicle remove bot", content = message}), { ['Content-Type'] = 'application/json' })
	end
	-- Kick check
	if kick then
		ESX.GetPlayerFromId(sender).kick(kickreason)
	end
end)
