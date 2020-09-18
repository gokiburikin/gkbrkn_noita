local entity = GetUpdatedEntityID();

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local penetration = ComponentGetValue2( projectile, "ground_penetration_coeff" );
    local bounces = ComponentGetValue2( projectile, "bounces_left" );
    if penetration > 0 or bounces == 0 then
        ComponentSetValue2( projectile, "ground_penetration_coeff", math.max( 3, penetration * 3 ) );
    end
end

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local mass = ComponentGetValue2( velocity, "mass" );
    ComponentSetValue2( velocity, "mass", math.max( 0.5, mass ) );
end