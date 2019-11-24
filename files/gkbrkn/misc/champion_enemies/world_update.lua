local debug_disabled = false;

if _GKBRKN_CHAMPION_ENEMIES_INIT == nil then
    _GKBRKN_CHAMPION_ENEMIES_INIT = true;
    CHAMPION_TYPE = {
        Melee = 1,
        Projectile = 2,
        Dash = 3,
        ChaoticBlood = 4,
        Fast = 5,
        Teleport = 6,
        Burning = 7,
        Freeze = 8,
        Shoot = 9,
        Invisible = 10,
        Loot = 11,
        Regeneration = 12,
        WormBait = 13,
        RevengeExplosion = 14,
        Shield = 15,
        Electricity = 16,
        ProjectileRepulsionField = 17,
        Healthy = 18,
    }
    CHAMPION_TYPE_DATA = {
        [CHAMPION_TYPE.Melee] = {
            particle_material = "spark_red",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/melee.xml",
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity )
                local has_melee_attack = false;
                local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
                if #animal_ais > 0 then
                    for _,ai in pairs( animal_ais ) do
                        if ComponentGetValue( ai, "attack_melee_enabled" ) == "1" then
                            has_melee_attack = true;
                            break;
                        end
                    end
                end
                return has_melee_attack;
            end,
            apply = function( entity )
                local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
                if #animal_ai > 0 then
                    for _,ai in pairs( animal_ai ) do
                        ComponentSetValue( ai, "attack_melee_damage_min", tostring( tonumber( ComponentGetValue( ai, "attack_melee_damage_min" ) ) * 1.5 ) );
                        ComponentSetValue( ai, "attack_melee_damage_max", tostring( tonumber( ComponentGetValue( ai, "attack_melee_damage_max" ) ) * 2 ) );
                        ComponentSetValue( ai, "attack_melee_frames_between", tostring( math.ceil( tonumber( ComponentGetValue( ai, "attack_melee_frames_between" ) ) / 2 ) ) );
                    end
                end
            end
        },
        [CHAMPION_TYPE.Projectile] = {
            particle_material = "spark_purple",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/projectile.xml",
            game_effects = {},
            disabled = debug_disabled,
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
                        ComponentSetValue( ai, "attack_ranged_predict", "1" );
                        ComponentSetValue( ai, "attack_ranged_frames_between", tostring( math.ceil( tonumber( ComponentGetValue( ai, "attack_ranged_frames_between" ) ) / 2 ) ) );
                        ComponentSetValue( ai, "attack_ranged_entity_count_min", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_min" ) + 1 ) ) );
                        ComponentSetValue( ai, "attack_ranged_entity_count_max", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_max" ) + 2 ) ) );
                    end
                end
            end
        },
        [CHAMPION_TYPE.Dash] = {
            particle_material = "spark_green",
            sprite_particle_sprite_file = nil,
            game_effects = {},
            disabled = debug_disabled,
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
                return has_dash_attack;
            end,
            apply = function( entity )
                local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
                if #animal_ai > 0 then
                    for _,ai in pairs( animal_ai ) do
                        ComponentSetValue( ai, "attack_dash_damage", tostring( tonumber( ComponentGetValue( ai, "attack_dash_damage" ) ) * 1.5 ) );
                        ComponentSetValue( ai, "attack_dash_frames_between", tostring( tonumber( ComponentGetValue( ai, "attack_dash_frames_between" ) ) * 3 ) );
                    end
                end
            end
        },
        [CHAMPION_TYPE.Fast] = {
            particle_material = "spark_green",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/movement_faster.xml",
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity )
                local character_platforming = EntityGetFirstComponent( entity, "CharacterPlatformingComponent" );
                if character_platforming ~= nil then
                    ComponentSetMetaCustom( character_platforming, "run_velocity", tostring( tonumber( ComponentGetMetaCustom( character_platforming, "run_velocity" ) ) * 3 ) );
                    ComponentSetValue( character_platforming, "jump_velocity_x", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_x" ) ) * 2 ) );
                    ComponentSetValue( character_platforming, "jump_velocity_y", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_y" ) ) * 2 ) );
                    ComponentSetValue( character_platforming, "fly_speed_max_up", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_max_up" ) ) * 2 ) );
                    ComponentSetValue( character_platforming, "fly_speed_max_down", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_max_down" ) ) * 2 ) );
                    ComponentSetValue( character_platforming, "fly_speed_change_spd", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_change_spd" ) ) * 2 ) );
                end
            end
        },
        [CHAMPION_TYPE.Teleport] = {
            particle_material = "spark_white",
            sprite_particle_sprite_file = nil,
            game_effects = {"TELEPORTATION","TELEPORTITIS"},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
        },
        [CHAMPION_TYPE.Burning] = {
            particle_material = nil,
            sprite_particle_sprite_file = nil,
            game_effects = {"PROTECTION_FIRE"},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity )
                local x,y = EntityGetTransform( entity );
                local burn = EntityLoad( "files/gkbrkn/misc/champion_enemies/entities/fire.xml", x, y );
                if burn ~= nil then
                    EntityAddChild( entity, burn );
                end
            end
        },
        [CHAMPION_TYPE.Freeze] = {
            particle_material = "blood_cold_vapour",
            sprite_particle_sprite_file = "data/particles/snowflake_$[1-2].xml",
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity )
                local x,y = EntityGetTransform( entity );
                local freeze_field = EntityLoad( "data/entities/misc/perks/freeze_field.xml", x, y );
                if freeze_field ~= nil then
                    EntityAddChild( entity, freeze_field );
                end
            end
        },
        [CHAMPION_TYPE.Shoot] = {
            particle_material = "spark_purple",
            sprite_particle_sprite_file = nil,
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return false end,
        },
        [CHAMPION_TYPE.Invisible] = {
            particle_material = nil,
            sprite_particle_sprite_file = nil,
            game_effects = {"INVISIBILITY","STAINS_DROP_FASTER"},
            disabled = debug_disabled,
            validator = function( entity ) return false end,
        },
        [CHAMPION_TYPE.Loot] = {
            particle_material = "spark_white",
            sprite_particle_sprite_file = nil,
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return false end,
        },
        [CHAMPION_TYPE.Regeneration] = {
            particle_material = "spark_green",
            sprite_particle_sprite_file = nil,
            game_effects = {"REGENERATION"},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
        },
        [CHAMPION_TYPE.WormBait] = {
            particle_material = "meat",
            sprite_particle_sprite_file = nil,
            game_effects = {"WORM_ATTRACTOR"},
            disabled = debug_disabled,
            validator = function( entity ) return false end,
        },
        [CHAMPION_TYPE.RevengeExplosion] = {
            particle_material = "spark_yellow",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/revenge_explosion.xml",
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity )
                EntityAddComponent( entity, "LuaComponent", { 
                    script_damage_received = "files/gkbrkn/misc/champion_enemies/revenge_explosion.lua",
                    execute_every_n_frame = "-1",
                } );
            end
        },
        [CHAMPION_TYPE.Shield] = {
            particle_material = nil,
            sprite_particle_sprite_file = nil,
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity )
                local shield = EntityLoad( "files/gkbrkn/misc/champion_enemies/entities/energy_shield.xml" );
                if shield ~= nil then EntityAddChild( entity, shield ); end
            end
        },
        [CHAMPION_TYPE.Electricity] = {
            particle_material = nil,
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/electricity.xml",
            game_effects = {"PROTECTION_ELECTRICITY"},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity ) 
                local electric = EntityAddComponent( entity, "ElectricChargeComponent", { 
                    _tags="enabled_in_world",
                    radius="128",
                    charge_time_frames="15",
                    electricity_emission_interval_frames="15",
                    fx_velocity_max="10",
                });
                local x,y = EntityGetTransform( entity );
                local electrocution = EntityLoad( "data/entities/particles/water_electrocution.xml", x, y );
                if electrocution ~= nil then
                    EntityAddChild( entity, electrocution );
                end
            end
        },
        [CHAMPION_TYPE.ProjectileRepulsionField] = {
            particle_material = nil,
            sprite_particle_sprite_file = nil,
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity )
                local shield = EntityLoad( "files/gkbrkn/misc/champion_enemies/entities/projectile_repulsion_field.xml" );
                if shield ~= nil then EntityAddChild( entity, shield ); end
            end
        },
        [CHAMPION_TYPE.Healthy] = {
            particle_material = "plasma_fading_pink",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/healthy.xml",
            game_effects = {},
            disabled = debug_disabled,
            validator = function( entity ) return true end,
            apply = function( entity )
                local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
                for index,damage_model in pairs( damage_models ) do
                    local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
                    local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
                    local new_max = max_hp * 2;
                    local regained = new_max - current_hp;
                    ComponentSetValue( damage_model, "max_hp", tostring( new_max ) );
                    ComponentSetValue( damage_model, "hp", tostring( current_hp + regained ) );
                end
            end
        },
    }
end

for _,entity in pairs( nearby_entities ) do
    if EntityHasTag( entity, "gkbrkn_champions" ) == false then
        EntityAddTag( entity, "gkbrkn_champions" );
        if HasFlagPersistent( MISC.ChampionEnemies.AlwaysChampionsEnabled ) or Random() <= 0.125 then
            local valid_champion_types = {};
            for champion_type,champion_type_data in pairs(CHAMPION_TYPE_DATA) do
            if champion_type_data.disabled ~= true and (champion_type_data.validator == nil or champion_type_data.validator( entity ) ~= false) then
                    table.insert( valid_champion_types, champion_type );
                end
            end

            local champion_types_to_apply = 1;
            while Random() <= 0.25 do
                champion_types_to_apply = champion_types_to_apply + 1;
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

            --[[ Per champion type ]]
            for i=1,champion_types_to_apply do
                local champion_type_index = math.ceil( math.random() * #valid_champion_types );
                if champion_type_index == 0 then
                    break;
                end
                local champion_type = valid_champion_types[ champion_type_index ];
                table.remove( valid_champion_types, champion_type_index );
                local champion_data = CHAMPION_TYPE_DATA[champion_type];

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
