table.insert( champion_types, {
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/damage_buff/badge.xml",
	id = "damage_buff",
	name = "$champion_type_name_damage_buff",
	description = "$champion_type_desc_damage_buff",
	author = "$ui_author_name_goki_dev",

    particle_material = nil,
    sprite_particle_sprite_file = nil,
    game_effects = {},
    validator = function( entity ) return true; end,
    apply = function( entity )
        local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
        if #animal_ai > 0 then
            for _,ai in pairs( animal_ai ) do
                ComponentSetValue( ai, "attack_melee_damage_min", tostring( tonumber( ComponentGetValue( ai, "attack_melee_damage_min" ) ) * 2 ) );
                ComponentSetValue( ai, "attack_melee_damage_max", tostring( tonumber( ComponentGetValue( ai, "attack_melee_damage_max" ) ) * 2 ) );
                --ComponentSetValue( ai, "attack_melee_frames_between", tostring( math.ceil( tonumber( ComponentGetValue( ai, "attack_melee_frames_between" ) ) / 2 ) ) );
                ComponentSetValue( ai, "attack_dash_damage", tostring( tonumber( ComponentGetValue( ai, "attack_dash_damage" ) ) * 2 ) );
                --ComponentSetValue( ai, "attack_dash_frames_between", tostring( tonumber( ComponentGetValue( ai, "attack_dash_frames_between" ) ) / 2 ) );
            end
        end
        EntityAddComponent( entity, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/damage_buff/shot.lua"
        });
    end
} )