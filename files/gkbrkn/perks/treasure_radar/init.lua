dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_TREASURE_RADAR", "treasure_radar", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", 
        { 
            script_source_file = "mods/gkbrkn_noita/files/gkbrkn/perks/treasure_radar/update.lua",
            execute_every_n_frame = "1",
        } );
	end
) );