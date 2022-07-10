local Callback = exports.plouffe_lib:Get("Callback")
local Utils = exports.plouffe_lib:Get("Utils")

function HouseFnc:Start()
    TriggerEvent('ooc_core:getCore', function(Core)
        while not Core.Player:IsPlayerLoaded() do
            Wait(500)
        end

        House.Player = Core.Player:GetPlayerData()

        self:InitHouses()
        self:ExportsAllZones()
        self:RegisterAllEvents()
        self:CreatePropMenuList()
    end)
end

function HouseFnc:ExportsAllZones()
    for k,v in pairs(House.Zones) do
        exports.plouffe_lib:ValidateZoneData(v)
    end
end

function HouseFnc:RegisterAllEvents()
    AddStateBagChangeHandler("dead", ("player:%s"):format(GetPlayerServerId(PlayerId())), function(bagName,key,value,reserved,replicated)
        if value then
            if House.Player.job.name == "realestateagent" then
                self:ResetCreator()
            end
        end
    end)

    AddEventHandler('plouffe_lib:setGroup', function(data)
        House.Player[data.type] = data
    end)

    RegisterNetEvent("plouffe_lib:inVehicle", function(inCar,carId)
        House.Utils.inCar = inCar
        House.Utils.carId = carId
    end)

    RegisterNetEvent("plouffe_lib:hasWeapon", function(isArmed, weaponHash)
        House.Utils.isArmed = isArmed
        House.Utils.currentWeaponHash = weaponHash
    end)

    RegisterNetEvent("plouffe_housing:on_zones", function(params)
        if self[params.fnc] then
            self[params.fnc](self,params)
        end
    end)

    RegisterNetEvent("plouffe_housing:house_interaction", function()
        self:InteractWithDoor()
    end)

    RegisterNetEvent("plouffe_housing:createhouse",function()
        if self:CanCreateHouse() then
            self:OpenCreatorMenu()
        end
    end)

    RegisterNetEvent("plouffe_housing:sync_new_house",function(house_data)
        self:ProcessNewHouse(house_data)
    end)

    RegisterNetEvent("plouffe_housing:delete_house",function(id)
        self:DeleteHouse(id)
    end)

    RegisterNetEvent("plouffe_housing:house_bought",function(id,newData)
        self:UpdateNewOwner(id,newData)
    end)

    RegisterNetEvent("plouffe_housing:client:unlock", function(id)
        House.Houses[tostring(id)].metadata.lock = false
    end)

    RegisterNetEvent("plouffe_housing:client:lock", function(id)
        House.Houses[tostring(id)].metadata.lock = true
    end)

    RegisterNetEvent("plouffe_housing:client:unbreach", function(id)
        House.Houses[tostring(id)].metadata.lock = true
        House.Breached[tostring(id)] = nil
    end)

    RegisterNetEvent("plouffe_housing:client:breach", function(id)
        House.Houses[tostring(id)].metadata.lock = false
        House.Breached[tostring(id)] = true
    end)

    RegisterNetEvent("plouffe_housing:sync_house_inventory", function(id,newinv)
        House.Houses[tostring(id)].coords.inventory = newinv
        self:RefreshHouseInteriorZones(id)
    end)

    RegisterNetEvent("plouffe_housing:sync_house_wardrobe", function(id,newwardrobe)
        House.Houses[tostring(id)].coords.wardrobe = newwardrobe
        self:RefreshHouseInteriorZones(id)
    end)

    RegisterNetEvent("plouffe_housing:set_house_for_sell", function(id,house)
        self:ForceUpdateHouse(id,house)
    end)

    RegisterNetEvent("plouffe_housing:update_keys",function(id,keys)
        House.Houses[tostring(id)].keys = keys
    end)

    RegisterNetEvent("plouffe_housing:update_furniture",function(id,meta)
        self:RefreshHouseFurniture(id,meta)
    end)

    RegisterNetEvent("plouffe_housing:force_sync_house_coords",function(id,coords)
        House.Houses[tostring(id)].coords = coords
        self:RefreshHouseInteriorZones(id)
    end)
end

function HouseFnc:GetarrayLenght(a)
    local cb = 0
    for k,v in pairs(a) do
        cb = cb + 1
    end
    return cb
end

function HouseFnc:AlphabeticArray(a)
    local sortedArray = {}
    local indexArray = {}
    local elements = {}

    for k,v in pairs(a) do
        if v.label then
            sortedArray[v.label] = v
            table.insert(indexArray, v.label)
        end
    end

    table.sort(indexArray)

    for k,v in pairs(indexArray) do
        table.insert(elements, sortedArray[v])
    end

    return elements
end

function HouseFnc:RequestModel(model)
    CreateThread(function()
        RequestModel(model)
    end)
end

function HouseFnc:AssureModel(model)
    local breakCount = 10000
    local requestStart = GetGameTimer()

    if type(model) == "string" then
        model = GetHashKey(model)
    end

    self:RequestModel(model)

    while not HasModelLoaded(model) and GetGameTimer() - requestStart < breakCount do
        self:RequestModel(model)
        Wait(0)
    end

    return HasModelLoaded(model)
end

function HouseFnc:PlayAnim(type,dict,anim,flag,time,disablemovement)
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    if type == "anim" then
        self:AssureAnim(dict)

        TaskPlayAnim(House.Utils.ped, dict, anim, 50.0, 50.0, time, flag, 0, false, false, false)

        CreateThread(function()
            while House.Utils.forceAnim and not LocalPlayer.state.dead do
                Wait(0)
                if not IsEntityPlayingAnim(House.Utils.ped, dict, anim, 3) then
                    TaskPlayAnim(House.Utils.ped, dict, anim, 50.0, 50.0, time, flag, 0, false, false, false)
                end
            end

            if LocalPlayer.state.dead and House.Utils.forceAnim then
                House.Utils.forceAnim = false
            end

            StopAnimTask(House.Utils.ped, dict, anim, 1.0)
        end)
    elseif type == "scenario" then
        TaskStartScenarioInPlace(House.Utils.ped, dict, 0, true)

        CreateThread(function()
            while House.Utils.forceAnim and not LocalPlayer.state.dead do
                Wait(0)
            end

            if LocalPlayer.state.dead and House.Utils.forceAnim then
                House.Utils.forceAnim = false
            end

            ClearPedTasks(House.Utils.ped)
        end)
    end

    CreateThread(function()
        while disablemovement and House.Utils.forceAnim and not LocalPlayer.state.dead do
            Wait(0)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 36, true)
            DisableControlAction(0, 21, true)
        end
    end)
end

function HouseFnc:AssureAnim(dict)
    local time = GetGameTimer()
    self:RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) and GetGameTimer() - time <= 5000 do
        self:RequestAnimDict(dict)
        Wait(0)
    end
end

function HouseFnc:RequestAnimDict(dict)
    CreateThread(function()
        RequestAnimDict(dict)
    end)
end

function HouseFnc:CanCreateHouse()
    if House.Job[House.Player.job.name] then
        if House.Job[House.Player.job.name][tostring(House.Player.job.grade)] then
            return true
        end
    end
end

function HouseFnc:InitHouses()
    for k,v in pairs(House.Houses) do
        self:CreateHouseBlip(v)
    end
end

function HouseFnc:CallSellAgent()
-- To do
end

function HouseFnc:RefreshHouseInteriorZones(id)
    if House.InsideHouse and House.InsideHouse.id == id then
        self:DeleteAllZones(House.Houses[tostring(id)])
        self:CreateAllZones(House.Houses[tostring(id)])
    end
end

function HouseFnc:ForcePlayerOut(id)
    if House.InsideHouse and House.InsideHouse.id == id then
        self:DeleteAllZones(House.Houses[tostring(id)])
        SetEntityCoords(PlayerPedId(), House.InsideHouse.coords.entrance[1].outside)
        House.InsideHouse = nil
    end
end

function HouseFnc:ForceUpdateHouse(id,newHouseData)
    House.Houses[tostring(id)] = newHouseData
end

function HouseFnc:DeleteAllZones(house)
    for k,v in pairs(house.coords.entrance) do
        exports.plouffe_lib:DestroyZone(("house_%s_%s_%s"):format("entrance",k,house.id))
    end

    for k,v in pairs(house.coords.inventory) do
        exports.plouffe_lib:DestroyZone(("house_%s_%s_%s"):format("inventory",k,house.id))
    end

    for k,v in pairs(house.coords.wardrobe) do
        exports.plouffe_lib:DestroyZone(("house_%s_%s_%s"):format("wardrobe",k,house.id))
    end
end

function HouseFnc:CreateAllZones(house)
    for k,v in pairs(house.coords.entrance) do
        exports.plouffe_lib:ValidateZoneData(
            {
                name = ("house_%s_%s_%s"):format("entrance",k,house.id),
                coords = v.inside,
                maxDst = 1.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Sortir",
                aditionalParams = {fnc = "InsideHouseInteraction", id = house.id, type = "leave"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "plouffe_housing:on_zones",
                    key = "E"
                }
            }
        )
    end

    for k,v in pairs(house.coords.inventory) do
        exports.plouffe_lib:ValidateZoneData(
            {
                name = ("house_%s_%s_%s"):format("inventory",k,house.id),
                coords = v.coords,
                maxDst = 1.5,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", id = house.id},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "plouffe_housing:on_zones",
                    key = "E"
                }
            }
        )
    end

    for k,v in pairs(house.coords.wardrobe) do
        exports.plouffe_lib:ValidateZoneData(
            {
                name = ("house_%s_%s_%s"):format("wardrobe",k,house.id),
                coords = v.coords,
                maxDst = 1.5,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", id = house.id},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "plouffe_housing:on_zones",
                    key = "E"
                }
            }
        )
    end
