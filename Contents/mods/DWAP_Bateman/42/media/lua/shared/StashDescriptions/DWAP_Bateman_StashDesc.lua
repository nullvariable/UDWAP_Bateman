require "StashDescriptions/StashUtil";

local configs = {
    [1] = {
        name = "Bateman Tower Map",
        stamps = {
            {"Star", nil, 12772, 1529, 0.50, 0.50, 0.0, 0.129, 0.129, 0.129},
        },
        buildingX = 12772,
        buildingY = 1529,
    },
}

for i = 1, #configs do
    local config = configs[i]
    local DWAPStashMap = StashUtil.newStash("DWAP_BatemanStashMap" .. i, "Map", "Base.RosewoodMap", config.name);
    for j = 1, #config.stamps do
        local stamp = config.stamps[j]
        if config.buildingX and config.buildingY then
            DWAPStashMap.buildingX = config.buildingX
            DWAPStashMap.buildingY = config.buildingY
        end
        DWAPStashMap:addStamp(stamp[1], stamp[2], stamp[3], stamp[4], stamp[5], stamp[6], stamp[7])
    end
    DWAPStashMap.customName = config.name
    Events.OnInitGlobalModData.Add(function()
        if SandboxVars.DWAPBateman.Map < 3 then
            DWAPStashMap.minDayToSpawn = 100
            DWAPStashMap.maxDayToSpawn = 1
        end
    end)
end
