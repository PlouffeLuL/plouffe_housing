function HouseFnc:Init()
    MySQL.query('SELECT * FROM housing', {}, function(houses)
        self:CreateHouseTable(houses)
        self:SetupShellArray()
        Server.Init = true
    end)
end

function HouseFnc:CreateHouseTable(houses)
    for k,v in pairs(houses) do
        House.Houses[tostring(v.id)] = {
            id = v.id,
            owner_state_id = v.owner_state_id,
            owner_name = v.owner_name,
            coords = json.decode(v.coords),
            keys = json.decode(v.house_keys),
            metadata = json.decode(v.metadata),
            label = v.label
        }
    end

    for id,house in pairs(House.Houses) do
        house.metadata.coords = vector3(house.metadata.coords.x,house.metadata.coords.y,house.metadata.coords.z)
        house.metadata.lock = true

        for k,v in pairs(house.coords.entrance) do
            v.inside = vector3(v.inside.x,v.inside.y,v.inside.z)
            v.outside = vector3(v.outside.x,v.outside.y,v.outside.z)
        end

        for k,v in pairs(house.coords.inventory) do
            v.coords = vector3(v.coords.x,v.coords.y,v.coords.z)
        end

        for k,v in pairs(house.coords.wardrobe) do
            v.coords = vector3(v.coords.x,v.coords.y,v.coords.z)
        end

        for k,v in pairs(house.coords.garage) do
            v.coords = vector3(v.coords.x,v.coords.y,v.coords.z)
            
            local garageId = #house.coords.garage
        
            if garageId == 0 then
                garageId = 1
            end
    
            exports.plouffe_garage:CreateGarage({
                name = ("maison_%s_%s"):format(house.id,garageId),
                label = ("Maison # %s, Garage # %s"):format(house.id,garageId),
                coords = v.coords,
                houseId = house.id,
                isHouse = true,
                maxDst = 4.0,
                isImpound = false,
                useBlip = false
            })
        end

        for k,v in pairs(house.metadata.furniture) do
            v.coords = vector3(v.coords.x,v.coords.y,v.coords.z)
            v.rotation = vector3(v.rotation.x,v.rotation.y,v.rotation.z)
        end
    end
end

function HouseFnc:SetupShellArray()
    for k,v in pairs(House.Interiors) do
        if not House.Menu[v.type] then
            House.Menu[v.type] = {}
        end

        table.insert(House.Menu[v.type], {
            id = HouseFnc:GetArrayLenght(House.Menu[v.type]) + 1,
            header = v.label,
            txt = "Crée une maison avec cette intérieur",
            params = {
                event = "",
                args = {
                    model = k
                }
            }
        })
    end
end
    
function HouseFnc:GetArrayLenght(array)
    local lenght = 0
    for k,v in pairs(array) do 
        lenght = lenght + 1
    end
    return lenght
end

function HouseFnc:SendTxt(playerId,label,txt)
    local text = {
        playerId = playerId,
        type = "message",
        sender = label,
        message = txt
    }

    -- exports.evo_phone:SendCustomMessage(text)
end

function HouseFnc:Notify(playerId,txt,type,length)
    local aType, atxt, alength = type,txt,length
    if not type or tostring(type) ~= ("error" or "success" or "inform") then
        aType = "inform" 
    end
    if not txt or not tostring(txt) then
        return 
    else 
        atxt = txt 
    end
    if not length or not tonumber(length) then
        if tonumber(type) then
            alength = tonumber(type)
        else
            alength = 5000 
        end
    else 
        alength = tonumber(length)
    end
    TriggerClientEvent('plouffe_lib:notify', playerId, { type = aType, text = atxt, length = alength})
end

function HouseFnc:IsAnyHouseNear(house_data)
    for k,v in pairs(House.Houses) do
        if #(v.metadata.coords - house_data.metadata.coords) <= 40.0 then
            return true
        end
    end
    return false
end

function HouseFnc:GetGarageDoor(maxDst)
    for id,house in pairs(House.Houses) do
        for k,v in pairs(house.coords.garage) do

            if #(v.coords - House.Utils.pedCoords) <= maxDst then
                return v
            end
        end
    end

    return nil
end

