table.insert( perk_list, {
	id = "GKBRKN_THRIFTY_SHOPPER",
	ui_name = "Thrifty Shopper",
	ui_description = "Holy Mountain shops carry two additional items.",
	ui_icon = "files/gkbrkn/perks/thrifty_shopper/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/thrifty_shopper/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", tostring( tonumber( GlobalsGetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" ) ) + 2 ) );
	end,
});