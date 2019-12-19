dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_CHAIN_CASTING", "chain_casting", false, function( entity_perk_item, entity_who_picked, item_name )
        EntitySetVariableNumber( entity_who_picked, "gkbrkn_force_trigger_death", 1 );
	end
));