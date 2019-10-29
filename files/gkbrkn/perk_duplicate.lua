dofile("data/scripts/lib/utilities.lua");
dofile("files/gkbrkn/helper.lua");
dofile("files/gkbrkn/gun.lua");

table.insert( perk_list, {
	id = "GKBRKN_DUPLICATE_WAND",
	ui_name = "Duplicate",
	ui_description = "A small favour.",
	ui_icon = "files/gkbrkn/perk_enraged_ui.png",
    perk_icon = "files/gkbrkn/perk_enraged_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local children = EntityGetAllChildren( entity_who_picked );
        local valid_wands = {};
		for key, child in pairs(children) do
			if EntityGetName(child) == "inventory_quick" then
                local wands = EntityGetAllChildren( child );
                for key2, wand in pairs( wands ) do
                    --Log( tostring(key2.."/"..wand) );
					if EntityHasTag( wand, "wand" ) then
                        --table.insert( valid_wands, wand );
                        local copy_wand = EntityLoad( "files/gkbrkn/placeholder_wand.xml", x + Random(-30,30), y - 4 );
                        Log("copy wand",wand);
                        CopyWand( wand, copy_wand );
					end
				end
			end
        end

        --local base_wand = random_from_array( valid_wands );
        --CopyWand( base_wand, copy_wand );
        LogTable(_G.GKBRKN.GetGunData());
	end,
		
})