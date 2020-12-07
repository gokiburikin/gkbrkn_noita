local memoize_content_types = {};
function find_content_type( id )
    local content_type = nil;
    if memoize_content_types[id] then
        content_type = memoize_content_types[id];
    else
        for _,entry in pairs(content_types) do
            if entry.id == id then
                content_type = entry;
                memoize_content_types[id] = entry;
            end
        end
    end
    return content_type;
end

content_types = {
    {
        id = "action",
        display_name = "$config_content_type_name_gkbrkn_action",
        short_name = "actions",
        content_filepath = "data/scripts/gun/gun_actions.lua",
        content_table = "actions",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/actions_cache.lua",
        cache_table = "actions_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( actions, "..content.options.index.." );\r\n" end,
    },
    {
        id = "perk",
        display_name = "$config_content_type_name_gkbrkn_perk",
        short_name = "perks",
        content_filepath = "data/scripts/perks/perk_list.lua",
        content_table = "perk_list",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/perks_cache.lua",
        cache_table = "perk_list_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( perk_list, "..content.options.index.." );\r\n" end,
    },
    {
        id = "loadout",
        display_name = "$config_content_type_name_gkbrkn_loadout",
        short_name = "loadouts",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua",
        content_table = "loadouts",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/loadouts_cache.lua",
        cache_table = "loadouts_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.insert( disabled_loadouts, loadouts["..content.options.index.."] ); table.remove( loadouts, "..content.options.index.." );\r\n" end,
    },
    {
        id = "tweak",
        display_name = "$config_content_type_name_gkbrkn_tweak",
        short_name = "tweaks",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua",
        content_table = "tweaks",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/tweaks_cache.lua",
        cache_table = "tweaks_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( tweaks, "..content.options.index.." );\r\n" end,
    },
    {
        id = "champion_type",
        display_name = "$config_content_type_name_gkbrkn_champion_type",
        short_name = "champion_types",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua",
        content_table = "champion_types",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/champion_types_cache.lua",
        cache_table = "champion_types_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( champion_types, "..content.options.index.." );\r\n" end,
    },
    {
        id = "legendary_wand",
        display_name = "$config_content_type_name_gkbrkn_legendary_wand",
        short_name = "legendary_wands",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands.lua",
        content_table = "legendary_wands",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/legendary_wands_cache.lua",
        cache_table = "legendary_wands_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.insert( disabled_legendary_wands, legendary_wands["..content.options.index.."] ); table.remove( legendary_wands, "..content.options.index.." );\r\n" end,
    },
    {
        id = "dev_option",
        display_name = "$config_content_type_name_gkbrkn_dev_option",
        short_name = "dev_options",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/dev_options.lua",
        content_table = "dev_options",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/dev_options_cache.lua",
        cache_table = "dev_options_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( dev_options, "..content.options.index.." );\r\n" end,
        development_only = true
    },
    {
        id = "game_modifier",
        display_name = "$config_content_type_name_gkbrkn_game_modifier",
        short_name = "game_modifiers",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua",
        content_table = "game_modifiers",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/game_modifiers_cache.lua",
        cache_table = "game_modifiers_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( game_modifiers, "..content.options.index.." );\r\n" end,
    },
    {
        id = "item",
        display_name = "$config_content_type_name_gkbrkn_item",
        short_name = "items",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/items.lua",
        content_table = "items",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/items_cache.lua",
        cache_table = "items_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( items, "..content.options.index.." );\r\n" end,
    },
    {
        id = "pack",
        display_name = "$config_content_type_name_gkbrkn_pack",
        short_name = "packs",
        content_filepath = "mods/gkbrkn_noita/files/gkbrkn/content/packs.lua",
        content_table = "packs",
        cache_filepath = "mods/gkbrkn_noita/files/gkbkrn/scratch/packs_cache.lua",
        cache_table = "packs_cache",
        content_disable_callback = function( content, current_string ) return current_string .."table.remove( packs, "..content.options.index.." );\r\n" end,
    }
}