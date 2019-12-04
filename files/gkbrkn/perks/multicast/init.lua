dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_MULTICAST",
	ui_name = "Multicast",
	ui_description = "You cast 2 additional spells per cast",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/multicast/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/multicast/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_draw_actions_bonus", 0, function(value) return tonumber( value ) + 2 end );
	end,
});