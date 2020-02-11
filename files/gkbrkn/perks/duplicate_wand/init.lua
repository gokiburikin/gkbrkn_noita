dofile_once("data/scripts/lib/utilities.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_DUPLICATE_WAND", "duplicate_wand", false, function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local base_wand = WandGetActiveOrRandom( entity_who_picked );
        if base_wand ~= nil then
            local copy_wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/placeholder_wand.xml", x, y-8 );
            EntitySetVariableNumber( copy_wand, "gkbrkn_duplicate_wand", 1 );
            CopyWand( base_wand, copy_wand );
            local item = EntityGetFirstComponent( copy_wand, "ItemComponent" );
            if item ~= nil then
                ComponentSetValue( item, "play_hover_animation", "1" );
            end
        end
	end
) );