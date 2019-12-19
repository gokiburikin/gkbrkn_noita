dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );

SETTINGS = {
    Debug = true,
    ShowDeprecatedContent = false,
    Version = "c70"
}

CONTENT_TYPE = {
    Action = 1,
    Perk = 2,
    --Misc = 3,
    Tweak = 4,
    ChampionType = 5,
    Item = 6,
    Loadout = 7,
    StartingPerk = 8,
}

CONTENT_TYPE_PREFIX = {
    [CONTENT_TYPE.Action] = "action_",
    [CONTENT_TYPE.Perk] = "perk_",
    --[CONTENT_TYPE.Misc] = "misc_",
    [CONTENT_TYPE.Tweak] = "tweak_",
    [CONTENT_TYPE.ChampionType] = "champion_type_",
    [CONTENT_TYPE.Item] = "item_",
    [CONTENT_TYPE.Loadout] = "loadout_",
    [CONTENT_TYPE.StartingPerk] = "starting_perk_",
}

CONTENT_TYPE_DISPLAY_NAME = {
    [CONTENT_TYPE.Action] = gkbrkn_localization.config_content_type_name_action,
    [CONTENT_TYPE.Perk] = gkbrkn_localization.config_content_type_name_perk,
    --[CONTENT_TYPE.Misc] = gkbrkn_localization.config_content_type_name_misc,
    [CONTENT_TYPE.Tweak] = gkbrkn_localization.config_content_type_name_tweak,
    [CONTENT_TYPE.ChampionType] = gkbrkn_localization.config_content_type_name_champion,
    [CONTENT_TYPE.Item] = gkbrkn_localization.config_content_type_name_item,
    [CONTENT_TYPE.Loadout] = gkbrkn_localization.config_content_type_name_loadout,
    [CONTENT_TYPE.StartingPerk] = gkbrkn_localization.config_content_type_name_starting_perk,
}


CONTENT = {};
function register_content( type, key, display_name, options, disabled_by_default, deprecated, inverted, init_function )
    local content_id = #CONTENT + 1;
    local content = {
        id = content_id,
        type = type,
        key = key,
        --name = CONTENT_TYPE_DISPLAY_NAME[type]..": "..display_name,
        name = display_name or ("missing display name: "..key),
        disabled_by_default = disabled_by_default,
        deprecated = deprecated,
        enabled = function()
            if SETTINGS.ShowDeprecatedContent == true or deprecated ~= true then
                if inverted ~= true then
                    return HasFlagPersistent( get_content_flag( content_id ) ) == false;
                else
                    return HasFlagPersistent( get_content_flag( content_id ) ) == true;
                end
            end
        end,
        visible = function()
            return SETTINGS.ShowDeprecatedContent == true or deprecated ~= true
        end,
        toggle = function( force )
            local flag = get_content_flag( content_id );
            local enable = true;
            if force == true then
                enable = true;
            elseif force == false then
                enable = false;
            else
                if HasFlagPersistent( flag ) then
                    enable = true;
                else
                    enable = false;
                end
            end
            if force ~= nil and inverted then
                enable = not enable;
            end
            if enable then
                RemoveFlagPersistent( flag );
            else
                AddFlagPersistent( flag );
            end
        end,
        options = options,
        init_function = init_function,
    }
    table.insert( CONTENT, content );
    return content.id;
end

function get_content( content_id )
    return CONTENT[content_id];
end

function get_content_flag( content_id )
    local content = CONTENT[content_id];
    if content ~= nil then
        return string.lower("GKBRKN_"..CONTENT_TYPE_PREFIX[content.type]..content.key);
    end
end

local register_perk = function( key, options, disabled_by_default, deprecated, inverted )
    return register_content( CONTENT_TYPE.Perk, key, gkbrkn_localization["perk_name_"..key], options, disabled_by_default, deprecated, inverted, function()
        ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/init.lua" );
    end );
end

