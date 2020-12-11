dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile then
    ComponentSetValue2( projectile, "penetrate_world", true );
    ComponentSetValue2( projectile, "penetrate_world_velocity_coeff", 1.0 );
    ComponentSetValue2( projectile, "die_on_low_velocity", false );
end
