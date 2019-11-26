dofile_once("data/scripts/lib/utilities.lua");
dofile_once("files/gkbrkn/helper.lua");

table.insert( perk_list, {
	id = "GKBRKN_DUPLICATE_WAND",
	ui_name = "Duplicate Wand",
	ui_description = "Your wand has been copied.",
	ui_icon = "files/gkbrkn/perks/duplicate_wand/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/duplicate_wand/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local base_wand = WandGetActiveOrRandom( entity_who_picked );
        if base_wand ~= nil then
            local copy_wand = EntityLoad( "files/gkbrkn/placeholder_wand.xml", x, y-8 );
            CopyWand( base_wand, copy_wand );
            local item = EntityGetFirstComponent( copy_wand, "ItemComponent" );
            if item ~= nil then
                ComponentSetValue( item, "play_hover_animation", "1" );
            end
        end
	end,
});