end

function HouseFnc:UpdateNewOwner(id,newData)
    House.Houses[tostring(id)].owner = newData.owner_state_id
    House.Houses[tostring(id)].owner_name = newData.owner_name
    House.Houses[tostring(id)].metadata = newData.metadata

    self:ForcePlayerOut(id)
    self:DestroyHouse(House.Houses[tostring(id)])
    self:CreateHouseBlip(House.Houses[tostring(id)])
end

function HouseFnc:DeleteHouse(id)
    self:ForcePlayerOut(id)
    self:DestroyHouse(House.Houses[tostring(id)])

    House.Houses[tostring(id)] = nil
end

function HouseFnc:CreateHouse(house,cb)
    if house.prop_id and house.prop_id ~= 0 and DoesEntityExist(house.prop_id) then
        self:DestroyHouse(house)
    end

    local modelHash = GetHashKey(house.metadata.shell)
    local createTime = GetGameTimer()
    local shell_prop = CreateObject(modelHash, house.metadata.coords.x, house.metadata.coords.y, house.metadata.coords.z - 1.0, false,false,false)

    while not DoesEntityExist(shell_prop) and GetGameTimer() - createTime < 5000 do
        Wait(100)
    end

    if not DoesEntityExist(shell_prop) then
        return false, Utils:Notify(("Il est impossible de crée cette intérieur %s (Code d'erreur #2)"):format(house.metadata.shell),"error")
    end

    house.prop_id = shell_prop

    SetEntityCoords(shell_prop, house.metadata.coords)
    SetEntityHeading(house.prop_id,house.metadata.heading)
    FreezeEntityPosition(house.prop_id,true)
    SetModelAsNoLongerNeeded(modelHash)

    House.InsideHouse = house

    self:CreateFurniture(house)

    cb(true)
end

function HouseFnc:RefreshHouseFurniture(id,meta)
    local house = House.Houses[tostring(id)]

    if House.InsideHouse and House.InsideHouse.id == id then
        self:DeleteAllFurnitures(house)

        house.metadata = meta

        self:CreateFurniture(house)
    else
        house.metadata = meta
    end
end

function HouseFnc:CreateFurniture(house)
    for k,v in pairs(house.metadata.furniture) do
        if not self:AssureModel(v.model) then
            Utils:Notify(("Le model de meuble est invalide %s (Code d'erreur #3)"):format(v.name),"error")
        else
            local createTime = GetGameTimer()

            v.prop_id = CreateObject(v.model, v.coords, false,false,false)

            while not DoesEntityExist(v.prop_id) and GetGameTimer() - createTime < 2500 do
                Wait(100)
            end

            if not DoesEntityExist(v.prop_id) then
                v.prop_id = 0
                Utils:Notify(("Le model de meuble est invalide %s (Code d'erreur #4)"):format(v.name),"error")
            else
                FreezeEntityPosition(v.prop_id,true)
                SetEntityCoords(v.prop_id, v.coords)
                SetEntityRotation(v.prop_id, v.rotation)
                SetModelAsNoLongerNeeded(v.model)
            end
        end
    end

    return true
end

function HouseFnc:DeleteAllFurnitures(house)
    for k,v in pairs(house.metadata.furniture) do
        DeleteEntity(v.prop_id)
        v.prop_id = 0
    end
end

function HouseFnc:DestroyHouse(house)
    if house.prop_id then
        DeleteEntity(house.prop_id)
        house.prop_id = 0
    end

    for k,v in pairs(house.metadata.furniture) do
        DeleteEntity(v.prop_id)
        v.prop_id = 0
    end

    for k,v in pairs(house.coords.entrance) do
        exports.plouffe_lib:DestroyZone(("house_%s_%s_%s"):format("entrance",k,house.id))
    end

    for k,v in pairs(house.coords.inventory) do
        exports.plouffe_lib:DestroyZone(("house_%s_%s_%s"):format("inventory",k,house.id))
    end

    for k,v in pairs(house.coords.wardrobe) do
        exports.plouffe_lib:DestroyZone(("house_%s_%s_%s"):format("wardrobe",k,house.id))
    end

    House.InsideHouse = nil
end

function HouseFnc:GetHouseEntryOrExit(house)
    for k,v in pairs(house.coords.entrance) do
        local outsideCheck = #(v.outside - House.Utils.pedCoords)
        local insideCheck = #(v.inside - House.Utils.pedCoords)

        if insideCheck <= outsideCheck and insideCheck <= 2.0 then
            return v.outside, "exit"
        elseif outsideCheck <= insideCheck and outsideCheck <= 2.0 then
            return v.inside, "entry"
        end
    end
    return false
end

function HouseFnc:TeleportPed(coords)
    local fadeTimer = GetGameTimer()

    DoScreenFadeOut(2000)

    while not IsScreenFadedOut() and GetGameTimer() - fadeTimer < 6000 do
        Wait(100)
    end

    SetEntityCoords(House.Utils.ped,coords)

    DoScreenFadeIn(2000)

    return true
end

function HouseFnc:EnterOrLeave(house)
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    local coords,type = self:GetHouseEntryOrExit(house)

    if not coords then
        return Utils:Notify("Aucune entré out sortit valid a été trouver pour votre maison (Corde d'erreur #5)","error")
    end

    if type == "exit" then
        self:TeleportPed(coords)
        self:DestroyHouse(house)

        exports.plouffe_lib:ChangeWeatherSync(true)
        exports.plouffe_lib:ChangeTimeSync(true)
        exports.plouffe_lib:Refresh(true, true)
    elseif type == "entry" then
        HouseFnc:CreateHouse(house,function(valid)
            if valid then
                self:TeleportPed(coords)

                exports.plouffe_lib:ChangeWeatherSync(false)
                exports.plouffe_lib:ChangeTimeSync(false)

                ClearOverrideWeather()
                ClearWeatherTypePersist()
                SetWeatherTypePersist("EXTRASUNNY")
                SetWeatherTypeNow("EXTRASUNNY")
                SetWeatherTypeNowPersist("EXTRASUNNY")

                NetworkOverrideClockTime(22, 22, 0)
            end
        end)
    end
end

function HouseFnc:OpenCreatorMenu()
    exports.ooc_menu:Open(House.Menu.shell_types, function(params)
        if not params then
            return
        end

        if params.shell_type then
            exports.ooc_menu:Open(House.Menu[params.shell_type], function(shell)
                if not shell then
                    return
                end

                self:HouseCreator(shell.model)
            end)
        end
    end)
end

function HouseFnc:CreatorCreateHouse(shell,cb)
    local modelHash = GetHashKey(shell)
    local createTime = GetGameTimer()
    local coords = GetOffsetFromEntityInWorldCoords(House.Utils.ped, 0.0, 20.0, 0.0)
    local shell_prop = CreateObject(modelHash, coords, false,false,false)

    while not DoesEntityExist(shell_prop) and GetGameTimer() - createTime < 5000 do
        Wait(100)
    end

    if not DoesEntityExist(shell_prop) then
        return false, Utils:Notify(("Il est impossible de crée cette intérieur %s (Code d'erreur #2)"):format(shell),"error")
    end

    House.Creator.shellCoords = GetEntityCoords(House.Creator.prop_id)
    House.Creator.prop_id = shell_prop
    House.Creator.createdHouse.metadata.shell = shell

    FreezeEntityPosition(House.Creator.prop_id,true)
    SetModelAsNoLongerNeeded(modelHash)

    cb(true)
end

function HouseFnc:HouseCreator(model)
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    self:ResetCreator()

    if not self:AssureModel(model) then
        return Utils:Notify("Model de maison est invalide (Code d'erreur #1)","error")
    end

    CreateThread(function()
        House.Creator.settingCoords = true

        while House.Creator.settingCoords and not House.Creator.canceled do
            Wait(0)
            self:ProcessOtherControls()
            self:CreatorLabelForCoords()
        end

        if not House.Creator.canceled then
            local fadeOutTime = GetGameTimer()

            DoScreenFadeOut(2000)

            while not IsScreenFadedOut() and GetGameTimer() - fadeOutTime < 4000 do
                Wait(100)
            end

            self:CreatorCreateHouse(model,function(valid)
                if valid then
                    self:CreatorCreateCam()
                    House.Creator.inCreator = true

                    while House.Creator.inCreator and not House.Creator.canceled do
                        self:ProcessCamControl()
                        self:ProcessShellControls()
                        self:CreatorNative()
                        self:CreatorLabel()
                        Wait(0)
                    end

                    if House.Creator.canceled then
                        self:ResetCreator()
                    end
                end
            end)
        else
            self:ResetCreator()
        end
    end)
