function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if EntityHasTag( entity, "boss_centipede" ) == false then
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
        if is_fatal then
            EntityConvertToMaterial( entity, "gold" );
            EntityKill( entity );
        else
            if damage_models ~= nil then
                for i,damage_model in ipairs( damage_models ) do
                    ComponentSetValue( damage_model, "blood_material", "gold" );
                    ComponentSetValue( damage_model, "blood_spray_material", "gold" );
                    ComponentSetValue( damage_model, "blood_spray_create_some_cosmetic", "1" );
                    ComponentSetValue( damage_model, "blood_multiplier", "0.1" );
                    ComponentSetValue( damage_model, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_yellow_$[1-3].xml" );
                    ComponentSetValue( damage_model, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_yellow_$[1-3].xml" );
                end
            end
        end
    end
end