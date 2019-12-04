dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
table.insert( perk_list, {
	id = "GKBRKN_INVINCIBILITY_FRAMES",
	ui_name = "Invincibility Frames",
	ui_description = "You become immune to enemy damage for a short time after taking enemy damage.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/invincibility_frames/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/invincibility_frames/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_invincibility_frames", 0.0, function( value ) return value + 20.0 end );
	end,
});