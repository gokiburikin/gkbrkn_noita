local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local entity = GetUpdatedEntityID();
    local take_damage_triggers = EntityGetWithTag("gkbrkn_trigger_take_damage_projectile") or {};
    for _,trigger in pairs( take_damage_triggers ) do
        local projectile = EntityGetFirstComponentIncludingDisabled( trigger, "ProjectileComponent" );
        if projectile then
            ComponentSetValue2( projectile, "on_collision_die", false );
            ComponentSetValue2( projectile, "collide_with_world", false );
            local who_shot = ComponentGetValue2( projectile, "mWhoShot" );
            if who_shot == entity then
                local x, y = EntityGetTransform( trigger );
                EntityApplyTransform( trigger, x, y );
                local linked_entity = EntityGetVariableNumber( trigger, "linked_entity", 0 )
                if linked_entity ~= 0 then EntityApplyTransform(  linked_entity, x, y ); end
                ComponentSetValue2( projectile, "collide_with_tag", "gkbrkn_trigger_take_damage" );
                EntityAddComponent( trigger, "LuaComponent", {
                    remove_after_executed = "1",
                    script_source_file = "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/clear_collide.lua"
                } );
            end
        end
    end
end