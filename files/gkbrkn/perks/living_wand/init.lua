dofile_once("data/scripts/lib/utilities.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_LIVING_WAND", "living_wand", false, function( entity_perk_item, entity_who_picked, item_name )
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
            EntityAddChild( entity_who_picked, EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/living_wand/anchor.xml" ) );

            local copy_wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/living_wand/ghost.xml", x, y );
            local living_wand = EntityGetWithTag( "gkbrkn_living_wand_"..tostring(copy_wand) )[1];
            CopyWand( base_wand, living_wand );

        end
	end
) );