table.insert( champion_types, {
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/eldritch/badge.xml",
	id = "eldritch",
	name = "$champion_type_name_eldritch",
	description = "$champion_type_desc_eldritch",
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
        return has_projectile_attack == false;
    end,
    apply = function( entity )
        local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ai > 0 then
            for _,ai in pairs( animal_ai ) do
                ComponentSetValues( ai, {
                    attack_ranged_action_frame="4",
                    attack_ranged_min_distance="0",
                    attack_ranged_max_distance="120",
                    attack_ranged_entity_file="data/entities/projectiles/tongue.xml",
                    attack_ranged_offset_x="0",
                    attack_ranged_offset_y="0",
                    attack_ranged_enabled="1",
                });
            end
        end
    end
} )