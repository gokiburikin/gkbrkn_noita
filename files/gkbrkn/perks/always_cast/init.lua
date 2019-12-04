dofile_once("data/scripts/lib/utilities.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");

function is_wand_always_cast_valid( wand )
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local components = EntityGetAllComponents( v );
        local has_a_valid_spell = false;
        for _,component in pairs(components) do
            if ComponentGetValue( component, "permanently_attached" ) == "0" then
                has_a_valid_spell = true;
                break;
            end
        end
        if has_a_valid_spell then
            return true;
        end
    end
    return false;
end

table.insert( perk_list, {
	id = "GKBRKN_ALWAYS_CAST",
	ui_name = "Always Cast",
	ui_description = "A random spell on your wand has been upgraded to always cast.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/always_cast/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/always_cast/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local base_wand = nil;
        local wands = {};
        local children = EntityGetAllChildren( entity_who_picked );
        for key,child in pairs( children ) do
            if EntityGetName( child ) == "inventory_quick" then
                wands = EntityGetChildrenWithTag( child, "wand" );
                break;
            end
        end
        if #wands > 0 then
            local filtered_wands = {};
            for _,wand in pairs(wands) do
                if is_wand_always_cast_valid( wand ) then
                    table.insert( filtered_wands, wand );
                end
            end
            if #filtered_wands > 0 then
                wands = filtered_wands;
                local inventory2 = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" );
                local active_item = tonumber( ComponentGetValue( inventory2, "mActiveItem" ) );
                for _,wand in pairs( wands ) do
                    if wand == active_item then
                        base_wand = wand;
                        break;
                    end
                end
                if base_wand == nil then
                    base_wand =  random_from_array( wands );
                end
            end
        end
        if base_wand ~= nil then
            local children = EntityGetAllChildren( base_wand );
            local ability_component = WandGetAbilityComponent( base_wand );
                if ability_component ~= nil then
                local deck_capacity = tonumber( ComponentObjectGetValue( ability_component, "gun_config", "deck_capacity" ) );
                ComponentObjectSetValue( ability_component, "gun_config", "deck_capacity", tostring( deck_capacity + 1 ) );
            end

            local actions = {};
            for i,v in ipairs( children ) do
                local components = EntityGetAllComponents( v );
                for _,component in pairs(components) do
                    if ComponentGetValue( component, "permanently_attached" ) == "0" then
                        table.insert( actions, component );
                    end
                end
            end
            if #actions > 0 then
                local to_attach = random_from_array( actions );
                if to_attach ~= nil then
                    ComponentSetValue( to_attach, "permanently_attached", "1" );
                end
            end
        end
	end,
});