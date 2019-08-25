ESX = nil
local doorInfo = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_doorlock:updateState')
AddEventHandler('esx_doorlock:updateState', function(doorID, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(doorID) ~= 'number' then
		print(('esx_doorlock: %s didn\'t send a number!'):format(xPlayer.identifier))
		return
	end

	if type(state) ~= 'boolean' then
		print(('esx_doorlock: %s attempted to update invalid state!'):format(xPlayer.identifier))
		return
	end

	if not Config.DoorList[doorID] then
		print(('esx_doorlock: %s attempted to update invalid door!'):format(xPlayer.identifier))
		return
	end

	doorInfo[doorID] = state

	TriggerClientEvent('esx_doorlock:setState', -1, doorID, state)
end)

ESX.RegisterServerCallback('esx_doorlock:getDoorInfo', function(source, cb)
	cb(doorInfo)
end)

function IsAuthorized(jobName, doorID)
	for _,job in pairs(doorID.authorizedJobs) do
		if job == jobName then
			return true
		end
	end

	return false
end

ESX.RegisterServerCallback('esx_doorlock:openDoor', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.getInventoryItem('keycard')
    local hasitem = xPlayer.getInventoryItem('keycard').count


    cb({
        items = items
    })

if hasitem == 0 then
TriggerClientEvent('esx:showNotification', source, _U('you_dont_have_keycard'))
end

end)

ESX.RegisterServerCallback('esx_doorlock:lockpickDoor', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.getInventoryItem('lockpick')
    local hasitem = xPlayer.getInventoryItem('lockpick').count


    cb({
        items = items
    })

if hasitem >= 1 then
TriggerClientEvent('esx:showNotification', source, _U('used_lockpick'))
xPlayer.removeInventoryItem('lockpick', 1)
else
TriggerClientEvent('esx:showNotification', source, _U('you_dont_have_lockpick'))
end

end)