end

function HouseFnc:SetExteriorCoords()
    if self:GetClosestDoor(5.0) then
        return Utils:Notify("Il y a déja une entré ici", "error")
    end

    House.Creator.createdHouse.coords.entrance[1].outside = GetEntityCoords(House.Utils.ped)
    House.Creator.settingCoords = false
end

function HouseFnc:CreatorCreateCam()
    House.Creator.cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", House.Creator.shellCoords, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(House.Creator.cam, true)
    RenderScriptCams(true, true, 8500, true, false)
    DoScreenFadeIn(2000)
end

function HouseFnc:ProcessCamControl()
    DisableFirstPersonCamThisFrame()
    local newPos = self:GetGamePostion()
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    SetCamCoord(House.Creator.cam, newPos.x, newPos.y, newPos.z + House.Creator.camHeight)
    PointCamAtCoord(House.Creator.cam, House.Creator.shellCoords.x, House.Creator.shellCoords.y, House.Creator.shellCoords.z)
end

function HouseFnc:GetGamePostion()
    local mouseX = GetDisabledControlNormal(1, 1) * 8.0
    local mouseY = GetDisabledControlNormal(1, 2) * 8.0

    House.Creator.angleZ = House.Creator.angleZ - mouseX
    House.Creator.angleY = House.Creator.angleY + mouseY

    if (House.Creator.angleY > 89.0) then
        House.Creator.angleY = 89.0
    elseif (House.Creator.angleY < -89.0) then
        House.Creator.angleY = -89.0
    end

    local behindCam = {
        x = House.Creator.shellCoords.x + ((Cos(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Cos(House.Creator.angleZ))) / 2 * (3.0+ 0.5),
        y = House.Creator.shellCoords.y + ((Sin(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Sin(House.Creator.angleZ))) / 2 * (3.0+ 0.5),
        z = House.Creator.shellCoords.z + ((Sin(House.Creator.angleY))) * (3.0+ 0.5)
    }
    local rayHandle = StartShapeTestRay(House.Creator.shellCoords.x, House.Creator.shellCoords.y, House.Creator.shellCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, House.Creator.prop_id, 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local maxRadius = House.Creator.camHeight
    if (hitBool and Vdist(House.Creator.shellCoords.x, House.Creator.shellCoords.y, House.Creator.shellCoords.z + 0.5, hitCoords) < 3.0+ 0.5) then
        maxRadius = Vdist(House.Creator.shellCoords.x, House.Creator.shellCoords.y, House.Creator.shellCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Cos(House.Creator.angleZ))) / 2 * maxRadius,
        y = ((Sin(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Sin(House.Creator.angleZ))) / 2 * maxRadius,
        z = ((Sin(House.Creator.angleY))) * maxRadius
    }

    local pos = {
        x = House.Creator.shellCoords.x + offset.x,
        y = House.Creator.shellCoords.y + offset.y,
        z = House.Creator.shellCoords.z + offset.z
    }

    return pos
end

function HouseFnc:ResetCreator()
    FreezeEntityPosition(House.Utils.ped, false)
    DestroyCam(House.Creator.cam, true)
    DeleteEntity(House.Creator.prop_id)
    RenderScriptCams(false, false, 0, true, false)
    ClearFocus()

    House.Creator.canceled = false
    House.Creator.disable_controls = true
    House.Creator.currentSpeed = 0.1
    House.Creator.prop_id = 0
    House.Creator.settingCoords = false
    House.Creator.inCreator = false
    House.Creator.cam = nil
    House.Creator.angleZ = 0.0
    House.Creator.angleY = 0.0
    House.Creator.createdHouse = {
        coords = {
            entrance =  {
                {
                    inside = vector3(0,0,0), -- This should be offSet
                    outside = vector3(0,0,0) -- This Should be Set By the player
                }
            }
        },
        metadata = {
            shell = "",
            coords = vector3(0,0,0),
        }
    }

    return true
end

function HouseFnc:CreatorNative()
    House.Creator.shellCoords = GetEntityCoords(House.Creator.prop_id)
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    FreezeEntityPosition(House.Utils.ped, true)
    FreezeEntityPosition(House.Creator.prop_id, true)
    SetEntityCollision(House.Creator.prop_id, false, false)

    DisableControlAction(0, House.Creator.keys["W"], true)
    DisableControlAction(0, House.Creator.keys["S"], true)
    DisableControlAction(0, House.Creator.keys["A"], true)
    DisableControlAction(0, House.Creator.keys["D"], true)
    DisableControlAction(0, House.Creator.keys["SPACE"], true)
    DisableControlAction(0, House.Creator.keys["Z"], true)
    DisableControlAction(0, House.Creator.keys['H'], true)
    DisableControlAction(0, House.Creator.keys['Q'], true)
    DisableControlAction(0, House.Creator.keys['E'], true)
    DisableControlAction(0, House.Creator.keys['LEFTSHIFT'], true)
    DisableControlAction(0, House.Creator.keys['TAB'], true)
    DisableControlAction(0, House.Creator.keys['WHEELUP'], true)
    DisableControlAction(0, House.Creator.keys['WHEELDOWN'], true)
    DisableControlAction(0, House.Creator.keys['K'], true)

    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)
end

function HouseFnc:ProcessOtherControls()
    if IsDisabledControlJustPressed(0, House.Creator.keys["TAB"]) then
        exports.ooc_menu:Open(House.Menu.confirm_entry, function(menuParams)
            if not menuParams then
                return
            end

            if menuParams.confirm then
                self:SetExteriorCoords()
            end
        end)
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["K"]) then
        exports.ooc_menu:Open(House.Menu.cancel_creator, function(menuParams)
            if not menuParams then
                return
            end

            if menuParams.confirm then
                House.Creator.canceled = true
            end
        end)
    end
end

function HouseFnc:ProcessShellControls()
    local xoff = 0.0
    local yoff = 0.0
    local zoff = 0.0

    if IsDisabledControlJustPressed(1, House.Creator.keys['WHEELDOWN']) then
        House.Creator.currentSpeed = House.Creator.currentSpeed - 0.1
        if House.Creator.currentSpeed <= 0.0 then
            House.Creator.currentSpeed = 0.1
        end
    end

    if IsDisabledControlJustPressed(1, House.Creator.keys['WHEELUP']) then
        House.Creator.currentSpeed = House.Creator.currentSpeed + 0.1
        if House.Creator.currentSpeed > 1.0 then
            House.Creator.currentSpeed = 1.0
        end
    end

    if IsDisabledControlPressed(0, House.Creator.keys['E']) then
        SetEntityHeading(House.Creator.prop_id, GetEntityHeading(House.Creator.prop_id) + (House.Creator.offSets.h * (House.Creator.currentSpeed + 0.0)))
    end

    if IsDisabledControlPressed(0, House.Creator.keys['Q']) then
        SetEntityHeading(House.Creator.prop_id, GetEntityHeading(House.Creator.prop_id) - (House.Creator.offSets.h * (House.Creator.currentSpeed + 0.0)))
    end

    if IsDisabledControlPressed(0, House.Creator.keys["W"]) then
        yoff = House.Creator.offSets.y
    end

    if IsDisabledControlPressed(0, House.Creator.keys["S"]) then
        yoff = - House.Creator.offSets.y
    end

    if IsDisabledControlPressed(0, House.Creator.keys["A"]) then
        xoff = House.Creator.offSets.x
    end

    if IsDisabledControlPressed(0, House.Creator.keys["D"]) then
        xoff = - House.Creator.offSets.x
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["RIGHTMOUSE"]) then
        House.Creator.camHeight = House.Creator.camHeight + 10.0
        if House.Creator.camHeight > 100.0 then
            House.Creator.camHeight = 0.0
        end
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["K"]) then
        exports.ooc_menu:Open(House.Menu.cancel_creator, function(menuParams)
            if not menuParams then
                return
            end

            if menuParams.confirm then
                House.Creator.canceled = true
            end
        end)
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["TAB"]) then
        exports.ooc_menu:Open(House.Menu.confirm_shell, function(menuParams)
            if not menuParams then
                return
            end

            if menuParams.confirm then
                self:ValidateInteriorLocation()
            end
        end)
    end

    if IsDisabledControlPressed(0, House.Creator.keys["SPACE"]) then
        zoff = House.Creator.offSets.z
    end

    if IsDisabledControlPressed(0, House.Creator.keys["Z"]) then
        zoff = -House.Creator.offSets.z
    end

    local newPos = GetOffsetFromEntityInWorldCoords(House.Creator.prop_id, xoff * (House.Creator.currentSpeed + 0.0), yoff * (House.Creator.currentSpeed + 0.0), zoff * (House.Creator.currentSpeed + 0.0))
    local heading = GetEntityHeading(House.Creator.prop_id)

    SetEntityVelocity(House.Creator.prop_id, 0.0, 0.0, 0.0)
    SetEntityRotation(House.Creator.prop_id, 0.0, 0.0, 0.0, 0, false)
    SetEntityHeading(House.Creator.prop_id, heading)

    if #(House.Creator.createdHouse.coords.entrance[1].outside - newPos) <= 75.0 then
        SetEntityCoordsNoOffset(House.Creator.prop_id, newPos.x, newPos.y, newPos.z, true, true, true)
    end
