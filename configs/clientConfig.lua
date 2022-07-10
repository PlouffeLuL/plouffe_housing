House = {}
HouseFnc = {} 
TriggerServerEvent("plouffe_housing:sendConfig")

RegisterNetEvent("plouffe_housing:getConfig",function(list)
	if list == nil then
		CreateThread(function()
			while true do
				Wait(0)
				House = nil
				HouseFnc = nil
				ESX = nil
			end
		end)
	else
		House = list
		HouseFnc:Start()
	end
end)