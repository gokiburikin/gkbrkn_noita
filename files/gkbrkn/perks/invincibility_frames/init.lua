dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
table.insert( perk_list,
    -- TODO this can be made into an enemy usable perk
    generate_perk_entry( "GKBRKN_INVINCIBILITY_FRAMES", "invincibility_frames", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_invincibility_frames", 0.0, function( value ) return value + 20.0 end );
	end
) );