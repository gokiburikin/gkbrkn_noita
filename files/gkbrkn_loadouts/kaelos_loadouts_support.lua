function OnPlayerSpawned() end
local loadout_file = "mods/Kaelos_Archetypes/files/K_Archetypes/Archetypes.lua";
ModLuaFileAppend( loadout_file, "mods/gkbrkn_noita/files/gkbrkn_loadouts/kaelos_loadouts_append.lua" );
ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn_loadouts/loadouts.lua", loadout_file );