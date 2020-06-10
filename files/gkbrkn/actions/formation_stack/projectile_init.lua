dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/constants.lua" );
local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_projectile_capture", bit.bxor( EntityGetVariableNumber( entity, "gkbrkn_projectile_capture", 0 ), GKBRKN_PROJECTILE_CAPTURE.FormationStack ) );
