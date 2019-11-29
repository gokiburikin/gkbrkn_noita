local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue( projectile, "die_on_liquid_collision", "0" );
    ComponentSetValue( projectile, "die_on_low_velocity", "0" );
end