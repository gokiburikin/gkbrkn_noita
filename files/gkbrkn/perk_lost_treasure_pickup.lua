function item_pickup( entity_item, entity_pickupper, item_name )
local tracker_variable = "gkbrkn_lost_treasure_tracker";
    local players = EntityGetWithTag( "player_unit" );
    for index,player in pairs( players ) do
        local tracker = EntityGetFirstComponent( player, "VariableStorageComponent", tracker_variable );
        if tracker ~= nil then
            local current_lost_treasure_count = tonumber(ComponentGetValue( tracker, "value_string" ));
            ComponentSetValue( tracker, "value_string", current_lost_treasure_count - 1 );
        end
    end
end