local basements = {
    dwap_bateman_basement = { width=22, height=20, stairx=7, stairy=7, stairDir="W" },
}

local basement_access = {
    ba_dwap_generator = { width=1, height=1, stairx=0, stairy=0, stairDir="N" },
    ba_dwap_bateman = { width=30, height=20, stairx=1, stairy=2, stairDir="W" },
    ba_dwap_bateman_no_elev = { width=30, height=20, stairx=1, stairy=2, stairDir="W" },
    ba_dwap_north_power = { width=4, height=1, stairx=0, stairy=0, stairDir="N" },
}

local fullConfig = table.newarray()
fullConfig[1] = {
    locations = {
        {x=12763, y = 1529, z=0, stairDir="W", choices={"dwap_bateman_basement"}, access="ba_dwap_bateman_no_elev", },
        {x=12752+12, y = 1510, z=0, stairDir="N", choices={"dummy"}, access="ba_dwap_north_power", },
    },
}


local locations = {}

for i = 1, #fullConfig do
    for j = 1, #fullConfig[i].locations do
        table.insert(locations, fullConfig[i].locations[j])
    end
end

local api = Basements.getAPIv1()
api:addAccessDefinitions('Muldraugh, KY', basement_access)
api:addBasementDefinitions('Muldraugh, KY', basements)
api:addSpawnLocations('Muldraugh, KY', locations)


if getActivatedMods():contains("\\Taylorsville") then
    api:addAccessDefinitions('Taylorsville', basement_access)
    api:addBasementDefinitions('Taylorsville', basements)
    api:addSpawnLocations('Taylorsville', locations)
end

print("DWAP Bateman basements.lua loaded")
