dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MANA_RECOVERY", "mana_recovery", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_mana_recovery", 0.0, function( value ) return value + 0.833; end );
	end
) );