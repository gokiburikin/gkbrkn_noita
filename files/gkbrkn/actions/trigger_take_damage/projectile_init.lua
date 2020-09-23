dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

local entity = GetUpdatedEntityID();
EntitySetVariableNumber( entity, "gkbrkn_spawn_time", GameGetFrameNum() );
EntityAddTag( entity, "gkbrkn_trigger_take_damage_projectile" );
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile then
    ComponentSetValue2( projectile, "on_collision_die", false );
    ComponentSetValue2( projectile, "collide_with_world", false );
    local who_shot = ComponentGetValue2( projectile, "mWhoShot" );
    if EntityGetVariableNumber( entity, "linked_entity", 0 ) == 0 then
        local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/trigger_entity.xml" );
        EntitySetVariableNumber( entity, "linked_entity", tonumber( link_entity ) );
        EntityAddChild( entity, link_entity );
        EntityAddChild( who_shot, entity );
        if not EntityGetFirstComponentIncludingDisabled( who_shot, "LuaComponent", "gkbrkn_trigger_take_damage_received" ) then
            EntityAddComponent( who_shot, "LuaComponent", {
                _tags="gkbrkn_trigger_take_damage_received",
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/damage_received.lua"
            } );
        end
    end
end