PERKS = {
    ShortTemper = register_perk( "short_temper" ),
    LivingWand = register_perk( "living_wand", {
        TeleportDistance = 128
    }, true, true ),
    DuplicateWand = register_perk( "duplicate_wand" ),
    GoldenBlood = register_perk( "golden_blood", nil, true, true ),
    SpellEfficiency = register_perk( "spell_efficiency", {
        RetainChance = 0.33
    }, true, true ),
    MaterialCompression = register_perk( "material_compression" ),
    ManaEfficiency = register_perk( "mana_efficiency", {
        Discount = 0.33
    }, true, true ),
    RapidFire = register_perk( "rapid_fire" ),
    KnockbackImmunity = register_perk( "knockback_immunity" ),
    Resilience = register_perk( "resilience", { Resistances = {
        fire=0.35,
        radioactive=0.35,
        poison=0.35,
        electricity=0.35,
        ice=0.35,
    }} ),
    PassiveRecharge = register_perk( "passive_recharge" ),
    LostTreasure = register_perk( "lost_treasure" ),
    AlwaysCast = register_perk( "always_cast" ),
    HealthierHeart = register_perk( "healthier_heart" ),
    InvincibilityFrames = register_perk( "invincibility_frames" ),
    ExtraProjectile = register_perk( "extra_projectile" ),
    ManaRecovery = register_perk( "mana_recovery" ),
    Protagonist = register_perk( "protagonist" ),
    FragileEgo = register_perk( "fragile_ego" ),
    ThriftyShopper = register_perk( "thrifty_shopper" ),
    Swapper = register_perk( "swapper" ),
    Demolitionist = register_perk( "demolitionist" ),
    Multicast = register_perk( "multicast" ),
    MagicLight = register_perk( "magic_light", nil, true, true ),
    ChainCasting = register_perk( "chain_casting" ),
    WIP = register_perk( "wip", nil, true, not SETTINGS.Debug ),
}

local register_action = function( key, options, disabled_by_default, deprecated, inverted )
    return register_content( CONTENT_TYPE.Action, key, gkbrkn_localization["action_name_"..key], options, disabled_by_default, deprecated, inverted, function()
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/init.lua" );
    end );
end

ACTIONS = {
    ManaEfficiency = register_action( "mana_efficiency", nil, true, true ),
    SpellEfficiency =  register_action( "spell_efficiency", nil, true, true ),
    GoldenBlessing = register_action( "golden_blessing", nil, true, true ),
    MagicLight = register_action( "magic_light" ),
    Revelation = register_action( "revelation" ),
    MicroShield = register_action( "micro_shield", nil, true, true ),
    ModificationField = register_action( "modification_field" ),
    SpectralShot = register_action( "spectral_shot", nil, true, true ),
    ArcaneBuckshot = register_action( "arcane_buckshot", nil, true, true ),
    ArcaneShot = register_action( "arcane_shot", nil, true, true ),
    DoubleCast = register_action( "double_cast" ),
    SpellMerge = register_action( "spell_merge" ),
    ExtraProjectile = register_action( "extra_projectile" ),
    OrderDeck = register_action( "order_deck" ),
    PerfectCritical = register_action( "perfect_critical" ),
    ProjectileBurst = register_action( "projectile_burst" ),
    TriggerHit = register_action( "trigger_hit" ),
    TriggerTimer = register_action( "trigger_timer" ),
    TriggerDeath = register_action( "trigger_death" ),
    DrawDeck = register_action( "draw_deck", nil, true, true ),
    ProjectileGravityWell = register_action( "projectile_gravity_well" ),
    DamageLifetime = register_action( "damage_lifetime" ),
    DamageBounce = register_action( "damage_bounce" ),
    PathCorrection = register_action( "path_correction" ),
    CollisionDetection = register_action( "collision_detection", nil, true, true ),
    PowerShot = register_action( "power_shot" ),
    ShimmeringTreasure = register_action( "shimmering_treasure" ),
    NgonShape = register_action( "ngon_shape", nil, true, true ),
    ShuffleDeck = register_action( "shuffle_deck", nil, true, true ),
    BreakCast = register_action( "break_cast" ),
    ProjectileOrbit = register_action( "projectile_orbit" ),
    PassiveRecharge = register_action( "passive_recharge" ),
    ManaRecharge = register_action( "mana_recharge" ),
    SuperBounce = register_action( "super_bounce" ),
    CopySpell = register_action( "copy_spell" ),
    TimeSplit = register_action( "time_split" ),
    FormationStack = register_action( "formation_stack" ),
    PiercingShot = register_action( "piercing_shot", nil, true, true ),
    BarrierTrail = register_action( "barrier_trail" ),
    GlitteringTrail = register_action( "glittering_trail" ),
    ChaoticBurst = register_action( "chaotic_burst" ),
    WIP = register_action( "wip", nil, true, not SETTINGS.Debug )
}

