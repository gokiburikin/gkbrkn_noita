dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
EntitySetVariableNumber( entity, "gkbrkn_anchor_x", x );
EntitySetVariableNumber( entity, "gkbrkn_anchor_y", y );
EntitySetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
