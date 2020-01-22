dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_HYPER_CASTING", "hyper_casting", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_hyper_casting", 0, function( value ) return tonumber( value ) + 1; end );
	end
));