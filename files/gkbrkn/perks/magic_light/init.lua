table.insert( perk_list, {
	id = "GKBRKN_MAGIC_LIGHT",
	ui_name = "Magic Light",
	ui_description = "Control a magic light that cuts through darkness",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/magic_light/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/magic_light/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local magic_light = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/perks/magic_light/magic_light.xml" );
        EntityAddChild( entity_who_picked, magic_light );
	end,
});