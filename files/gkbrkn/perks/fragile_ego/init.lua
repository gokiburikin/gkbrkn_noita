dofile_once("files/gkbrkn/helper.lua");
table.insert( perk_list, {
	id = "GKBRKN_FRAGILE_EGO",
	ui_name = "Fragile Ego",
	ui_description = "Receive 50% less damage, but damage is permanent",
	ui_icon = "files/gkbrkn/perks/fragile_ego/icon_ui.png",
    perk_icon = "files/gkbrkn/perks/fragile_ego/icon_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        TryAdjustDamageMultipliers( entity_who_picked, {
            ice = 0.50,
            electricity = 0.50,
            radioactive = 0.50,
            slice = 0.50,
            projectile = 0.50,
            healing = 0.50,
            physics_hit = 0.50,
            explosion = 0.50,
            poison = 0.50,
            melee = 0.50,
            drill = 0.50,
            fire = 0.50,
        });
        EntityAddComponent( entity_who_picked, "LuaComponent",{
            script_damage_received="files/gkbrkn/perks/fragile_ego/damage_received.lua",
            execute_every_n_frame="-1"
        })
	end,
});