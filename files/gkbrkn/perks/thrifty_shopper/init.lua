dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_THRIFTY_SHOPPER", "thrifty_shopper", function( entity_perk_item, entity_who_picked, item_name )
        GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", tostring( tonumber( GlobalsGetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" ) ) + 2 ) );
	end
) );