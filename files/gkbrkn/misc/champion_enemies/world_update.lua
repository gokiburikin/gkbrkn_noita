--[[
champions should have different types
melee - more melee damage
projectile - more projectiles and attack speed
dash - super dash attacls
chaotic blood - replace their blood with a random material
fasty - much greater mobility
teleport - constantly affected by teleport
burning - immune to fire, spreads fires
freezing - immune to ice, freezes stuff
shooter - add a random ranged attack
invisible - invisible
loot - drops gold when hit
]]

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
    }
    CHAMPION_TYPE_CHOICES = {
        CHAMPION_TYPE.Melee,
        CHAMPION_TYPE.Projectile,
            --CHAMPION_TYPE.Dash,
        CHAMPION_TYPE.Fast,
        CHAMPION_TYPE.Teleport,
            --CHAMPION_TYPE.Burning,
            --CHAMPION_TYPE.Freeze,
        --CHAMPION_TYPE.Shoot,
            --CHAMPION_TYPE.Invisible,
            --CHAMPION_TYPE.Loot,
        CHAMPION_TYPE.Regeneration,
        CHAMPION_TYPE.WormBait,
        CHAMPION_TYPE.RevengeExplosion,
        CHAMPION_TYPE.Shield,
    };
    CHAMPION_TYPE_DATA = {
        [CHAMPION_TYPE.Melee] = {
            particle_material = "spark_red",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/melee.xml",
            game_effects = {},
        },
        [CHAMPION_TYPE.Projectile] = {
            particle_material = "spark_purple",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/projectile.xml",
            game_effects = {},
        },
        [CHAMPION_TYPE.Dash] = {
            particle_material = "spark_green",
            sprite_particle_sprite_file = nil,
            game_effects = {},
        },
        [CHAMPION_TYPE.Fast] = {
            particle_material = "spark_green",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/movement_faster.xml",
            game_effects = {},
        },
        [CHAMPION_TYPE.Teleport] = {
            particle_material = "spark_white",
            sprite_particle_sprite_file = nil,
            game_effects = {"TELEPORTATION","TELEPORTITIS"},
        },
        [CHAMPION_TYPE.Burning] = {
            particle_material = "flame",
            sprite_particle_sprite_file = "data/particles/fire.xml",
            game_effects = {"ON_FIRE"},
        },
        [CHAMPION_TYPE.Freeze] = {
            particle_material = "spark_white",
            sprite_particle_sprite_file = "data/particles/snowflake_$[1-2].xml",
            game_effects = {},
        },
        [CHAMPION_TYPE.Shoot] = {
            particle_material = "spark_purple",
            sprite_particle_sprite_file = nil,
            game_effects = {},
        },
        [CHAMPION_TYPE.Invisible] = {
            particle_material = nil,
            sprite_particle_sprite_file = nil,
            game_effects = {"INVISIBILITY","STAINS_DROP_FASTER"},
        },
        [CHAMPION_TYPE.Loot] = {
            particle_material = "spark_white",
            sprite_particle_sprite_file = nil,
            game_effects = {},
        },
        [CHAMPION_TYPE.Regeneration] = {
            particle_material = "spark_green",
            sprite_particle_sprite_file = nil,
            game_effects = {"REGENERATION"},
        },
        [CHAMPION_TYPE.WormBait] = {
            particle_material = "blood",
            sprite_particle_sprite_file = nil,
            game_effects = {"WORM_ATTRACTOR"},
        },
        [CHAMPION_TYPE.RevengeExplosion] = {
            particle_material = "spark_yellow",
            sprite_particle_sprite_file = "files/gkbrkn/misc/champion_enemies/sprites/revenge_explosion.xml",
            game_effects = {},
        },
        [CHAMPION_TYPE.Shield] = {
            particle_material = nil,
            sprite_particle_sprite_file = nil,
            game_effects = {},
        },
    }
end

for _,entity in pairs( nearby_entities ) do
    if EntityHasTag( entity, "enemy" ) and EntityHasTag( entity, "gkbrkn_champions" ) == false then
        EntityAddTag( entity, "gkbrkn_champions" );
        if Random() <= 0.12 then
            local champion_type = CHAMPION_TYPE_CHOICES[ math.ceil( math.random() * #CHAMPION_TYPE_CHOICES ) ];
            local champion_data = CHAMPION_TYPE_DATA[champion_type];
            --GamePrint( "champion chosen "..champion_type.." for "..EntityGetName(entity));
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    ComponentSetValue( ai, "aggressiveness_min", "100" );
                    ComponentSetValue( ai, "aggressiveness_max", "100" );
                    ComponentSetValue( ai, "escape_if_damaged_probability", "0" );
                    ComponentSetValue( ai, "hide_from_prey", "0" );
                    ComponentSetValue( ai, "needs_food", "0" );
                    if champion_type == CHAMPION_TYPE.Melee then
                        ComponentSetValue( ai, "attack_melee_damage_min", tostring( tonumber( ComponentGetValue( ai, "attack_melee_damage_min" ) ) * 1.5 ) );
                        ComponentSetValue( ai, "attack_melee_damage_max", tostring( tonumber( ComponentGetValue( ai, "attack_melee_damage_max" ) ) * 2 ) );
                        ComponentSetValue( ai, "attack_melee_frames_between", tostring( math.ceil( tonumber( ComponentGetValue( ai, "attack_melee_frames_between" ) ) / 2 ) ) );
                    elseif champion_type == CHAMPION_TYPE.Projectile then
                        ComponentSetValue( ai, "attack_ranged_predict", "1" );
                        ComponentSetValue( ai, "attack_ranged_frames_between", tostring( math.ceil( tonumber( ComponentGetValue( ai, "attack_ranged_frames_between" ) ) / 2 ) ) );
                        ComponentSetValue( ai, "attack_ranged_entity_count_min", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_min" ) + 1 ) ) );
                        ComponentSetValue( ai, "attack_ranged_entity_count_max", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_max" ) + 2 ) ) );
                    elseif champion_type == CHAMPION_TYPE.Dash then
                        ComponentSetValue( ai, "attack_dash_damage", tostring( tonumber( ComponentGetValue( ai, "attack_dash_damage" ) ) * 1.5 ) );
                        ComponentSetValue( ai, "attack_dash_frames_between", tostring( tonumber( ComponentGetValue( ai, "attack_dash_frames_between" ) ) * 3 ) );
                    end
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
                        ComponentSetValue( damage_model, "critical_damage_resistance", tostring( math.max( critical_damage_resistance, 0.5 ) ) );
                    end
                end
                for _,game_effect in pairs( champion_data.game_effects or {} ) do
                    local effect = GetGameEffectLoadTo( entity, game_effect, true );
                    if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end
                end
                if champion_type == CHAMPION_TYPE.RevengeExplosion then
                    EntityAddComponent( entity, "LuaComponent", { 
                        script_damage_received = "files/gkbrkn/misc/champion_enemies/revenge_explosion.lua",
                        execute_every_n_frame = "-1",
                    } );
                elseif champion_type == CHAMPION_TYPE.Shield then
                    local shield = EntityLoad( "files/gkbrkn/misc/champion_enemies/energy_shield.xml" );
                    if shield ~= nil then EntityAddChild( entity, shield ); end
                elseif champion_type == CHAMPION_TYPE.Fast then
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
            end
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
