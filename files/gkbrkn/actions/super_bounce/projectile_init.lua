local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local bounce_energy = ComponentGetValue2( projectile, "bounce_energy" );
    ComponentSetValue2( projectile, "bounce_energy", math.max( 1.10, bounce_energy + 0.10 ) );
    ComponentSetValue2( projectile, "bounce_at_any_angle", true );
end