local register_tweak = function( key, options, disabled_by_default, deprecated, inverted )
    return register_content( CONTENT_TYPE.Tweak, key, GameTextGetTranslatedOrNot( gkbrkn_localization["tweak_name_"..key] ),  options, disabled_by_default, deprecated, inverted );
end

TWEAKS = {
    Chainsaw = register_tweak( "chainsaw", { action_id="CHAINSAW" }, true, nil, true ),
    HeavyShot = register_tweak( "heavy_shot", { action_id="HEAVY_SHOT" }, true, nil, true ),
    Damage = register_tweak( "damage", { action_id="DAMAGE" }, true, nil, true ),
    Freeze = register_tweak( "freeze", { action_id="FREEZE" }, true, nil, true ),
    IncreaseMana = register_tweak( "increase_mana", { action_id="MANA_REDUCE" }, true, nil, true ),
    Blindness = register_tweak( "blindness","Shorten Blindness", nil, true, true, true ),
    RevengeExplosion = register_tweak( "revenge_explosion", { perk_id="REVENGE_EXPLOSION" }, true, true, true ),
    GlassCannon = register_tweak( "glass_cannon", { perk_id="GLASS_CANNON" }, true ),
    AreaDamage = register_tweak( "area_damage", { action_id="AREA_DAMAGE" }, true ),
}

LOADOUTS = {}

local register_champion_type = function( key, options, disabled_by_default, deprecated, inverted )
    return register_content( CONTENT_TYPE.ChampionType, key, gkbrkn_localization["champion_type_name_"..key], options, disabled_by_default, deprecated, inverted );
end

