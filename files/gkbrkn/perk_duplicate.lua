dofile("data/scripts/lib/utilities.lua");
dofile("files/gkbrkn/helper.lua");
dofile("files/gkbrkn/gun.lua");

table.insert( perk_list, {
	id = "GKBRKN_DUPLICATE",
	ui_name = "Duplicate",
	ui_description = "A wand has been copied.",
	ui_icon = "files/gkbrkn/perk_duplicate_ui.png",
    perk_icon = "files/gkbrkn/perk_duplicate_ig.png",
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

        local base_wand = random_from_array( valid_wands );
        local copy_wand = EntityLoad( "files/gkbrkn/placeholder_wand.xml", x, y-8 );
        CopyWand( base_wand, copy_wand );
	end,
		
})