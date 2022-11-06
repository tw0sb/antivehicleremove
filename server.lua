--[[
	Script to locate players that use cheats to
	kick other players off their vehicle
	some badly coded scripts will cause this to falsly trigger
--]]

local ESXserver = false -- use ESX to kick player if kick is enabled

local cancel = true -- Set this to true and player wont be removed from the vehicle
local kick = true -- Kick the player if he gets detected? 
local kickreason = "anticheat" -- what will the hacker see when anticheat kicks them

--Webhook settings
local webhook = 'URL HERE' -- Discord Webhook make it '' for no log
local webhookname = 'AntiCheat' -- Webhook name
local webhookMsg = 'Anticheat detected $name ($id) trying to remove other players from their vehicle' -- Message to send to discord replace $name and $id with the cheaters name and id

--[[ DO NOT EDIT BELOW THIS LINE]]
--Check if discord webhook exists
function isValidURL(str)
	if str == nil or str == '' then return false end
	if string.sub(str, 1, string.len("http://")) ~= "http://" and string.sub(str, 1, string.len("https://")) ~= "https://" then
		return false
	end
	return true
end

function kickPlayer(src, reason)
	if(kick)then
		if(ESXserver == true) then
			ESX.GetPlayerFromId(sender).kick(reason)
		else	
			DropPlayer(src, reason)
		end
	end
end

function replace(str, what, with)
	local str, _ = string.gsub(str, what, with)
	return str
end

-- Intercept the event the cheaters are using
AddEventHandler('clearPedTasksEvent', function(sender, ev)
	-- Cancel check
	if cancel then
		CancelEvent()
	end
	-- Webook check
	if(isValidURL(webhook)) then
		local sendtoDiscordMsg = replace(replace(webhookMsg, "$id", sender), "$name", GetPlayerName(sender))
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = webhookname, content = sendtoDiscordMsg}), { ['Content-Type'] = 'application/json' })
	end
	-- Kick player
	kickPlayer(sender, kickreason)
end)

