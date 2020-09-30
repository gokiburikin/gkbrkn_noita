dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/constants.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local entity = GetUpdatedEntityID();
adjust_all_entity_damage( entity, function( value ) return value * 0.5; end )
