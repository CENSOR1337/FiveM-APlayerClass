fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
    "resource/client.lua"
}

-- Example

client_scripts {
    "@es_extended/imports.lua",
    -- "@fivem_aplayerclasses/imports/PlayerPool.lua", -- imports on other resource
    -- "@fivem_aplayerclasses/imports/APlayer.lua", -- imports on other resource
    "imports/PlayerPool.lua",
    "imports/APlayer.lua",
    "example.lua"
}

files {
    "imports/*.lua"
}