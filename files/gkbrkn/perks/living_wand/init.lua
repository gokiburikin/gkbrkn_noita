dofile_once("data/scripts/lib/utilities.lua");
dofile_once("files/gkbrkn/helper.lua");

table.insert( perk_list, {
	id = "GKBRKN_LIVING_WAND",
	ui_name = "Living Wand",
	ui_description = "Living Wand.",
	ui_icon = "files/gkbrkn/perk/living_wand/icon_ui.png",
    perk_icon = "files/gkbrkn/perk/living_wand/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local valid_wands = {};
        local children = EntityGetAllChildren( entity_who_picked );
		for key, child in pairs(children) do
			if EntityGetName( child ) == "inventory_quick" then
                valid_wands = EntityGetChildrenWithTag( child, "wand" );
                break;
			end
        end

        if #valid_wands > 0 then
            local base_wand = random_from_array( valid_wands );
            GameKillInventoryItem( entity_who_picked, base_wand );
            EntityAddChild( entity_who_picked, EntityLoad( "files/gkbrkn/living_wand/anchor.xml" ) );

            local copy_wand = EntityLoad( "files/gkbrkn/living_wand/ghost.xml", x, y );
            local living_wand = EntityGetWithTag( "gkbrkn_living_wand_"..tostring(copy_wand) )[1];
            CopyWand( base_wand, living_wand );

        end
	end,
})