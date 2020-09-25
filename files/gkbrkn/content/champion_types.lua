local memoize_champion_types = {};
function find_champion_type( id )
    local champion_type = nil;
    if memoize_champion_types[id] then
        champion_type = memoize_champion_types[id];
    else
        for _,entry in pairs(champion_types) do
            if entry.id == id then
                champion_type = entry;
                memoize_champion_types[id] = entry;
            end
        end
    end
    return champion_type;
end

champion_types = {
    { id = "armored",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/armored/badge.xml",
        name = "$champion_type_name_armored",
        description = "$champion_type_desc_armored",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local resistances = {
                ice = 0.50,
                electricity = 0.50,
                radioactive = 0.50,
                slice = 0.50,
                projectile = 0.50,
                healing = 0.50,
                physics_hit = 0.50,
                explosion = 0.50,
                poison = 0.50,
                melee = 0.00,
                drill = 0.50,
                fire = 0.50,
            };
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for index,damage_model in pairs( damage_models ) do
                for damage_type,multiplier in pairs( resistances ) do
                    local resistance = ComponentObjectGetValue2( damage_model, "damage_multipliers", damage_type );
                    resistance = resistance * multiplier;
                    ComponentObjectSetValue2( damage_model, "damage_multipliers", damage_type, resistance );
                end
                local minimum_knockback_force = ComponentGetValue2( damage_model, "minimum_knockback_force" );
                ComponentSetValue2( damage_model, "minimum_knockback_force", 99999 );
            end
        end,
        deprecated = true
    },
    { id = "melee_immune",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/melee_immune/badge.xml",
        name = "$champion_type_name_melee_immune",
        description = "$champion_type_desc_melee_immune",
        author = "$ui_author_name_goki_dev",
        game_effects = {"PROTECTION_MELEE"},
        validator = function( entity ) return true end,
        apply = function( entity ) end
    },
    { id = "explosion_immune",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/explosion_immune/badge.xml",
        name = "$champion_type_name_explosion_immune",
        description = "$champion_type_desc_explosion_immune",
        author = "$ui_author_name_goki_dev",
        game_effects = {"PROTECTION_EXPLOSION"},
        validator = function( entity ) return true end,
        apply = function( entity ) end
    },
    { id = "burning",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/burning/badge.xml",
        name = "$champion_type_name_burning",
        description = "$champion_type_desc_burning",
        author = "$ui_author_name_goki_dev",
        game_effects = {"PROTECTION_FIRE"},
        validator = function( entity ) return true end,
        apply = function( entity )
            local x,y = EntityGetTransform( entity );
            local burn = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/burning/fire.xml", x, y );
            if burn ~= nil then
                EntityAddChild( entity, burn );
            end
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/burning/shot.lua",
            });
            TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
        end
    },
    { id = "counter",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/counter/badge.xml",
        name = "$champion_type_name_counter",
        description = "$champion_type_desc_counter",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="-1",
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/counter/damage_received.lua",
            });
        end
    },
    { id = "damage_buff",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/damage_buff/badge.xml",
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
                    ComponentSetValue2( ai, "attack_melee_damage_min", ComponentGetValue2( ai, "attack_melee_damage_min" ) * 2 );
                    ComponentSetValue2( ai, "attack_melee_damage_max", ComponentGetValue2( ai, "attack_melee_damage_max" ) * 2 );
                    --ComponentSetValue2( ai, "attack_melee_frames_between", eil( tonumber( ComponentGetValue2( ai, "attack_melee_frames_between" ) / 2 ) );
                    ComponentSetValue2( ai, "attack_dash_damage", ComponentGetValue2( ai, "attack_dash_damage" ) * 2 );
                    --ComponentSetValue2( ai, "attack_dash_frames_between", ComponentGetValue2( ai, "attack_dash_frames_between" ) / 2 );
                end
            end
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/damage_buff/shot.lua"
            });
        end
    },
    { id = "digging",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/digging/badge.xml",
        name = "$champion_type_name_digging",
        description = "$champion_type_desc_digging",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity )
            local has_projectile_attack = false;
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    if ComponentGetValue2( ai, "attack_ranged_enabled" ) == true or ComponentGetValue2( ai, "attack_landing_ranged_enabled" ) == true then
                        has_projectile_attack = true;
                        break;
                    end
                end
            end
            return has_projectile_attack;
        end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="-1",
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/digging/shot.lua",
            });
        end
    },
    { id = "eldritch",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/eldritch/badge.xml",
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
                    if ComponentGetValue2( ai, "attack_ranged_enabled" ) == true or ComponentGetValue2( ai, "attack_landing_ranged_enabled" ) == true then
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
                        attack_ranged_action_frame=4,
                        attack_ranged_min_distance=0,
                        attack_ranged_max_distance=120,
                        attack_ranged_entity_file="data/entities/projectiles/tongue.xml",
                        attack_ranged_offset_x=0,
                        attack_ranged_offset_y=0,
                        attack_ranged_enabled=true,
                    });
                end
            end
        end
    },
    { id = "electric",
        particle_material = nil,
        sprite_particle_sprite_file = "data/particles/spark_electric.xml",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/badge.xml",
        name = "$champion_type_name_electric",
        description = "$champion_type_desc_electric",
        author = "$ui_author_name_goki_dev",
        game_effects = {"PROTECTION_ELECTRICITY"},
        validator = function( entity ) return true end,
        apply = function( entity ) 
            local electric = EntityAddComponent( entity, "ElectricChargeComponent", { 
                _tags="enabled_in_world",
                charge_time_frames="15",
                electricity_emission_interval_frames="15",
                fx_velocity_max="10",
            });
            local x,y = EntityGetTransform( entity );
            local electrocution = EntityLoad( "data/entities/particles/water_electrocution.xml", x, y );
            if electrocution ~= nil then
                EntityAddChild( entity, electrocution );
            end
            local field = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/electricity_field.xml", x, y );
            if field ~= nil then
                EntityAddChild( entity, field );
            end
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="60",
                execute_on_added="1",
                script_source_file="mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/update.lua",
            });
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/electric/shot.lua",
            });
            TryAdjustDamageMultipliers( entity, { electricity = 0.00 } );
        end
    },
    { id = "energy_shield",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/energy_shield/badge.xml",
        name = "$champion_type_name_energy_shield",
        description = "$champion_type_desc_energy_shield",
        author = "$ui_author_name_goki_dev",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local x, y = EntityGetTransform( entity );
            local radius = nil;
            local width,height = EntityGetFirstHitboxSize( entity, 18, 18 );
            radius = math.max( height, width ) + 6;
            local shield = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/energy_shield/energy_shield.xml", x, y );
            local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
            for _,emitter in pairs( emitters ) do
                ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius );
            end
            local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
            ComponentSetValue2( energy_shield, "radius", radius );

            local hotspot = EntityAddComponent( entity, "HotspotComponent",{
                _tags="gkbrkn_center"
            } );
            ComponentSetValue2( hotspot, "offset", 0, -height * 0.3 );

            if shield ~= nil then EntityAddChild( entity, shield ); end
        end
    },
    { id = "faster_movement",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/faster_movement/badge.xml",
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
    },
    { id = "freezing",
        particle_material = nil,
        sprite_particle_sprite_file = "data/particles/snowflake_$[1-2].xml",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/badge.xml",
        name = "$champion_type_name_freezing",
        description = "$champion_type_desc_freezing",
        author = "$ui_author_name_goki_dev",
        game_effects = {"PROTECTION_FIRE"},
        validator = function( entity ) return true end,
        apply = function( entity )
            local x,y = EntityGetTransform( entity );
            local field = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/freeze_field.xml", x, y );
            if field ~= nil then
                EntityAddChild( entity, field );
            end
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="60",
                execute_on_added="1",
                script_source_file="mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/freeze.lua",
            });
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/freezing/shot.lua",
            });
            TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
        end
    },
    { id = "tremor",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/tremor/badge.xml",
        name = "$champion_type_name_tremor",
        description = "$champion_type_desc_tremor",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="-1",
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/tremor/damage_received.lua",
            });
        end
    },
    { id = "poison_blood",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/poison_blood/badge.xml",
        name = "$champion_type_name_poison_blood",
        description = "$champion_type_desc_poison_blood",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue2( damage_model, "blood_material", "poison" );
                ComponentSetValue2( damage_model, "blood_spray_material", "poison" );
            end
        end
    },
    { id = "frozen_blood",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/frozen_blood/badge.xml",
        name = "$champion_type_name_frozen_blood",
        description = "$champion_type_desc_frozen_blood",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue2( damage_model, "blood_material", "blood_cold" );
                ComponentSetValue2( damage_model, "blood_spray_material", "blood_cold" );
            end
        end
    },
    { id = "gunpowder_blood",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/gunpowder_blood/badge.xml",
        name = "$champion_type_name_gunpowder_blood",
        description = "$champion_type_desc_gunpowder_blood",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {"PROTECTION_FIRE"},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue2( damage_model, "blood_material", "gunpowder_unstable" );
                ComponentSetValue2( damage_model, "blood_spray_material", "gunpowder_unstable" );
            end
        end
    },
    { id = "healthy",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/healthy/badge.xml",
        name = "$champion_type_name_healthy",
        description = "$champion_type_desc_healthy",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
            for index,damage_model in pairs( damage_models ) do
                local current_hp = ComponentGetValue2( damage_model, "hp" );
                local max_hp = ComponentGetValue2( damage_model, "max_hp" );
                local new_max = max_hp * 1.5;
                local regained = new_max - current_hp;
                ComponentSetValue2( damage_model, "max_hp", new_max );
                ComponentSetValue2( damage_model, "hp", current_hp + regained );
            end
        end,
        deprecated = true
    },
    { id = "hot_blooded",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/hot_blooded/badge.xml",
        name = "$champion_type_name_hot_blooded",
        description = "$champion_type_desc_hot_blooded",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {"PROTECTION_FIRE"},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue2( damage_model, "blood_material", "lava" );
                ComponentSetValue2( damage_model, "blood_spray_material", "lava" );
                ComponentSetValue2( damage_model, "blood_multiplier", 2 );
            end
        end
    },
    { id = "poly_blood",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/poly_blood/badge.xml",
        name = "$champion_type_name_poly_blood",
        description = "$champion_type_desc_poly_blood",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue2( damage_model, "blood_material", "magic_liquid_random_polymorph" );
                ComponentSetValue2( damage_model, "blood_spray_material", "magic_liquid_random_polymorph" );
                ComponentSetValue2( damage_model, "blood_multiplier", 0.3 );
            end
        end
    },
    { id = "blood_spray",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/blood_spray/badge.xml",
        name = "$champion_type_name_blood_spray",
        description = "$champion_type_desc_blood_spray",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local blood_materials = {};
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                table.insert( blood_materials, ComponentGetValue2( damage_model, "blood_material", "blood" ) );
            end
            local material_inventory = EntityAddComponent2( entity, "MaterialInventoryComponent",{
                drop_as_item = false,
                leak_on_damage_percent = 0.999
            });
            if material_inventory then
                for _,material in pairs( blood_materials ) do
                    AddMaterialInventoryMaterial( entity, material, 1000 );
                end
            end
        end
    },
    { id = "ice_burst",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/ice_burst/badge.xml",
        name = "$champion_type_name_ice_burst",
        description = "$champion_type_desc_ice_burst",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="-1",
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/ice_burst/damage_received.lua",
            });
            TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
        end
    },
    { id = "infested",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/infested/badge.xml",
        name = "$champion_type_name_infested",
        description = "$champion_type_desc_infested",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="-1",
                script_death="mods/gkbrkn_noita/files/gkbrkn/champion_types/infested/death.lua",
            });
        end
    },
    { id = "intangibility_frames",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/intangibility_frames/badge.xml",
        name = "$champion_type_name_intangibility_frames",
        description = "$champion_type_desc_intangibility_frames",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/intangibility_frames/damage_received.lua",
            });
        end,
        deprecated = true
    },
    { id = "invincibility_frames",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/invincibility_frames/badge.xml",
        name = "$champion_type_name_invincibility_frames",
        description = "$champion_type_desc_invincibility_frames",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/invincibility_frames/damage_received.lua",
            });
        end,
        deprecated = true
    },
    { id = "invisible",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/invisible/badge.xml",
        name = "$champion_type_name_invisible",
        description = "$champion_type_desc_invisible",
        author = "$ui_author_name_goki_dev",
        game_effects = {"STAINS_DROP_FASTER"},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_source_file="mods/gkbrkn_noita/files/gkbrkn/champion_types/invisible/update.lua",
                execute_on_added="1",
                execute_every_n_frame="10",
            });
        end
    },
    { id = "jetpack",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/jetpack/badge.xml",
        name = "$champion_type_name_jetpack",
        description = "$champion_type_desc_jetpack",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity )
            local can_fly = false;
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    if ComponentGetValue2( ai, "can_fly" ) == true then
                        can_fly = true;
                        break;
                    end
                end
            end
            return not can_fly;
        end,
        apply = function( entity )
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            for _,ai in pairs( animal_ais ) do
                ComponentSetValues( ai, {can_fly=true});
            end
            local path_finding = EntityGetFirstComponent( entity, "PathFindingComponent" );
            if path_finding ~= nil then
                ComponentSetValues( path_finding, { can_fly=true } );
            end
            
            local jetpack_particles = EntityAddComponent( entity, "ParticleEmitterComponent", {
                _tags="jetpack",
                emitted_material_name="rocket_particles",
                x_pos_offset_min="-1",
                x_pos_offset_max="1",
                y_pos_offset_min="",
                y_pos_offset_max="0",
                x_vel_min="-7",
                x_vel_max="7",
                y_vel_min="80",
                y_vel_max="180",
                count_min="3",
                count_max="7",
                lifetime_min="0.1",
                lifetime_max="0.2",
                create_real_particles="0",
                emit_cosmetic_particles="1",
                emission_interval_min_frames="0",
                emission_interval_max_frames="1",
                is_emitting="1",
            } );
        end
    },
    { id = "knockback",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/knockback/badge.xml",
        name = "$champion_type_name_knockback",
        description = "$champion_type_desc_knockback",
        author = "$ui_author_name_goki_dev",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true; end,
        apply = function( entity )
            local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ai > 0 then
                for _,ai in pairs( animal_ai ) do
                    ComponentSetValue2( ai, "attack_knockback_multiplier", ComponentGetValue2( ai, "attack_knockback_multiplier" ) * 2.5 );
                end
            end
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/knockback/shot.lua"
            });
        end
    },
    { id = "leaping",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/leaping/badge.xml",
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
                    if ComponentGetValue2( ai, "attack_dash_enabled" ) == true then
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
                        attack_dash_enabled=true,
                    });
                    ComponentAdjustValues( ai, {
                        attack_dash_distance=function(value) return math.max( tonumber( value ), 150 ) end,
                    });
                end
            end
        end
    },
    { id = "projectile_bounce",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_bounce/badge.xml",
        name = "$champion_type_name_projectile_bounce",
        description = "$champion_type_desc_projectile_bounce",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity )
            local has_projectile_attack = false;
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    if ComponentGetValue2( ai, "attack_ranged_enabled" ) == true or ComponentGetValue2( ai, "attack_landing_ranged_enabled" ) == true then
                        has_projectile_attack = true;
                        break;
                    end
                end
            end
            return has_projectile_attack;
        end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_bounce/shot.lua",
            });
        end
    },
    { id = "projectile_buff",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_buff/badge.xml",
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
                    if ComponentGetValue2( ai, "attack_ranged_enabled" ) == true or ComponentGetValue2( ai, "attack_landing_ranged_enabled" ) == true then
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
                    ComponentSetValue2( ai, "attack_ranged_min_distance", ComponentGetValue2( ai, "attack_ranged_min_distance" ) * 1.33 ) ;
                    ComponentSetValue2( ai, "attack_ranged_max_distance", ComponentGetValue2( ai, "attack_ranged_max_distance" ) * 1.33 ) ;
                    ComponentSetValue2( ai, "attack_ranged_entity_count_min", ComponentGetValue2( ai, "attack_ranged_entity_count_min" ) + 1 ) ;
                    ComponentSetValue2( ai, "attack_ranged_entity_count_max", ComponentGetValue2( ai, "attack_ranged_entity_count_max" ) + 2 ) ;
                end
            end
        end
    },
    { id = "projectile_repulsion_field",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_repulsion_field/badge.xml",
        name = "$champion_type_name_projectile_repulsion_field",
        description = "$champion_type_desc_projectile_repulsion_field",
        author = "$ui_author_name_goki_dev",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local shield = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/projectile_repulsion_field/projectile_repulsion_field.xml" );
            if shield ~= nil then EntityAddChild( entity, shield ); end
        end
    },
    { id = "rapid_attack",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/rapid_attack/badge.xml",
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
    },
    { id = "regenerating",
        particle_material = "spark_green",
        sprite_particle_sprite_file = "data/particles/heal.xml",
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/regenerating/badge.xml",
        name = "$champion_type_name_regenerating",
        description = "$champion_type_desc_regenerating",
        author = "$ui_author_name_goki_dev",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", { 
                script_source_file = "mods/gkbrkn_noita/files/gkbrkn/champion_types/regenerating/update.lua",
                execute_every_n_frame = "60",
            } );
            EntityAddComponent( entity, "LuaComponent", { 
                script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/champion_types/regenerating/damage_received.lua",
            } );
        end
    },
    { id = "revenge_explosion",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/revenge_explosion/badge.xml",
        name = "$champion_type_name_revenge_explosion",
        description = "$champion_type_desc_revenge_explosion",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", { 
                script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/champion_types/revenge_explosion/damage_received.lua",
                execute_every_n_frame = "-1",
            } );
        end
    },
    { id = "reward",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/reward/badge.xml",
        name = "$champion_type_name_reward",
        description = "$champion_type_desc_reward",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return false; end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/reward/damage_received.lua"
            });
        end
    },
    { id = "sparkbolt",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/sparkbolt/badge.xml",
        name = "$champion_type_name_sparkbolt",
        description = "$champion_type_desc_sparkbolt",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity )
            local has_projectile_attack = false;
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    if ComponentGetValue2( ai, "attack_ranged_enabled" ) == true or ComponentGetValue2( ai, "attack_landing_ranged_enabled" ) == true then
                        has_projectile_attack = true;
                        break;
                    end
                end
            end
            return not has_projectile_attack;
        end,
        apply = function( entity )
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            for _, animal_ai in pairs( animal_ais ) do
                ComponentSetValue2( animal_ai, "attack_ranged_enabled", true );
                ComponentSetValue2( animal_ai, "attack_landing_ranged_enabled", true );
                ComponentSetValue2( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/deck/light_bullet.xml" );
                ComponentSetValue2( animal_ai, "attack_ranged_predict", false );
                ComponentSetValue2( animal_ai, "attack_ranged_aim_rotation_speed", 0.5 );
                
            end
        end
    },
    { id = "teleporting",
        particle_material = "spark_white",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/teleporting/badge.xml",
        name = "$champion_type_name_teleporting",
        description = "$champion_type_desc_teleporting",
        author = "$ui_author_name_goki_dev",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", { 
                script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/champion_types/teleporting/damage_received.lua",
                execute_every_n_frame = "-1",
            } );
            EntityAddComponent( entity, "LuaComponent", { 
                script_source_file = "mods/gkbrkn_noita/files/gkbrkn/champion_types/teleporting/teleport_nearby.lua",
                execute_every_n_frame = "180",
            } );
        end,
    },
    { id = "toxic_trail",
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/champion_types/toxic_trail/badge.xml",
        name = "$champion_type_name_toxic_trail",
        description = "$champion_type_desc_toxic_trail",
        author = "$ui_author_name_goki_dev",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity )
            local has_projectile_attack = false;
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    if ComponentGetValue2( ai, "attack_ranged_enabled" ) == true or ComponentGetValue2( ai, "attack_landing_ranged_enabled" ) == true then
                        has_projectile_attack = true;
                        break;
                    end
                end
            end
            return has_projectile_attack;
        end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/champion_types/toxic_trail/shot.lua",
            });
        end
    }
}