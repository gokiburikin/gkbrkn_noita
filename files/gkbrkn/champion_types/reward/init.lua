table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/reward/badge.xml",
	id = "reward",
	name = "$champion_type_name_reward",
	description = "$champion_type_desc_reward",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return false; end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", {
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/reward/damage_received.lua"
        });
    end
} );