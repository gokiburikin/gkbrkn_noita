events = {
    { id = "take_damage", 
        name = "Take Damage", 
        description = "The player will take a small amount of damage.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            return {
                message = "You've been cursed!",
                callback = function( player_entity )
                    local x, y = EntityGetTransform( player_entity );
                    local hp = 0;
                    local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
                    for _,damage_model in pairs( damage_models ) do
                        hp = hp + ComponentGetValue( damage_model, "hp" );
                    end
                    local take_damage = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/events/take_damage.xml", x, y );
                    ComponentSetValue( EntityGetFirstComponent( take_damage, "AreaDamageComponent" ), "damage_per_frame", hp / 2 );
                end
            }
        end, 
    },
    { id = "circle_of_x",
        name = "Circle of X",
        description = "A circle of a random material will spawn near the player.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            local valid_materials = { "void_liquid", "fire", "acid", "water", "blood_cold_vapour" };
            local random_material = valid_materials[ Random( 1, #valid_materials ) ];
            local random_material_name = GameTextGetTranslatedOrNot( "$mat_"..random_material );
            return {
                message = "Circle of "..random_material_name,
                callback = function( player_entity )
                    local x, y = EntityGetTransform( player_entity );
                    local distance = 128;
                    local angle = math.random() * math.pi * 2;
                    local sx, sy = x + math.cos( angle ) * distance, y + math.sin( angle ) * distance;
                    local black_hole = EntityLoad( "data/entities/projectiles/deck/black_hole.xml", sx, sy );
                    local circle = EntityLoad( "data/entities/projectiles/deck/circle_acid.xml", sx, sy );
                    ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "emitted_material_name", random_material );
                end
            }
        end
    },
    { id = "random_perk",
        name = "Random Perk",
        description = "The player will gain a random perk.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            local random_perk = perk_list[ Random( 1, #perk_list ) ];
            local perk_name = GameTextGetTranslatedOrNot( random_perk.ui_name );
            local perk_id = random_perk.id;
            return {
                message = "You've been granted a perk",
                note = "Perk: "..perk_name,
                callback = function( player_entity )
                    local perk_entity = perk_spawn( x, y, random_perk.id );
                    if perk_entity ~= nil then
                        perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), true, false );
                    end
                end
            }
        end,
    },
    { id = "take_flight",
        name = "Take Flight",
        description = "All enemies around the player will gain flight.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            return {
                message = "Jetpack Jamboree",
                callback = function()
                    local x, y = EntityGetTransform( player_entity );
                    for _,entity in pairs( EntityGetInRadiusWithTag( x, y, 1024, "enemy" ) or {} ) do
                        local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
                        for _,ai in pairs( animal_ais ) do
                            ComponentSetValues( ai, { can_fly="1" } );
                        end

                        local path_finding = EntityGetFirstComponent( entity, "PathFindingComponent" );
                        if path_finding ~= nil then
                            ComponentSetValues( path_finding, { can_fly="1" } );
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
                end
            }
        end,
    },
    { id = "enemy_shields",
        name = "Enemy Shields",
        description = "All enemies around the player will gain an energy shield.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            return {
                message = "Enemy Shields",
                callback = function()
                    local x, y = EntityGetTransform( player_entity );
                    for _,entity in pairs( EntityGetInRadiusWithTag( x, y, 1024, "enemy" ) or {} ) do
                        local x, y = EntityGetTransform( entity );
                        local hitbox = EntityGetFirstComponent( entity, "HitboxComponent" );
                        local radius = nil;
                        local height = 18;
                        local width = 18;
                        if hitbox ~= nil then
                            height = tonumber( ComponentGetValue( hitbox, "aabb_max_y" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_min_y" ) );
                            width = tonumber( ComponentGetValue( hitbox, "aabb_max_x" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_min_x" ) );
                        end
                        radius = math.max( height, width ) + 6;
                        local shield = EntityLoad( "data/entities/misc/animal_energy_shield.xml", x, y );
                        local inherit_transform = EntityGetFirstComponent( shield, "InheritTransformComponent" );
                        if inherit_transform ~= nil then
                            ComponentSetValue( inherit_transform, "parent_hotspot_tag", "shield_center" );
                        end
                        local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
                        for _,emitter in pairs( emitters ) do
                            ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius );
                        end
                        local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
                        ComponentSetValue( energy_shield, "radius", tostring( radius ) );

                        local hotspot = EntityAddComponent( entity, "HotspotComponent",{
                            _tags="shield_center"
                        } );
                        ComponentSetValueVector2( hotspot, "offset", 0, -height * 0.3 );

                        if shield ~= nil then EntityAddChild( entity, shield ); end
                    end
                end
            }
        end
    },
    { id = "event_horizon",
        name = "Event Horizon",
        description = "Giga Black Holes will spawn near the player.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            local how_many = 3;
            local min_distance = 96;
            local max_distance = 192;
            return {
                message = "Event Horizon",
                callback = function( player_entity )
                    local x, y = EntityGetTransform( player_entity );
                    for i=1,how_many do
                        local distance = Random( min_distance, max_distance );
                        local angle = math.random() * math.pi * 2;
                        local sx, sy = x + math.cos( angle ) * distance, y + math.sin( angle ) * distance;
                        local black_hole = EntityLoad( "data/entities/projectiles/deck/black_hole_big.xml", sx, sy );
                    end
                end
            }
        end,
    },
    { id = "rainy_day",
        name = "Rainy Day",
        description = "A cloud of random material will spawn above the player's head.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            local material_choices = { "blood", "radioactive_liquid", "water", "slime", "magic_liquid_charm" };
            local min_distance = 24;
            local max_distance = 36;
            local chosen_material = material_choices[ Random( 1, #material_choices ) ];
            local random_material_name = GameTextGetTranslatedOrNot( "$mat_"..chosen_material );
            return {
                message = "Rainy Day",
                note = "Looks like it's raining "..random_material_name,
                callback = function( player_entity )
                    local x, y = EntityGetTransform( player_entity );
                    SetRandomSeed( GameGetFrameNum(), x + y );
                    local distance = Random( min_distance, max_distance );
                    local angle = math.rad(-90);
                    local sx, sy = x + math.cos( angle ) * distance, y + math.sin( angle ) * distance;
                    local cloud = EntityLoad( "data/entities/projectiles/deck/cloud_water.xml", sx, sy );
                    local cloud_children = EntityGetAllChildren( cloud ) or {};
                    for _,cloud_child in pairs( cloud_children ) do
                        local child_components = FindComponentByType( cloud_child, "ParticleEmitterComponent" ) or {};
                        for _,component in pairs( child_components ) do
                            if ComponentGetValue( component, "emitted_material_name" ) == "water" then
                                ComponentSetValue( component, "emitted_material_name", chosen_material );
                                break;
                            end
                        end
                    end
                end
            }
        end
    },
    { id = "gift_spell",
        name = "Gift: Random Spell",
        description = "A random spell will spawn near the player.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            SetRandomSeed( GameGetFrameNum(), x + y );
            local chosen_action = GetRandomAction( x, y, Random( 0, 6 ), Random( 1, 9999999 ) );
            --local random_action_name = GameTextGetTranslatedOrNot( "$action_"..chosen_action );
            return {
                message = "Gift: Random Spell",
                --note = "Spell: "..random_action_name,
                callback = function( player_entity )
                    local action = CreateItemActionEntity( chosen_action, x, y );
                    EntitySetComponentsWithTagEnabled( action,  "enabled_in_world", true );
                    EntitySetComponentsWithTagEnabled( action,  "item_unidentified", false );
                end
            }
        end,
    },
    { id = "blindness",
        name = "Blindness",
        description = "The player will receive the blindness affect for a short time.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            return {
                message = "Blindness",
                callback = function( player_entity )
                    local x, y = EntityGetTransform( player_entity );
                    local game_effect = GetGameEffectLoadTo( player_entity, "BLINDNESS", false );
                    if game_effect ~= nil then
                        ComponentSetValue( game_effect, "frames", 600 );
                    end
                end
            }
        end
    },
    { id = "homing_black_hole",
        name = "Homing Blackhole",
        description = "A black hole that moves towards the player will spawn.",
        author = "goki",
        weight = 1,
        condition_callback = nil,
        generator = function( player_entity )
            return {
                message = "Homing Blackhole",
                callback = function( player_entity )
                    local x, y = EntityGetTransform( player_entity );
                    local black_hole = EntityLoad( "data/entities/projectiles/deck/black_hole.xml", x, y );
                    EntityAddComponent( black_hole, "HomingComponent", {
                        target_tag="player_unit",
                        homing_targeting_coeff="30.0",
                        homing_velocity_multiplier="0.99",
                        detect_distance="300",
                    } );
                    local projectile = FindFirstComponentByType( black_hole, "ProjectileComponent" );
                    if projectile ~= nil then
                        ComponentSetValue( projectile, "lifetime", 300 );
                    end
                end
            }
        end
    }
}