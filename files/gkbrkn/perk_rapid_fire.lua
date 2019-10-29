table.insert( perk_list, {
	id = "GKBRKN_RAPID_FIRE",
	ui_name = "Rapid Fire",
	ui_description = "Cast spells more rapidly, but less accurately.",
	ui_icon = "files/gkbrkn/perk_rapid_fire_ui.png",
    perk_icon = "files/gkbrkn/perk_rapid_fire_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "ShotEffectComponent", { extra_modifier = "gkbrkn_rapid_fire", } );
	end,
});