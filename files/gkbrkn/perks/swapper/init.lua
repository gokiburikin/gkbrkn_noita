table.insert( perk_list, {
	id = "GKBRKN_SWAPPER",
	ui_name = "Swapper",
	ui_description = "Swap places with your attacker.",
	ui_icon = "files/gkbrkn/perks/swapper/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/swapper/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_damage_received="files/gkbrkn/perks/swapper/damage_received.lua"
        });
	end,
});