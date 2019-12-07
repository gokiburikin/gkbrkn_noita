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
        local x,y = EntityGetTransform( entity );
        local extra_gold = EntityLoad( "data/entities/items/pickup/goldnugget.xml", x + Random( -2, 2 ), y - 8 + Random( -2, 2 ) );
    end
end