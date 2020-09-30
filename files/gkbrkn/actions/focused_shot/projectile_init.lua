dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_empower_stacks", EntityGetVariableNumber( entity, "gkbrkn_empower_stacks", 0.0 ) + 1 );
