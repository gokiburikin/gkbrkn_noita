table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/intangibility_frames/badge.xml",
	id = "intangibility_frames",
	name = "$champion_type_name_intangibility_frames",
	description = "$champion_type_desc_intangibility_frames",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", {
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/intangibility_frames/damage_received.lua",
        });
    end
} );