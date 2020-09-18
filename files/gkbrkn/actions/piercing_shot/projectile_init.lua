local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentSetValue2( projectile, "penetrate_entities", true );
end