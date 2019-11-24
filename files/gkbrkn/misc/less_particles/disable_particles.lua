local entity = GetUpdatedEntityID();
local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
for _,emitter in pairs( particle_emitters ) do
    if ComponentGetValue( emitter, "emit_cosmetic_particles" ) == "1" and ComponentGetValue( emitter, "create_real_particles" ) == "0" and ComponentGetValue( emitter, "emit_real_particles" ) == "0" then
        EntitySetComponentIsEnabled( entity, emitter, false );
    end
end
local sprite_particle_emitters = EntityGetComponent( entity, "SpriteParticleEmitterComponent" ) or {};
for _,emitter in pairs( sprite_particle_emitters ) do
    EntitySetComponentIsEnabled( entity, emitter, false );
end