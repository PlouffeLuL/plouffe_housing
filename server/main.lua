CreateThread(function()
    MySQL.ready(function()
        HouseFnc:Init()
    end)
end)

RegisterNetEvent("plouffe_housing:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)
    
    while not Server.Init do
        Wait(100)
    end
    
    if registred then
        local cbArray = House
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_housing:getConfig",playerId,cbArray)
    else
        TriggerClientEvent("plouffe_housing:getConfig",playerId,nil)
    end
end)

RegisterNetEvent("plouffe_housing:removeItem",function(item,amount)
    local playerId = source
    exports.ox_inventory:RemoveItem(playerId, item, amount)
end)

RegisterNetEvent("plouffe_housing:create_new_house",function(house_data,price,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:create_new_house") then
            HouseFnc:CreateNewHouse(playerId,house_data,price)
        end
    end
end)

RegisterNetEvent("plouffe_housing:destroy_house",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:destroy_house") then
            HouseFnc:DestroyHouse(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:buy_house",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:buy_house") then
            HouseFnc:BuyHouse(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:unlock_house",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:unlock_house") then
            HouseFnc:Unlock(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:lock_house",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:lock_house") then
            HouseFnc:Lock(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:breach",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:breach") then
            HouseFnc:Breach(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:unbreach",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:unbreach") then
            HouseFnc:UnBreach(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:add_inventory_coords",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:add_inventory_coords") then
            HouseFnc:AddInventory(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:open_inventory",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:open_inventory") then
            HouseFnc:OpenInventory(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:add_wardrobe_coords",function(id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:add_wardrobe_coords") then
            HouseFnc:AddWardRobe(playerId,id)
        end
    end
end)

RegisterNetEvent("plouffe_housing:sellhouse", function(id,price,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:sellhouse") then
            HouseFnc:SellHouse(playerId,id,price)
        end
    end
end)

RegisterNetEvent("plouffe_housing:give_player_keys",function(id,targetId,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:give_player_keys") then
            HouseFnc:GivePlayerKeys(playerId,id,targetId)
        end
    end
end)

RegisterNetEvent("plouffe_housing:remove_player_keys",function(id,playerInfo,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:remove_player_keys") then
            HouseFnc:RemovePlayerKeys(playerId,id,playerInfo)
        end
    end
end)

RegisterNetEvent("plouffe_housing:add_furniture",function(id,item,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:add_furniture") then
            HouseFnc:AddFurniture(playerId,id,item)
        end
    end
end)

RegisterNetEvent("plouffe_housing:sell_furniture", function(houseId, furniture_index, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:sell_furniture") then
            HouseFnc:SellFurniture(playerId,houseId,furniture_index)
        end
    end
end)

RegisterNetEvent("plouffe_housing:addNewDoor", function(houseId, new_door, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:addNewDoor") then
            HouseFnc:AddDoor(playerId,houseId,new_door)
        end
    end
end)

RegisterNetEvent("plouffe_housing:addNewGarage", function(houseId, coords, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_housing:addNewGarage") then
            HouseFnc:AddGarage(playerId,houseId,coords)
        end
    end
end)

Callback:RegisterServerCallback("plouffe_housing:get_inventory_name", function(playerId, cb, id, authkey)
    if Auth:Validate(playerId, authkey) then
        if Auth:Events(playerId, "plouffe_housing:get_inventory_name") then
            cb(HouseFnc:OpenInventory(playerId,id))            
        end
    end
end)

RegisterNetEvent("plouffe_admin:playerwipe", function(state_id)
    if source == "" then
        HouseFnc:PlayerWiped(state_id)
    else
        DropPlayer(source, "Gros cave")
    end
end)
