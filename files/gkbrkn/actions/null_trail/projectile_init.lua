local entity = GetUpdatedEntityID();
local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
for _,particle_emitter in pairs( particle_emitters ) do
    EntityRemoveComponent( entity, particle_emitter );
end

local sprite_particle_emitters = EntityGetComponent( entity, "SpriteParticleEmitterComponent" ) or {};
for _,sprite_particle_emitter in pairs( sprite_particle_emitters ) do
    EntityRemoveComponent( entity, sprite_particle_emitter );
end
