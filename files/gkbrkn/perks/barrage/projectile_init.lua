dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/constants.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local entity = GetUpdatedEntityID();
adjust_all_entity_damage( entity, function( value ) return nexp( value, 0.8 ) * 0.25; end );
for k,v in ipairs( EntityGetComponent( entity, "SpriteComponent" ) or {} ) do
    ComponentSetValue2( v, "has_special_scale", true );
    ComponentSetValue2( v, "special_scale_x", 0.5 );
    ComponentSetValue2( v, "special_scale_y", 0.5 );
end

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile then
    local explosion_radius = ComponentObjectGetValue2( projectile, "config_explosion", "explosion_radius" );
    ComponentObjectSetValue2( projectile, "config_explosion", "explosion_radius", math.min( math.max( nexp( explosion_radius, 0.7 ), 3 ), explosion_radius ) );
end