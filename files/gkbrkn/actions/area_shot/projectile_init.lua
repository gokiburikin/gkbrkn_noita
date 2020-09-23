dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local entity = GetUpdatedEntityID();
adjust_all_entity_damage( entity, function( value ) return value * 0.50; end )
