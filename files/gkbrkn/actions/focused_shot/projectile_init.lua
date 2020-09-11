dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_damage_multiplier", EntityGetVariableNumber( entity, "gkbrkn_damage_multiplier", 1.0 ) + 5 );
