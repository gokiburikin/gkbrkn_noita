dofile_once("files/gkbrkn/helper.lua");
dofile_once( "files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_EXTRA_PROJECTILE",
	ui_name = "Extra Projectile",
	ui_description = "Spells you cast gain an additional projectile.",
	ui_icon = "files/gkbrkn/perks/extra_projectile/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/extra_projectile/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_extra_projectiles", 0.0, function( value ) return value + 1; end );
	end,
});