dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_DIPLOMATIC_IMMUNITY", "diplomatic_immunity", false, function( entity_perk_item, entity_who_picked, item_name )
        GameAddFlagRun( FLAGS.CalmGods );
        GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "0" );
	end
) );