dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

function does_entity_drop_gold( entity )
    local drops_gold = false;
    for _,component in pairs( EntityGetComponent( entity, "LuaComponent" ) ) do
        if ComponentGetValue( component, "script_death" ) == "data/scripts/items/drop_money.lua" then
            drops_gold = true;
            break;
        end
    end
    if drops_gold == true then
        if EntityGetFirstComponent( entity, "VariableStorageComponent", "no_drop_gold" ) ~= nil then
            drops_gold = false;
        end
    end
    return drops_gold;
end

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
            local gold_reward = math.ceil( total_health / 6 );
            local extra_gold = EntityLoad( "data/entities/items/pickup/goldnugget.xml", x + Random( -2, 2 ), y - 8 + Random( -2, 2 ) );
            --while gold_reward > 0 do
            --    local to_spawn = math.min( 5, gold_reward );
            --    gold_reward = gold_reward - to_spawn;
            --    GameCreateParticle( "gold", x + Random( -2, 2 ), y + Random( -2, 2 ), to_spawn, Random( -10, 10 ), Random( -100, 0 ), false, true );
            --end
        end
    end
end