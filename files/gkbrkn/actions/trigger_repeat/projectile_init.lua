dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/trigger_entity.xml" );
EntityAddChild( entity, link_entity );
-- TODO not a solution
local parent = entity - 3;
if EntityGetIsAlive( parent ) then
    EntityAddChild( parent, entity );
else
    EntityKill( entity );
end