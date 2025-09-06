local Bateman = require "DWAP_Bateman/configs/DWAP_Bateman"
print("DWAP Bateman extraLoot.lua loaded")
local extraLoot = {
}

if Bateman and Bateman.loot then
    for i = 1, #extraLoot do
        table.insert(Bateman.loot, extraLoot[i])
    end
end

return Bateman
