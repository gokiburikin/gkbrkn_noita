dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
EntitySetVariableNumber( entity, "gkbrkn_stick_to_player", 1 );
EntityAddTag( entity, "gkbrkn_trigger_take_damage_projectile" );
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile then
    ComponentSetValue2( projectile, "on_collision_die", false );
    ComponentSetValue2( projectile, "collide_with_world", false );
end

if EntityGetVariableNumber( entity, "linked_entity", 0 ) == 0 then
    local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/trigger_entity.xml");
    EntitySetVariableNumber( entity, "linked_entity", tonumber( link_entity ) );
end