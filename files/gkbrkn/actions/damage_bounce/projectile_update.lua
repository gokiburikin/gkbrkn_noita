dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local buffable_bounces_remaining = EntityGetVariableNumber( entity, "gkbrkn_bounce_damage_remaining" );
    if buffable_bounces_remaining > 0 then
        local last_bounces = EntityGetVariableNumber( entity, "gkbrkn_bounces_last" );
        local current_bounces = tonumber( ComponentGetValue( projectile, "bounces_left" ) );
        local bounces_done = math.min( last_bounces - current_bounces, buffable_bounces_remaining );
        if bounces_done > 0 then
            EntityAdjustVariableNumber( entity, "gkbrkn_bounce_damage_remaining", 0, function(value) return tonumber( value ) - bounces_done; end );
            EntitySetVariableNumber( entity, "gkbrkn_bounces_last", current_bounces );
            local initial_damage = EntityGetVariableNumber( entity, "gkbrkn_bounce_damage_initial" );
            local current_damage = tonumber( ComponentGetValue( projectile, "damage" ) );
            local new_damage = current_damage + initial_damage * 0.50;
            ComponentSetValue( projectile, "damage", tostring(new_damage) );

            local damage_by_types = ComponentObjectGetMembers( projectile, "damage_by_type" ) or {};
            for type,_ in pairs( damage_by_types ) do
                local current_type_damage = tonumber( ComponentObjectGetValue( projectile, "damage_by_type", type ) );
                local initial_type_damage = EntityGetVariableNumber( entity, "gkbrkn_bounce_initial_damage_"..type, 0.0 );
                if initial_type_damage ~= 0 then
                    local new_type_damage = current_type_damage + initial_type_damage * 0.50;
                    ComponentObjectSetValue( projectile, "damage_by_type", type, tostring( new_type_damage ) );
                end
            end

            local particle_emitter = EntityGetFirstComponent( entity, "ParticleEmitterComponent", "gkbrkn_dynamic_damage_particles" );
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