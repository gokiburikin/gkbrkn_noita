if _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end

local entity = GetUpdatedEntityID();

function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local components = EntityGetComponent( entity, "DamageModelComponent" );
    if components ~= nil and entity_thats_responsible ~= 0 then
        for _,data_component in pairs( components ) do
            local invincibility_frames = tonumber( ComponentGetValue( data_component, "invincibility_frames" ) );
            if invincibility_frames <= 0 then
                ComponentSetValue( data_component, "invincibility_frames", tostring(MISC.InvincibilityFrames.Duration) );
            end
        end
    end
end