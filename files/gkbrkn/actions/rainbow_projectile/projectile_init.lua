local entity = GetUpdatedEntityID();
SetRandomSeed( entity, entity );
local color = 0xFF000000 + math.floor( Random() * 0xFFFFFF );
local b = bit.rshift( bit.band( 0xFF0000, color ), 16 );
local g = bit.rshift( bit.band( 0xFF00, color ), 8 );
local r = bit.band( 0xFF, color );
local particle_emitters = EntityGetComponent( entity, "ParticleEmitterComponent" ) or {};
for _,particle_emitter in pairs( particle_emitters ) do
    ComponentSetValue2( particle_emitter, "color", color );
end

if ComponentGetValue2 and ComponentSetValue2 then
    local sprite_particle_emitters = EntityGetComponent( entity, "SpriteParticleEmitterComponent" ) or {};
    for _,sprite_particle_emitter in pairs( sprite_particle_emitters ) do
        local color = {ComponentGetValue2( sprite_particle_emitter, "color" )};
        local color_change = {ComponentGetValue2( sprite_particle_emitter, "color_change" )};
        local ratio_r = r / 255;
        local ratio_g = g / 255;
        local ratio_b = b / 255;
        ComponentSetValue2( sprite_particle_emitter, "color", ratio_r, ratio_g, ratio_b, color[4] );
    end
end
