local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue( projectile, "lifetime", "-1" );
end
local lifetime = EntityGetFirstComponent( entity, "LifetimeComponent" );
if lifetime ~= nil then
    EntityRemoveComponent( entity, lifetime );
end