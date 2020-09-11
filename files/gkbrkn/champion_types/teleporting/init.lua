table.insert( champion_types, {
    particle_material = "spark_white",
    sprite_particle_sprite_file = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/teleporting/badge.xml",
	id = "teleporting",
	name = "$champion_type_name_teleporting",
	description = "$champion_type_desc_teleporting",
	author = "$ui_author_name_goki_dev",

    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", { 
            script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/champion_types/teleporting/damage_received.lua",
            execute_every_n_frame = "-1",
        } );
        EntityAddComponent( entity, "LuaComponent", { 
            script_source_file = "mods/gkbrkn_noita/files/gkbrkn/champion_types/teleporting/teleport_nearby.lua",
            execute_every_n_frame = "180",
        } );
    end,
} )