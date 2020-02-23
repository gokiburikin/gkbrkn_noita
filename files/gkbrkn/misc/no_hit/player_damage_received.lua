function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = tonumber( GetUpdatedEntityID() );
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
    for _,damage_model in pairs( damage_models ) do
        ComponentSetValue( damage_model, "hp", 0 );
        ComponentSetValue( damage_model, "max_hp", 0 );
    end
end