CHAMPION_TYPES = {
    Damage = register_champion_type( "damage_buff", {
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/damage.xml",
        particle_material = "spark_red",
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
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_damage_buff.lua"
            });
        end
    }),
    Projectile = register_champion_type( "projectile_buff", {
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/projectile.xml",
        particle_material = "spark_purple",
        sprite_particle_sprite_file = nil,
        game_effects = {},
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
                    ComponentSetValue( ai, "attack_ranged_min_distance", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_min_distance" ) * 1.33 ) ) );
                    ComponentSetValue( ai, "attack_ranged_max_distance", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_max_distance" ) * 1.33 ) ) );
                    ComponentSetValue( ai, "attack_ranged_entity_count_min", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_min" ) + 1 ) ) );
                    ComponentSetValue( ai, "attack_ranged_entity_count_max", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_max" ) + 2 ) ) );
                    ComponentSetValue( ai, "attack_ranged_state_duration_frames", "1" );
                end
            end
        end
    }),
    Haste = register_champion_type( "rapid_attack", {
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/haste.xml",
        particle_material = "spark_purple",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true;
        end,
        apply = function( entity )
            local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ai > 0 then
                for _,ai in pairs( animal_ai ) do
                    ComponentAdjustValues( ai, {
                        attack_melee_frames_between=function(value) return math.ceil( tonumber( value ) / 1.5 ) end,
                        attack_dash_frames_between=function(value) return math.ceil( tonumber( value ) / 1.5 ) end,
                        attack_ranged_frames_between=function(value) return math.ceil( tonumber( value ) / 1.5 ) end,
                    });
                end
            end
        end
    }),
    Fast = register_champion_type( "faster_movement", {
        particle_material = "spark_green",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/movement_faster.xml",
        game_effects = {},
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
    }),
    Teleport = register_champion_type( "teleporting", {
        particle_material = "spark_white",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/teleporting.xml",
        game_effects = {"TELEPORTATION"},
        validator = function( entity ) return true end,
    }),
    Burning = register_champion_type( "burning", {
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/burning.xml",
        game_effects = {"PROTECTION_FIRE"},
        validator = function( entity ) return true end,
        apply = function( entity )
            local x,y = EntityGetTransform( entity );
            local burn = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/fire.xml", x, y );
            if burn ~= nil then
                EntityAddChild( entity, burn );
            end
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_burning.lua",
            });
        end
    }),
    Freezing = register_champion_type( "freezing", {
        particle_material = "blood_cold_vapour",
        sprite_particle_sprite_file = "data/particles/snowflake_$[1-2].xml",
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/freezing.xml",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local x,y = EntityGetTransform( entity );
            local field = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/freeze_field.xml", x, y );
            if field ~= nil then
                EntityAddChild( entity, field );
            end
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="60",
                execute_on_added="1",
                script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/freeze.lua",
            });
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_freeze.lua",
            });
        end
    }),
    Shoot = register_champion_type( "shoot", {
        particle_material = "spark_purple",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/champion.xml",
        game_effects = {},
        validator = function( entity ) return true end,
    }, true, true),
    -- TODO Update this when Invisible game effect doesn't crash
    Invisible = register_champion_type( "invisible", {
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/invisible.xml",
        game_effects = {"STAINS_DROP_FASTER"},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/invisible.lua",
                execute_on_added="1",
                execute_every_n_frame="10",
            });
        end
    } ),
    Loot =register_champion_type( "loot", {
        particle_material = "spark_white",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/champion.xml",
        game_effects = {},
        validator = function( entity ) return true end,
    }, true, true),
    Regeneration = register_champion_type( "regenerating", {
        particle_material = "spark_green",
        sprite_particle_sprite_file = "data/particles/heal.xml",
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/regeneration.xml",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", { 
                script_source_file = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/regeneration.lua",
                execute_every_n_frame = "60",
            } );
            EntityAddComponent( entity, "LuaComponent", { 
                script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/regeneration_damage_received.lua",
            } );
        end
    }),
    WormBait = register_champion_type( "worm_bait", {
        particle_material = "meat",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/champion.xml",
        game_effects = {"WORM_ATTRACTOR"},
        validator = function( entity ) return true end,
    }, true, true ),
    RevengeExplosion = register_champion_type( "revenge_explosion", {
        particle_material = "spark_yellow",
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/revenge_explosion.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", { 
                script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/revenge_explosion.lua",
                execute_every_n_frame = "-1",
            } );
        end
    }),
    EnergyShield = register_champion_type( "energy_shield", {
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/energy_shield.xml",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
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
            local shield = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/energy_shield.xml", x, y );
            local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
            for _,emitter in pairs( emitters ) do
                ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius );
            end
            local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
            ComponentSetValue( energy_shield, "radius", tostring( radius ) );

            local hotspot = EntityAddComponent( entity, "HotspotComponent",{
                _tags="gkbrkn_center"
            } );
            ComponentSetValueVector2( hotspot, "offset", 0, -height * 0.3 );

            if shield ~= nil then EntityAddChild( entity, shield ); end
        end
    }),
    Electricity = register_champion_type( "electric", {
        particle_material = nil,
        sprite_particle_sprite_file = "data/particles/spark_electric.xml",
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/electricity.xml",
        game_effects = {"PROTECTION_ELECTRICITY"},
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
            local field = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/electricity_field.xml", x, y );
            if field ~= nil then
                EntityAddChild( entity, field );
            end
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="60",
                execute_on_added="1",
                script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/electricity.lua",
            });
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_electricity.lua",
            });
        end
    }),
    ProjectileRepulsionField = register_champion_type( "projectile_repulsion_field", {
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/projectile_repulsion_field.xml",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local shield = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/projectile_repulsion_field.xml" );
            if shield ~= nil then EntityAddChild( entity, shield ); end
        end
    }),
    Healthy = register_champion_type( "healthy", {
        particle_material = "plasma_fading_pink",
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/healthy.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
            for index,damage_model in pairs( damage_models ) do
                local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
                local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
                local new_max = max_hp * 1.5;
                local regained = new_max - current_hp;
                ComponentSetValue( damage_model, "max_hp", tostring( new_max ) );
                ComponentSetValue( damage_model, "hp", tostring( current_hp + regained ) );
            end
        end
    }),
    HotBlooded = register_champion_type( "hot_blooded", {
        particle_material = "fire",
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/hot_blooded.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue( damage_model, "blood_material", "lava" );
                ComponentSetValue( damage_model, "blood_spray_material", "lava" );
            end
        end
    }),
    ProjectileBounce =  register_champion_type( "projectile_bounce", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/projectile_bounce.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
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
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_projectile_bounce.lua",
            });
        end
    }),
    Eldritch =  register_champion_type( "eldritch", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/eldritch.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
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
            return has_projectile_attack == false;
        end,
        apply = function( entity )
            local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ai > 0 then
                for _,ai in pairs( animal_ai ) do
                    ComponentSetValues( ai, {
                        attack_ranged_action_frame="4",
                        attack_ranged_min_distance="0",
                        attack_ranged_max_distance="120",
                        attack_ranged_entity_file="data/entities/projectiles/tongue.xml",
                        attack_ranged_offset_x="0",
                        attack_ranged_offset_y="0",
                        attack_ranged_enabled="1",
                    });
                end
            end
        end
    }),
    InvincibilityFrames = register_champion_type( "invincibility_frames", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/invincibility_frames.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/invincibility_frames.lua",
            });
        end
    }),
    ToxicTrail =  register_champion_type( "toxic_trail", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/toxic_trail.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
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
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_toxic_trail.lua",
            });
        end
    }),
    Counter =  register_champion_type( "counter", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/counter.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="99999999",
		        script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/counter_damage_received.lua",
            });
        end
    }),
    Infested =  register_champion_type( "infested", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/infested.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="99999999",
		        script_death="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/infested_death.lua",
            });
        end
    }),
    --[[
    Leader = register_content( CONTENT_TYPE.ChampionType, "leader", "Leader", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/champion.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/leader.lua",
                execute_every_n_frame="30",
            });
        end
    }),
    ]]
}

