local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue2( projectile, "lifetime", -1 );
end
local lifetime = EntityGetFirstComponentIncludingDisabled( entity, "LifetimeComponent" );
if lifetime ~= nil then
    EntityRemoveComponent( entity, lifetime );
end