function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if not is_fatal then
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
        if damage_models ~= nil then
            for i,damage_model in pairs( damage_models ) do
                local max_hp = tonumber( ComponentGetValue( damage_model, "max_hp" ) );
                ComponentSetValue( damage_model, "max_hp", tostring( math.min( max_hp, math.max( 0, max_hp - damage ) ) ) );
            end
        end
    end
end