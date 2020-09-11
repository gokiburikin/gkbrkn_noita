local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local entity = GetUpdatedEntityID();

    -- TODO utilizing this for Blood Magic will be problematic when Blood Magic deals proper damage to self
    if damage > 0 then
        EntitySetVariableNumber( entity, "gkbrkn_last_frame_damaged", GameGetFrameNum() );
    end

    local invincibility_duration = EntityGetVariableNumber(entity, "gkbrkn_invincibility_frames", 0 );
    if HasFlagPersistent( MISC.InvincibilityFrames.EnabledFlag ) and invincibility_duration < MISC.InvincibilityFrames.Duration then
        invincibility_duration = MISC.InvincibilityFrames.Duration;
    end
    if invincibility_duration > 0 and damage > 0 then
        local components = EntityGetComponent( entity, "DamageModelComponent" );
        if components ~= nil and entity_thats_responsible ~= 0 then
            for _,data_component in pairs( components ) do
                local current_invincibility_frames = tonumber( ComponentGetValue( data_component, "invincibility_frames" ) );
                -- only add invincibility frames if we are not currently invincible
                if current_invincibility_frames <= 0 then
                    ComponentSetValue( data_component, "invincibility_frames", tostring( invincibility_duration ) );
                end
            end
        end
    end

    local take_damage_triggers = EntityGetWithTag("gkbrkn_trigger_take_damage_projectile") or {};
    for _,trigger in pairs( take_damage_triggers ) do
        local x, y = EntityGetTransform( entity );
        EntityApplyTransform( trigger, x, y );
        local linked_entity = EntityGetVariableNumber( trigger, "linked_entity", 0 )
        if linked_entity ~= 0 then EntityApplyTransform(  linked_entity, x, y ); end
        local projectile = EntityGetFirstComponent( trigger, "ProjectileComponent" );
        if projectile then ComponentSetValue2( projectile, "collide_with_tag", "gkbrkn_trigger_take_damage" ); end
        EntityAddComponent( trigger, "LuaComponent", {
            remove_after_executed = "1",
            script_source_file = "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/clear_collide.lua"
        } );
    end
end