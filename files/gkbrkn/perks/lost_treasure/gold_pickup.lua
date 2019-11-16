function item_pickup( entity_item, entity_pickupper, item_name )
    EntityRemoveComponent( entity_item, EntityGetFirstComponent( entity_item, "LuaComponent", "gkbrkn_lost_treasure" ) );
end 