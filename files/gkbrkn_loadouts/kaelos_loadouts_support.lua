function OnPlayerSpawned() end
local loadout_file = "files/K_Archetypes/Archetypes.lua";
ModLuaFileAppend( loadout_file, "files/gkbrkn_loadouts/kaelos_loadouts_append.lua" );
ModLuaFileAppend( "files/gkbrkn_loadouts/loadouts.lua", loadout_file );