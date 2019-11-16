local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local bounce_energy = tonumber( ComponentGetValue( projectile, "bounce_energy" ) );
    ComponentSetValue( projectile, "bounce_energy", tostring( math.max( 1.10, bounce_energy + 0.10 ) ) );
    ComponentSetValue( projectile, "bounce_at_any_angle", "1" );
end