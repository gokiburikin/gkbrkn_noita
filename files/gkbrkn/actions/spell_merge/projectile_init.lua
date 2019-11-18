function EntitiesAverageMemberList( entities, component_type, member_list, rounded, overrides )
    local averages = {};
    local overridden = {};
    for _,member in pairs(member_list) do
        averages[member] = 0;
    end
    local components = {};
    for _,entity in pairs(entities) do
        for _,component in pairs( EntityGetComponent( entity, component_type ) or {} ) do
            table.insert( components, component );
        end
    end
    for _,component in pairs( components ) do
        local members = ComponentGetMembers( component );
        for _,member in pairs(member_list) do
            averages[member] = averages[member] + members[member];
        end
        for member,value in pairs(overrides or {}) do
            if overridden[member] == nil and members[member] == value then
                overridden[member] = members[member];
            end
        end
    end
    for _,member in pairs(member_list) do
        averages[member] = averages[member] / #entities;
        if (rounded or {})[member] ~= nil then
            averages[member] = math.floor( averages[member] + 0.5 );
        end
    end
    for _,component in pairs( components ) do
        for _,member in pairs(member_list) do
            ComponentSetValue( component, member, averages[member] );
        end
        for member,value in pairs(overridden) do
            ComponentSetValue( component, member, value );
        end
    end
end

function mean_angle ( angles )
    local sumSin, sumCos = 0, 0;
    for i, angle in pairs( angles ) do
        sumSin = sumSin + math.sin( angle );
        sumCos = sumCos + math.cos( angle );
    end
    return math.atan2( sumSin, sumCos );
end

local entity = GetUpdatedEntityID();
EntityAddTag( entity, "gkbrkn_spell_merge" );
local projectile_entities = EntityGetWithTag("gkbrkn_spell_merge");
if #projectile_entities == tonumber( GlobalsGetValue( "gkbrkn_projectiles_fired", -1 ) ) then
    local leader = projectile_entities[1];
    EntitiesAverageMemberList( projectile_entities, "ProjectileComponent", {
        "damage", "lifetime", "bounces_left", "bounce_energy",
        "ground_penetration_coeff", "knockback_force", "ragdoll_force_multiplier", "camera_shake_when_shot",
        "angular_velocity", "friction"
    },
    { bounces_left = true },
    { bounce_at_any_angle="1", bounce_always="1" } );
    EntitiesAverageMemberList( projectile_entities, "VelocityComponent", { 
        "gravity_x", "gravity_y", "mass", "air_friction", "terminal_velocity"
    } );
    local average_velocity_magnitude = 0;
    local angles = {};
    for i,entity in pairs( projectile_entities ) do
        EntityRemoveTag( entity, "gkbrkn_spell_merge" );
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local magnitude = vx * vx + vy * vy;
        average_velocity_magnitude = average_velocity_magnitude + magnitude;

        -- ignore projectiles that don't move
        if magnitude > 0 then table.insert( angles, angle ); end

    end
    local average_angle = mean_angle( angles );
    average_velocity_magnitude = math.sqrt(average_velocity_magnitude / #projectile_entities);
    for i,entity in pairs(projectile_entities) do
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        ComponentSetValueVector2( velocity, "mVelocity", math.cos( average_angle ) * average_velocity_magnitude, math.sin( average_angle ) * average_velocity_magnitude );
        if entity ~= leader then
            if EntityGetParent( entity ) == 0 then
                EntityAddChild( leader, entity );
                EntityAddComponent( entity, "InheritTransformComponent" );
            end
        end
    end
end
