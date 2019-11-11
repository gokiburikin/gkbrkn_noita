dofile("data/scripts/lib/utilities.lua");
if _GKBRKN_HELPER == nil then dofile("files/gkbrkn/helper.lua"); end

table.insert( perk_list, {
	id = "GKBRKN_ALWAYS_CAST",
	ui_name = "Always Cast",
	ui_description = "A random spell has been upgraded to always cast.",
	ui_icon = "files/gkbrkn/perks/always_cast/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/always_cast/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local valid_wands = {};
        local children = EntityGetAllChildren( entity_who_picked );
        for key, child in pairs(children) do
            if EntityGetName( child ) == "inventory_quick" then
                valid_wands = EntityGetChildrenWithTag( child, "wand" );
                break;
            end
        end

        local base_wand = random_from_array( valid_wands );

        local children = EntityGetAllChildren( base_wand );
        local actions = {};
        local ability_component = WandGetAbilityComponent( base_wand );
            if ability_component ~= nil then
            local deck_capacity = tonumber( ComponentObjectGetValue( ability_component, "gun_config", "deck_capacity" ) );
            ComponentObjectSetValue( ability_component, "gun_config", "deck_capacity", tostring( deck_capacity + 1 ) );
        end
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
	end,
});