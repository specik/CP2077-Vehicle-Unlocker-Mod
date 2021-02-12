local VehicleSpawnerCore = {
    DeltaTime = 0,
    SpawnDistance = 10,

    Util = require "util",
    Data = require "data",

    VehicleSpawnSystemToggled = false,

    ValidVehicleTypes = {
        "vehicleCarBaseObject",
        "vehicleTankBaseObject",
        "vehicleBikeBaseObject",
        "vehicleAVBaseObject",
        "vehicleBaseObject"
    }
}

function VehicleSpawnerCore.Tick(deltaTime)
    VehicleSpawnerCore.DeltaTime = VehicleSpawnerCore.DeltaTime + deltaTime

    if VehicleSpawnerCore.DeltaTime > 1 then
        VehicleSpawnerCore.Monitor()

        VehicleSpawnerCore.DeltaTime = VehicleSpawnerCore.DeltaTime - 1
    end
end

function VehicleSpawnerCore.Monitor()
    local player = Game.GetPlayer()

    if player then
        local vehicle = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

        if vehicle then
            if VehicleSpawnerCore.Util.IfArrayHasValue(VehicleSpawnerCore.ValidVehicleTypes, vehicle) then
                local vehiclePS = vehicle:GetVehiclePS()
                
                if vehiclePS:GetDoorInteractionState(1).value ~= "Available" then
                    vehiclePS:UnlockAllVehDoors()
                end

                VehicleSpawnerCore.DeltaTime = VehicleSpawnerCore.DeltaTime - 1
            end
        end
    end
end

function VehicleSpawnerCore.Populate()
    local vehicles = VehicleSpawnerCore.Data.Read()
    local vehiclesList = TweakDB:GetFlat(TweakDBID.new("Vehicle.vehicle_list.list"))

    for i = 1, #vehiclesList do
        table.remove(vehiclesList, 1)
    end

    for i, vehicle in ipairs(vehicles) do
        table.insert(vehiclesList, TweakDBID.new(tostring(vehicle)))
    end
    
    TweakDB:SetFlat(TweakDBID.new("Vehicle.vehicle_list.list"), vehiclesList)

    TweakDB:Update(TweakDBID.new("Vehicle.vehicle_list.list"))
end

function VehicleSpawnerCore.Spawn(id)
    if not id then return end

    local vs = Game.GetVehicleSystem()

    -- if not VehicleSpawnerCore.VehicleSpawnSystemToggled then
    --     vs:ToggleSummonMode()

    --     VehicleSpawnerCore.VehicleSpawnSystemToggled = true
    -- end


    
    vehObj = NewObject('vehicleGarageVehicleID')

    print(Dump(vehObj, true))
    -- vehicleID = Game['Cast;TweakDBID;GarageVehicleID']
    -- vehicleID = vehObj['Resolve;string'](tostring(id))
    -- print(Dump(vs,false))
    -- print(GameDump(vehicleID))
    
    -- print(Dump(Game['vehicleGarageVehicleID'],false))

    
    -- vehicleID = vehObj['Resolve'](tostring(id))

    -- vehObj.name = tostring(id)
    -- vehObj.recordID = TweakDBID.new(id)

    -- print(vehicleID)
    -- print(Dump(vehObj,false))

    -- vs:TogglePlayerActiveVehicle(vehObj, "Car", false)
    -- vs:SpawnPlayerVehicle()

	-- local player = Game.GetPlayer()
	-- local worldForward = player:GetWorldForward()
	-- local offset = Vector3.new(worldForward.x * VehicleSpawnerCore.SpawnDistance, worldForward.y * VehicleSpawnerCore.SpawnDistance, 1)

	-- local spawnTransform = player:GetWorldTransform()
	-- local spawnPosition = spawnTransform.Position:ToVector4(spawnTransform.Position)

    -- local vehicleTDBID = TweakDBID.new(id)

	-- spawnTransform:SetPosition(spawnTransform, Vector4.new(spawnPosition.x + offset.x, spawnPosition.y + offset.y, spawnPosition.z + offset.z, spawnPosition.w))
	
    -- Game.GetPreventionSpawnSystem():RequestSpawn(vehicleTDBID, -1, spawnTransform)
end

function VehicleSpawnerCore.Despawn()

    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if target then
        if VehicleSpawnerCore.Util.IfArrayHasValue(VehicleSpawnerCore.ValidVehicleTypes, target) then

            -- local targetTDBID = target:GetEntityID()
            -- Game.GetPreventionSpawnSystem():RequestDespawn(targetTDBID)
            target:Dispose()
        end
    end
end


function VehicleSpawnerCore.CheckValid()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if VehicleSpawnerCore.Util.IfArrayHasValue(VehicleSpawnerCore.ValidVehicleTypes, target) then
        return true
    else
        return false
    end
end


return VehicleSpawnerCore