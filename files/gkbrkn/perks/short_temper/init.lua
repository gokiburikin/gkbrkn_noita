table.insert( perk_list,
{
	id = "GKBRKN_SHORT_TEMPER",
	ui_name = "Short Temper",
	ui_description = "You are quick to anger.",
	ui_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/short_temper/icon_ui.png",
    perk_icon = "mods/gkbrkn_noita/files/gkbrkn/perks/short_temper/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/perks/short_temper/damage_received.lua"
        });
    end,
})