local register_item = function( key, options )
    return register_content( CONTENT_TYPE.Item, key, gkbrkn_localization["item_name_"..key], options );
end

ITEMS = {
    SpellBag = register_item( "spell_bag", nil, true, nil, true ),
}

OPTIONS = {
    {
        Name = gkbrkn_localization.option_gold_tracking,
    },
    {
        Name = gkbrkn_localization.sub_option_gold_tracking_show_log_message,
        PersistentFlag = "gkbrkn_gold_tracking_message",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_gold_tracking_show_in_world,
        PersistentFlag = "gkbrkn_gold_tracking_in_world",
        SubOption = true,
        EnabledByDefault = true,
    },
    {
        Name = gkbrkn_localization.option_invincibility_frames,
    },
    {
        Name = gkbrkn_localization.sub_option_invincibility_frames_enabled,
        PersistentFlag = "gkbrkn_invincibility_frames",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_invincibility_frames_show_flashing,
        PersistentFlag = "gkbrkn_invincibility_frames_flashing",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.option_heal_new_health,
    },
    {
        Name = gkbrkn_localization.sub_option_heal_new_health_enabled,
        PersistentFlag = "gkbrkn_max_health_heal",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_heal_new_health_heal_to_full,
        PersistentFlag = "gkbrkn_max_health_heal_full",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.option_less_particles,
    },
    {
        Name = gkbrkn_localization.sub_option_less_particles_enabled,
        PersistentFlag = "gkbrkn_less_particles",
        SubOption = true,
        ToggleCallback = function()
            for _,entity in pairs( EntityGetWithTag("gkbrkn_less_particles") or {} ) do
                EntityRemoveTag( entity, "gkbrkn_less_particles" );
            end
        end
    },
    {
        Name = gkbrkn_localization.sub_option_less_particles_disable_cosmetic_particles,
        PersistentFlag = "gkbrkn_less_particles_disable",
        SubOption = true,
        ToggleCallback = function()
            for _,entity in pairs( EntityGetWithTag("gkbrkn_less_particles") or {} ) do
                EntityRemoveTag( entity, "gkbrkn_less_particles" );
            end
        end
    },
    {
        Name = gkbrkn_localization.option_random_start,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_wands,
        PersistentFlag = "gkbrkn_random_start_random_wand",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_default_wand_generation,
        PersistentFlag = "gkbrkn_random_start_default_wands",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_cape_colour,
        PersistentFlag = "gkbrkn_random_start_random_cape",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_health,
        PersistentFlag = "gkbrkn_random_start_random_health",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_flask,
        PersistentFlag = "gkbrkn_random_start_random_flask",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_perk,
        PersistentFlag = "gkbrkn_random_start_random_perk",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_champion_enemies,
    },
    {
        Name = gkbrkn_localization.sub_option_champion_enemies_enabled,
        SubOption = true,
        PersistentFlag = "gkbrkn_champion_enemies",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_champion_enemies_super_champions,
        SubOption = true,
        PersistentFlag = "gkbrkn_champion_enemies_super",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_champion_enemies_champions_only,
        SubOption = true,
        PersistentFlag = "gkbrkn_champion_enemies_always",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_hero_mode,
    },
    {
        Name = gkbrkn_localization.sub_option_hero_mode_enabled,
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_hero_mode_orbs_difficulty,
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode_orb_scale",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_hero_mode_distance_difficulty,
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode_distance_scale",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_loadouts,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_manage,
        PersistentFlag = "gkbrkn_loadouts_manage",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_enabled,
        PersistentFlag = "gkbrkn_loadouts_enabled",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_custom_cape_color,
        PersistentFlag = "gkbrkn_loadouts_cape_color",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_custom_player_sprites,
        PersistentFlag = "gkbrkn_loadouts_player_sprites",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_disable_random_spells,
        PersistentFlag = "gkbrkn_disable_spells",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_charm_nerf,
        PersistentFlag = "gkbrkn_charm_nerf",
    },
    {
        Name = gkbrkn_localization.option_limited_ammo,
        PersistentFlag = "gkbrkn_limited_ammo",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_unlimited_ammo,
        PersistentFlag = "gkbrkn_unlimited_ammo",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_quick_swap,
        PersistentFlag = "gkbrkn_quick_swap",
    },
    {
        Name = gkbrkn_localization.option_passive_recharge,
        PersistentFlag = "gkbrkn_passive_recharge",
    },
    {
        Name = gkbrkn_localization.option_wand_shops_only,
        PersistentFlag = "gkbrkn_wand_shops_only",
    },
    {
        Name = gkbrkn_localization.option_loose_spell_generation,
        PersistentFlag = "gkbrkn_loose_spell_generation",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_extended_wand_generation,
        PersistentFlag = "gkbrkn_extended_wand_generation",
    },
    {
        Name = gkbrkn_localization.option_chaotic_wand_generation,
        PersistentFlag = "gkbrkn_chaotic_wand_generation",
    },
    {
        Name = gkbrkn_localization.option_no_pregen_wands,
        PersistentFlag = "gkbrkn_no_pregen_wands",
        RequiresRestart = true,
    },
    --{
    --    Name = gkbrkn_localization.option_gold_decay,
    --    PersistentFlag = "gkbrkn_gold_decay",
    --},
    {
        Name = gkbrkn_localization.option_persistent_gold,
        PersistentFlag = "gkbrkn_persistent_gold",
    },
    {
        Name = gkbrkn_localization.option_target_dummy,
        PersistentFlag = "gkbrkn_target_dummy",
    },
    {
        Name = gkbrkn_localization.option_health_bars,
        PersistentFlag = "gkbrkn_health_bars",
    },
    {
        Name = gkbrkn_localization.option_show_fps,
        PersistentFlag = "gkbrkn_show_fps",
    },
    {
        Name = gkbrkn_localization.option_show_badges,
        PersistentFlag = "gkbrkn_show_badges",
        RequiresRestart = true,
        EnabledByDefault = true,
    },
    {
        Name = gkbrkn_localization.option_auto_hide,
        PersistentFlag = "gkbrkn_auto_hide",
    }
}

