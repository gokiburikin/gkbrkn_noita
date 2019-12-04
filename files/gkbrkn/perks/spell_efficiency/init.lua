table.insert( perk_list, {
	id = "GKBRKN_SPELL_EFFICIENCY",
	ui_name = "Spell Efficiency",
	ui_description = "Some spell casts are free.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/spell_efficiency/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/spell_efficiency/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "ShotEffectComponent", { extra_modifier = "gkbrkn_spell_efficiency", } );
	end,
});