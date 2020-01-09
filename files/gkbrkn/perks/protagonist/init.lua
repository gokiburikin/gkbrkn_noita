dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list,
    -- TODO this can be made to support enemies
    generate_perk_entry( "GKBRKN_PROTAGONIST", "protagonist", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_low_health_damage_bonus", 0.0, function( value ) return value + 2.00; end );
	end
) );