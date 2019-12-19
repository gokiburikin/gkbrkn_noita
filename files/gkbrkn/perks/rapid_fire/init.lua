dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

table.insert( perk_list,
    -- TODO this can be made to support enemies
    generate_perk_entry( "GKBRKN_RAPID_FIRE", "rapid_fire", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_rapid_fire", 0.0, function( value ) return value + 1; end );
	end
) );