dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua");

function load_dynamic_badge ( key, append_bool_table, localization_table )
    local badge_image = "ui_icon_image_"..key;
    local badge_name = "ui_icon_name_"..key;
    local badge_description = "ui_icon_description_"..key;
    if append_bool_table ~= nil then
        for _,pair in ipairs(append_bool_table) do
            for append,bool in pairs(pair) do
                if bool then
                    badge_image = badge_image .. append;
                    badge_name = badge_name .. append;
                    badge_description = badge_description .. append;
                end
            end
        end
    end
    local badge = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/badges/badge.xml" );
    if badge ~= nil then
        local ui_icon = EntityGetFirstComponent( badge, "UIIconComponent" );
        if ui_icon ~= nil then
            ComponentSetValue( ui_icon, "icon_sprite_file", localization_table[badge_image] );
            ComponentSetValue( ui_icon, "name", localization_table[badge_name] );
            ComponentSetValue( ui_icon, "description", localization_table[badge_description] );
        end
    end
    return badge;
end

function get_update_time( )
    return tonumber( GlobalsGetValue( "gkbrkn_update_time" ) ) or 0;
end

function reset_update_time( )
    GlobalsSetValue( "gkbrkn_update_time", 0 );
end

function add_update_time( amount )
    GlobalsSetValue( "gkbrkn_update_time", get_update_time() + amount );
end

function generate_perk_entry( perk_id, key, usable_by_enemies, pickup_function )
    return {
        id = perk_id,
        ui_name = gkbrkn_localization["perk_name_"..key],
        ui_description = gkbrkn_localization["perk_description_"..key],
        ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/icon_ui.png",
        perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/icon_ig.png",
        usable_by_enemies = usable_by_enemies,
        func = pickup_function,
    };
end

function generate_action_entry( action_id, key, action_type, spawn_level, spawn_probability, price, mana, max_uses, custom_xml, action_function )
    return {
        id = action_id,
        name 		        = gkbrkn_localization["action_name_"..key],
        description         = gkbrkn_localization["action_description_"..key],
        sprite 		        = "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/icon.png",
        sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/icon.png",
        type 		        = action_type,
        spawn_level         = spawn_level,
        spawn_probability   = spawn_probability,
        price               = price,
        mana                = mana,
        max_uses            = max_uses,
        custom_xml_file     = custom_xml,
        action = action_function
    };
end

function spawn_gold_nuggets( gold_value, x, y )
    local sizes = { 10000, 1000, 200, 50, 10 };
    for _,size in pairs(sizes) do
        while gold_value >= size do
            gold_value = gold_value - size;
            EntityLoad( "data/entities/items/pickup/goldnugget_"..size..".xml", x, y );
        end
    end
end

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