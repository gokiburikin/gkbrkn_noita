local entity = GetUpdatedEntityID();
local parent = EntityGetParent( entity );
if parent ~= nil then
    local orbit = EntityGetFirstComponent( entity, "VariableStorageComponent", "gkbrkn_orbit" );
    local orbit_index = tonumber( ComponentGetValue( orbit, "value_int" ) );
    local orbit_total = tonumber( ComponentGetValue( orbit, "value_string" ) ) - 1;
    local frame = GameGetFrameNum();
    local velocity_x, velocity_y = nil;
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    local physics = EntityGetFirstComponent( entity, "PhysicsBodyComponent" );
    local use_physics = false;
    if velocity ~= nil then
        velocity_x, velocity_y = ComponentGetValueVector2( velocity, "mVelocity" );
    elseif physics ~= nil then
        velocity_x, velocity_y = PhysicsVecToGameVec( PhysicsGetComponentVelocity( entity, physics ) );
        use_physics = true;
    end
    if velocity_x ~= nil and velocity_y ~= nil then
        local parent_velocity = EntityGetFirstComponent( parent, "VelocityComponent" );
        local parent_velocity_x, parent_velocity_y = ComponentGetValueVector2( parent_velocity, "mVelocity" );
        local x,y = EntityGetTransform( entity );
        local parent_x, parent_y = EntityGetTransform( parent );
        local orbit_radius = 8;
        local target_x = ( parent_x + parent_velocity_x / 40 ) + math.cos( math.pi * 2 / orbit_total * orbit_index + frame / 10 ) * orbit_radius;
        local target_y = ( parent_y + parent_velocity_y / 40 ) + math.sin( math.pi * 2 / orbit_total * orbit_index + frame / 10 ) * orbit_radius;
        --local magnitude = math.sqrt( velocity_x * velocity_x + velocity_y * velocity_y );
        local distance_to_target = math.sqrt( ( target_x - x ) ^ 2 + ( target_y - y ) ^ 2 );
        local angle_to_target = math.atan2( target_y - y, target_x - x );
        --local target_velocity_x = math.cos( angle_to_target ) * distance_to_target;
        --local target_velocity_y = math.sin( angle_to_target ) * distance_to_target;
        local target_velocity_x = (target_x - x) * 40;
        local target_velocity_y = (target_y - y) * 40;
        if use_physics == false then
            ComponentSetValueVector2( velocity, "mVelocity", target_velocity_x, target_velocity_y );
        else
            --PhysicsApplyForce( entity, physics, GameVecToPhysicsVec( target_velocity_x, target_velocity_y ) );
        end
    end
end