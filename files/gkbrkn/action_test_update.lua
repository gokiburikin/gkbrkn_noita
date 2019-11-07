local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local ray_length = 8;
local rays = 12;
local deviation_angle = 90 / 180 * math.pi;

function angle_difference( target_angle, starting_angle )
    return math.atan2( math.sin( target_angle - starting_angle ), math.cos( target_angle - starting_angle ) );
end

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local velocity_x, velocity_y = ComponentGetValueVector2( velocity, "mVelocity" );
    if velocity_x ~= 0 and velocity_y ~= 0 then
        local angle = math.atan2( velocity_y, velocity_x );
        local magnitude = math.sqrt( velocity_x * velocity_x + velocity_y * velocity_y );
        --local normal_found, normal_x, normal_y, normal_dist = GetSurfaceNormal( x, y, ray_length, rays );
        local normal_found, normal_x, normal_y, normal_dist = GetSurfaceNormal( x + math.cos(angle) * ray_length, y + math.sin(angle) * ray_length, ray_length, rays );
        if normal_found then
            local normal_angle = math.atan2( normal_y, normal_x );
            local difference = angle_difference(angle, normal_angle);
            local sign_difference = difference / math.abs( difference );
            local target_velocity_x = normal_y * magnitude * -sign_difference;
            local target_velocity_y = normal_x * magnitude * sign_difference;
            local easing = math.max( 1, normal_dist * 0.42 );
            local new_velocity_x = velocity_x + (target_velocity_x - velocity_x) / easing;
            local new_velocity_y = velocity_y + (target_velocity_y - velocity_y) / easing;
            ComponentSetValueVector2( velocity, "mVelocity", new_velocity_x, new_velocity_y );
        end
    end
end