table.insert( perk_list, {
	id = "GKBRKN_LIVING_WAND",
	ui_name = "Living Wand",
	ui_description = "Living Wand.",
	ui_icon = "files/gkbrkn/perk_enraged_ui.png",
    perk_icon = "files/gkbrkn/perk_enraged_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
	    local eid = EntityLoad( "data/entities/projectiles/deck/wand_ghost_player.xml", x, y );
	end,
})