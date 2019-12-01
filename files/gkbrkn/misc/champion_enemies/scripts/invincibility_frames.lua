function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
    for _,damage_model in pairs( damage_models ) do
        local invincibility_frames = tonumber( ComponentGetValue( damage_model, "invincibility_frames" ) );
        if invincibility_frames <= 0 then
            ComponentSetValue( damage_model, "invincibility_frames", 10 );
        end
    end
end