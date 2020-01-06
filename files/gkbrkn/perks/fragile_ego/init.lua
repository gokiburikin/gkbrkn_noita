dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/helper.lua");
table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_FRAGILE_EGO", "fragile_ego", true, function( entity_perk_item, entity_who_picked, item_name )
        TryAdjustDamageMultipliers( entity_who_picked, {
            ice = 0.25,
            electricity = 0.25,
            radioactive = 0.25,
            slice = 0.25,
            projectile = 0.25,
            healing = 0.25,
            physics_hit = 0.25,
            explosion = 0.25,
            poison = 0.25,
            melee = 0.25,
            drill = 0.25,
            fire = 0.25,
        });
        EntityAddComponent( entity_who_picked, "LuaComponent",{
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/perks/fragile_ego/damage_received.lua",
            execute_every_n_frame="-1"
        })
	end
));