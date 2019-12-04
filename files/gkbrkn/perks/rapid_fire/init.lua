dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_RAPID_FIRE",
	ui_name = "Rapid Fire",
	ui_description = "Cast spells much more rapidly, but less accurately.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/rapid_fire/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/rapid_fire/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_rapid_fire", 0.0, function( value ) return value + 1; end );
	end,
});