function HouseFnc:CanCreateHouse(xPlayer)
    if House.Job[xPlayer.job.name] ~= nil then
        if House.Job[xPlayer.job.name][tostring(xPlayer.job.grade)] ~= nil then
            return true
        end
    end
    return false
end

function HouseFnc:GetNextId()
    local id = 1
    for k,v in pairs(House.Houses) do
        if v.id >= id then
            id = v.id + 1
        end
    end
    return id
end

function HouseFnc:CreateNewHouse(playerId,house_data,price)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)

    if not self:CanCreateHouse(xPlayer) then
        return self:Notify(playerId, "Vous n'etes pas autoriser a faire cela", "error")
    elseif self:IsAnyHouseNear(house_data) then
        return self:Notify(playerId, "Il y a une maison trop près", "error")
    end
    
    house_data.id = self:GetNextId()
    house_data.metadata.lock = true
    house_data.metadata.forsale = true
    house_data.metadata.price = price
    house_data.metadata.furniture = {}

    house_data.keys = {}

    house_data.coords.inventory = {}
    house_data.coords.wardrobe = {}
    house_data.coords.garage = {}

    MySQL.query("INSERT INTO housing (id, creator_state_id, creator_name, coords, metadata) VALUES (@id, @creator_state_id, @creator_name, @coords, @metadata)", {
        ["@id"] = house_data.id,
        ["@creator_state_id"] = xPlayer.state_id,
        ["@creator_name"] = xPlayer.name,
        ["@coords"] = json.encode(house_data.coords),
        ["@metadata"] = json.encode(house_data.metadata)
    }, function()
        House.Houses[tostring(house_data.id)] = house_data

        TriggerClientEvent("plouffe_housing:sync_new_house", -1, House.Houses[tostring(house_data.id)])
    end)
end

function HouseFnc:DestroyHouse(playerId,id)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)

    if not self:CanCreateHouse(xPlayer) then
        return self:Notify(playerId, "Vous n'etes pas autoriser a faire cela", "error")
    end

    if House.Houses[tostring(id)] then
        House.Houses[tostring(id)] = nil
        MySQL.query("DELETE FROM housing WHERE id = @id", {
            ["@id"] = id
        }, function()
            TriggerClientEvent("plouffe_housing:delete_house", -1, tonumber(id))
        end)
    end
end

function HouseFnc:BuyHouse(playerId,id)
    if House.Houses[tostring(id)] and House.Houses[tostring(id)].metadata.forsale then
        local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
        local bankMoney = xPlayer.getAccount("bank").money

        if bankMoney >= House.Houses[tostring(id)].metadata.price then
            House.Houses[tostring(id)].metadata.forsale = false
            House.Houses[tostring(id)].metadata.lock = true
            
            MySQL.query("SELECT owners_history FROM housing WHERE id = @id", {
                ["@id"] = id
            }, function(res)
                local owners_history = json.decode(res[1].owners_history)
                table.insert(owners_history,{
                    state_id = xPlayer.state_id,
                    name = xPlayer.name
                })

                if not House.Houses[tostring(id)].metadata.seller then
                    exports.plouffe_society:AddSocietyAccountMoney(nil,"society_realestateagent","bank",math.floor(House.Houses[tostring(id)].metadata.price * (House.JobPercentOnSales/100)),function(valid)
                        
                    end)
                else
                    self:PlayerSoldHouse(House.Houses[tostring(id)].metadata.seller.state_id,id,House.Houses[tostring(id)].metadata.price)
                end

                MySQL.query("UPDATE housing SET owner_state_id = @owner_state_id, owner_name = @owner_name, metadata = @metadata, owners_history = @owners_history WHERE id = @id", {
                    ["@owner_state_id"] =  xPlayer.state_id,
                    ["@owner_name"] = xPlayer.name,
                    ["@metadata"] = json.encode(House.Houses[tostring(id)].metadata),
                    ["@owners_history"] = json.encode(owners_history),
                    ["@id"] = id
                }, function()
                    xPlayer.removeAccountMoney("bank",House.Houses[tostring(id)].metadata.price)
                    TriggerClientEvent("plouffe_housing:house_bought", -1, id, {
                        owner_state_id =  xPlayer.state_id,
                        owner_name = xPlayer.name,
                        metadata = House.Houses[tostring(id)].metadata,
                    })
                    
                    House.Houses[tostring(id)].owner_state_id = xPlayer.state_id
                    House.Houses[tostring(id)].owner_name = xPlayer.name

                    self:SendTxt(playerId,"Immobilier",("Vous avez acheter la propriété au numéro de contrat %s pour un montant de %s $, merci pour votre achat."):format(id,House.Houses[tostring(id)].metadata.price))
                end)
            end)
        end
    end