end

function HouseFnc:LabelMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function HouseFnc:CreatorLabel()
    local scaleform = RequestScaleformMovie("instructional_buttons")
    local houseNear, closestCoords = self:GetClosestHouseDistance()

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["K"], true))
    self:LabelMessage("Annuler la création")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["SPACE"], true))
    self:LabelMessage("Monter")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["Z"], true))
    self:LabelMessage("Descendre")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(3)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["D"], true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["A"], true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["S"], true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["W"], true))
    self:LabelMessage("Déplacement")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(4)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["TAB"], true))
    self:LabelMessage("Confirmer l'emplacement")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(5)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["RIGHTMOUSE"], true))
    self:LabelMessage("Distance de vue")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(6)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["WHEELUP"], true))
    self:LabelMessage("Vitesse + 0.1")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(7)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["WHEELDOWN"], true))
    self:LabelMessage("Vitesse - 0.1")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(8)
    self:LabelMessage("Vitess: "..tostring(House.Creator.currentSpeed))
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(9)
    self:LabelMessage("Coords: "..tostring(House.Creator.shellCoords))
    EndScaleformMovieMethod()

    if houseNear then
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(10)
        self:LabelMessage("Une maison est trop près de la votre: "..closestCoords)
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

function HouseFnc:CreatorLabelForCoords()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["TAB"], true))
    self:LabelMessage("Confirmer l'emplacement de l'entré")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["K"], true))
    self:LabelMessage("Annuler la création")
    EndScaleformMovieMethod()


    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

