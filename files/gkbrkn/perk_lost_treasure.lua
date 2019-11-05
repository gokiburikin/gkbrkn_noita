dofile( "data/scripts/lib/utilities.lua" );

local tracker_variable = "gkbrkn_lost_treasure_tracker";
table.insert( perk_list, {
	id = "GKBRKN_LOST_TREASURE",
	ui_name = "Lost Treasure",
	ui_description = "The gift of that which was forgotten",
	ui_icon = "files/gkbrkn/perk_lost_treasure_ui.png",
    perk_icon = "files/gkbrkn/perk_lost_treasure_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local tracker = EntityGetFirstComponent( entity_who_picked, "VariableStorageComponent", tracker_variable );
        if tracker ~= nil then
            local spawner = EntityLoad( "files/gkbrkn/perk_lost_treasure_spawner.xml", 0, 0 );
            local current_lost_treasure_count = tonumber(ComponentGetValue( tracker, "value_string" ));
            EntityAddComponent( spawner, "VariableStorageComponent", {
                _tags=tracker_variable,
                name=tracker_variable,
                value_string=tostring(current_lost_treasure_count)
            });
            EntityAddChild( entity_who_picked, spawner );
        end
	end,
})