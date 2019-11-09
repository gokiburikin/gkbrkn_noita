local entity = GetUpdatedEntityID();

local projectile_component = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile_component ~= nil then
    ComponentSetValue( projectile_component, "penetrate_world", "1" );
    ComponentSetValue( projectile_component, "penetrate_entities", "0" );
    ComponentSetValue( projectile_component, "penetrate_world_velocity_coeff", "0.2" );
end
