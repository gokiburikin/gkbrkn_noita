dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local entity = GetUpdatedEntityID();
EntityAddTag( entity, "homing_target" );