items = {
    {
        id = "spell_bag",
        name = "$item_name_gkbrkn_spell_bag",
        description = "$item_desc_gkbrkn_spell_bag",
        author = "goki_dev",
        local_content = true,
        item_path = "mods/gkbrkn_noita/files/gkbrkn/items/spell_bag/item.xml",
        options = {
            player_spawned_callback = function( player_entity )
                local x,y = EntityGetTransform( player_entity );
                local inventory = EntityGetNamedChild( player_entity, "inventory_quick" );
                if inventory ~= nil then
                    EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/items/spell_bag/item.xml", x + 20, y - 10 );
                end
            end
        }
    },
    {
        id = "endless_flask",
        name = "$item_name_gkbrkn_endless_flask",
        description = "$item_desc_gkbrkn_endless_flask",
        author = "goki_dev",
        local_content = true,
        item_path = "mods/gkbrkn_noita/files/gkbrkn/items/endless_flask/item.xml",
        options = {
            player_spawned_callback = function( player_entity )
                local x,y = EntityGetTransform( player_entity );
                local inventory = EntityGetNamedChild( player_entity, "inventory_quick" );
                if inventory ~= nil then
                    EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/items/endless_flask/item.xml", x + 20, y - 10 );
                end
            end
        }
    }
}
