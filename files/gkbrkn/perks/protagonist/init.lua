dofile_once("files/gkbrkn/helper.lua");
dofile_once( "files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_PROTAGONIST",
	ui_name = "Protagonist",
	ui_description = "Your damage increases the more damaged you are",
	ui_icon = "files/gkbrkn/perks/protagonist/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/protagonist/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_low_health_damage_bonus", 0.0, function( value ) return value + 1.00; end );
	end,
});