end

function HouseFnc:PlayerSoldHouse(state_id,id,price)
    local xPlayer = Core:GetPlayerFromStateId(state_id)
    if xPlayer then
        xPlayer.addAccountMoney("bank",price)
        self:SendTxt(xPlayer.source,"Immobilier",("Vous avez vendu la propriété au numéro de contrat %s pour un montant de %s $"):format(id,price))
    else
        MySQL.query('UPDATE users SET bank = bank + :amount WHERE state_id = :state_id',
        {
            amount = price,
            state_id = state_id,
        }, function()

        end)
    end
end

function HouseFnc:IsHouseOwner(house,xPlayer)
    return house.owner_state_id == xPlayer.state_id
end

function HouseFnc:HasHouseKeys(house,xPlayer)
    for k,v in pairs(house.keys) do
        if v.state_id == xPlayer.state_id then
            return true
        end
    end
    return false
end

function HouseFnc:Unlock(playerId,id)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    if self:IsHouseOwner(House.Houses[tostring(id)],xPlayer) or self:HasHouseKeys(House.Houses[tostring(id)],xPlayer) then
        House.Houses[tostring(id)].metadata.lock = false
        TriggerClientEvent("plouffe_housing:client:unlock", -1, id)
    end
end

function HouseFnc:Lock(playerId,id)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    if self:IsHouseOwner(House.Houses[tostring(id)],xPlayer) or self:HasHouseKeys(House.Houses[tostring(id)],xPlayer) then
        House.Houses[tostring(id)].metadata.lock = true
        TriggerClientEvent("plouffe_housing:client:lock", -1, id)
    end
end

function HouseFnc:CanBreach(xPlayer)
    if House.RaidJobs[xPlayer.job.name] then
        if House.RaidJobs[xPlayer.job.name][tostring(xPlayer.job.grade)] then
            return true
        end
    end
end

function HouseFnc:HashBreachedInventoryAcces(xPlayer)
    if House.RaidJobsInventory[xPlayer.job.name] then
        if House.RaidJobsInventory[xPlayer.job.name][tostring(xPlayer.job.grade)] then
            return true
        end
    end
end

function HouseFnc:Breach(playerId,id)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)

    if self:CanBreach(xPlayer) then
        exports.plouffe_society:RemoveSocietyAccountMoney(nil,"society_police","bank",House.BreachPrice,function()   
            self:SendTxt(playerId,"Immobilier",("Des frais de réparation de %s pour des réparation a la propriété %s on été débiter du compte de police."):format(House.BreachPrice, id))
            House.Houses[tostring(id)].metadata.lock = false
            House.Breached[tostring(id)] = true
            TriggerClientEvent("plouffe_housing:client:breach", -1, id)
        end)
    end
end

function HouseFnc:UnBreach(playerId,id)
    House.Houses[tostring(id)].metadata.lock = true
    House.Breached[tostring(id)] = nil
    TriggerClientEvent("plouffe_housing:client:unbreach", -1, id)
end

