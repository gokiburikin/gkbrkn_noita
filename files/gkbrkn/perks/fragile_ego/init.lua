dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_FRAGILE_EGO", "fragile_ego", function( entity_perk_item, entity_who_picked, item_name )
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
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/perks/fragile_ego/damage_received.lua",
            execute_every_n_frame="-1"
        })
	end
));