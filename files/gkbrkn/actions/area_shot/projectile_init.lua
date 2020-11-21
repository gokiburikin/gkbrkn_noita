dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local entity = GetUpdatedEntityID();
local radius_per_stack = 10;
local game_area_effect = EntityGetFirstComponentIncludingDisabled( entity, "GameAreaEffectComponent" );
if game_area_effect then
    ComponentSetValue2( game_area_effect, "radius", ComponentGetValue2( game_area_effect, "radius") + radius_per_stack );
    for _,particle_emitter in pairs( EntityGetComponent( entity, "ParticleEmitterComponent", "area_damage" ) or {} ) do
        local min, max = ComponentGetValue2( particle_emitter, "area_circle_radius" );
        if min ~= -1 then
            min = min + radius_per_stack
        end
        max = max + radius_per_stack;
        ComponentSetValue2( particle_emitter, "area_circle_radius", min, max );
        ComponentSetValue2( particle_emitter, "area_circle_radius", min, max );
    end
end