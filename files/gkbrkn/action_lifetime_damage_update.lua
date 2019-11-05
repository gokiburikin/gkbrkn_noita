local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local projectile_component = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile_component ~= nil then
    ComponentSetValue( projectile_component, "damage", tostring(tonumber(ComponentGetValue( projectile_component, "damage" ) + 0.02) ) );
end