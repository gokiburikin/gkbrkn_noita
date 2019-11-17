function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if is_fatal and entity_thats_responsible ~= entity then
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
        if damage_models ~= nil then
            local total_health = 0;
            for i,damage_model in ipairs( damage_models ) do
                total_health = total_health + ComponentGetValue( damage_model, "max_hp" );
            end
            local x, y = EntityGetTransform( entity );
            local gold_reward = math.ceil( total_health * 2.5 ) + 30;
            while gold_reward > 0 do
                local to_spawn = math.min( 5, gold_reward );
                gold_reward = gold_reward - to_spawn;
                GameCreateParticle( "gold", x + Random( -2, 2 ), y + Random( -2, 2 ), to_spawn, Random( -10, 10 ), Random( -100, 0 ), false, true );
            end
        end
    end
end