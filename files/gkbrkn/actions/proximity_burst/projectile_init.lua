dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/constants.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local entity = GetUpdatedEntityID();
adjust_all_entity_damage( entity, function( value ) return value * 0.12; end )
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity then
    ComponentSetValue2( velocity, "air_friction", 6 );
end
