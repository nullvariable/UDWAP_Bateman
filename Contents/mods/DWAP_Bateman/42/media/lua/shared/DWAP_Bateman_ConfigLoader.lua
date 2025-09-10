local DWAPUtils = require("DWAPUtils")
Events.OnLoadRadioScripts.Add(function()
    local config = {
        minimumVersion = 17,
        file = "DWAP_Bateman/configs/DWAP_Bateman",
        overrides = {
            makePrimary = SandboxVars.DWAPBateman.MakePrimary,
            key = SandboxVars.DWAPBateman.Key,
            map = SandboxVars.DWAPBateman.Map,
            essentialLoot = SandboxVars.DWAPBateman.EssentialLoot,
            regularLoot = SandboxVars.DWAPBateman.RegularLoot,
        },
    }
    if SandboxVars.DWAPBateman.ExtraLoot then
        config.file = "DWAP_Bateman/configs/DWAP_Bateman_extra"
    end
    DWAPUtils.dprint("Loading DWAP Bateman config")
    DWAPUtils.addExternalConfig(config)
end)

function DWAP_Bateman_beforeTeleport(coords)
    Events.OnZombieCreate.Add(function(zombie)
        local x, y, z = coords.x, coords.y, coords.z
        if zombie then
            local zombieX, zombieY, zombieZ = zombie:getX(), zombie:getY(), zombie:getZ()
            if zombieX >= x - 15 and zombieX <= x + 15 and
            zombieY >= y - 15 and zombieY <= y + 15 and
            (zombieZ == z or zombieZ == z - 1) then
                print("Removing zombie: " .. zombieX .. ", " .. zombieY)
                -- prevent zombie spawns
                zombie:removeFromWorld()
                zombie:removeFromSquare()
            end
        end
    end)
end

function DWAP_Bateman_afterTeleport(coords)
    for x = coords.x - 15, coords.x + 15 do
        for y = coords.y - 15, coords.y + 15 do
            for z = coords.z - 1, coords.z do
                local square = getSquare(x, y, z)
                if square then
                    local movingObjects = square:getLuaMovingObjectList()
                    for i = 1, #movingObjects do
                        local movingObject = movingObjects[i]
                        if instanceof(movingObject, "IsoZombie") then
                            movingObject:removeFromWorld()
                            movingObject:removeFromSquare()
                            print("Removed zombie at: " .. x .. ", " .. y)
                        end
                    end
                end
            end
        end
    end
    local result = DWAPUtils.lightsOnCurrentRoom(nil, -120)
    if not result then
        DWAPUtils.DeferMinute(function()
            DWAPUtils.lightsOnCurrentRoom()
        end)
    end
end

local spawns = {
    { x = 12765, y = 1533, z = 27 }, -- penthouse
    { x = 12780, y = 1520, z = 25 }, -- 26fl apt
    { x = 12771, y = 1521, z = 21 }, -- 22fl restaurant lobby
    { x = 12755, y = 1539, z = 16 }, -- 17thfl balcony
    { x = 12756, y = 1518, z = 9 }, -- 10fl construction storage
    { x = 12767, y = 1514, z = 3 }, -- 4fl balcony
    { x = 12763, y = 1531, z = 0 }, -- first floor bathroom
    { x = 12768, y = 1526, z = -1 }, -- basement garbage
}

DWAP_Bateman_Random = function()
    local random = newrandom()
    local seed = WGParams.instance:getSeedString()
    random:seed(seed)
    return random:random(1, #spawns)
end

DWAP_Bateman_SelectedSpawn = function()
    local index = SandboxVars.DWAPBateman.SpawnLocation - 1
    if index == 0 then
        index = DWAP_Bateman_Random()
    end
    return index
end

Events.OnNewGame.Add(function(player, square)
    local modData = player:getModData()
    if not modData.DWAPBateman_Spawn then
        DWAPUtils.dprint("DWAP Bateman spawn logic running")
        local spawnRegion = MapSpawnSelect.instance.selectedRegion

        if not spawnRegion then
            spawnRegion = MapSpawnSelect.instance:useDefaultSpawnRegion()
        end
        DWAPUtils.dprint("Spawn region: " .. (spawnRegion and spawnRegion.name or "nil"))
        if spawnRegion and spawnRegion.name == "DWAP_Bateman" then
            local index = DWAP_Bateman_SelectedSpawn()
            local coords = spawns[index]
            DWAPUtils.dprint("Teleporting to DWAP Bateman spawn index " .. index)
            DWAP_Bateman_beforeTeleport(coords)
            if isClient() then
                SendCommandToServer("/teleportto " .. coords.x .. "," .. coords.y .. "," .. coords.z);
            else
                getPlayer():teleportTo(coords.x, coords.y, coords.z)
            end
            DWAPUtils.Defer(function()
                DWAP_Bateman_afterTeleport(coords)
            end)
            modData.DWAPBateman_Spawn = true
        end
    end
end)

-- Gun's Elevator integration for Bateman Building basement
Events.OnLoadMapZones.Add(function()

    -- Check if Gun's Elevator mod is active
    if getActivatedMods():contains("\\Gelevator") or not GE or not GE.loadGridData then
        print("DWAP Bateman: Gun's Elevator mod not detected or GE.loadGridData not found, skipping elevator button addition")
        return
    end

    -- Add Bateman Building basement elevator buttons directly to GE.loadGridData
    -- These coordinates match the existing Bateman elevator positions but for basement level (z = -1)
    table.insert(GE.loadGridData, {coords = {12767,1526,-1}, objType = "NelevatorButtons_0"})

    print("DWAP Bateman: Added basement elevator button to Gun's Elevator system")
end)


-- getPokerNightClutterItem()
