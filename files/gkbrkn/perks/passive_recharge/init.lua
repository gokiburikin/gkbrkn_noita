table.insert( perk_list, {
	id = "GKBRKN_PASSIVE_RECHARGE_PERK",
	ui_name = "Passive Recharge",
	ui_description = "Your wands recharge even when holstered.",
	ui_icon = "files/gkbrkn/perks/passive_recharge/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/passive_recharge/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", { 
            execute_every_n_frame="1",
            script_source_file="files/gkbrkn/perks/passive_recharge/player_update.lua"
        } );
	end,
});