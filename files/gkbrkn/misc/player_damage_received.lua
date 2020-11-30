local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local entity = GetUpdatedEntityID();

    -- TODO utilizing this for Blood Magic will be problematic when Blood Magic deals proper damage to self
    if damage > 0 then
        EntitySetVariableNumber( entity, "gkbrkn_last_frame_damaged", GameGetFrameNum() );
    end

    local invincibility_duration = EntityGetVariableNumber(entity, "gkbrkn_invincibility_frames", 0 );
    local duration = setting_get( MISC.InvincibilityFrames.Duration );
    if duration > 0 and invincibility_duration < duration then
        invincibility_duration = duration;
    end
    if invincibility_duration > 0 and damage > 0 then
        local components = EntityGetComponent( entity, "DamageModelComponent" );
        if components ~= nil and entity_thats_responsible ~= 0 then
            for _,data_component in pairs( components ) do
                local current_invincibility_frames = ComponentGetValue2( data_component, "invincibility_frames" );
                -- only add invincibility frames if we are not currently invincible
                if current_invincibility_frames <= 0 then
                    ComponentSetValue2( data_component, "invincibility_frames", invincibility_duration );
                end
            end
        end
    end
end