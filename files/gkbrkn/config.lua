--dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );

FLAGS = {
    SpellShopsOnly = "gkbrkn_spell_shops_only",
    WandShopsOnly = "gkbrkn_wand_shops_only",
    RemoveGenericWands = "gkbrkn_remove_generic_wands",
    NoWandGeneration = "gkbrkn_no_wand_generation",
    GooMode = "gkbrkn_goo_mode",
    HotGooMode = "gkbrkn_hot_goo_mode",
    KillerGooMode = "gkbrkn_killer_goo_mode",
    AltKillerGooMode = "gkbrkn_alt_killer_goo_mode",
    PolyGooMode = "gkbrkn_poly_goo_mode",
    NoWandEditing = "gkbrkn_no_wand_editing",
    NoHit = "gkbrkn_no_hit",
    LimitedAmmo = "gkbrkn_limited_ammo",
    UnlimitedAmmo = "gkbrkn_unlimited_ammo",
    ShuffleWandsOnly = "gkbrkn_shuffle_wands_only",
    OrderWandsOnly = "gkbrkn_order_wands_only",
    GuaranteedAlwaysCast = "gkbrkn_guaranteed_always_cast",
    FreeShops = "gkbrkn_free_shops",
    InfiniteFlight = "gkbrkn_infinite_flight",
    FloorIsLava = "gkbrkn_floor_is_lava",
    DisintegrateCorpses = "gkbrkn_disintegrate_corpses",
    DebugMode = "gkbrkn_debug_mode",
    ShowDeprecatedContent = "gkbrkn_show_deprecated_content",
}

SETTINGS = {
    Version = "c96"
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
    LegendaryWand = 9,
    Event = 10,
    GameModifier = 11,
    DevOption = 12,
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
    [CONTENT_TYPE.LegendaryWand] = "legendary_wand_",
    [CONTENT_TYPE.Event] = "event_",
    [CONTENT_TYPE.GameModifier] = "game_modifier_",
    [CONTENT_TYPE.DevOption] = "dev_option_",
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
    [CONTENT_TYPE.LegendaryWand] = gkbrkn_localization.config_content_type_name_legendary_wand,
    [CONTENT_TYPE.Event] = gkbrkn_localization.config_content_type_name_event,
    [CONTENT_TYPE.GameModifier] = gkbrkn_localization.config_content_type_name_game_modifier,
    [CONTENT_TYPE.DevOption] = gkbrkn_localization.config_content_type_name_dev_option,
}

CONTENT_TYPE_DEVELOPMENT_ONLY = {
    [CONTENT_TYPE.DevOption] = true,
}

local get_content_flag = function( content_id )
    local content = CONTENT[content_id];
    if content ~= nil then
        return string.lower("GKBRKN_"..CONTENT_TYPE_PREFIX[content.type]..content.key);
    end
end

CONTENT = {};
local register_content = function( type, key, display_name, options, disabled_by_default, deprecated, inverted, init_function, development_mode_only )
    local content_id = #CONTENT + 1;
    local complete_display_name = display_name or ("missing display name: "..key);
    if deprecated then
        complete_display_name = complete_display_name .. " (D)";
    end
    local content = {
        id = content_id,
        type = type,
        key = key,
        --name = CONTENT_TYPE_DISPLAY_NAME[type]..": "..display_name,
        name = complete_display_name,
        disabled_by_default = disabled_by_default,
        deprecated = deprecated,
        development_mode_only = development_mode_only,
        enabled = function()
            if development_mode_only == true and SETTINGS.Debug == false then
                return false;
            end
            if HasFlagPersistent( FLAGS.ShowDeprecatedContent ) == true or deprecated ~= true then
                if inverted ~= true then
                    return HasFlagPersistent( get_content_flag( content_id ) ) == false;
                else
                    return HasFlagPersistent( get_content_flag( content_id ) ) == true;
                end
            end
        end,
        visible = function()
            return HasFlagPersistent( FLAGS.ShowDeprecatedContent ) == true or deprecated ~= true;
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

local get_content = function( content_id )
    return CONTENT[content_id];
end

local register_perk = function( key, options, disabled_by_default, deprecated, inverted )
    if options == nil then
        options = {};
    end
    local content_id = register_content( CONTENT_TYPE.Perk, key, gkbrkn_localization["perk_name_"..key], options, disabled_by_default, deprecated, inverted, function()
        ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/"..key.."/init.lua" );
    end );
    local description = gkbrkn_localization["perk_description_"..key];
    if description ~= nil then
        options.description = description;
    end
    options.preview_callback = function( player_entity )
        dofile_once( "data/scripts/perks/perk.lua" );
        local perk_entity = perk_spawn( x, y, string.upper( "gkbrkn_"..key ) );
        if perk_entity ~= nil then
            perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
        end
    end
    return content_id;
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
        fire=0.33,
        radioactive=0.33,
        poison=0.33,
        electricity=0.33,
    }} ),
    PassiveRecharge = register_perk( "passive_recharge", nil, true, true ),
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
    Multicast = register_perk( "multicast", nil, true, true ),
    Megacast = register_perk( "megacast" ),
    MagicLight = register_perk( "magic_light", nil, true, true ),
    QueueCasting = register_perk( "queue_casting" ),
    DisenchantSpell = register_perk( "disenchant_spell" ),
    BloodMagic = register_perk( "blood_magic", {
        BloodToManaRatio = 1,
        FreeAlwaysCasts = true,
        DamageMultiplier = 5,
    }, nil, true, true ),
    ManaMastery = register_perk( "mana_mastery" ),
    Wandsmith = register_perk( "wandsmith" ),
    HyperCasting = register_perk( "hyper_casting" ),
    LeadBoots = register_perk( "lead_boots" ),
    DiplomaticImmunity = register_perk( "diplomatic_immunity" ),
    TreasureRadar = register_perk( "treasure_radar", nil, GameCreateSpriteForXFrames == nil, GameCreateSpriteForXFrames == nil ),
    MergeWands = register_perk( "merge_wands" ),
    WIP = register_perk( "wip", nil, true, not HasFlagPersistent( FLAGS.DebugMode ) ),
}

local register_action = function( key, init_path, options, disabled_by_default, deprecated, inverted )
    if options == nil then
        options = {};
    end
    local content_id = register_content( CONTENT_TYPE.Action, key, gkbrkn_localization["action_name_"..key] or key, options, disabled_by_default, deprecated, inverted, function()
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", init_path or "mods/gkbrkn_noita/files/gkbrkn/actions/"..key.."/init.lua" );
        if options ~= nil and options.callback ~= nil then
            options.callback();
        end
    end );
    local description = gkbrkn_localization["action_description_"..key];
    if description ~= nil then
        options.description = description;
    end
    options.preview_callback = function( player_entity )
        local x, y = EntityGetTransform( player_entity );
        local action_entity = CreateItemActionEntity( string.upper( "gkbrkn_"..key ), x, y );
    end
    return content_id;
