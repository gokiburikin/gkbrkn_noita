table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/infested/badge.xml",
	id = "infested",
	name = "$champion_type_name_infested",
	description = "$champion_type_desc_infested",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", {
            execute_every_n_frame="-1",
            script_death="mods/gkbrkn_noita/files/gkbrkn/champion_types/infested/death.lua",
        });
    end
} );