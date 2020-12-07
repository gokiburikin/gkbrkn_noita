function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if EntityHasTag( entity, "boss_centipede" ) == false then
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
        if is_fatal then
            EntityConvertToMaterial( entity, "gold" );
            EntityKill( entity );
        end
    end
end