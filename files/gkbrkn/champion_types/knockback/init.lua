table.insert( champion_types, {
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/knockback/badge.xml",
	id = "knockback",
	name = "$champion_type_name_knockback",
	description = "$champion_type_desc_knockback",
	author = "$ui_author_name_goki_dev",

    particle_material = nil,
    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true; end,
    apply = function( entity )
        local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ai > 0 then
            for _,ai in pairs( animal_ai ) do
                ComponentSetValue( ai, "attack_knockback_multiplier", tostring( tonumber( ComponentGetValue( ai, "attack_knockback_multiplier" ) ) * 2.5 ) );
            end
        end
        EntityAddComponent( entity, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/knockback/shot.lua"
        });
    end
} );