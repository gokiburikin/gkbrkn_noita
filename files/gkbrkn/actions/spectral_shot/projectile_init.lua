local entity = GetUpdatedEntityID();

local projectile_component = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile_component ~= nil then
    ComponentSetValue2( projectile_component, "penetrate_world", true );
    ComponentSetValue2( projectile_component, "penetrate_world_velocity_coeff", 0.2 );
end
