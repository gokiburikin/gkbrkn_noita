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
end