for _,entity in pairs( nearby_entities ) do
    if EntityHasTag( entity, "gkbrkn_champions" ) == false then
        EntityAddTag( entity, "gkbrkn_champions" );
        if Random() <= 0.1 then
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    ComponentSetValue( ai, "aggressiveness_min", "100" );
                    ComponentSetValue( ai, "aggressiveness_max", "100" );
                    ComponentSetValue( ai, "escape_if_damaged_probability", "0" );
                    ComponentSetValue( ai, "hide_from_prey", "0" );
                    ComponentSetValue( ai, "needs_food", "0" );
                end
                local emitter = EntityAddComponent( entity, "ParticleEmitterComponent", {
                    emitted_material_name="spark_red",
                    x_pos_offset_min="-5",
                    x_pos_offset_max="5",
                    y_pos_offset_min="-5",
                    y_pos_offset_max="5",
                    x_vel_min="-0",
                    x_vel_max="0",
                    y_vel_min="-100",
                    y_vel_max="0",
                    count_min="1",
                    count_max="4",
                    fade_based_on_lifetime="1",
                    lifetime_min="0.4",
                    lifetime_max="1.2",
                    airflow_force="0",
                    create_real_particles="0",
                    emit_cosmetic_particles="1",
                    render_on_grid="1",
                    emission_interval_min_frames="1",
                    emission_interval_max_frames="1",
                    draw_as_long="1",
                    is_emitting="1"
                } );
                ComponentSetValueVector2( emitter, "gravity", 0, -200 );
                local light = EntityAddComponent( entity, "LightComponent", {
                    radius="128",
                    r="255",
                    g="40",
                    b="0"
                });
                EntityAddComponent( entity, "LuaComponent", {
                    script_damage_received="files/gkbrkn/misc/champion_damage_received.lua"
                });
                TryAdjustMaxHealth( entity, function( max_hp ) return max_hp * 3; end );
            end
        end
        --[[
        if EntityHasTag( entity, "gkbrkn_bad_aimer" ) == false then
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" );
            if animal_ais ~= nil then
                for _,ai in pairs( animal_ais ) do
                    ComponentSetValue( ai, "creature_detection_range_x", "100" );
                    ComponentSetValue( ai, "creature_detection_range_y", "100" );
                    --ComponentSetValue( ai, "attack_ranged_frames_between", "10" );
                    GamePrint("made enemy "..entity.." suck at detection");
                end
                EntityAddTag( entity, "gkbrkn_bad_aimer" );
            end
        end
    ]]
    end
end