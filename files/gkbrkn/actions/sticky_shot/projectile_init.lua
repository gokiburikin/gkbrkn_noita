local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local bounce_energy = ComponentGetValue2( projectile, "bounce_energy" );
    ComponentSetValue2( projectile, "bounce_energy", 0 );
    ComponentSetValue2( projectile, "bounce_always", true );
    ComponentSetValue2( projectile, "bounce_at_any_angle", true );
    ComponentSetValue2( projectile, "on_collision_die", false );
    ComponentSetValue2( projectile, "die_on_low_velocity", false );
end