MISC = {
    GoldPickupTracker = {
        TrackDuration = 180, -- in game frames
        ShowMessageEnabled = "gkbrkn_gold_tracking_message",
        ShowTrackerEnabled = "gkbrkn_gold_tracking_in_world",
    },
    CharmNerf = {
        Enabled = "gkbrkn_charm_nerf",
    },
    InvincibilityFrames = {
        Duration = 40,
        Enabled = "gkbrkn_invincibility_frames",
        FlashEnabled = "gkbrkn_invincibility_frames_flashing",
    },
    HealOnMaxHealthUp = {
        Enabled = "gkbrkn_max_health_heal",
        FullHeal = "gkbrkn_max_health_heal_full",
    },
    LooseSpellGeneration = {
        Enabled = "gkbrkn_loose_spell_generation",
    },
    LimitedAmmo = {
        Enabled = "gkbrkn_limited_ammo",
    },
    UnlimitedAmmo = {
        Enabled = "gkbrkn_unlimited_ammo",
    },
    DisableSpells = {
        Enabled = "gkbrkn_disable_spells",
    },
    ChampionEnemies = {
        Enabled = "gkbrkn_champion_enemies",
        SuperChampionsEnabled = "gkbrkn_champion_enemies_super",
        AlwaysChampionsEnabled = "gkbrkn_champion_enemies_always",
        ChampionChance = 0.125,
        ExtraTypeChance = 0.25,
    },
    QuickSwap = {
        Enabled = "gkbrkn_quick_swap",
    },
    LessParticles = {
        Enabled = "gkbrkn_less_particles",
        DisableEnabled = "gkbrkn_less_particles_disable"
    },
    RandomStart = {
        RandomWandEnabled = "gkbrkn_random_start_random_wand",
        RandomHealthEnabled = "gkbrkn_random_start_random_health",
        MinimumHP = 50,
        MaximumHP = 150,
        DefaultWandGenerationEnabled = "gkbrkn_random_start_default_wands",
        RandomCapeColorEnabled = "gkbrkn_random_start_random_cape",
        RandomFlaskEnabled = "gkbrkn_random_start_random_flask",
        RandomPerkEnabled = "gkbrkn_random_start_random_perk",
        RandomPerks = 1,
    },
    WandShopsOnly = {
        Enabled = "gkbrkn_wand_shops_only",
    },
    ExtendedWandGeneration = {
        Enabled = "gkbrkn_extended_wand_generation",
    },
    ChaoticWandGeneration = {
        Enabled = "gkbrkn_chaotic_wand_generation",
    },
    ShowFPS = {
        Enabled = "gkbrkn_show_fps",
    },
    HealthBars = {
        Enabled = "gkbrkn_health_bars",
    },
    --GoldDecay = {
    --    Enabled = "gkbrkn_gold_decay",
    --},
    PersistentGold = {
        Enabled = "gkbrkn_persistent_gold",
    },
    PassiveRecharge = {
        Enabled = "gkbrkn_passive_recharge",
        Speed = 1
    },
    TargetDummy = {
        Enabled = "gkbrkn_target_dummy",
    },
    Loadouts = {
        Manage = "gkbrkn_loadouts_manage",
        Enabled = "gkbrkn_loadouts_enabled",
        CapeColorEnabled = "gkbrkn_loadouts_cape_color",
        PlayerSpritesEnabled = "gkbrkn_loadouts_player_sprites",
    },
    HeroMode = {
        Enabled = "gkbrkn_hero_mode",
        OrbsIncreaseDifficultyEnabled = "gkbrkn_hero_mode_orb_scale",
        DistanceDifficultyEnabled = "gkbrkn_hero_mode_distance_scale",
    },
    NoPregenWands = {
        Enabled = "gkbrkn_no_pregen_wands",
    },
    Badges = {
        Enabled = "gkbrkn_show_badges",
    },
    AutoHide = {
        Enabled = "gkbrkn_auto_hide",
    }
}

