local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local lifetime = ComponentGetValue2( projectile, "lifetime" );
    ComponentSetValue2( projectile, "lifetime", math.floor(lifetime * 1.5) );
end