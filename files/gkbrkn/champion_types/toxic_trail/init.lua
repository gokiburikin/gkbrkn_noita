table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/toxic_trail/badge.xml",
	id = "toxic_trail",
	name = "$champion_type_name_toxic_trail",
	description = "$champion_type_desc_toxic_trail",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity )
        local has_projectile_attack = false;
        local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ais > 0 then
            for _,ai in pairs( animal_ais ) do
                if ComponentGetValue( ai, "attack_ranged_enabled" ) == "1" or ComponentGetValue( ai, "attack_landing_ranged_enabled" ) == "1" then
                    has_projectile_attack = true;
                    break;
                end
            end
        end
        return has_projectile_attack;
    end,
    apply = function( entity )
        EntityAddComponent( entity, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/toxic_trail/shot.lua",
        });
    end
} );