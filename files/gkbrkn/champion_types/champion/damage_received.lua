dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")

function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    local entity = GetUpdatedEntityID()
    if is_fatal and entity_thats_responsible ~= entity and does_entity_drop_gold(entity) then
        local x, y = EntityGetTransform( entity )
        local gold_reward = EntityGetVariableNumber( entity, "gkbrkn_champion_reward", 0.0 )
        if gold_reward > 0 then
            --do_money_drop( gold_reward )
            spawn_gold_nuggets( gold_reward * 10.0, x, y )
        end
    end
end