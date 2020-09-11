table.insert( champion_types, {
    particle_material = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/leaping/badge.xml",
	id = "leaping",
	name = "$champion_type_name_leaping",
	description = "$champion_type_desc_leaping",
	author = "$ui_author_name_goki_dev",

    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity )
        local has_dash_attack = false;
        local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ais > 0 then
            for _,ai in pairs( animal_ais ) do
                if ComponentGetValue( ai, "attack_dash_enabled" ) == "1" then
                    has_dash_attack = true;
                    break;
                end
            end
        end
        return not has_dash_attack;
    end,
    apply = function( entity )
        local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ais > 0 then
            for _,ai in pairs( animal_ais ) do
                ComponentSetValues( ai, {
                    attack_dash_enabled="1",
                });
                ComponentAdjustValues( ai, {
                    attack_dash_distance=function(value) return math.max( tonumber( value ), 150 ) end,
                });
            end
        end
    end
} );