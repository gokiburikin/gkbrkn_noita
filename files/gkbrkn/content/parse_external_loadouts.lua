if loadouts_to_parse ~= nil then
    for _,loadout_data in pairs( loadouts_to_parse ) do
        local id = loadout_data.key.."_"..loadout_data.name:gsub(" ","_");
        local name = loadout_data.name;
        local cape_color = loadout_data.cape_color;
        local cape_color_edge = loadout_data.cape_color_edge;
        local items = {};
        for _,item_data in pairs( loadout_data.items or {} ) do
            if type( item_data ) == "table" then
                for i=1,item_data.amount or 1 do
                    if item_data.options ~= nil then
                        table.insert( items, item_data.options );
                    else
                        table.insert( items, { item_data[1] } );
                    end
                end
            else
                table.insert( items, { item_data } );
            end
        end
        local perks = {};
        for _,perk_data in pairs( loadout_data.perks or {} ) do
            table.insert( perks, { perk_data } );
        end
        table.insert( loadouts, {
            id = id, -- unique identifier
            name = name, -- displayed loadout name
            description = loadout_data.description or "An automatically managed loadout.",
            author = loadout_data.author,
            cape_color = cape_color, -- cape color (ABGR) *can be nil
            cape_color_edge = cape_color_edge, -- cape edge color (ABGR) *can be nil
            wands = loadout_data.wands or {},
            potions = {},
            items = items,
            perks = perks,
            actions = {},
            sprites = loadout_data.sprites,
            custom_message = nil,
            callback = nil,
            condition_callback = nil,
            menu_note = "("..loadout_data.author..")"
        } );
    end
end