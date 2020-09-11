table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/revenge_explosion/badge.xml",
	id = "revenge_explosion",
	name = "$champion_type_name_revenge_explosion",
	description = "$champion_type_desc_revenge_explosion",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", { 
            script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/champion_types/revenge_explosion/damage_received.lua",
            execute_every_n_frame = "-1",
        } );
    end
})