table.insert( champion_types, {
    particle_material = nil,
    sprite_particle_sprite_file = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/invisible/badge.xml",
	id = "invisible",
	name = "$champion_type_name_invisible",
	description = "$champion_type_desc_invisible",
	author = "$ui_author_name_goki_dev",

    game_effects = {"STAINS_DROP_FASTER"},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", {
            script_source_file="mods/gkbrkn_noita/files/gkbrkn/champion_types/invisible/update.lua",
            execute_on_added="1",
            execute_every_n_frame="10",
        });
    end
} )