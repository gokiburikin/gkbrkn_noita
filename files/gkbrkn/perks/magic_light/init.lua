dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MAGIC_LIGHT", "magic_light", function( entity_perk_item, entity_who_picked, item_name )
        local magic_light = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/perks/magic_light/magic_light.xml" );
        EntityAddChild( entity_who_picked, magic_light );
	end
) );