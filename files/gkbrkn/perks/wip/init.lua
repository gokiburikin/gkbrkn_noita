dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_PERK_WIP", "wip", function( entity_perk_item, entity_who_picked, item_name )
        DoFileEnvironment(  "mods/gkbrkn_noita/files/gkbrkn/perks/wip/perk.lua", { 
            entity_perk_item = entity_perk_item, 
            entity_who_picked = entity_who_picked,
            item_name = item_name
        } );
        --dofile("mods/gkbrkn_noita/files/gkbrkn/perks/wip/perk.lua");
	end
) );