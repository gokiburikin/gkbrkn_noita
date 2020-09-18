function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if damage > 0 then
        if tonumber(entity) ~= tonumber(entity_thats_responsible) and tonumber(entity_thats_responsible) ~= 0 then
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
            for _,damage_model in pairs( damage_models ) do
                local invincibility_frames = ComponentGetValue2( damage_model, "invincibility_frames" );
                if invincibility_frames <= 0 then
                    ComponentSetValue2( damage_model, "invincibility_frames", 1 );
                end
            end
        end
    end
end