function HouseFnc:GetClosestHouseDistance()
    for k,v in pairs(House.Houses) do
        if #(v.metadata.coords - House.Creator.shellCoords) <= 40.0 then
            return true, tostring(math.ceil(#(v.metadata.coords - House.Creator.shellCoords)))
        end
    end
    return false, ""
end

function HouseFnc:GetClosestDoor(maxDst)
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    for id,house in pairs(House.Houses) do
        for k,v in pairs(house.coords.entrance) do

            if #(v.outside - House.Utils.pedCoords) <= maxDst then
                return v
            end
        end
    end

    return nil
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

function HouseFnc:GetClosestHouseFromDoorCoords(maxDst)
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    for id,house in pairs(House.Houses) do
        for k,v in pairs(house.coords.entrance) do

            if #(v.outside - House.Utils.pedCoords) <= maxDst then
                return house
            end
        end
    end

    return nil
end

function HouseFnc:ValidateInteriorLocation()
    if self:GetClosestHouseDistance() then
        return Utils:Notify("Il y a déja un intérieur trop près de celui la", "error")
    end

    exports.ooc_dialog:Open({
        rows = {
            {
                id = 0,
                txt = "Prix "
            }
        }
    }, function(data)
        if not data then return end

        if not data[1].input or not tonumber(data[1].input) or tonumber(data[1].input) < 0 then
            return Utils:Notify("Le prix que vous avez entré est invalide", "error")
        end

        House.Creator.createdHouse.coords.entrance[1].inside = GetOffsetFromEntityInWorldCoords(House.Creator.prop_id,House.OffSets[House.Creator.createdHouse.metadata.shell].default.coords)
        House.Creator.createdHouse.metadata.coords = House.Creator.shellCoords
        House.Creator.createdHouse.metadata.heading = GetEntityHeading(House.Creator.prop_id)
        House.Creator.inCreator = false

        TriggerServerEvent("plouffe_housing:create_new_house", House.Creator.createdHouse, tonumber(data[1].input), House.Utils.MyAuthKey)

        CreateThread(function()
            Wait(500)
            self:ResetCreator()
        end)
    end)
end

function HouseFnc:CreateHouseBlip(house)
    local sprite = 134
    local createblip = false
    local name = "Etablisement a vendre"
    local color = 46

    if House.Utils.blips[tostring(house.id)] then
        RemoveBlip(House.Utils.blips[tostring(house.id)])
    end

    if house.owner_state_id and (self:IsHouseOwner(house) or self:HasHouseKeys(house)) and not house.metadata.forsale then
        sprite = 40
        color = 63
        name = house.label or ("Maison %s"):format(house.id)
        createblip = true
    elseif not house.owner_state_id and house.metadata.forsale then
        createblip = true
    end

    if createblip then
        House.Utils.blips[tostring(house.id)] = AddBlipForCoord(house.coords.entrance[1].outside)
        SetBlipSprite (House.Utils.blips[tostring(house.id)],sprite)
        SetBlipColour (House.Utils.blips[tostring(house.id)],color)
        SetBlipDisplay(House.Utils.blips[tostring(house.id)],3)
        SetBlipScale  (House.Utils.blips[tostring(house.id)],0.75)
        SetBlipAsShortRange(House.Utils.blips[tostring(house.id)], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(name)
        EndTextCommandSetBlipName(House.Utils.blips[tostring(house.id)])
    end
end

function HouseFnc:IsHouseOwner(house)
    return house.owner_state_id == House.Player.state_id
end

function HouseFnc:HasHouseKeys(house)
    for k,v in pairs(house.keys) do
        if v.state_id == House.Player.state_id then
            return true
        end
    end
    return false
end

function HouseFnc:CanBreach()
    if House.RaidJobs[House.Player.job.name] then
        if House.RaidJobs[House.Player.job.name][tostring(House.Player.job.grade)] then
            return true
        end
    end
end

function HouseFnc:HashBreachedInventoryAcces()
    if House.RaidJobsInventory[House.Player.job.name] then
        if House.RaidJobsInventory[House.Player.job.name][tostring(House.Player.job.grade)] then
            return true
        end
    end
end

function HouseFnc:ProcessNewHouse(house_data)
    House.Houses[tostring(house_data.id)] = house_data
    self:CreateHouseBlip(House.Houses[tostring(house_data.id)])
end

function HouseFnc:InteractWithDoor()
    local house = self:GetClosestHouseFromDoorCoords(2.0)

    local menuData = {}

    if House.InsideHouse then
        local house = House.Houses[tostring(House.InsideHouse.id)]
        local owner = self:IsHouseOwner(house)
        local hasKeys = self:HasHouseKeys(house)

        if (owner or hasKeys) and self:IsAllowedToAddDoors() then
            table.insert(menuData,{
                id = "housing_add_door",
                displayName = "Ajouter une porte",
                icon = "#house-removekey",
                params = {fnc = "AddHouseDoor", id = house.id}
            })
        end

        if house.owner_state_id and owner and #house.coords.inventory < House.Maximums.inventory then
            table.insert(menuData,{
                id = "place_inventory",
                displayName = ("Placer un inventaire %s/%s"):format(#house.coords.inventory, House.Maximums.inventory),
                icon = "#house-setstash",
                params = {fnc = "PlaceNewInventory"}
            })
        end

        if house.owner_state_id and owner and #house.coords.wardrobe < House.Maximums.wardrobe then
            table.insert(menuData,{
                id = "place_wardrobe",
                displayName = ("Placer un garde-robe %s/%s"):format(#house.coords.wardrobe, House.Maximums.wardrobe),
                icon = "#house-setoutift",
                params = {fnc = "PlaceNewWardrobe"}
            })
        end

        if house.owner_state_id and (owner or hasKeys) and self:IsEntryNear(house) then
            if not house.metadata.lock and house.owner_state_id and (owner or hasKeys) and not house.metadata.forsale then
                table.insert(menuData,{
                    id = "lock",
                    displayName = "Vérouiller",
                    icon = "#house-doorlock",
                    params = {fnc = "Lock", id = house.id}
                })
            elseif house.metadata.lock and house.owner_state_id and (owner or hasKeys) and not house.metadata.forsale then
                table.insert(menuData,{
                    id = "unlock",
                    displayName = "Dévérouiller",
                    icon = "#house-resetlock",
                    params = {fnc = "Unlock", id = house.id}
                })
            end
        end

        if house.owner_state_id and owner and not house.metadata.forsale then
            table.insert(menuData,{
                id = "give_key",
                displayName = "Donner les clées",
                icon = "#house-givekey",
                params = {fnc = "GiveKeys", id = house.id}
            })

            table.insert(menuData,{
                id = "list_keys",
                displayName = "Liste des clées",
                icon = "#house-removekey",
                params = {fnc = "ShowPlayerKeys", id = house.id}
            })
        end

        if house.owner_state_id and (owner or hasKeys) and not house.metadata.forsale then
            table.insert(menuData,{
                id = "decoration",
                displayName = "Ameublement",
                icon = "#house-decorate",
                params = {fnc = "SelectDeleteOrAddFurniture", id = house.id}
            })
        end
    elseif house then
        local owner = self:IsHouseOwner(house)
        local hasKeys = self:HasHouseKeys(house)
        local canBreach = self:CanBreach(house)

        if not house.metadata.lock and house.owner_state_id and (owner or hasKeys) and not house.metadata.forsale then
            table.insert(menuData,{
                id = "lock",
                displayName = "Vérouiller",
                icon = "#house-doorlock",
                params = {fnc = "Lock", id = house.id}
            })
        elseif house.metadata.lock and house.owner_state_id and (owner or hasKeys) and not house.metadata.forsale then
            table.insert(menuData,{
                id = "unlock",
                displayName = "Dévérouiller",
                icon = "#house-resetlock",
                params = {fnc = "Unlock", id = house.id}
            })
        elseif house.metadata.lock and house.owner_state_id and canBreach and not house.metadata.forsale then
            table.insert(menuData,{
                id = "breach",
                displayName = ("Défoncer la porte %s $"):format(House.BreachPrice),
                icon = "#house-doorlock",
                params = {fnc = "Breach", id = house.id}
            })
        elseif House.Breached[tostring(house.id)] and house.owner_state_id and canBreach and not house.metadata.forsale then
            table.insert(menuData,{
                id = "Unbreach",
                displayName = ("Vérouiller"),
                icon = "#house-doorlock",
                params = {fnc = "Unbreach", id = house.id}
            })
        end

        if house.metadata.lock and house.owner_state_id and owner and not house.metadata.forsale then
            table.insert(menuData,{
                id = "sell",
                displayName = "Mettre en vente",
                icon = "#animation-money",
                params = {fnc = "Sell", id = house.id}
            })
        end

        if not house.metadata.lock and house.owner_state_id and (owner or hasKeys) and not house.metadata.forsale then
            table.insert(menuData,{
                id = "enter",
                displayName = "Entré",
                icon = "#house",
                params = {fnc = "LoadHouse", id = house.id}
            })
        elseif not house.metadata.lock and house.owner_state_id and not owner and not hasKeys and not house.metadata.forsale then
            table.insert(menuData,{
                id = "enter",
                displayName = "Entré",
                icon = "#house",
                params = {fnc = "Visit", id = house.id}
            })
        end

        if house.metadata.forsale then
            table.insert(menuData,{
                id = "buy",
                displayName = ("Acheter %s $"):format(house.metadata.price),
                icon = "#animation-money",
                params = {fnc = "Buy", id = house.id}
            })
            table.insert(menuData,{
                id = "visit",
                displayName = ("Visiter"),
                icon = "#house",
                params = {fnc = "Visit", id = house.id}
            })
            if not house.owner_state_id and self:CanCreateHouse() then
                table.insert(menuData,{
                    id = "destroy",
                    displayName = ("Detruire la maison"),
                    icon = "#house",
                    params = {fnc = "Destroy", id = house.id}
                })
            end
            if not house.owner_state_id and self:CanCreateHouse() then
                table.insert(menuData,{
                    id = "add_garage",
                    displayName = ("Ajouter un garage"),
                    icon = "#house",
                    params = {fnc = "AddGarage", id = house.id}
                })
            end
        end
    end

    if #menuData > 0 then
        exports.ooc_radial_menu:Open(menuData,nil,function(params)
            if params then
                if self[params.fnc] then
                    self[params.fnc](self,params)
                end
            end
        end)
    else
        Utils:Notify("Aucune action n'est possible présentement", "error")
    end
end

function HouseFnc:ShowPlayerKeys(info)
    local closestPlayer, distance = Utils:GetClosestPlayer()
    local house = House.Houses[tostring(info.id)]
    local owner = self:IsHouseOwner(house)
    local menuData = {}

    for k,v in pairs(house.keys) do
        table.insert(menuData,{
            id = k,
            header = v.name,
            txt = "Selectioner pour retirer les clées",
            params = {
                event = "",
                args = {
                    player = v
                }
            }
        })
    end

    if #menuData > 0 then
        exports.ooc_menu:Open(menuData, function(params)
            if not params then
                return
            end

            exports.ooc_menu:Open({
                {
                    id = 1,
                    header = ("Voulez vous vraiment retirer les clées a %s "):format(params.player.name),
                    txt = "Selectioner 'Oui' pour comfirmer",
                    params = {
                        event = "",
                        args = {
                        }
                    }
                },

                {
                    id = 2,
                    header = "Oui",
                    txt = ("Retirer les clées a %s"):format(params.player.name),
                    params = {
                        event = "",
                        args = {
                            validate = true
                        }
                    }
                },

                {
                    id = 3,
                    header = "Non",
                    txt = "Fermer le menu",
                    params = {
                        event = "",
                        args = {
                        }
                    }
                }

            }, function(valid)
                if not valid then
                    return
                end

                if valid.validate then
                    TriggerServerEvent("plouffe_housing:remove_player_keys",info.id,params.player,House.Utils.MyAuthKey)
                end
            end)
        end)
    else
        Utils:Notify("Personne na les clées mise appart vous", "error")
    end
end

function HouseFnc:GiveKeys(params)
    local closestPlayer, distance = Utils:GetClosestPlayer()
    local house = House.Houses[tostring(params.id)]
    local owner = self:IsHouseOwner(house)

    if owner then
        if closestPlayer ~= -1 and distance <= 2.0 then
            local name = GetPlayerName(closestPlayer)
            exports.ooc_menu:Open({
                {
                    id = 1,
                    header = ("Voulez vous vraiment donner les clées a %s "):format(name),
                    txt = "Selectioner 'Oui' pour comfirmer",
                    params = {
                        event = "",
                        args = {
                        }
                    }
                },

                {
                    id = 2,
                    header = "Oui",
                    txt = ("Donner %s"):format(name),
                    params = {
                        event = "",
                        args = {
                            validate = true
                        }
                    }
                },

                {
                    id = 3,
                    header = "Non",
                    txt = "Fermer le menu",
                    params = {
                        event = "",
                        args = {
                        }
                    }
                }

            }, function(params2)
                if not params2 then
                    return
                end

                if params2.validate then
                    TriggerServerEvent("plouffe_housing:give_player_keys",params.id,GetPlayerServerId(closestPlayer),House.Utils.MyAuthKey)
                end
            end)
        else
            Utils:Notify("Aucun joueur près", "error")
        end
    end
end

function HouseFnc:InventoryNear(house)
    for k,v in pairs(house.coords.inventory) do
        if #(v.coords - House.Utils.pedCoords) <= 3.0 then
            return true
        end
    end
    return false
end

function HouseFnc:IsWardRobeNear(house)
    for k,v in pairs(house.coords.wardrobe) do
        if #(v.coords - House.Utils.pedCoords) <= 3.0 then
            return true
        end
    end
    return false
end

function HouseFnc:IsEntryNear(house)
    for k,v in pairs(house.coords.entrance) do
        if #(v.inside - House.Utils.pedCoords) <= 2.0 then
            return true
        end
    end
    return false
end

function HouseFnc:PlaceNewInventory()
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    if self:InventoryNear(House.Houses[tostring(House.InsideHouse.id)]) then
        return Utils:Notify("Il y a déja un inventaire trop près","error")
    elseif self:IsWardRobeNear(House.Houses[tostring(House.InsideHouse.id)]) then
        return Utils:Notify("Il y a un garde robe trop près","error")
    elseif self:IsEntryNear(House.Houses[tostring(House.InsideHouse.id)]) then
        return Utils:Notify("Il y a un entré trop près", "error")
    end

    exports.ooc_menu:Open(House.Menu.confirm_inventory_placement, function(params)
        if not params then
            return
        end

        if params.confirm then
            House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)
            if #(House.Utils.pedCoords - House.Houses[tostring(House.InsideHouse.id)].metadata.coords) <= 50.0 then
                TriggerServerEvent("plouffe_housing:add_inventory_coords",House.InsideHouse.id,House.Utils.MyAuthKey)
            else
                Utils:Notify("Vous etes trop loin", "error")
            end
        end
    end)
end

function HouseFnc:PlaceNewWardrobe()
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    if self:InventoryNear(House.Houses[tostring(House.InsideHouse.id)]) then
        return Utils:Notify("Il y a déja un inventaire trop près","error")
    elseif self:IsWardRobeNear(House.Houses[tostring(House.InsideHouse.id)]) then
        return Utils:Notify("Il y a un garde robe trop près","error")
    elseif self:IsEntryNear(House.Houses[tostring(House.InsideHouse.id)]) then
        return Utils:Notify("Il y a un entré trop près", "error")
    end

    exports.ooc_menu:Open(House.Menu.confirm_wardrobe_placement, function(params)
        if not params then
            return
        end

        if params.confirm then
            House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)
            if #(House.Utils.pedCoords - House.Houses[tostring(House.InsideHouse.id)].metadata.coords) <= 50.0 then
                TriggerServerEvent("plouffe_housing:add_wardrobe_coords",House.InsideHouse.id,House.Utils.MyAuthKey)
            else
                Utils:Notify("Vous etes trop loin", "error")
            end
        end
    end)
end

function HouseFnc:Unbreach(params)
    local house = House.Houses[tostring(params.id)]
    local canBreach = self:CanBreach(house)
    TriggerServerEvent("plouffe_housing:unbreach", params.id, House.Utils.MyAuthKey)
end

function HouseFnc:Breach(params)
    local house = House.Houses[tostring(params.id)]
    local canBreach = self:CanBreach(house)
    House.Utils.ped = PlayerPedId()

    math.randomseed(GetGameTimer())
    local kek = math.random(1,2)
    local penis = math.random(1,2)
    self:PlayAnim("anim","missprologuemcs_1","kick_down_player_zero",1,2500)

    if penis == kek then
        TriggerServerEvent("plouffe_housing:breach", params.id, House.Utils.MyAuthKey)
        Utils:Notify("Vous avez défoncer la porte","success")
    else
        Utils:Notify("Vous n'avez pas été apte a défoncer la porte","error")
    end
end

function HouseFnc:Unlock(params)
    local house = House.Houses[tostring(params.id)]
    local owner = self:IsHouseOwner(house)
    local hasKeys = self:HasHouseKeys(house)

    if owner or hasKeys then
        TriggerServerEvent("plouffe_housing:unlock_house", params.id, House.Utils.MyAuthKey)
        self:PlayAnim("anim","anim@mp_player_intmenu@key_fob@","fob_click",49,1000)
        Wait(100)
        self:InteractWithDoor()
    end
end

function HouseFnc:Lock(params)
    local house = House.Houses[tostring(params.id)]
    local owner = self:IsHouseOwner(house)
    local hasKeys = self:HasHouseKeys(house)

    if owner or hasKeys then
        TriggerServerEvent("plouffe_housing:lock_house", params.id, House.Utils.MyAuthKey)
        self:PlayAnim("anim","anim@mp_player_intmenu@key_fob@","fob_click",49,1000)
        Wait(100)
        self:InteractWithDoor()
    end
end

function HouseFnc:Sell(params)
    local house = House.Houses[tostring(params.id)]
    local owner = self:IsHouseOwner(house)
    if owner then
        exports.ooc_dialog:Open({
            rows = {
                {
                    id = 0,
                    txt = "Prix "
                }
            }
        }, function(data)
            if not data then return end

            if not data[1].input or not tonumber(data[1].input) or tonumber(data[1].input) < 0 then
                return Utils:Notify("Le prix que vous avez entré est invalide", "error")
            end

            TriggerServerEvent("plouffe_housing:sellhouse", params.id, tonumber(data[1].input), House.Utils.MyAuthKey)
        end)
    end
end

function HouseFnc:Buy(params)
    exports.ooc_menu:Open({
        {
            id = 1,
            header = ("Etes vous certain de vouloir acheter cette emplacement pour %s $"):format(House.Houses[tostring(params.id)].metadata.price),
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Vous aller acheter cette emplacement",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Ferme le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    }, function(menuParams)
        if not menuParams then
            return
        end

        if menuParams.confirm then
            TriggerServerEvent("plouffe_housing:buy_house", params.id, House.Utils.MyAuthKey)
        end
    end)
end

function HouseFnc:Destroy(params)
    local house = House.Houses[tostring(params.id)]
    exports.ooc_menu:Open(House.Menu.confirm_destroy, function(menuParams)
        if not menuParams then
            return
        end

        if menuParams.confirm then
            TriggerServerEvent("plouffe_housing:destroy_house", params.id, House.Utils.MyAuthKey)
        end
    end)
end

function HouseFnc:LoadHouse(params)
    local house = House.Houses[tostring(params.id)]
    self:CreateHouse(house,function()
        self:EnterOrLeave(house)
        self:CreateAllZones(house)
    end)
end

function HouseFnc:Visit(params)
    local house = House.Houses[tostring(params.id)]
    self:CreateHouse(house,function()
        self:EnterOrLeave(house)

        if House.Breached[tostring(house.id)] and self:HashBreachedInventoryAcces() then
            self:CreateAllZones(house)
        else
            self:ExportDoorsOnly(house)
        end
    end)
end

function HouseFnc:ExportDoorsOnly(house,destroy)
    for k,v in pairs(house.coords.entrance) do
        exports.plouffe_lib:ValidateZoneData(
            {
                name = ("house_%s_%s_%s"):format("entrance",k,house.id),
                coords = v.inside,
                maxDst = 1.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Sortir",
                aditionalParams = {fnc = "InsideHouseInteraction", id = house.id, type = "leave"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "plouffe_housing:on_zones",
                    key = "E"
                }
            }
        )
    end
end

function HouseFnc:InsideHouseInteraction(params)
    local house = House.Houses[tostring(params.id)]

    if params.type == "leave" then
        -- if House.Houses[tostring(params.id)].metadata.lock and House.Houses[tostring(params.id)].owner then
            -- return Utils:Notify("La porte est vérouiller", "error")
        -- end

        self:EnterOrLeave(house)
        self:DestroyHouse(house)
    end
end

function HouseFnc:OpenInventory(params)
    local house = House.Houses[tostring(params.id)]
    local owner = self:IsHouseOwner(house)
    local hasKeys = self:HasHouseKeys(house)

    if (owner or hasKeys) or (House.Breached[tostring(house.id)] and self:HashBreachedInventoryAcces()) then
        local inventoryName = Callback:Sync("plouffe_housing:get_inventory_name", params.id, House.Utils.MyAuthKey)
        exports.ox_inventory:openInventory("stash", {id = inventoryName, type = "stash"})
        -- TriggerServerEvent("plouffe_housing:open_inventory", params.id, House.Utils.MyAuthKey)
    end
end

function HouseFnc:OpenWardrobe(params)
    local house = House.Houses[tostring(params.id)]
    local owner = self:IsHouseOwner(house)
    local hasKeys = self:HasHouseKeys(house)

    if owner or hasKeys then
        Core.Skin:OpenWardrobe()
    end
end

function HouseFnc:CreatePropMenuList()
    for index,list in pairs(House.Props) do
        if not House.Menu[index] then
            House.Menu[index] = {}
        end

        for k,v in ipairs(list) do
            House.Menu[index][k] = {
                id = k,
                header = v.name,
                txt = ("Prix %s $"):format(v.price),
                params = {
                    event = "",
                    args = {
                        info = v
                    }
                }
            }
        end
    end
end

function HouseFnc:SelectProp(cb)
    exports.ooc_menu:Open(House.Menu.props_type,function(prop)
        if not prop then
            return
        end

        exports.ooc_menu:Open(House.Menu[prop.type],function(item)
            if not item then
                return
            end

            self:CreateProp(item.info,cb)
        end)
    end)
end

function HouseFnc:CreateProp(item,cb)
    if not self:AssureModel(item.model) then
        return Utils:Notify("Il est impossible de valider cette object (Code d'erreur #12)", "error")
    end

    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    local offSet = GetOffsetFromEntityInWorldCoords(House.Utils.ped, 0.0, 2.0, 0.0)
    local createTime = GetGameTimer()
    local item_prop = CreateObject(item.model, offSet.x, offSet.y, offSet.z, false, false, false)

    while not DoesEntityExist(item_prop) and GetGameTimer() - createTime < 5000 do
        Wait(100)
    end

    if not DoesEntityExist(item_prop) then
        return false, Utils:Notify(("Il est impossible de crée cette object %s (Code d'erreur #13)"):format(item.name),"error")
    end

    House.PropsPlacer.createdProps[item_prop] = true
    House.PropsPlacer.prop_id = item_prop
    House.PropsPlacer.propCoords = GetEntityCoords(House.PropsPlacer.prop_id)

    FreezeEntityPosition(House.PropsPlacer.prop_id, true)
    SetEntityCollision(House.PropsPlacer.prop_id, false, false)

    cb(item)
end

function HouseFnc:StartPropPlacer()
    if House.PropsPlacer.active then
        House.PropsPlacer.active = false
        return
    end

    self:SelectProp(function(item)
        House.PropsPlacer.active = true
        House.PropsPlacer.currentItem = item

        self:PlacerCreateCam()

        Wait(2000)

        CreateThread(function()
            while House.PropsPlacer.active do
                self:PlacerLabel()
                self:PlacerNative()
                self:ProcessPropCamControl()
                self:ProcessItemControl()

                Wait(0)
            end

            self:ResetPropPlacer()
        end)
    end)
end

function HouseFnc:ResetPropPlacer()
    DestroyCam(House.PropsPlacer.cam, true)
    DeleteEntity(House.PropsPlacer.prop_id)
    RenderScriptCams(false, false, 0, true, false)
    ClearFocus()

    House.PropsPlacer.active = false
    House.PropsPlacer.camHeight = 1.0
    House.PropsPlacer.currentItem = {}
    House.PropsPlacer.createdProps = {}
    House.Creator.currentSpeed = 0.1
    House.Creator.prop_id = 0
    House.Creator.cam = nil

    return true
end

function HouseFnc:PlacerLabel()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["K"], true))
    self:LabelMessage("Annuler")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["SPACE"], true))
    self:LabelMessage("Monter")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["Z"], true))
    self:LabelMessage("Descendre")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(3)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["D"], true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["A"], true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["S"], true))
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["W"], true))
    self:LabelMessage("Déplacement")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(4)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["F"], true))
    self:LabelMessage("Confirmer l'emplacement")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(5)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["WHEELUP"], true))
    self:LabelMessage("Vitesse + 0.1")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(6)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["WHEELDOWN"], true))
    self:LabelMessage("Vitesse - 0.1")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(7)
    self:LabelMessage("Vitess: "..tostring(House.PropsPlacer.currentSpeed))
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(8)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["RIGHTMOUSE"], true))
    self:LabelMessage("Distance de vue")
    EndScaleformMovieMethod()

    -- PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    -- ScaleformMovieMethodAddParamInt(9)
    -- ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["TAB"], true))
    -- self:LabelMessage("Mettre au sol")
    -- EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

