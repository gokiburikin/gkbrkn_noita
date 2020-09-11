table.insert( champion_types, {
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/template/badge.xml",
	id = "template",
	name = "$champion_type_name_template",
	description = "$champion_type_desc_template",
	author = "$ui_author_name_goki_dev",

    particle_material = nil,
    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true; end,
    apply = function( entity )
    end
} );