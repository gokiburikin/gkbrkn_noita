if _GKBRKN_CHAMPION_ENEMIES_INIT == nil then
    _GKBRKN_CHAMPION_ENEMIES_INIT = true;
    dofile( "files/gkbrkn/config.lua");
    champion_type_data = {};
    for index,champion_type in pairs( CHAMPION_TYPES ) do
        champion_type_data[champion_type] = CONTENT[champion_type].options;
    end
end

for _,entity in pairs( nearby_entities ) do
    if EntityHasTag( entity, "gkbrkn_champions" ) == false then
        EntityAddTag( entity, "gkbrkn_champions" );
        if HasFlagPersistent( MISC.ChampionEnemies.AlwaysChampionsEnabled ) or Random() <= MISC.ChampionEnemies.ChampionChance then
            local valid_champion_types = {};
            for champion_type,champion_type_data in pairs(champion_type_data) do
                if CONTENT[champion_type].enabled() and (champion_type_data.validator == nil or champion_type_data.validator( entity ) ~= false) then
                    table.insert( valid_champion_types, champion_type );
                end
            end

            local champion_types_to_apply = 1;
            if HasFlagPersistent( MISC.ChampionEnemies.SuperChampionsEnabled ) then
                while Random() <= MISC.ChampionEnemies.ExtraTypeChance and champion_types_to_apply < #valid_champion_types do
                    champion_types_to_apply = champion_types_to_apply + 1;
                end
            end
            
            --[[ Things to apply to all champions ]]
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    ComponentSetValue( ai, "aggressiveness_min", "100" );
                    ComponentSetValue( ai, "aggressiveness_max", "100" );
                    ComponentSetValue( ai, "escape_if_damaged_probability", "0" );
                    ComponentSetValue( ai, "hide_from_prey", "0" );
                    ComponentSetValue( ai, "needs_food", "0" );
                    ComponentSetValue( ai, "sense_creatures", "1" );
                    ComponentSetValue( ai, "attack_only_if_attacked", "0" );
                    ComponentSetValue( ai, "creature_detection_check_every_x_frames", "60" );
                    ComponentSetValue( ai, "max_distance_to_cam_to_start_hunting", tostring( tonumber( ComponentGetValue( ai, "max_distance_to_cam_to_start_hunting") ) * 2 ) );
                    ComponentSetValue( ai, "creature_detection_range_x", tostring( tonumber( ComponentGetValue( ai, "creature_detection_range_x") ) * 2 ) );
                    ComponentSetValue( ai, "creature_detection_range_y", tostring( tonumber( ComponentGetValue( ai, "creature_detection_range_y") ) * 2 ) );
                end
            end
            local character_platforming = EntityGetFirstComponent( entity, "CharacterPlatformingComponent" );
            if character_platforming ~= nil then
                ComponentSetMetaCustom( character_platforming, "run_velocity", tostring( tonumber( ComponentGetMetaCustom( character_platforming, "run_velocity" ) ) * 2 ) );
                ComponentSetValue( character_platforming, "jump_velocity_x", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_x" ) ) * 2 ) );
                ComponentSetValue( character_platforming, "jump_velocity_y", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_y" ) ) * 2 ) );
                ComponentSetValue( character_platforming, "fly_speed_max_up", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_max_up" ) ) * 2 ) );
                ComponentSetValue( character_platforming, "fly_speed_max_down", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_max_down" ) ) * 2 ) );
                ComponentSetValue( character_platforming, "fly_speed_change_spd", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_change_spd" ) ) * 2 ) );
            end
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
            if damage_models ~= nil then
                local resistances = {
                    ice = 0.67,
                    electricity = 0.67,
                    radioactive = 0.67,
                    slice = 0.67,
                    projectile = 0.67,
                    healing = 0.67,
                    physics_hit = 0.67,
                    explosion = 0.67,
                    poison = 0.67,
                    melee = 0.67,
                    drill = 0.67,
                    fire = 0.67,
                };
                for index,damage_model in pairs( damage_models ) do
                    for damage_type,multiplier in pairs( resistances ) do
                        local resistance = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                        resistance = resistance * multiplier;
                        ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( resistance ) );
                    end

                    local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
                    local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
                    local new_max = max_hp * 2;
                    local regained = new_max - current_hp;
                    ComponentSetValue( damage_model, "max_hp", tostring( new_max ) );
                    ComponentSetValue( damage_model, "hp", tostring( current_hp + regained ) );

                    local critical_damage_resistance = tonumber( ComponentGetValue( damage_model, "critical_damage_resistance" ) );
                    ComponentSetValue( damage_model, "critical_damage_resistance", tostring( math.max( critical_damage_resistance, 0.67 ) ) );
                end
            end
            local badges = EntityLoad( "files/gkbrkn/misc/champion_enemies/badges.xml");
            EntityAddChild( entity, badges );

            --[[ Per champion type ]]
            for i=1,champion_types_to_apply do
                local champion_type_index = math.ceil( math.random() * #valid_champion_types );
                if champion_type_index == 0 then
                    break;
                end
                local champion_type = valid_champion_types[ champion_type_index ];
                table.remove( valid_champion_types, champion_type_index );
                local champion_data = champion_type_data[champion_type];

                if champion_data.badge ~= nil then
                    local badge = EntityCreateNew();
                    
                    local sprite = EntityAddComponent( badge, "SpriteComponent",{
                        image_file=champion_data.badge
                    });
                    ComponentSetValue( sprite, "has_special_scale", "1");
                    ComponentSetValue( sprite, "z_index", "128");
                    EntityAddComponent( badge, "InheritTransformComponent",{
                        only_position="1"
                    });
                    EntityAddChild( badges, badge );
                end

                --[[ Game Effects ]]
                for _,game_effect in pairs( champion_data.game_effects or {} ) do
                    local effect = GetGameEffectLoadTo( entity, game_effect, true );
                    if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end
                end

                --[[ General Application ]]
                if champion_data.apply ~= nil then
                    champion_data.apply( entity );
                end

                --[[ Particle Emitter ]]
                local particle_material = champion_data.particle_material;
                if particle_material ~= nil then
                    local emitter_entity = EntityLoad( "files/gkbrkn/misc/champion_enemies/particles.xml" );
                    local emitter = EntityGetFirstComponent( emitter_entity, "ParticleEmitterComponent" );
                    if emitter ~= nil then
                        ComponentSetValue( emitter, "emitted_material_name", particle_material );
                        EntityAddChild( entity, emitter_entity );
                    end
                    ComponentSetValueVector2( emitter, "gravity", 0, -200 );
                end

                --[[ Sprite Particle Emitter ]]
                local sprite_particle_sprite_file = champion_data.sprite_particle_sprite_file;
                if sprite_particle_sprite_file ~= nil then
                    local emitter_entity = EntityLoad( "files/gkbrkn/misc/champion_enemies/sprite_particles.xml" );
                    local emitter = EntityGetFirstComponent( emitter_entity, "SpriteParticleEmitterComponent" );
                    if emitter ~= nil then
                        ComponentSetValue( emitter, "sprite_file", sprite_particle_sprite_file );
                        EntityAddChild( entity, emitter_entity );
                    end
                end

                --[[ Rewards Drop ]]
                EntityAddComponent( entity, "LuaComponent", {
                    script_damage_received="files/gkbrkn/misc/champion_enemies/champion_damage_received.lua"
                });
            end
        end
    end
end
