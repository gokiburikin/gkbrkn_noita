local entity_id = GetUpdatedEntityID();

local projectile_component = EntityGetFirstComponent( entity_id, "ProjectileComponent" );
if projectile_component ~= nil then
    local last_bounces_variable_component = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "gkbrkn_bounces_last" );
    local initial_damage_variable_component = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "gkbrkn_damage_initial" );
    if last_bounces_variable_component ~= nil and initial_damage_variable_component ~= nil then
        local last_bounces = tonumber(ComponentGetValueInt( last_bounces_variable_component, "value_int" ));
        local initial_damage = tonumber(ComponentGetValue( initial_damage_variable_component, "value_string" ));
        local current_bounces = tonumber(ComponentGetValue( projectile_component, "bounces_left" ));
        local current_damage = tonumber(ComponentGetValue( projectile_component, "damage" ));
        local bounces_done = last_bounces - current_bounces;
        if bounces_done > 1 then
            local new_damage = current_damage + initial_damage * 0.25 * bounces_done;
            ComponentSetValue( last_bounces_variable_component, "value_int", current_bounces );
            ComponentSetValue( projectile_component, "damage", tostring(new_damage) );
            local particle_emitter = EntityGetFirstComponent( entity_id, "ParticleEmitterComponent", "gkbrkn_dynamic_damage_particles" );
            if particle_emitter ~= nil then
                ComponentSetValue( particle_emitter, "x_vel_min", tostring( tonumber( ComponentGetValue( particle_emitter, "x_vel_min" ) - 10 ) ) );
                ComponentSetValue( particle_emitter, "x_vel_max", tostring( tonumber( ComponentGetValue( particle_emitter, "x_vel_max" ) + 10 ) ) );
                ComponentSetValue( particle_emitter, "y_vel_min", tostring( tonumber( ComponentGetValue( particle_emitter, "y_vel_min" ) - 10 ) ) );
                ComponentSetValue( particle_emitter, "y_vel_max", tostring( tonumber( ComponentGetValue( particle_emitter, "y_vel_max" ) + 10 ) ) );
                ComponentSetValue( particle_emitter, "trail_gap", tostring( math.max( 1, tonumber( ComponentGetValue( particle_emitter, "trail_gap" ) - 1 ) ) ) );
            end
        end
    end
end