end

ACTIONS = {
    ManaEfficiency = register_action( "mana_efficiency", nil, nil, true, true ),
    SpellEfficiency =  register_action( "spell_efficiency", nil, nil, true, true ),
    GoldenBlessing = register_action( "golden_blessing", nil, nil, true, true ),
    MagicLight = register_action( "magic_light" ),
    Revelation = register_action( "revelation", nil, nil,true, true ),
    MicroShield = register_action( "micro_shield", nil, nil, true, true ),
    ModificationField = register_action( "modification_field" ),
    SpectralShot = register_action( "spectral_shot", nil, nil, true, true ),
    ArcaneBuckshot = register_action( "arcane_buckshot", nil, nil, true, true ),
    ArcaneShot = register_action( "arcane_shot", nil, nil, true, true ),
    DoubleCast = register_action( "double_cast" ),
    TripleCast = register_action( "triple_cast" ),
    SpellMerge = register_action( "spell_merge" ),
    ExtraProjectile = register_action( "extra_projectile" ),
    OrderDeck = register_action( "order_deck" ),
    PerfectCritical = register_action( "perfect_critical" ),
    ProjectileBurst = register_action( "projectile_burst", nil, nil, true, true ),
    TriggerHit = register_action( "trigger_hit" ),
    TriggerTimer = register_action( "trigger_timer" ),
    TriggerDeath = register_action( "trigger_death" ),
    DrawDeck = register_action( "draw_deck", nil, nil, true, true ),
    ProjectileGravityWell = register_action( "projectile_gravity_well" ),
    DamageLifetime = register_action( "damage_lifetime" ),
    DamageBounce = register_action( "damage_bounce" ),
    PathCorrection = register_action( "path_correction" ),
    CollisionDetection = register_action( "collision_detection", nil, nil, true, true ),
    PowerShot = register_action( "power_shot" ),
    ShimmeringTreasure = register_action( "shimmering_treasure", nil, nil, true, true ),
    NgonShape = register_action( "ngon_shape", nil, nil, true, true ),
    ShuffleDeck = register_action( "shuffle_deck", nil, nil, true, true ),
    BreakCast = register_action( "break_cast" ),
    ProjectileOrbit = register_action( "projectile_orbit" ),
    PassiveRecharge = register_action( "passive_recharge" ),
    ManaRecharge = register_action( "mana_recharge" ),
    SuperBounce = register_action( "super_bounce", nil, nil, true, true ),
    CopySpell = register_action( "copy_spell" ),
    TimeSplit = register_action( "time_split" ),
    FormationStack = register_action( "formation_stack" ),
    PiercingShot = register_action( "piercing_shot", nil, nil, true, true ),
    BarrierTrail = register_action( "barrier_trail" ),
    GlitteringTrail = register_action( "glittering_trail" ),
    ChaoticBurst = register_action( "chaotic_burst" ),
    Zap = register_action( "zap" ),
    StoredShot = register_action( "stored_shot" ),
    CarryShot = register_action( "carry_shot" ),
    TreasureSense = register_action( "treasure_sense", nil, nil, true, true ),
    NuggetShot = register_action( "nugget_shot", nil, { callback=function() ModMaterialsFileAdd("mods/gkbrkn_noita/files/gkbrkn/actions/nugget_shot/materials.xml") end } ),
    ProtectiveEnchantment = register_action( "protective_enchantment" ),
    ChainCast = register_action( "chain_cast" ),
    MultiDeathTrigger = register_action( "multi_death_trigger" ),
    SpellDuplicator = register_action( "spell_duplicator" ),
    FeatherShot = register_action( "feather_shot" ),
    FollowShot = register_action( "follow_shot" ),
    StickyShot = register_action( "sticky_shot", nil, nil, true, true ),
    ClingingShot = register_action( "clinging_shot" ),
    Duplicast = register_action( "duplicast" ),
    CarpetBomb = register_action( "carpet_bomb", nil, nil, true, true ),
    PersistentShot = register_action( "persistent_shot" ),
    IceShot = register_action( "ice_shot", nil, nil, true, true ),
    DestructiveShot = register_action( "destructive_shot" ),
    BoundShot = register_action( "bound_shot" ),
    GuidedShot = register_action( "guided_shot" ),
    TimeCompression = register_action( "time_compression" ),
    LinkShot = register_action( "link_shot" ),
    TrailingShot = register_action( "trailing_shot" ),
}

local register_tweak = function( key, options, disabled_by_default, deprecated, inverted, init_function )
    if disabled_by_default == nil then disabled_by_default = true; end
    if inverted == nil then inverted = true; end
    if options == nil then
        options = {};
    end
    local description = gkbrkn_localization["tweak_name_"..key.."_description"];
    if description ~= nil then
        options.description = description;
    end
    return register_content( CONTENT_TYPE.Tweak, key, GameTextGetTranslatedOrNot( gkbrkn_localization["tweak_name_"..key] or key ),  options, disabled_by_default, deprecated, inverted, init_function );
end

TWEAKS = {
    Chainsaw = register_tweak( "chainsaw", { action_id="CHAINSAW" } ),
    HeavyShot = register_tweak( "heavy_shot", { action_id="HEAVY_SHOT" } ),
    Damage = register_tweak( "damage", { action_id="DAMAGE" } ),
    Freeze = register_tweak( "freeze", { action_id="FREEZE" } ),
    IncreaseMana = register_tweak( "increase_mana", { action_id="MANA_REDUCE" } ),
    Blindness = register_tweak( "blindness", nil, true, true, true ),
    RevengeExplosion = register_tweak( "revenge_explosion", { perk_id="REVENGE_EXPLOSION" } ),
    RevengeTentacle = register_tweak( "revenge_tentacle", { perk_id="REVENGE_TENTACLE" } ),
    GlassCannon = register_tweak( "glass_cannon", { perk_id="GLASS_CANNON" } ),
    AreaDamage = register_tweak( "area_damage", { action_id="AREA_DAMAGE" } ),
    ChainBolt = register_tweak( "chain_bolt", { action_id="CHAIN_BOLT" } ),
    StunLock = register_tweak( "stun_lock" ),
    ProjectileRepulsion = register_tweak( "projectile_repulsion", { perk_id="PROJECTILE_REPULSION" } ),
    ExplosionOfThunder = register_tweak( "explosion_of_thunder", { action_id="THUNDER_BLAST" } ),
    AllSeeingEye = register_tweak( "all_seeing_eye", { action_id="X_RAY" }, true, true, true ),
    SpiralShot = register_tweak( "spiral_shot", { action_id="SPIRAL_SHOT" } ),
    TeleportCast = register_tweak( "teleport_cast", { action_id="TELEPORT_CAST" } ),
    BloodAmount = register_tweak( "blood_amount", {
        Multiplier = 0.98,
    } ),
}

