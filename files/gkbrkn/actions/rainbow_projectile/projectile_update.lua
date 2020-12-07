local entity = GetUpdatedEntityID();
local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
for _,particle_emitter in pairs( particle_emitters ) do
    ComponentSetValue2( particle_emitter, "color", 0xFF000000 + math.floor( math.random() * 0xFFFFFF ) );
end