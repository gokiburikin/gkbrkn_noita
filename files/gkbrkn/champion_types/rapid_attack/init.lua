table.insert( champion_types, {
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/rapid_attack/badge.xml",
	id = "rapid_attack",
	name = "$champion_type_name_rapid_attack",
	description = "$champion_type_desc_rapid_attack",
	author = "$ui_author_name_goki_dev",

    particle_material = nil,
    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true;
    end,
    apply = function( entity )
        local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ai > 0 then
            for _,ai in pairs( animal_ai ) do
                ComponentAdjustValues( ai, {
                    attack_melee_frames_between=function(value) return math.ceil( tonumber( value ) / 2 ) end,
                    attack_dash_frames_between=function(value) return math.ceil( tonumber( value ) / 2 ) end,
                    attack_ranged_frames_between=function(value) return math.ceil( tonumber( value ) / 2 ) end,
                });
            end
        end
    end
} )