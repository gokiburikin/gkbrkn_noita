dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

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

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentObjectSetValues( projectile, "config_explosion", {
        sparks_count_min="0",
        sparks_count_max="0",
    });
end