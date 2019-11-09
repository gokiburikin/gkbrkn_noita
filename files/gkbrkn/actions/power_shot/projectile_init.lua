local entity = GetUpdatedEntityID();

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local penetration = tonumber( ComponentGetValue( projectile, "ground_penetration_coeff" ) );
    ComponentSetValue( projectile, "ground_penetration_coeff", tostring( math.max( 1, penetration * 2 ) ) );
end

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local mass = tonumber( ComponentGetValue( velocity, "mass" ) );
    ComponentSetValue( velocity, "mass", tostring( math.max( 1, mass * 2 ) ) );
end
