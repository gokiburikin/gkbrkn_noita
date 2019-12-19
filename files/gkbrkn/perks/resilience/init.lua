dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/config.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_RESILIENCE", "resilience", true, function( entity_perk_item, entity_who_picked, item_name )
        TryAdjustDamageMultipliers( entity_who_picked, CONTENT[PERKS.Resilience].options.Resistances );
	end
) );
