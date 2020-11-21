if loadouts_to_parse then
    for _,loadout in pairs( class_list ) do
        loadout.name = loadout.ui_name;
        loadout.description = loadout.ui_description;
        loadout.key = "runi";
        loadout.author = "Runi";
        local adjusted_wands = {};
        if loadout.wands ~= nil then
            for _,wand_data in pairs(loadout.wands ) do
                if type( wand_data ) == "string" then
                    table.insert( adjusted_wands, wand_data );
                elseif type( wand_data ) == "table" then
                    local adjusted_wand_data = {};
                    adjusted_wand_data.stats = {
                        fire_rate_wait = wand_data.fire_rate_wait,
                        actions_per_round = wand_data.actions_per_round,
                        shuffle_deck_when_empty = wand_data.shuffle_deck_when_empty and true or false,
                        deck_capacity = wand_data.deck_capacity,
                        spread_degrees = wand_data.spread_degrees,
                        reload_time = wand_data.reload_time,
                        mana_charge_speed = wand_data.mana_charge_speed,
                        mana_max = wand_data.mana_max,
                        speed_multiplier = wand_data.speed_multiplier,
                    };
                    adjusted_wand_data.actions = {};
                    for _,action_id in pairs( wand_data.actions or {} ) do
                        table.insert( adjusted_wand_data.actions, {{ action_id = action_id }} );
                    end
                    for _,action_id in pairs( wand_data.always_cast or {} ) do
                        table.insert( adjusted_wand_data.actions, {{ action_id = action_id, permanent = true }} );
                    end
                    table.insert( adjusted_wands, adjusted_wand_data );
                end
            end
            loadout.wands = adjusted_wands;
        end
        local adjusted_items = {};
        for _,item_data in pairs( loadout.items or {} ) do
            if type( item_data ) == "table" then
                table.insert( adjusted_items, { options = {{
                    filepath = item_data.base,
                    initialize = item_data.setup,
                } }} );
            elseif type( item_data ) == "string" then
                table.insert( adjusted_items, { item_data } );
            end
        end
        loadout.items = adjusted_items;
        local adjusted_perks = {};
        for _,perk_id in pairs( loadout.perks or {} ) do
            table.insert( adjusted_perks, perk_id );
        end
        loadout.perks = adjusted_perks;
    end
    for _,loadout in pairs(class_list) do
        table.insert( loadouts_to_parse, loadout );
    end
else
    print("[goki's things] Couldn't find the loadouts table for selectable_classes loadout management.");
end