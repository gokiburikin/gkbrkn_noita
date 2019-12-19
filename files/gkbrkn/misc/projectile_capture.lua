dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

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

function mean_angle ( angles, magnitudes )
    local sum_sin, sum_cos, sum_magnitude = 0, 0, 0;
    for i, magnitude in pairs( magnitudes ) do
        sum_magnitude = sum_magnitude + magnitude;
    end
    for i, angle in pairs( angles ) do
        local magnitude = magnitudes[i];
        local proportion = magnitude / sum_magnitude;
        -- no velocities
        if proportion ~= proportion then
            proportion = 0;
        end
        sum_sin = sum_sin + math.sin( angle ) * proportion;
        sum_cos = sum_cos + math.cos( angle ) * proportion;
    end
    return math.atan2( sum_sin, sum_cos );
end

local projectile_entities = EntityGetWithTag("gkbrkn_formation_stack") or {};
if #projectile_entities > 0 then
    local stack_distance = 5;
    local captured_projectiles = "";
    for i,projectile in pairs(projectile_entities) do
    end
        local angles = {};
    local magnitudes = {};
    local velocities = {};
    for i,projectile in pairs(projectile_entities) do
        EntityRemoveTag( projectile, "gkbrkn_formation_stack" );

        local velocity = EntityGetFirstComponent( projectile, "VelocityComponent" );
        if velocity ~= nil then
            local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
            local angle = math.atan2( vy, vx );
            local magnitude = vx * vx + vy * vy;
            if magnitude ~= 0 then table.insert( angles, angle ); end
            table.insert( velocities, velocity );
            table.insert( magnitudes, magnitude );
        end
    end
    local average_angle = mean_angle( angles, magnitudes );
    for i,projectile in pairs( projectile_entities ) do
        local velocity = velocities[i];
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local magnitude = magnitudes[i];
        local x, y = EntityGetTransform( projectile );
        --x = x - math.cos( angle ) * math.sqrt(magnitude) / 60;
        --y = y - math.sin( angle ) * math.sqrt(magnitude) / 60;
        local offset = (stack_distance * #projectile_entities) - stack_distance * i - stack_distance * (#projectile_entities-1) / 2;
        EntitySetTransform( projectile, x + math.cos( average_angle - math.pi / 2 ) * offset, y + math.sin( average_angle - math.pi / 2 ) * offset );
        --ComponentSetValueVector2( velocity, "mVelocity", math.cos( average_angle ) * magnitude, math.sin( average_angle ) * magnitude );
    end
end

projectile_entities = EntityGetWithTag("gkbrkn_spell_merge");
if #projectile_entities > 0 then
    local leader = projectile_entities[1];
    EntitiesAverageMemberList( projectile_entities, "ProjectileComponent", {
        "lifetime", "bounces_left", "bounce_energy",
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
    local magnitudes = {};
    for i,projectile_entity in pairs( projectile_entities ) do
        EntityRemoveTag( projectile_entity, "gkbrkn_spell_merge" );
        local velocity = EntityGetFirstComponent( projectile_entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local magnitude = math.sqrt(vx * vx + vy * vy);
        average_velocity_magnitude = average_velocity_magnitude + magnitude;

        -- ignore projectiles that don't move
        table.insert( angles, angle );
        table.insert( magnitudes, magnitude );

    end
    local average_angle = mean_angle( angles, magnitudes );
    average_velocity_magnitude = average_velocity_magnitude / #projectile_entities;
    for i,projectile_entity in pairs( projectile_entities ) do
        if projectile_entity == leader then
            local velocity = EntityGetFirstComponent( projectile_entity, "VelocityComponent" );
            local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
            local angle = math.atan2( vy, vx );
            ComponentSetValueVector2( velocity, "mVelocity", math.cos( average_angle ) * average_velocity_magnitude, math.sin( average_angle ) * average_velocity_magnitude );
        else
            EntitySetVariableString( projectile_entity, "gkbrkn_soft_parent", tostring( leader ) );
        end
        EntityAddComponent( projectile_entity, "LuaComponent", {
            execute_on_added="1",
            execute_every_n_frame="1",
            script_source_file="mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/projectile_update.lua",
        });
    end
end

projectile_entities = EntityGetWithTag("gkbrkn_projectile_orbit");
if #projectile_entities > 0 then
    local leader = projectile_entities[1];
    local velocity = EntityGetFirstComponent( leader, "VelocityComponent" );
    if velocity ~= nil then
        local velocity_x, velocity_y = ComponentGetValueVector2( velocity, "mVelocity" );
        local previous_projectile = nil;
        local leader = nil;
        for i,projectile in pairs(projectile_entities) do
            EntityRemoveTag( projectile, "gkbrkn_projectile_orbit" );
            if previous_projectile ~= nil then
                EntitySetVariableString( projectile, "gkbrkn_soft_parent", tostring(leader) );
                EntityAddComponent( projectile, "VariableStorageComponent", {
                    _tags="gkbrkn_orbit",
                    name="gkbrkn_orbit",
                    value_string=tostring(#projectile_entities);
                    value_int=tostring(i-1);
                } );
                EntityAddComponent( projectile, "LuaComponent", {
                    execute_on_added="1",
                    execute_every_n_frame="1",
                    script_source_file="mods/gkbrkn_noita/files/gkbrkn/actions/projectile_orbit/projectile_update.lua",
                });
                if projectile ~= leader then
                    local velocity = EntityGetFirstComponent( projectile, "VelocityComponent" );
                    local velocity_x, velocity_y = ComponentGetValueVector2( velocity, "mVelocity" );
                    ComponentSetValueVector2( velocity, "mVelocity", 0, 0 );

                    local leader_projectile = EntityGetFirstComponent( leader, "ProjectileComponent" );
                    local projectile = EntityGetFirstComponent( projectile, "ProjectileComponent" );
                    if projectile ~= nil and leader_projectile ~= nil then
                        local leader_lifetime = tonumber( ComponentGetValue( leader_projectile, "lifetime" ) );
                        local projectile_lifetime = tonumber( ComponentGetValue( projectile, "lifetime" ) );
                        ComponentSetValue( projectile, "lifetime", tostring( leader_lifetime + projectile_lifetime ) );
                    end
                end
            else
                leader = projectile;
            end
            previous_projectile = projectile;
        end
    end
end

projectile_entities = EntityGetWithTag("gkbrkn_projectile_gravity_well");
if #projectile_entities > 0 then
    local previous_projectile = nil;
    local leader = nil;
    for i,projectile in pairs(projectile_entities) do
        EntityRemoveTag( projectile, "gkbrkn_projectile_gravity_well" );
        if previous_projectile ~= nil then
            EntitySetVariableString( projectile, "gkbrkn_soft_parent", tostring(leader) );
            local leader_projectile = EntityGetFirstComponent( leader, "ProjectileComponent" );
            local projectile = EntityGetFirstComponent( projectile, "ProjectileComponent" );
            if projectile ~= nil and leader_projectile ~= nil then
                local leader_lifetime = tonumber( ComponentGetValue( leader_projectile, "lifetime" ) );
                local projectile_lifetime = tonumber( ComponentGetValue( projectile, "lifetime" ) );
                ComponentSetValue( projectile, "lifetime", tostring( leader_lifetime + projectile_lifetime ) );
            end
        else
            leader = projectile;
            local velocity = EntityGetFirstComponent( projectile, "VelocityComponent" );
            if velocity ~= nil then
                ComponentSetValue( velocity, "gravity_y", "0" )
                ComponentSetValue( velocity, "air_friction", "0" )
            end
        end
        previous_projectile = projectile;
    end
end