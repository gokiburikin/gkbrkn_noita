dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile then
    ComponentSetValue2( projectile, "die_on_low_velocity", false );
end

local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
if velocity then
    ComponentSetValue2( velocity, "gravity_y", 0 );
    ComponentSetValue2( velocity, "air_friction", 0 );
end