function HouseFnc:ProcessItemControl()
    local xoff = 0.0
    local yoff = 0.0
    local zoff = 0.0

    if IsDisabledControlJustPressed(1, House.Creator.keys['WHEELDOWN']) then
        House.PropsPlacer.currentSpeed = House.PropsPlacer.currentSpeed - 0.1
        if House.PropsPlacer.currentSpeed <= 0.0 then
            House.PropsPlacer.currentSpeed = 0.1
        end
    end

    if IsDisabledControlJustPressed(1, House.Creator.keys['WHEELUP']) then
        House.PropsPlacer.currentSpeed = House.PropsPlacer.currentSpeed + 0.1
        if House.PropsPlacer.currentSpeed > 1.0 then
            House.PropsPlacer.currentSpeed = 1.0
        end
    end

    if IsDisabledControlPressed(0, House.Creator.keys['E']) then
        local currentRotation = GetEntityRotation(House.PropsPlacer.prop_id, 2)
        local newRotation = vector3(currentRotation.x, currentRotation.y, currentRotation.z - (House.Creator.offSets.yaw * (House.PropsPlacer.currentSpeed + 0.0)))
        SetEntityRotation(House.PropsPlacer.prop_id, newRotation, 2)
    end

    if IsDisabledControlPressed(0, House.Creator.keys['Q']) then
        local currentRotation = GetEntityRotation(House.PropsPlacer.prop_id, 2)
        local newRotation = vector3(currentRotation.x, currentRotation.y, currentRotation.z + (House.Creator.offSets.yaw * (House.PropsPlacer.currentSpeed + 0.0)))
        SetEntityRotation(House.PropsPlacer.prop_id, newRotation, 2)
    end

    if IsDisabledControlPressed(0, House.Creator.keys["W"]) then
        yoff = House.Creator.offSets.y
    end

    if IsDisabledControlPressed(0, House.Creator.keys["S"]) then
        yoff = - House.Creator.offSets.y
    end

    if IsDisabledControlPressed(0, House.Creator.keys["A"]) then
        xoff = House.Creator.offSets.x
    end

    if IsDisabledControlPressed(0, House.Creator.keys["D"]) then
        xoff = - House.Creator.offSets.x
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["RIGHTMOUSE"]) then
        House.PropsPlacer.camHeight = House.PropsPlacer.camHeight + 1.0
        if House.PropsPlacer.camHeight > 6.0 then
            House.PropsPlacer.camHeight = 1.0
        end
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["K"]) then
        exports.ooc_menu:Open(House.Menu.cancel_creator, function(menuParams)
            if not menuParams then
                return
            end

            if menuParams.confirm then
                House.PropsPlacer.active = false
            end
        end)
    end

    if IsDisabledControlPressed(0, House.Creator.keys["N4"]) then
        local currentRotation = GetEntityRotation(House.PropsPlacer.prop_id, 2)
        local newRotation = vector3(currentRotation.x, currentRotation.y - (House.Creator.offSets.roll * (House.PropsPlacer.currentSpeed + 0.0)), currentRotation.z)
        SetEntityRotation(House.PropsPlacer.prop_id, newRotation, 2)
    end

    if IsDisabledControlPressed(0, House.Creator.keys["N6"]) then
        local currentRotation = GetEntityRotation(House.PropsPlacer.prop_id, 2)
        local newRotation = vector3(currentRotation.x, currentRotation.y + (House.Creator.offSets.roll * (House.PropsPlacer.currentSpeed + 0.0)), currentRotation.z)
        SetEntityRotation(House.PropsPlacer.prop_id, newRotation, 2)
    end

    if IsDisabledControlPressed(0, House.Creator.keys["N8"]) then
        local currentRotation = GetEntityRotation(House.PropsPlacer.prop_id, 2)
        local newRotation = vector3(currentRotation.x - (House.Creator.offSets.pitch * (House.PropsPlacer.currentSpeed + 0.0)), currentRotation.y, currentRotation.z)
        SetEntityRotation(House.PropsPlacer.prop_id, newRotation, 2)
    end

    if IsDisabledControlPressed(0, House.Creator.keys["N5"]) then
        local currentRotation = GetEntityRotation(House.PropsPlacer.prop_id, 2)
        local newRotation = vector3(currentRotation.x + (House.Creator.offSets.pitch * (House.PropsPlacer.currentSpeed + 0.0)), currentRotation.y, currentRotation.z)
        SetEntityRotation(House.PropsPlacer.prop_id, newRotation, 2)
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["F"]) then
        exports.ooc_menu:Open(House.Menu.confirm_shell, function(menuParams)
            if not menuParams then
                return
            end

            if menuParams.confirm then
                TriggerServerEvent("plouffe_housing:add_furniture",House.InsideHouse.id,House.PropsPlacer.currentItem,House.Utils.MyAuthKey)
                House.PropsPlacer.active = false
            end
        end)
    end

    if IsDisabledControlPressed(0, House.Creator.keys["SPACE"]) then
        zoff = House.Creator.offSets.z
    end

    if IsDisabledControlPressed(0, House.Creator.keys["Z"]) then
        zoff = -House.Creator.offSets.z
    end

    local newPos = GetOffsetFromEntityInWorldCoords(House.PropsPlacer.prop_id, xoff * (House.PropsPlacer.currentSpeed + 0.0), yoff * (House.PropsPlacer.currentSpeed + 0.0), zoff * (House.PropsPlacer.currentSpeed + 0.0))

    SetEntityVelocity(House.PropsPlacer.prop_id, 0.0, 0.0, 0.0)

    if #(House.Utils.pedCoords - newPos) <= 20.0 then
        SetEntityCoordsNoOffset(House.PropsPlacer.prop_id, newPos.x, newPos.y, newPos.z, true, true, true)
    end
