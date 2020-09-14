dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/trigger_entity.xml" );
EntityAddChild( entity, link_entity );
-- TODO not a solution
EntityAddChild( entity - 3, entity );