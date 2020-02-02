dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local parent = EntityGetVariableNumber( entity, "gkbrkn_soft_parent", 0 );
if parent ~= 0 and EntityGetIsAlive( parent ) == false then
    EntityKill( entity );
end