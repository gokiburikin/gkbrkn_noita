dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_HEALTHIER_HEART", "healthier_heart", function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_max_health_recovery", 0.0, function( value ) return value + 1.0; end );
	end
));