end

function HouseFnc:PlacerNative()
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)
    House.PropsPlacer.propCoords = GetEntityCoords(House.PropsPlacer.prop_id)
    House.PropsPlacer.currentItem.coords = House.PropsPlacer.propCoords
    House.PropsPlacer.currentItem.rotation = GetEntityRotation(House.PropsPlacer.prop_id)

    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)
end

function HouseFnc:PlacerCreateCam()
    House.PropsPlacer.cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", House.PropsPlacer.propCoords, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(House.PropsPlacer.cam, true)
    RenderScriptCams(true, true, 2000, true, false)
    DoScreenFadeIn(2000)
end

function HouseFnc:ProcessPropCamControl()
    DisableFirstPersonCamThisFrame()
    local newPos = self:GetPlacerGamePostion()
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    SetCamCoord(House.PropsPlacer.cam, newPos.x, newPos.y, newPos.z + 1.0)
    PointCamAtCoord(House.PropsPlacer.cam, House.PropsPlacer.propCoords.x, House.PropsPlacer.propCoords.y, House.PropsPlacer.propCoords.z)
end

function HouseFnc:GetPlacerGamePostion()
    local mouseX = GetDisabledControlNormal(1, 1) * 8.0
    local mouseY = GetDisabledControlNormal(1, 2) * 8.0

    House.Creator.angleZ = House.Creator.angleZ - mouseX
    House.Creator.angleY = House.Creator.angleY + mouseY

    if (House.Creator.angleY > 89.0) then
        House.Creator.angleY = 89.0
    elseif (House.Creator.angleY < -89.0) then
        House.Creator.angleY = -89.0
    end

    local behindCam = {
        x = House.PropsPlacer.propCoords.x + ((Cos(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Cos(House.Creator.angleZ))) / 2 * (3.0+ 0.5),
        y = House.PropsPlacer.propCoords.y + ((Sin(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Sin(House.Creator.angleZ))) / 2 * (3.0+ 0.5),
        z = House.PropsPlacer.propCoords.z + ((Sin(House.Creator.angleY))) * (3.0+ 0.5)
    }
    local rayHandle = StartShapeTestRay(House.PropsPlacer.propCoords.x, House.PropsPlacer.propCoords.y, House.PropsPlacer.propCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, House.PropsPlacer.prop_id, 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local maxRadius = House.PropsPlacer.camHeight
    if (hitBool and Vdist(House.PropsPlacer.propCoords.x, House.PropsPlacer.propCoords.y, House.PropsPlacer.propCoords.z + 0.5, hitCoords) < 3.0+ 0.5) then
        maxRadius = Vdist(House.PropsPlacer.propCoords.x, House.PropsPlacer.propCoords.y, House.PropsPlacer.propCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Cos(House.Creator.angleZ))) / 2 * maxRadius,
        y = ((Sin(House.Creator.angleZ) * Cos(House.Creator.angleY)) + (Cos(House.Creator.angleY) * Sin(House.Creator.angleZ))) / 2 * maxRadius,
        z = ((Sin(House.Creator.angleY))) * maxRadius
    }

    local pos = {
        x = House.PropsPlacer.propCoords.x + offset.x,
        y = House.PropsPlacer.propCoords.y + offset.y,
        z = House.PropsPlacer.propCoords.z + offset.z
    }

    return pos
end

function HouseFnc:SelectDeleteOrAddFurniture()
    exports.ooc_menu:Open(House.Menu.furniture_menu_delete_or_add, function(params)
        if not params then
            return
        end

        if self[params.fnc] then
            self[params.fnc](self,params)
        end
    end)
end

function HouseFnc:StartDeleteProp()
    local house = House.Houses[tostring(House.InsideHouse.id)]
    local owner = self:IsHouseOwner(house)
    local hasKeys = self:HasHouseKeys(house)

    if owner or hasKeys then
        if #House.Houses[tostring(House.InsideHouse.id)].metadata.furniture == 0 then
            return Utils:Notify("Il n'y a pas de meubles a vendre dans cette maison")
        end

        self:DeleterThread()
    end
end

function HouseFnc:DeleterThread()
    House.Deleter.active = not House.Deleter.active

    CreateThread(function()
        while House.Deleter.active do
            self:DeleterLabel()
            self:DeleterNatives()
            self:DeleterActions()
            self:DeleterInputs()
            Wait(0)
        end
    end)
end

function HouseFnc:DeleterInputs()
    if IsDisabledControlJustPressed(0, House.Creator.keys["Q"]) then
        if House.Houses[tostring(House.InsideHouse.id)].metadata.furniture[House.Deleter.current_furni_index - 1] then
            House.Deleter.current_furni_index = House.Deleter.current_furni_index - 1
        else
            House.Deleter.current_furni_index = #House.Houses[tostring(House.InsideHouse.id)].metadata.furniture
        end
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["E"]) then
        if House.Houses[tostring(House.InsideHouse.id)].metadata.furniture[House.Deleter.current_furni_index + 1] then
            House.Deleter.current_furni_index = House.Deleter.current_furni_index + 1
        else
            House.Deleter.current_furni_index = 1
        end
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["K"]) then
        House.Deleter.active = false
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["F"]) then
        exports.ooc_menu:Open(House.Menu.confirm_sell_funrniture, function(menuParams)
            if not menuParams then
                return
            end

            if menuParams.confirm then
                TriggerServerEvent("plouffe_housing:sell_furniture",House.InsideHouse.id, House.Deleter.current_furni_index, House.Utils.MyAuthKey)
                House.Deleter.current_furni_index = 1
                House.Deleter.active = false
            end
        end)
    end
