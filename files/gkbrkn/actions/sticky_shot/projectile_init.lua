local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local bounce_energy = tonumber( ComponentGetValue( projectile, "bounce_energy" ) );
    ComponentSetValue( projectile, "bounce_energy", "0" );
    ComponentSetValue( projectile, "bounce_always", "1" );
    ComponentSetValue( projectile, "bounce_at_any_angle", "1" );
    ComponentSetValue( projectile, "on_collision_die", "0" );
    ComponentSetValue( projectile, "die_on_low_velocity", "0" );
end