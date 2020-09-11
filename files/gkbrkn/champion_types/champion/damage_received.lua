dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID();
    if is_fatal and entity_thats_responsible ~= entity and does_entity_drop_gold(entity) then
        local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
        if damage_models ~= nil then
            local total_health = 0;
            for i,damage_model in ipairs( damage_models ) do
                total_health = total_health + ComponentGetValue( damage_model, "max_hp" );
            end
            local x, y = EntityGetTransform( entity );
            local gold_reward = math.ceil( total_health + 0.5 ) * 8 * EntityGetVariableNumber( entity, "gkbrkn_champion_modifier_amount", 0 );
            gold_reward = math.ceil( gold_reward / 10 ) * 10;
            GamePrint( "[goki's things] champion bonus was "..gold_reward.." gold for "..(total_health * 25).. " health");
            if gold_reward > 0 then
                spawn_gold_nuggets( gold_reward, x, y );
            end
        end
    end
end