end

function HouseFnc:DeleterActions()
    local coords = House.Houses[tostring(House.InsideHouse.id)].metadata.furniture[House.Deleter.current_furni_index].coords
    DrawLine(House.Utils.pedCoords, coords, 255 , 0 , 0 , 255)
end

function HouseFnc:DeleterNatives()
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    DisableControlAction(0, House.Creator.keys["Q"], true)
    DisableControlAction(0, House.Creator.keys["E"], true)
    DisableControlAction(0, House.Creator.keys["F"], true)
end

function HouseFnc:DeleterLabel()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["Q"], true))
    self:LabelMessage("Suivant")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["E"], true))
    self:LabelMessage("Précédent")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["F"], true))
    self:LabelMessage("Suprimer")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(3)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["K"], true))
    self:LabelMessage("Annuler")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

function HouseFnc:IsAllowedToAddDoors()
    if House.AllowedToAddDoors[House.Player.job.name] then
        return House.AllowedToAddDoors[House.Player.job.name][tostring(House.Player.job.grade)] ~= (nil or false)
    end
    return false
end

function HouseFnc:AddHouseDoor(params)
    House.DoorAdder.active = not House.DoorAdder.active

    CreateThread(function()
        House.DoorAdder.house_id = params.id

        while House.DoorAdder.active and self:IsAllowedToAddDoors() do
            self:AddDoorInputs()
            self:AddDoorLabel()
            Wait(0)
        end
    end)
end

function HouseFnc:AddDoorInputs()
    if IsDisabledControlJustPressed(0, House.Creator.keys["E"]) then
        exports.ooc_menu:Open(House.Menu.new_confirm_entry, function(params)
            if not params then
                return
            end

            if params.confirm then
                self:AddDoorHere()
            end
        end)
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["K"]) then
        self:ResetNewDoorArray()
    end
end

function HouseFnc:AddDoorHere()
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    if self:GetClosestDoor(4.0) then
        return Utils:Notify("Il y a déja une entré ici", "error")
    end

    if House.DoorAdder.next_door_label == "Intérieur" then
        House.DoorAdder.new_door.inside = GetEntityCoords(House.Utils.ped)
        House.DoorAdder.next_door_label = "Extérieur"
    else
        House.DoorAdder.new_door.outside = GetEntityCoords(House.Utils.ped)
        TriggerServerEvent("plouffe_housing:addNewDoor",House.DoorAdder.house_id, House.DoorAdder.new_door, House.Utils.MyAuthKey)
        self:ResetNewDoorArray()
    end
end

function HouseFnc:ResetNewDoorArray()
    House.DoorAdder = {
        active = false,
        house_id = 0,
        next_door_label = "Intérieur",
        new_door = {
            inside = vector3(0,0,0),
            outisde = vector3(0,0,0)
        }
    }
end

function HouseFnc:AddDoorLabel()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    self:LabelMessage(("Ajouter l'emplacement pour la porte %s"):format(House.DoorAdder.next_door_label))
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["E"], true))
    self:LabelMessage("Confirmer l'emplacement")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["K"], true))
    self:LabelMessage("Annuler")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

function HouseFnc:AddGarage(params)
    House.GarageAdder.active = not House.GarageAdder.active

    CreateThread(function()
        House.GarageAdder.house_id = params.id

        while House.GarageAdder.active and self:CanCreateHouse() do
            self:AddGarageInputs()
            self:AddGarageLabel()
            Wait(0)
        end
    end)
end

function HouseFnc:AddGarageInputs()
    if IsDisabledControlJustPressed(0, House.Creator.keys["E"]) then
        exports.ooc_menu:Open(House.Menu.new_confirm_entry, function(params)
            if not params then
                return
            end

            if params.confirm then
                self:AddGarageHere()
            end
        end)
    end

    if IsDisabledControlJustPressed(0, House.Creator.keys["K"]) then
        self:ResetNewGarageArray()
    end
end

function HouseFnc:AddGarageHere()
    House.Utils.ped = PlayerPedId()
    House.Utils.pedCoords = GetEntityCoords(House.Utils.ped)

    if self:GetClosestDoor(4.0) then
        return Utils:Notify("Il y a déja une entré ici", "error")
    elseif self:GetGarageDoor(6.0) then
        return Utils:Notify("Il y a déja un garage ici", "error")
    end

    TriggerServerEvent("plouffe_housing:addNewGarage", House.GarageAdder.house_id, GetEntityCoords(House.Utils.ped), House.Utils.MyAuthKey)

    self:ResetNewGarageArray()
end

function HouseFnc:ResetNewGarageArray()
    House.GarageAdder = {
        active = false,
        house_id = 0
    }
end

function HouseFnc:AddGarageLabel()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    self:LabelMessage(("Ajouter l'emplacement pour le garage"))
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["E"], true))
    self:LabelMessage("Confirmer l'emplacement")
    EndScaleformMovieMethod()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, House.Creator.keys["K"], true))
    self:LabelMessage("Annuler")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

function HouseFnc:HasGArageAcces(houseId)
    local house = House.Houses[tostring(houseId)]
    if house then
        local owner = self:IsHouseOwner(house)
        local hasKeys = self:HasHouseKeys(house)
        return owner == true or hasKeys == true
    end
    return false
end

function HouseFnc:LockpickHouse()
    local speed = math.ceil(math.random(7, 15))
    local range = math.random(8,13)
    local amount = math.random(5,8)
    local house = self:GetClosestHouseFromDoorCoords(2.0)

    if house then
        House.Utils.forceAnim = true

        self:PlayAnim("anim","veh@break_in@0h@p_m_one@","low_force_entry_ds",49,3500,true)
        local success = exports.roundbar:Start(amount, speed)

        House.Utils.forceAnim = false

        if success then
            Utils:Notify("Vous avez réussi a dévérouiller la porte", "success")
            TriggerServerEvent("plouffe_housing:unlock_house", house.id, House.Utils.MyAuthKey)
        else
            exports.plouffe_dispatch:SendAlert("Houserob")
            Core.Status:Add("stress", 100)
            TriggerServerEvent('plouffe_housing:removeItem',"lockpick",1)
        end
    end
end

function Lockpick(...)
    HouseFnc:LockpickHouse(...)
end

function HasGArageAcces(houseId)
    return HouseFnc:HasGArageAcces(houseId)
end

function IsNearHouse()
    if House.InsideHouse and (HouseFnc:IsHouseOwner(House.Houses[tostring(House.InsideHouse.id)]) or HouseFnc:HasHouseKeys(House.Houses[tostring(House.InsideHouse.id)])) then
        return true
    elseif HouseFnc:GetClosestDoor(2.0) then
        return true
    end
end