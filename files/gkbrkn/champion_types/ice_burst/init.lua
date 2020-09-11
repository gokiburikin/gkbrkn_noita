table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/ice_burst/badge.xml",
	id = "ice_burst",
	name = "$champion_type_name_ice_burst",
	description = "$champion_type_desc_ice_burst",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", {
            execute_every_n_frame="-1",
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/ice_burst/damage_received.lua",
        });
        TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
    end
} )