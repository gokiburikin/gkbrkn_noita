dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

local entity = GetUpdatedEntityID();
local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
for _,emitter in pairs( particle_emitters ) do
    if ComponentGetValue( emitter, "emit_cosmetic_particles" ) == "1" and ComponentGetValue( emitter, "create_real_particles" ) == "0" and ComponentGetValue( emitter, "emit_real_particles" ) == "0" then
        ComponentSetValue( emitter, "count_min", "1" );
        ComponentSetValue( emitter, "count_max", "1" );
        ComponentSetValue( emitter, "collide_with_grid", "0" );
        ComponentSetValue( emitter, "is_trail", "0" );
        local lifetime_min = tonumber( ComponentGetValue( emitter, "lifetime_min" ) );
        ComponentSetValue( emitter, "lifetime_min", tostring( math.min( lifetime_min * 0.5, 0.1 ) ) );
        local lifetime_max = tonumber( ComponentGetValue( emitter, "lifetime_max" ) );
        ComponentSetValue( emitter, "lifetime_max", tostring( math.min( lifetime_max * 0.5, 0.5 ) ) );
    end
end

local sprite_particle_emitters = EntityGetComponent( entity, "SpriteParticleEmitterComponent" ) or {};
for _,emitter in pairs( sprite_particle_emitters ) do
    if ComponentGetValue( emitter, "entity_file" ) == "" then
        ComponentSetValue( emitter, "count_max", "1" );
        ComponentSetValue( emitter, "emission_interval_min_frames", tostring( math.ceil( tonumber( ComponentGetValue( emitter, "emission_interval_min_frames" ) ) * 2 ) ) );
        ComponentSetValue( emitter, "emission_interval_max_frames", tostring( math.ceil( tonumber( ComponentGetValue( emitter, "emission_interval_max_frames" ) ) * 2 ) ) );
    end
end

local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    ComponentObjectAdjustValues( projectile, "config_explosion", {
        sparks_count_min=function( value ) return math.min( tonumber( value ) or 0, 1 ); end,
        sparks_count_max=function( value ) return math.min( tonumber( value ) or 0, 2 ); end,
    });
end