local disable = HasFlagPersistent( MISC.LessParticles.DisableEnabled );
_entity_cache = _entity_cache or {};
for _,nearby in pairs( nearby_entities ) do
    if _entity_cache[nearby] ~= true then
        _entity_cache[nearby] = true;
        local particle_emitters = EntityGetComponent( nearby, "ParticleEmitterComponent" ) or {};
        for _,emitter in pairs( particle_emitters ) do
            if ComponentGetValue( emitter, "emit_cosmetic_particles" ) == "1" and ComponentGetValue( emitter, "create_real_particles" ) == "0" and ComponentGetValue( emitter, "emit_real_particles" ) == "0" then
                if disable then
                    EntitySetComponentIsEnabled( nearby, emitter, false );
                else
                    ComponentSetValue( emitter, "count_max", "1" );
                    ComponentSetValue( emitter, "collide_with_grid", "0" );
                    ComponentSetValue( emitter, "is_trail", "0" );
                    ComponentSetValue( emitter, "lifetime_max", "0.5" );
                end
            end
        end
        local sprite_particle_emitters = EntityGetComponent( nearby, "SpriteParticleEmitterComponent" ) or {};
        for _,emitter in pairs( sprite_particle_emitters ) do
            if disable then
                EntitySetComponentIsEnabled( nearby, emitter, false );
            else
                if ComponentGetValue( emitter, "entity_file" ) == "" then
                    ComponentSetValue( emitter, "count_max", "1" );
                    ComponentSetValue( emitter, "emission_interval_min_frames", tostring( math.ceil( tonumber( ComponentGetValue( emitter, "emission_interval_min_frames" ) ) * 2 ) ) );
                    ComponentSetValue( emitter, "emission_interval_max_frames", tostring( math.ceil( tonumber( ComponentGetValue( emitter, "emission_interval_max_frames" ) ) * 2 ) ) );
                end
            end
        end
    end
end