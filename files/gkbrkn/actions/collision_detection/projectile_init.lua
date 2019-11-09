local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local lifetime = tonumber( ComponentGetValue( projectile, "lifetime" ) );
    ComponentSetValue( projectile, "lifetime", tostring( math.floor(lifetime * 1.5) ) );
end