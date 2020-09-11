table.insert( champion_types, 
{
    particle_material = "spark_green",
    sprite_particle_sprite_file = "data/particles/heal.xml",
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/regenerating/badge.xml",
	id = "regenerating",
	name = "$champion_type_name_regenerating",
	description = "$champion_type_desc_regenerating",
	author = "$ui_author_name_goki_dev",

    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", { 
            script_source_file = "mods/gkbrkn_noita/files/gkbrkn/champion_types/regenerating/update.lua",
            execute_every_n_frame = "60",
        } );
        EntityAddComponent( entity, "LuaComponent", { 
            script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/champion_types/regenerating/damage_received.lua",
        } );
    end
} )