function trim(s)
   local from = s:match"^%s*()"
   return from > #s and "" or s:match(".*%S", from)
end

function register_loadout( id, name, author, cape_color, cape_color_edge, wands, potions, items, perks, actions, sprites, custom_message, callback )
    local display_name = trim(string.gsub( name, "TYPE", "" ));
    if author ~= nil then
        display_name = display_name .. " ("..author..")";
    end
    local content_id = register_content( CONTENT_TYPE.Loadout, id, display_name, {
        name = name,
        author = author,
        cape_color = cape_color,
        cape_color_edge = cape_color_edge,
        wands = wands,
        potions = potions,
        items = items,
        perks = perks,
        actions = actions,
        sprites = sprites,
        custom_message = custom_message,
        callback = callback,
    } );
    LOADOUTS[id] = content_id;
end

if SETTINGS.Debug then
    -- Debug
    register_loadout(
        "gkbrkn_debug", -- unique identifier
        gkbrkn_localization.loadout_debug, -- displayed loadout name
        "goki",
        nil, -- cape color (ABGR)
        nil, -- cape edge color (ABGR)
        { -- wands
            {
                name = "Debug Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {25,25}, -- capacity
                    reload_time = {10,10}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {1000,1000}, -- mana charge speed
                    mana_max = {5000,5000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "GKBRKN_COPY_SPELL" },
                    { "SCATTER_2" },
                    { "SLOW_BULLET" },
                    { "SLOW_BULLET" },
                    { "SLOW_BULLET" },
                    { "SLOW_BULLET" },
                }
            },
            {
                name = "Debug Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {25,25}, -- capacity
                    reload_time = {10,10}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {1000,1000}, -- mana charge speed
                    mana_max = {5000,5000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "SCATTER_4" },
                    { "DEATH_CROSS" },
                    { "DEATH_CROSS" },
                    { "DEATH_CROSS" },
                    { "CHAINSAW" },
                }
            },
            {
                name = "Debug Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {25,25}, -- capacity
                    reload_time = {10,10}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {1000,1000}, -- mana charge speed
                    mana_max = {5000,5000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "SPEED" },
                    { "SPEED" },
                    { "LIFETIME" },
                    { "BLACK_HOLE" },
                    { "BLACK_HOLE" },
                    { "BLACK_HOLE" },
                    { "BLACK_HOLE" },
                }
            },
            {
                name = "Debug Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {15,15}, -- capacity
                    reload_time = {40,40}, -- recharge time in frames
                    fire_rate_wait = {20,20}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {200,200}, -- mana charge speed
                    mana_max = {1000,1000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "GKBRKN_SPELL_MERGE" },
                    { "SCATTER_4" },
                    { "RUBBER_BALL" },
                    { "LIGHT_BULLET" },
                    { "CHAINSAW" },
                    { "CHAINSAW" },
                }
            }
        },
        { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        { -- items
        },
        { -- perks
        },
        { -- actions
            {"LIGHT_BULLET"},
            {"GKBRKN_MAGIC_LIGHT"},
            {"LIGHT_BULLET","HEAVY_BULLET","SLOW_BULLET"},
            {"CHAINSAW"},
            {"DIGGER"},
            {"POWERDIGGER"},
            {"GKBRKN_SPELL_MERGE"},
            {"BURST_2"},
            {"GKBRKN_GLITTERING_TRAIL"},
            --[[
            {"GKBRKN_ACTION_WIP"},
            {"GKBRKN_MANA_EFFICIENCY"},
            {"GKBRKN_SPELL_EFFICIENCY"},
            {"GKBRKN_GOLDEN_BLESSING"},
            {"GKBRKN_MAGIC_LIGHT"},
            {"GKBRKN_REVELATION"},
            {"GKBRKN_MICRO_SHIELD"},
            {"GKBRKN_MODIFICATION_FIELD"},
            {"GKBRKN_SPECTRAL_SHOT"},
            {"GKBRKN_ARCANE_BUCKSHOT"},
            {"GKBRKN_ARCANE_SHOT"},
            {"GKBRKN_DOUBLE_CAST"},
            {"GKBRKN_SPELL_MERGE"},
            {"GKBRKN_EXTRA_PROJECTILE"},
            {"GKBRKN_ORDER_DECK"},
            {"GKBRKN_PERFECT_CRITICAL"},
            {"GKBRKN_PROJECTILE_BURST"},
            {"GKBRKN_TRIGGER_HIT"},
            {"GKBRKN_TRIGGER_TIMER"},
            {"GKBRKN_TRIGGER_DEATH"},
            {"GKBRKN_DRAW_DECK"},
            {"GKBRKN_PROJECTILE_GRAVITY_WELL"},
            {"GKBRKN_DAMAGE_LIFETIME"},
            {"GKBRKN_DAMAGE_BOUNCE"},
            {"GKBRKN_PATH_CORRECTION"},
            {"GKBRKN_COLLISION_DETECTION"},
            {"GKBRKN_POWER_SHOT"},
            {"GKBRKN_SHIMMERING_TREASURE"},
            {"GKBRKN_NGON_SHAPE"},
            {"GKBRKN_SHUFFLE_DECK"},
            {"GKBRKN_BREAK_CAST"},
            {"GKBRKN_PROJECTILE_ORBIT"},
            {"GKBRKN_PASSIVE_RECHARGE"},
            {"GKBRKN_MANA_RECHARGE"},
            {"GKBRKN_SUPER_BOUNCE"},
            {"GKBRKN_COPY_SPELL"},
            {"GKBRKN_TIME_SPLIT"},
            {"GKBRKN_FORMATION_STACK"},
            {"GKBRKN_PIERCING_SHOT"},
            {"GKBRKN_ACTION_WIP"},
            ]]
        },
        nil, -- sprites
        "", -- custom message
        function( player )
            local x, y = EntityGetTransform( player );
            local target_dummy = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x - 80, y - 40 );
            local effect = GetGameEffectLoadTo( player, "EDIT_WANDS_EVERYWHERE", true );
            if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end
            local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
            if inventory2 ~= nil then
                ComponentSetValue( inventory2, "full_inventory_slots_y", 5 );
            end
            --EntityAddComponent( player, "LuaComponent", {
            --    script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/regen.lua"
            --});
        end

    );
end