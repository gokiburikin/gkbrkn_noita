dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
local entity = GetUpdatedEntityID();
adjust_all_entity_damage( entity, function( value ) return value * 0.50; end );
local game_area_effect = EntityGetFirstComponentIncludingDisabled( entity, "GameAreaEffectComponent" );
if game_area_effect then
    ComponentSetValue2( game_area_effect, "radius", ComponentGetValue2( game_area_effect, "radius") + 16 );
    for _,particle_emitter in pairs( EntityGetComponent( entity, "ParticleEmitterComponent", "area_damage" ) or {} ) do
        local min, max = ComponentGetValue2( particle_emitter, "area_circle_radius" );
        if min ~= -1 then
            min = min + 16
        end
        max = max + 16;
        ComponentSetValue2( particle_emitter, "area_circle_radius", min, max );
        ComponentSetValue2( particle_emitter, "area_circle_radius", min, max );
    end
end