dofile("files/gkbrkn/helper.lua");
dofile("files/gkbrkn/config.lua");
table.insert( perk_list, {
	id = "GKBRKN_RESILIENCE",
	ui_name = "Resilience",
	ui_description = "You are more resistant to damage from status ailments.",
	ui_icon = "files/gkbrkn/perk_resilience_ui.png",
    perk_icon = "files/gkbrkn/perk_resilience_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        TryAdjustDamageMultipliers( entity_who_picked, PERKS.Resilience.Resistances );
	end,
});
