dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

local seek_distance = 128;
local entity = GetUpdatedEntityID();
local x, y  = EntityGetTransform( entity );
local nearby_entities = EntityGetInRadiusWithTag( x, y, seek_distance, "homing_target" ) or {};
local target = nil;
local nearest_distance = seek_distance;
-- setting nearest_angle to less than pi will effectively limit the projectiles line of sight to a certain cone in front of it
local nearest_angle = math.pi / 3;
function angle_difference( target_angle, starting_angle )
    return math.atan2( math.sin( target_angle - starting_angle ), math.cos( target_angle - starting_angle ) );
end
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
    local velocity_angle = math.atan2( vy, vx );

    for _,test_entity in pairs( nearby_entities ) do
        --[[
        local distance = distance_to_entity( x, y, test_entity );
        if distance < nearest_distance then
            target = test_entity;
            nearest_distance = distance;
        end
        ]]
        local ex, ey = EntityGetTransform( test_entity );
        local target_angle = math.atan2( ey - y, ex - x );
        local angle = math.abs(angle_difference( target_angle, velocity_angle ));
        --print("\ntarget angle "..tostring(target_angle * 180 / math.pi));
        --print("velocity angle "..tostring(velocity_angle * 180 / math.pi));
        --print("outcome angle "..tostring(angle * 180 / math.pi));
        if angle < nearest_angle then
            nearest_angle = angle;
            target = test_entity;
        end
    end
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    if velocity ~= nil then
        SetRandomSeed( x, y );
        if target ~= nil then
            local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
            if projectile ~= nil then
                --local tx, ty = EntityGetTransform( target );
                local tx, ty = EntityGetFirstHitboxCenter( target );
                if tx == nil or ty == nil then
                    tx, ty = EntityGetTransform( target );
                end
                local lifetime_multiplier = math.pow( math.min( 1, ( GameGetFrameNum() - EntityGetVariableNumber( entity, "gkbrkn_spawn_frame", 0 ) ) / 30  ), 2 );
                local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
                local aim_angle = math.atan2( ty - y, tx - x );
                local magnitude = math.sqrt( vx * vx + vy * vy );
                local angle = math.atan2( vy, vx );
                local difference = math.abs( math.pow( angle_difference( angle, aim_angle ), 2 ) );
                local new_angle = ease_angle( angle, aim_angle + (Random(-1.0, 1.0) * 15 / 180 * math.pi), ( 0.06 + 0.27 * lifetime_multiplier ) ) + (Random(-1.0, 1.0) * 3 / 180 * math.pi);

                ComponentSetValue2( velocity, "mVelocity", math.cos( new_angle ) * magnitude, math.sin( new_angle ) * magnitude );
            end
        else
            local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
            local magnitude = math.sqrt( vx * vx + vy * vy );
            local angle = math.atan2( vy, vx );
            local new_angle = angle + (Random(-1.0, 1.0) * 3 / 180 * math.pi);
            ComponentSetValue2( velocity, "mVelocity", math.cos( new_angle ) * magnitude, math.sin( new_angle ) * magnitude );
        end
    end
end