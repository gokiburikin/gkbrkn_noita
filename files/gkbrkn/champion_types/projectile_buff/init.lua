table.insert( champion_types, {
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_buff/badge.xml",
	id = "projectile_buff",
	name = "$champion_type_name_projectile_buff",
	description = "$champion_type_desc_projectile_buff",
	author = "$ui_author_name_goki_dev",

    particle_material = nil,
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
        local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ai > 0 then
            for _,ai in pairs( animal_ai ) do
                ComponentSetValue( ai, "attack_ranged_min_distance", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_min_distance" ) * 1.33 ) ) );
                ComponentSetValue( ai, "attack_ranged_max_distance", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_max_distance" ) * 1.33 ) ) );
                ComponentSetValue( ai, "attack_ranged_entity_count_min", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_min" ) + 1 ) ) );
                ComponentSetValue( ai, "attack_ranged_entity_count_max", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_max" ) + 2 ) ) );
            end
        end
    end
} );