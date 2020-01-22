dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MEGACAST", "megacast", false, function( entity_perk_item, entity_who_picked, item_name )
        EntitySetVariableNumber( entity_who_picked, "gkbrkn_draw_remaining", 1 );
	end
) );