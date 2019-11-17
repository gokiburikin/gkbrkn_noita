dofile("files/gkbrkn/helper.lua");
dofile( "files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_MANA_RECOVERY",
	ui_name = "Mana Recovery",
	ui_description = "Your wands charge more quickly.",
	ui_icon = "files/gkbrkn/perks/mana_recovery/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/mana_recovery/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_mana_recovery", 0.0, function( value ) return value + 0.625; end );
	end,
});