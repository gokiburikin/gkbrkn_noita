local check_radius = 48;
local easing = 2;
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
local shooter = ComponentGetValue( projectile, "mWhoShot" );

local nearby_entities = EntityGetInRadiusWithTag( x, y, check_radius, "mortal" );
for _,nearby in pairs( nearby_entities ) do
    if tonumber(nearby) ~= tonumber(shooter) then
        local nearby_x, nearby_y = EntityGetTransform( nearby );
        local hit,hit_x,hit_y = Raytrace( x, y, nearby_x, nearby_y );
        local in_line_of_sight = false;
        if hit == false then
            in_line_of_sight = true;
        else
            local distance_to_hit = math.sqrt( (hit_x - x) ^2 + (hit_y - y) ^2 );
            local distance_to_target = math.sqrt( (nearby_x - x) ^2 + (nearby_y - y) ^2 );
            if distance_to_hit > distance_to_target then
                in_line_of_sight = true;
            end
        end
        if in_line_of_sight then
            local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
            local velocity_x, velocity_y = ComponentGetValueVector2( velocity, "mVelocity" );
            local angle = math.atan2( nearby_y - y, nearby_x - x);
            local magnitude = math.sqrt( velocity_x * velocity_x + velocity_y * velocity_y );
            local new_velocity_x = math.cos( angle ) * magnitude;
            local new_velocity_y = math.sin( angle ) * magnitude;
            ComponentSetValueVector2( velocity, "mVelocity", velocity_x + ( new_velocity_x - velocity_x ) / easing, velocity_y + ( new_velocity_y - velocity_y ) / easing );
        end
    end
end