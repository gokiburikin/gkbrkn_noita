table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/counter/badge.xml",
	id = "counter",
	name = "$champion_type_name_counter",
	description = "$champion_type_desc_counter",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", {
            execute_every_n_frame="-1",
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/counter/damage_received.lua",
        });
    end
} )