LOADOUTS = {};
LEGENDARY_WANDS = {};

local register_champion_type = function( key, options, disabled_by_default, deprecated, inverted )
    if options == nil then
        options = {};
    end
    local content_id = register_content( CONTENT_TYPE.ChampionType, key, gkbrkn_localization["champion_type_name_"..key], options, disabled_by_default, deprecated, inverted );
    local description = gkbrkn_localization["champion_type_"..key.."_description"];
    if description ~= nil then
        options.description = description;
    end
    return content_id;
end

CHAMPION_TYPES = {
    Damage = register_champion_type( "damage_buff", {
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/damage.xml",
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
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_damage_buff.lua"
            });
        end
    }),
    Projectile = register_champion_type( "projectile_buff", {
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/projectile.xml",
        particle_material = nil,
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
                    ComponentSetValue( ai, "attack_ranged_min_distance", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_min_distance" ) * 1.33 ) ) );
                    ComponentSetValue( ai, "attack_ranged_max_distance", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_max_distance" ) * 1.33 ) ) );
                    ComponentSetValue( ai, "attack_ranged_entity_count_min", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_min" ) + 1 ) ) );
                    ComponentSetValue( ai, "attack_ranged_entity_count_max", tostring( tonumber( ComponentGetValue( ai, "attack_ranged_entity_count_max" ) + 2 ) ) );
                end
            end
        end
    }),
    Knockback = register_champion_type( "knockback", {
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/knockback.xml",
        particle_material = nil,
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true; end,
        apply = function( entity )
            local animal_ai = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ai > 0 then
                for _,ai in pairs( animal_ai ) do
                    ComponentSetValue( ai, "attack_knockback_multiplier", tostring( tonumber( ComponentGetValue( ai, "attack_knockback_multiplier" ) ) * 2.5 ) );
                end
            end
            EntityAddComponent( entity, "LuaComponent", {
                script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_knockback.lua"
            });
        end
    }),
    Haste = register_champion_type( "rapid_attack", {
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/haste.xml",
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
    }),
    Fast = register_champion_type( "faster_movement", {
        particle_material = nil,
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
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", { 
                script_damage_received = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/teleport_damage_received.lua",
                execute_every_n_frame = "-1",
            } );
            EntityAddComponent( entity, "LuaComponent", { 
                script_source_file = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/teleport_nearby.lua",
                execute_every_n_frame = "180",
            } );
        end,
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
        particle_material = nil,
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
            TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
        end
    }),
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
    RevengeExplosion = register_champion_type( "revenge_explosion", {
        particle_material = nil,
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
            TryAdjustDamageMultipliers( entity, { electricity = 0.00 } );
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
        particle_material = nil,
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
    }, true, true),
    HotBlooded = register_champion_type( "hot_blooded", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/hot_blooded.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {"PROTECTION_FIRE"},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue( damage_model, "blood_material", "lava" );
                ComponentSetValue( damage_model, "blood_spray_material", "lava" );
                ComponentSetValue( damage_model, "blood_multiplier", "2" );
            end
        end
    }),
    GunpowderBlood = register_champion_type( "gunpowder_blood", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/gunpowder_blood.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {"PROTECTION_FIRE"},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue( damage_model, "blood_material", "gunpowder_unstable" );
                ComponentSetValue( damage_model, "blood_spray_material", "gunpowder_unstable" );
            end
        end
    }),
    FrozenBlood = register_champion_type( "frozen_blood", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/frozen_blood.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                ComponentSetValue( damage_model, "blood_material", "blood_cold" );
                ComponentSetValue( damage_model, "blood_spray_material", "blood_cold" );
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
    }, true, true),
    Armored = register_champion_type( "armored", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/armored.xml",
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
                    local resistance = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                    resistance = resistance * multiplier;
                    ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( resistance ) );
                end
                local minimum_knockback_force = tonumber( ComponentGetValue( damage_model, "minimum_knockback_force" ) );
                ComponentSetValue( damage_model, "minimum_knockback_force", "99999" );
            end
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
                execute_every_n_frame="-1",
		        script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/counter_damage_received.lua",
            });
        end
    }),
    IceBurst =  register_champion_type( "ice_burst", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/ice_burst.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                execute_every_n_frame="-1",
		        script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/ice_burst_damage_received.lua",
            });
            TryAdjustDamageMultipliers( entity, { ice = 0.00 } );
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
    Digging =  register_champion_type( "digging", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/digging.xml",
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
                execute_every_n_frame="-1",
		        script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_digging.lua",
            });
        end
    }),
    Leaping =  register_champion_type( "leaping", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/leaping.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
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
            return not has_dash_attack;
        end,
        apply = function( entity )
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    ComponentSetValues( ai, {
                        attack_dash_enabled="1",
                    });
                    ComponentAdjustValues( ai, {
                        attack_dash_distance=function(value) return math.max( tonumber( value ), 150 ) end,
                    });
                end
            end
        end
    }),
    Jetpack =  register_champion_type( "jetpack", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/jetpack.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity )
            local can_fly = false;
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            if #animal_ais > 0 then
                for _,ai in pairs( animal_ais ) do
                    if ComponentGetValue( ai, "can_fly" ) == "1" then
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
                ComponentSetValues( ai, {can_fly="1"});
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
    }),
    Sparkbolt =  register_champion_type( "sparkbolt", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/sparkbolt.xml",
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
            return not has_projectile_attack;
        end,
        apply = function( entity )
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            for _, animal_ai in pairs( animal_ais ) do
                ComponentSetValue( animal_ai, "attack_ranged_enabled", "1" );
                ComponentSetValue( animal_ai, "attack_landing_ranged_enabled", "1" );
                ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/deck/light_bullet.xml" );
            end
        end
    }),
    Reward =  register_champion_type( "reward", {
        particle_material = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/reward.xml",
        sprite_particle_sprite_file = nil,
        game_effects = {},
        validator = function( entity ) return false; end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", {
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/reward_damage_received.lua"
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

local register_item = function( key, options, disabled_by_default, deprecated, inverted )
    if options == nil then
        options = {};
    end
    local description = gkbrkn_localization["item_"..key.."_description"];
    if description ~= nil then
        options.description = description;
    end
    if options.item_path ~= nil then
        options.preview_callback = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            EntityLoad( options.item_path, x, y );
        end
    end
    return register_content( CONTENT_TYPE.Item, key, gkbrkn_localization["item_name_"..key], options, disabled_by_default, deprecated, inverted );
end

ITEMS = {
    SpellBag = register_item( "spell_bag", { item_path="mods/gkbrkn_noita/files/gkbrkn/items/spell_bag/item.xml" }, true, nil, true ),
}

local register_dev_option = function( key, options, disabled_by_default, deprecated, inverted )
    if options == nil then options = {}; end
    if disabled_by_default == nil then disabled_by_default = true; end
    if inverted == nil then inverted = true; end
    local description = gkbrkn_localization["dev_option_"..key.."_description"];
    if description ~= nil then
        options.description = description;
    end
    return register_content( CONTENT_TYPE.DevOption, key, gkbrkn_localization["dev_option_"..key.."_name"], options, disabled_by_default, deprecated, inverted, nil, true );
end

DEV_OPTIONS = {
    InfiniteMana = register_dev_option( "infinite_mana" ),
    InfiniteSpells = register_dev_option( "infinite_spells" ),
    RecoverHealth = register_dev_option( "recover_health" ),
}

local register_game_modifier = function( key, options, disabled_by_default, deprecated, inverted )
    if options == nil then
        options = {};
    end
    if disabled_by_default == nil then disabled_by_default = true; end
    if inverted == nil then inverted = true; end
    local content_id = register_content( CONTENT_TYPE.GameModifier, key, gkbrkn_localization["game_modifier_"..key.."_name"], options, disabled_by_default, deprecated, inverted );
    local description = gkbrkn_localization["game_modifier_"..key.."_description"];
    if description ~= nil then
        options.description = description;
    end
    return content_id;
end

GAME_MODIFIERS = {
    GooMode = register_game_modifier( "goo_mode", {
        player_spawned_callback = function( player_entity )
            dofile_once( "data/scripts/perks/perk.lua" );
            local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
            if perk_entity ~= nil then
                perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
            end
            local x, y = EntityGetTransform( player_entity );
            GameCreateParticle( "creepy_liquid", x - 50, y, 5, 0, 0, false, false );
        end,
        run_flags = { FLAGS.GooMode }
    } ),
    PolyGooMode = register_game_modifier( "poly_goo_mode", {
        player_spawned_callback = function( player_entity )
            local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
            if perk_entity ~= nil then
                perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
            end
            local x, y = EntityGetTransform( player_entity );
            GameCreateParticle( "poly_goo", x - 50, y, 5, 0, 0, false, false );
        end,
        run_flags = { FLAGS.PolyGooMode }
    } ),
    HotGooMode = register_game_modifier( "hot_goo_mode", {
        player_spawned_callback = function( player_entity )
            local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
            if perk_entity ~= nil then
                perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
            end

            local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                adjust_material_damage( damage_model, function( materials, damage )
                    table.insert( materials, "creepy_lava");
                    table.insert( damage, "0.003");
                    return materials, damage;
                end);
                EntitySetComponentIsEnabled( player_entity, damage_model, true );
                local polymorph = GetGameEffectLoadTo( player_entity, "POLYMORPH", true )
                ComponentSetValue( polymorph, "frames", 1 );
            end

            local x, y = EntityGetTransform( player_entity );
            GameCreateParticle( "creepy_lava", x - 50, y, 5, 0, 0, false, false );
        end,
        run_flags = { FLAGS.HotGooMode }
    } ),
    KillerGooMode = register_game_modifier( "killer_goo_mode", {
        player_spawned_callback = function( player_entity )
            local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
            if perk_entity ~= nil then
                perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
            end
            local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                adjust_material_damage( damage_model, function( materials, damage )
                    table.insert( materials, "killer_goo");
                    table.insert( damage, "0.001");
                    table.insert( materials, "corruption");
                    table.insert( damage, "0.001");
                    return materials, damage;
                end);
                EntitySetComponentIsEnabled( player_entity, damage_model, true );
                local polymorph = GetGameEffectLoadTo( player_entity, "POLYMORPH", true )
                ComponentSetValue( polymorph, "frames", 1 );
            end

            local x, y = EntityGetTransform( player_entity );
            GameCreateParticle( "killer_goo", x - 50, y, 5, 0, 0, false, false );
        end,
        run_flags = { FLAGS.KillerGooMode }
    } ),
    AltKillerGooMode = register_game_modifier( "alt_killer_goo_mode", {
        player_spawned_callback = function( player_entity )
            local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
            if perk_entity ~= nil then
                perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
            end
            local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
            for _,damage_model in pairs( damage_models ) do
                adjust_material_damage( damage_model, function( materials, damage )
                    table.insert( materials, "alt_killer_goo");
                    table.insert( damage, "0.001");
                    table.insert( materials, "corruption");
                    table.insert( damage, "0.001");
                    return materials, damage;
                end);
                EntitySetComponentIsEnabled( player_entity, damage_model, true );
                local polymorph = GetGameEffectLoadTo( player_entity, "POLYMORPH", true )
                ComponentSetValue( polymorph, "frames", 1 );
            end

            local x, y = EntityGetTransform( player_entity );
            GameCreateParticle( "alt_killer_goo", x - 50, y, 5, 0, 0, false, false );
        end,
        run_flags = { FLAGS.AltKillerGooMode }
    } ),
    LimitedMana = register_game_modifier( "limited_mana", { run_flags = { FLAGS.LimitedMana } } ),
    HardMode = register_game_modifier( "hard_mode", { run_flags = { FLAGS.HardMode } } ),
    RemoveGenericWands = register_game_modifier( "remove_generic_wands", { run_flags = { FLAGS.RemoveGenericWands } } ),
    --NoWandGeneration = register_game_modifier( "no_wand_generation", { run_flags = { FLAGS.NoWandGeneration } } ),
    NoEdit = register_game_modifier( "no_edit", { run_flags = { FLAGS.NoWandEditing } } ),
    LimitedAmmo = register_game_modifier( "limited_ammo", { run_flags = { FLAGS.LimitedAmmo } } ),
    UnlimitedAmmo = register_game_modifier( "unlimited_ammo", { run_flags = { FLAGS.UnlimitedAmmo } } ),
    NoHit = register_game_modifier( "no_hit", {
        player_spawned_callback = function( player_entity )
            EntityAddComponent( player_entity, "LuaComponent", {
                script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/no_hit/player_damage_received.lua"
            });
        end,
        run_flags = { FLAGS.NoHit }
    } ),
    OrderWandsOnly = register_game_modifier( "order_wands_only", { run_flags = { FLAGS.OrderWandsOnly } } ),
    ShuffleWandsOnly = register_game_modifier( "shuffle_wands_only", { run_flags = { FLAGS.ShuffleWandsOnly } } ),
    GuaranteedAlwaysCast = register_game_modifier( "guaranteed_always_cast", { run_flags = { FLAGS.GuaranteedAlwaysCast } } ),
    SpellShopsOnly = register_game_modifier( "spell_shops_only", { run_flags = { FLAGS.SpellShopsOnly } } ),
    WandShopsOnly = register_game_modifier( "wand_shops_only", { run_flags = { FLAGS.WandShopsOnly } } ),
    FreeShops = register_game_modifier( "free_shops", { run_flags = { FLAGS.FreeShops } } ),
    FloorIsLava = register_game_modifier( "floor_is_lava", { run_flags = { FLAGS.FloorIsLava } } ),
    InfiniteFlight = register_game_modifier( "infinite_flight", { run_flags = { FLAGS.InfiniteFlight } } ),
    DisintegrateCorpses = register_game_modifier( "disintegrate_corpses", { run_flags = { FLAGS.DisintegrateCorpses } } ),
}

local register_event = function( key, name, message, callback, condition, weight, disabled_by_default, deprecated, inverted )
    return register_content( CONTENT_TYPE.Event, key, gkbrkn_localization["event_name_"..key], {
        name=name,
        message=message,
        callback=callback,
        condition=condition,
        weight=weight,
    }, disabled_by_default, deprecated, inverted );
end

local register_dynamic_event = function( key, generator, condition, weight, disabled_by_default, deprecated, inverted )
    return register_content( CONTENT_TYPE.Event, key, gkbrkn_localization["event_name_"..key], {
        generator=generator,
        condition=condition,
        weight=weight
    }, disabled_by_default, deprecated, inverted );
end

EVENTS = {
    TakeDamage = register_event( "take_damage", "Take Damage", "You've been cursed!",
    function( player_entity ) 
        local x, y = EntityGetTransform( player_entity );
        local hp = 0;
        local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
        for _,damage_model in pairs( damage_models ) do
            hp = hp + ComponentGetValue( damage_model, "hp" );
        end
        local take_damage = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/events/take_damage.xml", x, y );
        ComponentSetValue( EntityGetFirstComponent( take_damage, "AreaDamageComponent" ), "damage_per_frame", hp / 2 );
    end, nil, 1
    ),
    CircleOfX = register_dynamic_event( "circle_of_x", function( player_entity )
        local valid_materials = { "void_liquid", "fire", "acid", "water", "blood_cold_vapour" };
        local random_material = valid_materials[ Random( 1, #valid_materials ) ];
        local random_material_name = GameTextGetTranslatedOrNot( "$mat_"..random_material );
        local callback = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            local distance = 128;
            local angle = math.random() * math.pi * 2;
            local sx, sy = x + math.cos( angle ) * distance, y + math.sin( angle ) * distance;
            local black_hole = EntityLoad( "data/entities/projectiles/deck/black_hole.xml", sx, sy );
            local circle = EntityLoad( "data/entities/projectiles/deck/circle_acid.xml", sx, sy );
            ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "emitted_material_name", random_material );
        end
        return "Circle of "..random_material_name, "", callback;
    end, nil, 1
    ),
    RandomPerk = register_dynamic_event( "random_perk", function( player_entity )
        local x, y = EntityGetTransform( player_entity );
        local random_perk = perk_list[ Random( 1, #perk_list ) ];
        local perk_name = GameTextGetTranslatedOrNot( random_perk.ui_name );
        local perk_id = random_perk.id;
        local callback = function( player_entity )
            local perk_entity = perk_spawn( x, y, random_perk.id );
            if perk_entity ~= nil then
                perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), true, false );
            end
        end
        return "Perk: "..perk_name, "You've been granted a perk", callback;
    end, nil, 1
    ),
    TakeFlight = register_dynamic_event( "take_flight", function( player_entity )
        return "Jetpack Jamboree","",function()
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
    end, nil, 1
    ),
    EnemyShields = register_dynamic_event( "enemy_shields", function( player_entity )
        return "Enemy Shields","",function()
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
    end, nil, 1
    ),
    EventHorizon = register_dynamic_event( "event_horizon", function( player_entity )
        local how_many = 3;
        local min_distance = 96;
        local max_distance = 192;
        local callback = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            for i=1,how_many do
                local distance = Random( min_distance, max_distance );
                local angle = math.random() * math.pi * 2;
                local sx, sy = x + math.cos( angle ) * distance, y + math.sin( angle ) * distance;
                local black_hole = EntityLoad( "data/entities/projectiles/deck/black_hole_big.xml", sx, sy );
            end
        end
        return "Event Horizon", "", callback;
    end, nil, 1
    ),
    RainyDay = register_dynamic_event( "rainy_day", function( player_entity )
        local material_choices = { "blood", "radioactive_liquid", "water", "slime", "magic_liquid_charm" };
        local min_distance = 24;
        local max_distance = 36;
        local callback = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            SetRandomSeed( GameGetFrameNum(), x + y );
            local chosen_material = material_choices[ Random( 1, #material_choices ) ];
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
        return "Rainy Day", "", callback;
    end, nil, 1
    ),
    GiftSpell = register_dynamic_event( "gift_spell", function( player_entity )
        local callback = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            SetRandomSeed( GameGetFrameNum(), x + y );

            local chosen_action = GetRandomAction( x, y, Random( 0, 6 ), Random( 1, 9999999 ) );
            local action = CreateItemActionEntity( chosen_action, x, y );
            EntitySetComponentsWithTagEnabled( action,  "enabled_in_world", true );
            EntitySetComponentsWithTagEnabled( action,  "item_unidentified", false );
        end
        return "Gift: Random Spell", "", callback;
    end, nil, 1
    ),
    Blindness = register_dynamic_event( "blindness", function( player_entity )
        local callback = function( player_entity )
            local x, y = EntityGetTransform( player_entity );
            local game_effect = GetGameEffectLoadTo( player_entity, "BLINDNESS", false );
            if game_effect ~= nil then
                ComponentSetValue( game_effect, "frames", 600 );
            end
        end
        return "Blindness", "", callback;
    end, nil, 1
    ),
    HomingBlackhole = register_dynamic_event( "homing_black_hole", function( player_entity )
        local callback = function( player_entity )
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
        return "Homing Blackhole", "", callback;
    end, nil, 1
    )
}

MISC = {
    DebugMode = {
        Enabled = HasFlagPersistent( FLAGS.DebugMode ),
    },
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
    DisableSpells = {
        Enabled = "gkbrkn_disable_spells",
    },
    ChampionEnemies = {
        Enabled = "gkbrkn_champion_enemies",
        SuperChampionsEnabled = "gkbrkn_champion_enemies_super",
        AlwaysChampionsEnabled = "gkbrkn_champion_enemies_always",
        MiniBossesEnabled = "gkbrkn_champion_mini_bosses",
        ChampionChance = 0.20,
        MiniBossChance = 0.10, -- rolled after champion chance only if mini boss kill threshold has been met
        MiniBossThreshold = 50, -- the amount of enemies that must be killed before a miniboss can spawn
        ExtraTypeChance = 0.05,
    },
    QuickSwap = {
        Enabled = "gkbrkn_quick_swap",
    },
    LessParticles = {
        PlayerProjectilesEnabled = "gkbrkn_less_particles_player",
        OtherStuffEnabled = "gkbrkn_less_particles_other_stuff",
        DisableEnabled = "gkbrkn_less_particles_disable"
    },
    RandomStart = {
        RandomWandEnabled = "gkbrkn_random_start_random_wand",
        RandomHealthEnabled = "gkbrkn_random_start_random_health",
        MinimumHP = 50,
        MaximumHP = 150,
        CustomWandGenerationEnabled = "gkbrkn_random_start_custom_wands",
        RandomCapeColorEnabled = "gkbrkn_random_start_random_cape",
        RandomFlaskEnabled = "gkbrkn_random_start_random_flask",
        RandomPerkEnabled = "gkbrkn_random_start_random_perk",
        RandomPerks = 1,
    },
    LegendaryWands = {
        Enabled = "gkbrkn_legendary_wands",
        SpawnWeighting = 0.025,
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
        PrettyHealthBarsEnabled = "gkbrkn_health_bars_pretty",
    },
    GoldDecay = {
        Enabled = "gkbrkn_gold_decay",
    },
    PersistentGold = {
        Enabled = "gkbrkn_persistent_gold",
    },
    AutoPickupGold = {
        Enabled = "gkbrkn_auto_pickup_gold",
    },
    CombineGold = {
        Enabled = "gkbrkn_combine_gold",
        Radius = 48,
    },
    PassiveRecharge = {
        Enabled = "gkbrkn_passive_recharge",
        Speed = 1
    },
    TargetDummy = {
        Enabled = "gkbrkn_target_dummy",
    },
    SlotMachine = {
        Enabled = "gkbrkn_slot_machine",
    },
    Loadouts = {
        Manage = "gkbrkn_loadouts_manage",
        Enabled = "gkbrkn_loadouts_enabled",
        CapeColorEnabled = "gkbrkn_loadouts_cape_color",
        PlayerSpritesEnabled = "gkbrkn_loadouts_player_sprites",
        SelectableClassesIntegration = "gkbrkn_selectable_classes_integration",
    },
    HeroMode = {
        Enabled = "gkbrkn_hero_mode",
        OrbsDifficultyEnabled = "gkbrkn_hero_mode_orb_scale",
        DistanceDifficultyEnabled = "gkbrkn_hero_mode_distance_scale",
        CarnageDifficultyEnabled = "gkbrkn_hero_mode_carnage",
    },
    NoPregenWands = {
        Enabled = "gkbrkn_no_pregen_wands",
    },
    ChestsContainPerks = {
        Enabled = "gkbrkn_chests_contain_perks",
        Chance=0.12,
        SuperChance=0.25,
        RemovePerkTag=false, -- this makes it so that picking up other perks doesn't kill this perk. might have side effects!!!
        DontKillOtherPerks=true,
    },
    Badges = {
        Enabled = "gkbrkn_show_badges",
    },
    ShowEntityNames = {
        Enabled = "gkbrkn_show_entity_names",
    },
    FixedCamera = {
        Enabled = "gkbrkn_fixed_camera",
    },
    Events = {
        Enabled = "gkbrkn_events_enabled",
    },
    AutoHide = {
        Enabled = "gkbrkn_auto_hide",
    }
}

OPTIONS = {
    {
        Name = gkbrkn_localization.option_gold_tracking,
        Description = gkbrkn_localization.option_gold_tracking_description,
    },
    {
        Name = gkbrkn_localization.sub_option_gold_tracking_show_log_message,
        Description = gkbrkn_localization.sub_option_gold_tracking_show_log_message_description,
        PersistentFlag = "gkbrkn_gold_tracking_message",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_gold_tracking_show_in_world,
        Description = gkbrkn_localization.sub_option_gold_tracking_show_in_world_description,
        PersistentFlag = "gkbrkn_gold_tracking_in_world",
        SubOption = true,
        EnabledByDefault = true,
    },
    {
        Name = gkbrkn_localization.option_invincibility_frames,
        Description = gkbrkn_localization.option_invincibility_frames_description,
    },
    {
        Name = gkbrkn_localization.sub_option_invincibility_frames_enabled,
        Description = gkbrkn_localization.sub_option_invincibility_frames_enabled_description,
        PersistentFlag = "gkbrkn_invincibility_frames",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_invincibility_frames_show_flashing,
        Description = gkbrkn_localization.sub_option_invincibility_frames_show_flashing_description,
        PersistentFlag = "gkbrkn_invincibility_frames_flashing",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.option_heal_new_health,
        Description = gkbrkn_localization.option_heal_new_health_description,
    },
    {
        Name = gkbrkn_localization.sub_option_heal_new_health_enabled,
        Description = gkbrkn_localization.sub_option_heal_new_health_enabled_description,
        PersistentFlag = "gkbrkn_max_health_heal",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_heal_new_health_heal_to_full,
        Description = gkbrkn_localization.sub_option_heal_new_health_heal_to_full_description,
        PersistentFlag = "gkbrkn_max_health_heal_full",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.option_less_particles,
        Description = gkbrkn_localization.option_less_particles_description,
    },
    {
        Name = gkbrkn_localization.sub_option_less_particles_player_projectiles_enabled,
        Description = gkbrkn_localization.sub_option_less_particles_player_projectiles_enabled_description,
        PersistentFlag = MISC.LessParticles.PlayerProjectilesEnabled,
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_less_particles_other_stuff_enabled,
        Description = gkbrkn_localization.sub_option_less_particles_other_stuff_enabled_description,
        PersistentFlag = MISC.LessParticles.OtherStuffEnabled,
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_less_particles_disable_cosmetic_particles,
        Description = gkbrkn_localization.sub_option_less_particles_disable_cosmetic_particles_description,
        PersistentFlag =  MISC.LessParticles.DisableEnabled,
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.option_random_start,
        Description = gkbrkn_localization.option_random_start_description,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_wands,
        Description = gkbrkn_localization.sub_option_random_start_random_wands_description,
        PersistentFlag = "gkbrkn_random_start_random_wand",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_custom_wand_generation,
        Description = gkbrkn_localization.sub_option_random_start_custom_wand_generation_description,
        PersistentFlag = "gkbrkn_random_start_custom_wands",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_cape_colour,
        Description = gkbrkn_localization.sub_option_random_start_random_cape_colour_description,
        PersistentFlag = "gkbrkn_random_start_random_cape",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_health,
        Description = gkbrkn_localization.sub_option_random_start_random_health_description,
        PersistentFlag = "gkbrkn_random_start_random_health",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_flask,
        Description = gkbrkn_localization.sub_option_random_start_random_flask_description,
        PersistentFlag = "gkbrkn_random_start_random_flask",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_random_start_random_perk,
        Description = gkbrkn_localization.sub_option_random_start_random_perk_description,
        PersistentFlag = "gkbrkn_random_start_random_perk",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_champion_enemies,
        Description = gkbrkn_localization.option_champion_enemies_description,
    },
    {
        Name = gkbrkn_localization.sub_option_champion_enemies_enabled,
        Description = gkbrkn_localization.sub_option_champion_enemies_enabled_description,
        SubOption = true,
        PersistentFlag = MISC.ChampionEnemies.Enabled,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_champion_enemies_mini_bosses,
        Description = gkbrkn_localization.sub_option_champion_enemies_mini_bosses_description,
        SubOption = true,
        PersistentFlag = MISC.ChampionEnemies.MiniBossesEnabled,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_champion_enemies_super_champions,
        Description = gkbrkn_localization.sub_option_champion_enemies_super_champions_description,
        SubOption = true,
        PersistentFlag = MISC.ChampionEnemies.SuperChampionsEnabled,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_champion_enemies_champions_only,
        Description = gkbrkn_localization.sub_option_champion_enemies_champions_only_description,
        SubOption = true,
        PersistentFlag = MISC.ChampionEnemies.AlwaysChampionsEnabled,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_hero_mode,
        Description = gkbrkn_localization.option_hero_mode_description,
    },
    {
        Name = gkbrkn_localization.sub_option_hero_mode_enabled,
        Description = gkbrkn_localization.sub_option_hero_mode_enabled_description,
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_hero_mode_orbs_difficulty,
        Description = gkbrkn_localization.sub_option_hero_mode_orbs_difficulty_description,
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode_orb_scale",
        RequiresRestart = true,
        ToggleCallback = function( enabled )
            if not enabled then
                RemoveFlagPersistent( MISC.HeroMode.CarnageDifficultyEnabled );
            end
        end
    },
    {
        Name = gkbrkn_localization.sub_option_hero_mode_distance_difficulty,
        Description = gkbrkn_localization.sub_option_hero_mode_distance_difficulty_description,
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode_distance_scale",
        RequiresRestart = true,
        ToggleCallback = function( enabled )
            if not enabled then
                RemoveFlagPersistent( MISC.HeroMode.CarnageDifficultyEnabled );
            end
        end
    },
    {
        Name = gkbrkn_localization.sub_option_hero_mode_carnage_difficulty,
        Description = gkbrkn_localization.sub_option_hero_mode_carnage_difficulty_description,
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode_carnage",
        RequiresRestart = true,
        ToggleCallback = function( enabled )
            if enabled then
                AddFlagPersistent( MISC.HeroMode.OrbsDifficultyEnabled );
                AddFlagPersistent( MISC.HeroMode.DistanceDifficultyEnabled );
            end
        end
    },
    {
        Name = gkbrkn_localization.option_loadouts,
        Description = gkbrkn_localization.option_loadouts_description,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_manage,
        Description = gkbrkn_localization.sub_option_loadouts_manage_description,
        PersistentFlag = "gkbrkn_loadouts_manage",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_enabled,
        Description = gkbrkn_localization.sub_option_loadouts_enabled_description,
        PersistentFlag = "gkbrkn_loadouts_enabled",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_selectable_classes_integration,
        Description = gkbrkn_localization.sub_option_selectable_classes_integration_description,
        PersistentFlag = MISC.Loadouts.SelectableClassesIntegration,
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_custom_cape_color,
        Description = gkbrkn_localization.sub_option_loadouts_custom_cape_color_description,
        PersistentFlag = "gkbrkn_loadouts_cape_color",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_loadouts_custom_player_sprites,
        Description = gkbrkn_localization.sub_option_loadouts_custom_player_sprites_description,
        PersistentFlag = "gkbrkn_loadouts_player_sprites",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_wands,
        Description = gkbrkn_localization.option_wands_description,
    },
    {
        Name = gkbrkn_localization.sub_option_legendary_wands,
        Description = gkbrkn_localization.sub_option_legendary_wands_description,
        PersistentFlag = MISC.LegendaryWands.Enabled,
        RequiresRestart = true,
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_loose_spell_generation,
        Description = gkbrkn_localization.sub_option_loose_spell_generation_description,
        PersistentFlag = "gkbrkn_loose_spell_generation",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_extended_wand_generation,
        Description = gkbrkn_localization.sub_option_extended_wand_generation_description,
        SubOption = true,
        PersistentFlag = "gkbrkn_extended_wand_generation",
    },
    {
        Name = gkbrkn_localization.sub_option_chaotic_wand_generation,
        Description = gkbrkn_localization.sub_option_chaotic_wand_generation_description,
        SubOption = true,
        PersistentFlag = "gkbrkn_chaotic_wand_generation",
    },
    {
        Name = gkbrkn_localization.sub_option_no_pregen_wands,
        Description = gkbrkn_localization.sub_option_no_pregen_wands_description,
        SubOption = true,
        PersistentFlag = "gkbrkn_no_pregen_wands",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.sub_option_passive_recharge,
        Description = gkbrkn_localization.sub_option_passive_recharge_description,
        PersistentFlag = "gkbrkn_passive_recharge",
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.option_health_bars,
        Description = gkbrkn_localization.option_health_bars_description,
    },
    {
        Name = gkbrkn_localization.sub_option_health_bars_enabled,
        Description = gkbrkn_localization.sub_option_health_bars_enabled_description,
        PersistentFlag = MISC.HealthBars.Enabled,
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.sub_option_health_bars_pretty_enabled,
        Description = gkbrkn_localization.sub_option_health_bars_pretty_enabled_description,
        PersistentFlag = MISC.HealthBars.PrettyHealthBarsEnabled,
        SubOption = true,
    },
    {
        Name = gkbrkn_localization.option_disable_random_spells,
        Description = gkbrkn_localization.option_disable_random_spells_description,
        PersistentFlag = "gkbrkn_disable_spells",
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_charm_nerf,
        Description = gkbrkn_localization.option_charm_nerf_description,
        PersistentFlag = "gkbrkn_charm_nerf",
    },
    {
        Name = gkbrkn_localization.option_quick_swap,
        Description = gkbrkn_localization.option_quick_swap_description,
        PersistentFlag = "gkbrkn_quick_swap",
    },
    {
        Name = gkbrkn_localization.option_chests_contain_perks,
        Description = gkbrkn_localization.option_chests_contain_perks_description,
        PersistentFlag = MISC.ChestsContainPerks.Enabled,
    },
    {
        Name = gkbrkn_localization.option_gold_decay,
        Description = gkbrkn_localization.option_gold_decay_description,
        PersistentFlag = "gkbrkn_gold_decay",
    },
    {
        Name = gkbrkn_localization.option_persistent_gold,
        Description = gkbrkn_localization.option_persistent_gold_description,
        PersistentFlag = "gkbrkn_persistent_gold",
    },
    {
        Name = gkbrkn_localization.option_auto_pickup_gold,
        Description = gkbrkn_localization.option_auto_pickup_gold_description,
        PersistentFlag = "gkbrkn_auto_pickup_gold",
    },
    {
        Name = gkbrkn_localization.option_combine_gold,
        Description = gkbrkn_localization.option_combine_gold_description,
        PersistentFlag = "gkbrkn_combine_gold",
    },
    {
        Name = gkbrkn_localization.option_target_dummy,
        Description = gkbrkn_localization.option_target_dummy_description,
        PersistentFlag = "gkbrkn_target_dummy",
    },
    {
        Name = gkbrkn_localization.option_slot_machine,
        Description = gkbrkn_localization.option_slot_machine_description,
        PersistentFlag = MISC.SlotMachine.Enabled,
    },
    {
        Name = gkbrkn_localization.option_events,
        Description = gkbrkn_localization.option_events_description,
        PersistentFlag = MISC.Events.Enabled,
    },
    {
        Name = gkbrkn_localization.option_show_fps,
        Description = gkbrkn_localization.option_show_fps_description,
        PersistentFlag = "gkbrkn_show_fps",
    },
    {
        Name = gkbrkn_localization.option_show_badges,
        Description = gkbrkn_localization.option_show_badges_description,
        PersistentFlag = "gkbrkn_show_badges",
        RequiresRestart = true,
        EnabledByDefault = true,
    },
    {
        Name = gkbrkn_localization.option_show_entity_names,
        Description = gkbrkn_localization.option_show_entity_names_description,
        PersistentFlag = MISC.ShowEntityNames.Enabled,
    },
    {
        Name = gkbrkn_localization.option_fixed_camera,
        Description = gkbrkn_localization.option_fixed_camera_description,
        PersistentFlag = MISC.FixedCamera.Enabled,
        RequiresRestart = true,
    },
    {
        Name = gkbrkn_localization.option_auto_hide,
        Description = gkbrkn_localization.option_auto_hide_description,
        PersistentFlag = "gkbrkn_auto_hide",
    },
    {
        Name = gkbrkn_localization.option_debug_mode,
        Description = gkbrkn_localization.option_debug_mode_description,
        PersistentFlag = FLAGS.DebugMode,
    },
    {
        Name = gkbrkn_localization.option_deprecated_content,
        Description = gkbrkn_localization.option_deprecated_content_description,
        PersistentFlag = FLAGS.ShowDeprecatedContent,
    }
}

local initialize_legendary_wand = function ( base_wand, x, y, level, force )
    for _,child in pairs( EntityGetAllChildren( base_wand ) or {} ) do
        EntityRemoveFromParent( child );
    end
    local shine = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand_shine.xml" );
    if shine ~= nil then
        EntityAddChild( base_wand, shine );
    end
    SetRandomSeed( GameGetFrameNum(), x + y );
    local valid_wands = {};
    local chosen_wand = force;
    if chosen_wand == nil then
        for _,content_id in pairs( LEGENDARY_WANDS ) do
            local content = CONTENT[content_id];
            if level == nil or ( level >= content.options.min_level and level <= content.options.max_level ) then
                table.insert( valid_wands, content_id );
            end
        end
        chosen_wand = valid_wands[Random( 1, #valid_wands )];
    end
    local content_data = CONTENT[chosen_wand];
    if content_data == nil then print("legendary wand error: no wand data found"); return; end
    initialize_wand( base_wand, content_data.options.wand_data );
    return base_wand;
end

local register_legendary_wand = function( id, name, author, wand_data, min_level, max_level, weight, custom_message, callback )
    local display_name = name;
    if author ~= nil then
        display_name = display_name .. " ("..author..")";
    end
    local content_id = register_content( CONTENT_TYPE.LegendaryWand, id, display_name, {
        name = name,
        author = author,
        wand_data = wand_data,
        min_level = min_level,
        max_level = max_level,
        weight = weight,
        custom_message = custom_message,
        callback = callback
    } );
    CONTENT[content_id].options.preview_callback = function( player_entity )
        local x, y = EntityGetTransform( player_entity );
        local wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml", x, y );
        initialize_legendary_wand( wand, x, y, nil, content_id );
    end
    LEGENDARY_WANDS[id] = content_id;
end

local register_loadout = function( id, name, author, cape_color, cape_color_edge, wands, potions, items, perks, actions, sprites, custom_message, callback, condition_callback )
    name = name or id;
    local display_name = string_trim(string.gsub( name, "TYPE", "" ));
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
        condition_callback = condition_callback
    } );
    CONTENT[content_id].options.preview_callback = function( player_entity )
        dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );
        handle_loadout( player_entity, CONTENT[content_id].options );
    end
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
                    spread_degrees = {30,30}, -- spread
                    mana_charge_speed = {1000,1000}, -- mana charge speed
                    mana_max = {5000,5000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "GKBRKN_TRIPLE_CAST" },
                    { "BUBBLESHOT" },
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
                    { "LIGHT_BULLET_TRIGGER" },
                    { "HITFX_CRITICAL_WATER" },
                    { "HITFX_CRITICAL_WATER" },
                    { "HITFX_CRITICAL_WATER" },
                    { "HITFX_CRITICAL_WATER" },
                    { "HITFX_CRITICAL_WATER" },
                    { "BURST_4" },
                    { "MATERIAL_WATER" },
                    { "CHAINSAW" },
                    { "CHAINSAW" },
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
                    { "GKBRKN_TRIPLE_CAST" },
                    { "GKBRKN_TRIPLE_CAST" },
                }
            },
            {
                name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 2, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {120,120}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {-1,-1}, -- spread
                mana_charge_speed = {200,200}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LONG_DISTANCE_CAST", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="TELEPORT_PROJECTILE", locked=false } },
                { { action="DELAYED_SPELL", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="TELEPORT_PROJECTILE", locked=false } },
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
            {"GKBRKN_STORED_SHOT"},
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
            local target_dummy = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x + 500, y - 80 );
            local effect = GetGameEffectLoadTo( player, "EDIT_WANDS_EVERYWHERE", true );
            if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end
            local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
            if inventory2 ~= nil then
                ComponentSetValue( inventory2, "full_inventory_slots_y", 5 );
            end
            EntityLoad( "data/entities/items/pickup/goldnugget_10000.xml", x + 50, y - 30 );
            --EntityAddComponent( player, "LuaComponent", {
            --    script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/regen.lua"
            --});
        end

    );
end

GKBRKN_CONFIG = {
    register_content = register_content,
    get_content = get_content,
    get_content_flag = get_content_flag,
    register_perk = register_perk,
    register_action = register_action,
    register_tweak = register_tweak,
    register_champion_type = register_champion_type,
    register_item = register_item,
    register_event = register_event,
    register_dynamic_event = register_dynamic_event,
    register_legendary_wand = register_legendary_wand,
    initialize_legendary_wand = initialize_legendary_wand,
    register_loadout = register_loadout,
};