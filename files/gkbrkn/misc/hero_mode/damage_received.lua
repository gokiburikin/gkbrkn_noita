dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "data/scripts/items/drop_money.lua" );

function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if is_fatal and entity_thats_responsible ~= entity and does_entity_drop_gold(entity) then
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
        if damage_models ~= nil then
            local total_health = 0;
            for i,damage_model in ipairs( damage_models ) do
                total_health = total_health + ComponentGetValue2( damage_model, "max_hp" );
            end
            local x, y = EntityGetTransform( entity );
            --local gold_reward = math.ceil( total_health / 6 ) * 10;
            local gold_multiplier = math.floor( total_health / 8 );
            if gold_multiplier > 0 then
                print("hero bonus "..gold_multiplier)
                do_money_drop( gold_multiplier );
            end
            --spawn_gold_nuggets( gold_reward, x, y );
        end
    end
end