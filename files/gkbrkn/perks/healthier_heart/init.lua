dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_HEALTHIER_HEART",
	ui_name = "Healthier Heart",
	ui_description = "You heal for the amount gained when gaining maximum health.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/healthier_heart/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/healthier_heart/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_max_health_recovery", 0.0, function( value ) return value + 1.0; end );
	end,
});