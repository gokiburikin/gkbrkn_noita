dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
local lifetime = GameGetFrameNum() - EntityGetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile then
    if lifetime % 15 == 0 then
        --[[ only work with enemies nearby
        local x, y = EntityGetTransform( entity );
        local nearby_enemies = EntityGetInRadiusWithTag( x, y, 192, "enemy" );
        if #nearby_enemies > 0 then
            ComponentSetValue2( projectile, "collide_with_tag", "gkbrkn_trigger_repeat" );
        end
        ]]
        ComponentSetValue2( projectile, "collide_with_tag", "gkbrkn_trigger_repeat" );
    else
        ComponentSetValue2( projectile, "collide_with_tag", "" );
    end
end