function HouseFnc:AddInventory(playerId,id)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    if self:IsHouseOwner(House.Houses[tostring(id)],xPlayer) then
        local pedCoords = GetEntityCoords(GetPlayerPed(playerId))

        if #(pedCoords - House.Houses[tostring(id)].metadata.coords) <= 50.0 then
            if #House.Houses[tostring(id)].coords.inventory < House.Maximums.inventory then
                table.insert(House.Houses[tostring(id)].coords.inventory, {
                    coords = pedCoords,
                    name = ("housing_inventory_%s_%s"):format(id, #House.Houses[tostring(id)].coords.inventory + 1),
                })

                MySQL.query("UPDATE housing SET coords = @coords WHERE id = @id", {
                    ["@coords"] = json.encode(House.Houses[tostring(id)].coords),
                    ["@id"] = id
                }, function()
                    TriggerClientEvent("plouffe_housing:sync_house_inventory", -1, id, House.Houses[tostring(id)].coords.inventory)
                end)
            end
        end
    end
end

function HouseFnc:AddWardRobe(playerId,id)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    if self:IsHouseOwner(House.Houses[tostring(id)],xPlayer) then
        local pedCoords = GetEntityCoords(GetPlayerPed(playerId))

        if #(pedCoords - House.Houses[tostring(id)].metadata.coords) <= 50.0 then
            if #House.Houses[tostring(id)].coords.wardrobe < House.Maximums.wardrobe then
                table.insert(House.Houses[tostring(id)].coords.wardrobe, {
                    coords = pedCoords,
                    name = ("housing_wardrobe_%s_%s"):format(id, #House.Houses[tostring(id)].coords.wardrobe + 1),
                })

                MySQL.query("UPDATE housing SET coords = @coords WHERE id = @id", {
                    ["@coords"] = json.encode(House.Houses[tostring(id)].coords),
                    ["@id"] = id
                }, function()
                    TriggerClientEvent("plouffe_housing:sync_house_wardrobe", -1, id, House.Houses[tostring(id)].coords.wardrobe)
                end)
            end
        end
    end
end

function HouseFnc:GetClosesHouseInventory(playerId,house)
    local pedCoords = GetEntityCoords(GetPlayerPed(playerId))

    for k,v in pairs(house.coords.inventory) do
        if #(v.coords - pedCoords) <= 2.5 then
            return v
        end
    end

    return false
end

function HouseFnc:OpenInventory(playerId,id)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    local house = House.Houses[tostring(id)]
    local owner = self:IsHouseOwner(house,xPlayer)
    local hasKeys = self:HasHouseKeys(house,xPlayer)
    local inv = self:GetClosesHouseInventory(playerId,house)

    if (owner or hasKeys) or (House.Breached[tostring(house.id)] and self:HashBreachedInventoryAcces(xPlayer)) then
        exports.ox_inventory:RegisterStash(inv.name, "Inventaire", 100, 500000, nil, nil, inv.coords)
        return inv.name
    end
end

function HouseFnc:SellHouse(playerId,id,price)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    local house = House.Houses[tostring(id)]
    local owner = self:IsHouseOwner(house,xPlayer)
    
    if type(price) ~= "number" or (type(price) == "number" and price <= 0) then 
        return self:Notify(playerId,"Le prix que vous avez entré est invalide", "error") 
    end

    if owner then
        house.owner_state_id = nil
        house.owner_name = nil
        house.keys = {}
        house.metadata.lock = true
        house.metadata.forsale = true
        house.metadata.price = price
        house.metadata.seller = {
            state_id = xPlayer.state_id
        }

        local keys = json.encode(house.keys) and json.encode(house.keys) ~= "[]" or "{}"

        MySQL.query("UPDATE housing SET owner_state_id = @owner_state_id, owner_name = @owner_name, house_keys = @house_keys, metadata = @metadata WHERE id = @id", {
            ["@id"] = house.id,
            ["@owner_state_id"] = house.owner_state_id,
            ["@owner_name"] = house.owner_name,
            ["@house_keys"] = keys,
            ["@metadata"] = json.encode(house.metadata)
        }, function()
            TriggerClientEvent("plouffe_housing:set_house_for_sell", -1, id, house)
            self:SendTxt(playerId,"Immobilier",("Vous avez mis en vente la propriété au numéro de contrat %s pour un montant de %s $."):format(id,price))
        end)
    end
end

function HouseFnc:GivePlayerKeys(playerId,id,targetId)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    local house = House.Houses[tostring(id)]
    local owner = self:IsHouseOwner(house,xPlayer)

    if owner then
        local xTarget = exports.ooc_core:getPlayerFromId(targetId)

        if xTarget then
            table.insert(house.keys, {
                state_id = xTarget.state_id,
                name = xTarget.name
            })

            MySQL.query("SELECT keys_history FROM housing WHERE id = @id", {
                ["@id"] = id
            }, function(res)
                local keys_history = json.decode(res[1].keys_history)

                table.insert(keys_history, {
                    state_id = xTarget.state_id,
                    name = xTarget.name
                })

                MySQL.query("UPDATE housing SET house_keys = @house_keys, keys_history = @keys_history WHERE id = @id", {
                    ["@id"] = house.id,
                    ["@house_keys"] = json.encode(house.keys),
                    ["@keys_history"] = json.encode(keys_history)
                }, function()
                    TriggerClientEvent("plouffe_housing:update_keys", targetId, id, house.keys)
                    TriggerClientEvent("plouffe_housing:update_keys", playerId, id, house.keys)
                    self:SendTxt(playerId,"Immobilier",("Vous avez donner les clées de la propriété au numéro de contrat %s a %s "):format(id,xTarget.name))
                end)
            end)
        end
    end
end

function HouseFnc:RemovePlayerKeys(playerId,id,playerInfo)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    local house = House.Houses[tostring(id)]
    local owner = self:IsHouseOwner(house,xPlayer)
    local found = false

    if owner then
        for k,v in pairs(house.keys) do
            if v.state_id == playerInfo.state_id then
                table.remove(house.keys, k)
                found = true
                break
            end
        end

        if found then
            MySQL.query("UPDATE housing SET house_keys = @house_keys WHERE id = @id", {
                ["@id"] = house.id,
                ["@house_keys"] = json.encode(house.keys)
            }, function()
                TriggerClientEvent("plouffe_housing:update_keys", -1, id, house.keys)
                self:SendTxt(playerId,"Immobilier",("Vous avez retirer les clées de la propriété au numéro de contrat %s a %s "):format(id,playerInfo.name))
            end)
        end
    end
end

function HouseFnc:AddFurniture(playerId,id,item)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    local house = House.Houses[tostring(id)]
    local owner = self:IsHouseOwner(house,xPlayer)
    local hasKeys = self:HasHouseKeys(house,xPlayer)
    local bankMoney = xPlayer.getAccount("bank").money
    
    if owner or hasKeys then
        if bankMoney < item.price then
            return self:Notify("Vous n'avez pas les moyens de payer cela", "error")
        end
        
        xPlayer.removeAccountMoney("bank",item.price)

        table.insert(house.metadata.furniture, item)

        MySQL.query("UPDATE housing SET metadata = @metadata WHERE id = @id", {
            ["@id"] = house.id,
            ["@metadata"] = json.encode(house.metadata)
        }, function()
            self:SendTxt(playerId,"Immobilier", ("Vous avez acheter %s pour un montant de %s"):format(item.name, item.price))
            TriggerClientEvent("plouffe_housing:update_furniture", -1, id, house.metadata)
        end)
    end
end

function HouseFnc:SellFurniture(playerId,houseId,furniture_index)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
    local house = House.Houses[tostring(houseId)]
    local owner = self:IsHouseOwner(house,xPlayer)
    local hasKeys = self:HasHouseKeys(house,xPlayer)
    
    if owner or hasKeys then
        local target_furniture = house.metadata.furniture[furniture_index]
        
        if target_furniture then
            local price = target_furniture.price
            
            table.remove(house.metadata.furniture, furniture_index)
            
            MySQL.query("UPDATE housing SET metadata = @metadata WHERE id = @id",{
                ["@metadata"] = json.encode(house.metadata),
                ["@id"] = houseId
            }, function()
                xPlayer.addAccountMoney("bank", price)
                self:SendTxt(playerId,"Immobilier", ("Vous avez vendu %s pour un montant de %s"):format(target_furniture.name, target_furniture.price))
                TriggerClientEvent("plouffe_housing:update_furniture", -1, houseId, house.metadata)
            end)
        end
    end
    
end

function HouseFnc:IsAllowedToAddDoors(xPlayer)
    if House.AllowedToAddDoors[xPlayer.job.name] then
        return House.AllowedToAddDoors[xPlayer.job.name][tostring(xPlayer.job.grade)] ~= (nil or false)
    end
    return false
end

function HouseFnc:AddDoor(playerId,houseId,new_door)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)

    if self:IsAllowedToAddDoors(xPlayer) then
        local xPlayer = exports.ooc_core:getPlayerFromId(playerId)
        local house = House.Houses[tostring(houseId)]
        local owner = self:IsHouseOwner(house,xPlayer)
        local hasKeys = self:HasHouseKeys(house,xPlayer)

        if house and (owner or hasKeys) then
            table.insert(house.coords.entrance, new_door)

            MySQL.query("UPDATE housing SET coords = @coords WHERE id = @id", {
                ["@coords"] = json.encode(house.coords),
                ["@id"] = house.id
            }, function()
                TriggerClientEvent("plouffe_housing:force_sync_house_coords", -1, house.id, house.coords)
            end)
        end
    end
end

function HouseFnc:AddGarage(playerId,houseId,coords)
    local xPlayer = exports.ooc_core:getPlayerFromId(playerId)

    if not self:CanCreateHouse(xPlayer) then
        return self:Notify(playerId, "Vous n'etes pas autoriser a faire cela", "error")
    elseif self:GetGarageDoor(4.0) then
        return self:Notify(playerId, "Il y a déja un garage trop près", "error")
    end

    local house = House.Houses[tostring(houseId)]

    if house.owner_state_id then
        return self:Notify(playerId, "Vous ne pouvez pas ajouter un garage a une propriété qui a déjà été acheter", "error")
    elseif #(house.coords.entrance[1].outside - coords) > 40.0 then
        return self:Notify(playerId, "Vous etes trop loin de la porte d'entré", "error")
    end

    table.insert(house.coords.garage, {
        coords = coords
    })

    MySQL.query("UPDATE housing SET coords = @coords WHERE id = @id", {
        ["@coords"] = json.encode(house.coords),
        ["@id"] = house.id
    }, function()
        local garageId = #house.coords.garage
        
        if garageId == 0 then
            garageId = 1
        end

        exports.plouffe_garage:CreateGarage({
            name = ("maison_%s_%s"):format(houseId,garageId),
            label = ("Maison # %s, Garage # %s"):format(houseId,garageId),
            coords = coords,
            maxDst = 4.0,
            houseId = houseId,
            isHouse = true,
            isImpound = false,
            useBlip = false
        })
    end)
end

function HouseFnc:PlayerWiped(state_id)
    local sync = false
    local foundHouses = {}
    
    for id,house in pairs(House.Houses) do
        local foundKeys = {}

        if house.owner_state_id == state_id then
            table.insert(foundHouses, id)

            MySQL.query("DELETE FROM housing WHERE id = @id", {
                ["@id"] = id
            }, function()
            end)
        else
            for k,v in pairs(house.keys) do
                if v.state_id == state_id then
                    table.insert(foundKeys, k)
                end
            end

            if #foundKeys > 0 then
                for k,v in pairs(foundKeys) do
                    table.remove(house.keys, v)
                end
                
                TriggerClientEvent("plouffe_housing:update_keys", -1, id, house.keys)
                Wait(1000)
            end
        end
    end

    if #foundHouses > 0 then
        for k,v in pairs(foundHouses) do
            House.Houses[v] = nil
            TriggerClientEvent("plouffe_housing:delete_house", -1, v)
            Wait(1000)
        end
    end
end

RegisterCommand("housing:reset_furniture", function(s,a,r)
    local id = tonumber(a[1])

    if id and House.Houses[tostring(id)] then
        MySQL.query("UPDATE housing SET metadata = @metadata WHERE id = @id", {
            ["@id"] = id,
            ["@metadata"] = json.encode(House.Houses[tostring(id)].metadata)
        }, function()
            TriggerClientEvent("plouffe_housing:update_furniture", -1, id, House.Houses[tostring(id)].metadata)
        end)
    end
end, true)

RegisterCommand("housing:destroy_house", function(s,a,r)
    local id = tonumber(a[1])

    if id and House.Houses[tostring(id)] then
        MySQL.query("DELETE FROM housing WHERE id = @id", {
            ["@id"] = id
        }, function()
            House.Houses[tostring(id)] = nil
            TriggerClientEvent("plouffe_housing:delete_house", -1, id)
        end)
    end
end, true)