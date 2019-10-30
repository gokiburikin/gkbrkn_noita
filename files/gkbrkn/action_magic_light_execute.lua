dofile( "data/scripts/lib/utilities.lua" );
dofile( "files/gkbrkn/helper.lua" );

local entity_id    = GetUpdatedEntityID();

--if EntityGetComponent( entity_id, "MagicXRayComponent" ) == nil then
--    EntityAddComponent( entity_id, "MagicXRayComponent", {
--        radius=48,
--        steps_per_frame=1
--    });
--end
--if EntityGetComponent( entity_id, "TorchComponent" ) == nil then
--    EntityAddComponent( entity_id, "TorchComponent", {
--    });
--end

--[[
if EntityGetComponent( entity_id, "HitEffectComponent" ) == nil then
    Log(entity_id, "added hit effect component");
    local component = EntityAddComponent( entity_id, "HitEffectComponent", {
        effect_hit="LOAD_ENTITY",
        value_string="data/entities/misc/fireball_ray_enemy.xml"
    });
    EntitySetComponentIsEnabled( entity_id, component, true );
end
]]
