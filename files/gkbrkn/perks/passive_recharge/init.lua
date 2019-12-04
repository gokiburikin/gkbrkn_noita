dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_PASSIVE_RECHARGE_PERK",
	ui_name = "Passive Recharge",
	ui_description = "Your wands recharge even when holstered.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/passive_recharge/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/passive_recharge/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_passive_recharge", 0.0, function( value ) return value + 1; end );
	end,
});