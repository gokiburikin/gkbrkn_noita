dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");

local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_guided_shot", 1 );