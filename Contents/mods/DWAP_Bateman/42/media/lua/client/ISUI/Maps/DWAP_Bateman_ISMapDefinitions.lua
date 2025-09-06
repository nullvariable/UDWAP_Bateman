print("DWAP Bateman StashDesc.lua loaded")
LootMaps.Init.DWAP_BatemanStashMap1 = function(mapUI)
    print("Initializing DWAP_BatemanStashMap1")
    local mapAPI = mapUI.javaObject:getAPIv1()
    MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
    MapUtils.initDefaultStyleV1(mapUI)
    mapAPI:setBoundsInSquares(12616, 1448, 12831, 1695)
end
