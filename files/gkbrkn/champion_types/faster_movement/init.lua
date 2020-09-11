table.insert( champion_types, {
    particle_material = nil,
    sprite_particle_sprite_file = nil,
    badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/faster_movement/badge.xml",
	id = "faster_movement",
	name = "$champion_type_name_faster_movement",
	description = "$champion_type_desc_faster_movement",
	author = "$ui_author_name_goki_dev",

    game_effects = {},
    validator = function( entity ) return true end,
    apply = function( entity )
        local character_platforming = EntityGetFirstComponent( entity, "CharacterPlatformingComponent" );
        if character_platforming ~= nil then
            ComponentSetValue2( character_platforming, "run_velocity", ComponentGetValue2( character_platforming, "run_velocity" ) * 3 );
            ComponentSetValue2( character_platforming, "jump_velocity_x", ComponentGetValue2( character_platforming, "jump_velocity_x" ) * 2 );
            ComponentSetValue2( character_platforming, "jump_velocity_y", ComponentGetValue2( character_platforming, "jump_velocity_y" ) * 2 );
            ComponentSetValue2( character_platforming, "fly_speed_max_up", ComponentGetValue2( character_platforming, "fly_speed_max_up" ) * 2 );
            ComponentSetValue2( character_platforming, "fly_speed_max_down", ComponentGetValue2( character_platforming, "fly_speed_max_down" ) * 2 );
            ComponentSetValue2( character_platforming, "fly_speed_change_spd", ComponentGetValue2( character_platforming, "fly_speed_change_spd" ) * 2 );
            ComponentSetValue2( character_platforming, "fly_smooth_y", false );
            ComponentSetValue2( character_platforming, "accel_x_air", 1.0 );
        end
    end
} );