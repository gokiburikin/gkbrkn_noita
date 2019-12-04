table.insert( perk_list, {
	id = "GKBRKN_DEMOLITIONIST",
	ui_name = "Demolitionist",
	ui_description = "Your spells cause larger, more powerful explosions.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/demolitionist/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/demolitionist/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/perks/wip/shot.lua"
        });
	end,
});