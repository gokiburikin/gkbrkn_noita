dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");

SETTINGS = {
    Debug = DebugGetIsDevBuild(),
    ShowDeprecatedContent = false,
    Version = "c65"
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
    [CONTENT_TYPE.Action] = "Action",
    [CONTENT_TYPE.Perk] = "Perk",
    --[CONTENT_TYPE.Misc] = "Misc",
    [CONTENT_TYPE.Tweak] = "Tweak",
    [CONTENT_TYPE.ChampionType] = "Champion",
    [CONTENT_TYPE.Item] = "Item",
    [CONTENT_TYPE.Loadout] = "Loadout",
    [CONTENT_TYPE.StartingPerk] = "Starting Perk",
}

CONTENT = {};
function register_content( type, key, display_name, options, disabled_by_default, deprecated, inverted )
    local content_id = #CONTENT + 1;
    local content = {
        id = content_id,
        type = type,
        key = key,
        name = CONTENT_TYPE_DISPLAY_NAME[type]..": "..display_name,
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

PERKS = {
    ShortTemper = register_content( CONTENT_TYPE.Perk, "short_temper","Short Temper" ),
    LivingWand = register_content( CONTENT_TYPE.Perk, "living_wand","Living Wand", {
        TeleportDistance = 128
    }, true, true ),
    DuplicateWand = register_content( CONTENT_TYPE.Perk, "duplicate_wand","Duplicate Wand" ),
    GoldenBlood = register_content( CONTENT_TYPE.Perk, "golden_blood","Golden Blood", nil, true, true ),
    SpellEfficiency = register_content( CONTENT_TYPE.Perk, "spell_efficiency","Spell Efficiency", {
        RetainChance = 0.33
    }, true, true ),
    MaterialCompression = register_content( CONTENT_TYPE.Perk, "material_compression","Material Compression" ),
    ManaEfficiency = register_content( CONTENT_TYPE.Perk, "mana_efficiency","Mana Efficiency", {
        Discount = 0.33
    }, true, true ),
    RapidFire = register_content( CONTENT_TYPE.Perk, "rapid_fire","Rapid Fire" ),
    KnockbackImmunity = register_content( CONTENT_TYPE.Perk, "knockback_immunity","Knockback Immunity" ),
    Resilience = register_content( CONTENT_TYPE.Perk, "resilience","Resilience", { Resistances = {
        fire=0.35,
        radioactive=0.35,
        poison=0.35,
        electricity=0.35,
        ice=0.35,
    }} ),
    PassiveRecharge = register_content( CONTENT_TYPE.Perk, "passive_recharge","Passive Recharge" ),
    LostTreasure = register_content( CONTENT_TYPE.Perk, "lost_treasure","Lost Treasure" ),
    AlwaysCast = register_content( CONTENT_TYPE.Perk, "always_cast","Always Cast" ),
    HealthierHeart = register_content( CONTENT_TYPE.Perk, "healthier_heart","Healthier Heart" ),
    InvincibilityFrames = register_content( CONTENT_TYPE.Perk, "invincibility_frames","Invincibility Frames" ),
    ExtraProjectile = register_content( CONTENT_TYPE.Perk, "extra_projectile","Extra Projectile" ),
    ManaRecovery = register_content( CONTENT_TYPE.Perk, "mana_recovery","Mana Recovery" ),
    Protagonist = register_content( CONTENT_TYPE.Perk, "protagonist","Protagonist" ),
    FragileEgo = register_content( CONTENT_TYPE.Perk, "fragile_ego","Fragile Ego" ),
    ThriftyShopper = register_content( CONTENT_TYPE.Perk, "thrifty_shopper","Thrifty Shopper" ),
    Swapper = register_content( CONTENT_TYPE.Perk, "swapper","Swapper" ),
    Demolitionist = register_content( CONTENT_TYPE.Perk, "demolitionist","Demolitionist" ),
    Multicast = register_content( CONTENT_TYPE.Perk, "multicast","Multicast" ),
    MagicLight = register_content( CONTENT_TYPE.Perk, "magic_light","Magic Light", nil, true, true ),
    WIP = register_content( CONTENT_TYPE.Perk, "perk_wip","Work In Progress (Perk)", nil, true, not SETTINGS.Debug ),
}

ACTIONS = {
    ManaEfficiency = register_content( CONTENT_TYPE.Action, "mana_efficiency","Mana Efficiency", nil, true, true ),
    SpellEfficiency =  register_content( CONTENT_TYPE.Action, "spell_efficiency","Spell Efficiency", nil, true, true ),
    GoldenBlessing = register_content( CONTENT_TYPE.Action, "golden_blessing","Golden Blessing", nil, true, true ),
    MagicLight = register_content( CONTENT_TYPE.Action, "magic_light","Magic Light" ),
    Revelation = register_content( CONTENT_TYPE.Action, "revelation","Revelation" ),
    MicroShield = register_content( CONTENT_TYPE.Action, "micro_shield","Micro Shield", nil, true, true ),
    ModificationField = register_content( CONTENT_TYPE.Action, "modification_field","Modification Field" ),
    SpectralShot = register_content( CONTENT_TYPE.Action, "spectral_shot","Spectral Shot", nil, true, true ),
    ArcaneBuckshot = register_content( CONTENT_TYPE.Action, "arcane_buckshot","Arcane Buckshot", nil, true, true ),
    ArcaneShot = register_content( CONTENT_TYPE.Action, "arcane_shot","Arcane Shot", nil, true, true ),
    DoubleCast = register_content( CONTENT_TYPE.Action, "double_cast","Double Cast" ),
    SpellMerge = register_content( CONTENT_TYPE.Action, "spell_merge","Spell Merge" ),
    ExtraProjectile = register_content( CONTENT_TYPE.Action, "extra_projectile","Extra Projectile" ),
    OrderDeck = register_content( CONTENT_TYPE.Action, "order_deck","Order Deck" ),
    PerfectCritical = register_content( CONTENT_TYPE.Action, "perfect_critical","Perfect Critical" ),
    ProjectileBurst = register_content( CONTENT_TYPE.Action, "projectile_burst","Projectile Burst" ),
    TriggerHit = register_content( CONTENT_TYPE.Action, "trigger_hit","Trigger - Hit" ),
    TriggerTimer = register_content( CONTENT_TYPE.Action, "trigger_timer","Trigger - Timer" ),
    TriggerDeath = register_content( CONTENT_TYPE.Action, "trigger_death","Trigger - Death" ),
    DrawDeck = register_content( CONTENT_TYPE.Action, "draw_deck","Draw Deck", nil, true, true ),
    ProjectileGravityWell = register_content( CONTENT_TYPE.Action, "projectile_gravity_well","Projectile Gravity Well" ),
    LifetimeDamage = register_content( CONTENT_TYPE.Action, "damage_lifetime","Damage Plus - Lifetime" ),
    BounceDamage = register_content( CONTENT_TYPE.Action, "damage_bounce","Damage Plus - Bounce" ),
    PathCorrection = register_content( CONTENT_TYPE.Action, "path_correction","Path Correction" ),
    CollisionDetection = register_content( CONTENT_TYPE.Action, "collision_detection","Collision Detection" ),
    PowerShot = register_content( CONTENT_TYPE.Action, "power_shot","Power Shot" ),
    ShimmeringTreasure = register_content( CONTENT_TYPE.Action, "shimmering_treasure","Shimmering Treasure" ),
    NgonShape = register_content( CONTENT_TYPE.Action, "ngon_shape","N-gon Shape", nil, true, true ),
    ShuffleDeck = register_content( CONTENT_TYPE.Action, "shuffle_deck","Shuffle Deck", nil, true, true ),
    BreakCast = register_content( CONTENT_TYPE.Action, "break_cast","Break Cast" ),
    ProjectileOrbit = register_content( CONTENT_TYPE.Action, "projectile_orbit","Projectile Orbit" ),
    PassiveRecharge = register_content( CONTENT_TYPE.Action, "passive_recharge","Passive Recharge" ),
    ManaRecharge = register_content( CONTENT_TYPE.Action, "mana_recharge","Mana Recharge" ),
    SuperBounce = register_content( CONTENT_TYPE.Action, "super_bounce","Super Bounce" ),
    CopySpell = register_content( CONTENT_TYPE.Action, "copy_spell","Copy Spell" ),
    TimeSplit = register_content( CONTENT_TYPE.Action, "time_split","Time Split" ),
    FormationStack = register_content( CONTENT_TYPE.Action, "formation_stack","Formation Stack" ),
    PiercingShot = register_content( CONTENT_TYPE.Action, "piercing_shot","Piercing Shot", nil, true, true ),
    WIP = register_content( CONTENT_TYPE.Action, "action_wip","Work In Progress (Action)", nil, true, not SETTINGS.Debug )
}

TWEAKS = {
    Chainsaw = register_content( CONTENT_TYPE.Tweak, "chainsaw","Chainsaw", { action_id="CHAINSAW" }, true, nil, true ),
    HeavyShot = register_content( CONTENT_TYPE.Tweak, "heavy_shot","Heavy Shot", { action_id="HEAVY_SHOT" }, true, nil, true ),
    Damage = register_content( CONTENT_TYPE.Tweak, "damage","Damage Plus", { action_id="DAMAGE" }, true, nil, true ),
    Freeze = register_content( CONTENT_TYPE.Tweak, "freeze","Freeze Charge", { action_id="FREEZE" }, true, nil, true ),
    IncreaseMana = register_content( CONTENT_TYPE.Tweak, "increase_mana","Increase Mana", { action_id="MANA_REDUCE" }, true, nil, true ),
    Blindness = register_content( CONTENT_TYPE.Tweak, "blindness","Shorten Blindness", nil, true, true, true ),
    RevengeExplosion = register_content( CONTENT_TYPE.Tweak, "revenge_explosion","Revenge Explosion",  { perk_id="REVENGE_EXPLOSION" }, true, true, true ),
    GlassCannon = register_content( CONTENT_TYPE.Tweak, "glass_cannon", "Glass Cannon",  { perk_id="GLASS_CANNON" }, true ),
    AreaDamage = register_content( CONTENT_TYPE.Tweak, "area_damage", "Damage Field",  { action_id="AREA_DAMAGE" }, true ),
}

LOADOUTS = {}

CHAMPION_TYPES = {
    Damage = register_content( CONTENT_TYPE.ChampionType, "damage", "Damage Buff", {
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
    Projectile = register_content( CONTENT_TYPE.ChampionType, "projectile", "Projectile Buff", {
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
    Haste = register_content( CONTENT_TYPE.ChampionType, "haste", "Haste", {
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
    Fast = register_content( CONTENT_TYPE.ChampionType, "fast", "Fast", {
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
    Teleport = register_content( CONTENT_TYPE.ChampionType, "teleport", "Teleport", {
        particle_material = "spark_white",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/teleporting.xml",
        game_effects = {"TELEPORTATION","TELEPORTITIS"},
        validator = function( entity ) return true end,
    }),
    Burning = register_content( CONTENT_TYPE.ChampionType, "burning", "Burning", {
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
    Freezing = register_content( CONTENT_TYPE.ChampionType, "freezing", "Freezing", {
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
    Shoot = register_content( CONTENT_TYPE.ChampionType, "shoot", "Shoot (NYI)", {
        particle_material = "spark_purple",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/champion.xml",
        game_effects = {},
        validator = function( entity ) return true end,
    }, true, true),
    -- TODO Update this when Invisible game effect doesn't crash
    Invisible = register_content( CONTENT_TYPE.ChampionType, "invisible", "Invisible", {
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
    Loot = register_content( CONTENT_TYPE.ChampionType, "loot", "Loot (NYI)", {
        particle_material = "spark_white",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/champion.xml",
        game_effects = {},
        validator = function( entity ) return true end,
    }, true, true),
    Regeneration = register_content( CONTENT_TYPE.ChampionType, "regeneration", "Regeneration", {
        particle_material = "spark_green",
        sprite_particle_sprite_file = "data/particles/heal.xml",
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/regeneration.xml",
        game_effects = {},
        validator = function( entity ) return true end,
        apply = function( entity )
            EntityAddComponent( entity, "LuaComponent", { 
                script_source_file = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/regeneration.lua",
                execute_every_n_frame = "5",
            } );
        end
    }),
    WormBait = register_content( CONTENT_TYPE.ChampionType, "worm_bait", "Worm Bait", {
        particle_material = "meat",
        sprite_particle_sprite_file = nil,
        badge = "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/champion.xml",
        game_effects = {"WORM_ATTRACTOR"},
        validator = function( entity ) return true end,
    }, true, true ),
    RevengeExplosion = register_content( CONTENT_TYPE.ChampionType, "revenge_explosion", "Revenge Explosion", {
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
    EnergyShield = register_content( CONTENT_TYPE.ChampionType, "energy_shield", "Energy Shield", {
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
    Electricity = register_content( CONTENT_TYPE.ChampionType, "electricity", "Electricity", {
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
    ProjectileRepulsionField = register_content( CONTENT_TYPE.ChampionType, "projectile_repulsion_field", "Projectile Repulsion Field", {
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
    Healthy = register_content( CONTENT_TYPE.ChampionType, "healthy", "Healthy", {
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
    HotBlooded = register_content( CONTENT_TYPE.ChampionType, "hot_blooded", "Hot Blooded", {
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
    ProjectileBounce = register_content( CONTENT_TYPE.ChampionType, "projectile_bounce", "Projectile Bounce", {
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
    Eldritch = register_content( CONTENT_TYPE.ChampionType, "eldritch", "Eldritch", {
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
                        attack_ranged_max_distance="150",
                        attack_ranged_entity_file="data/entities/projectiles/tongue.xml",
                        attack_ranged_offset_x="0",
                        attack_ranged_offset_y="0",
                        attack_ranged_enabled="1",
                    });
                end
            end
        end
    }),
    InvincibilityFrames = register_content( CONTENT_TYPE.ChampionType, "invincibility_frames", "Invincibility Frames", {
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
    ToxicTrail = register_content( CONTENT_TYPE.ChampionType, "toxic_trail", "Toxic Trail", {
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
    Counter = register_content( CONTENT_TYPE.ChampionType, "counter", "Counter", {
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

OPTIONS = {
    {
        Name = "Gold Tracking",
    },
    {
        Name = "Show Log Message",
        PersistentFlag = "gkbrkn_gold_tracking_message",
        SubOption = true,
    },
    {
        Name = "Show In World",
        PersistentFlag = "gkbrkn_gold_tracking_in_world",
        SubOption = true,
        EnabledByDefault = true,
    },
    {
        Name = "Invincibility Frames",
    },
    {
        Name = "Enabled",
        PersistentFlag = "gkbrkn_invincibility_frames",
        SubOption = true,
    },
    {
        Name = "Show Flashing",
        PersistentFlag = "gkbrkn_invincibility_frames_flashing",
        SubOption = true,
    },
    {
        Name = "Heal New Health",
    },
    {
        Name = "Enabled",
        PersistentFlag = "gkbrkn_max_health_heal",
        SubOption = true,
    },
    {
        Name = "Heal To Full",
        PersistentFlag = "gkbrkn_max_health_heal_full",
        SubOption = true,
    },
    {
        Name = "Less Particles",
    },
    {
        Name = "Enabled",
        PersistentFlag = "gkbrkn_less_particles",
        SubOption = true,
        ToggleCallback = function()
            for _,entity in pairs( EntityGetWithTag("gkbrkn_less_particles") or {} ) do
                EntityRemoveTag( entity, "gkbrkn_less_particles" );
            end
        end
    },
    {
        Name = "Disable Cosmetic Particles",
        PersistentFlag = "gkbrkn_less_particles_disable",
        SubOption = true,
        ToggleCallback = function()
            for _,entity in pairs( EntityGetWithTag("gkbrkn_less_particles") or {} ) do
                EntityRemoveTag( entity, "gkbrkn_less_particles" );
            end
        end
    },
    {
        Name = "Random Start",
    },
    {
        Name = "Random Wands",
        PersistentFlag = "gkbrkn_random_start_random_wand",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Default Wand Generation",
        PersistentFlag = "gkbrkn_random_start_default_wands",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Random Cape Colour",
        PersistentFlag = "gkbrkn_random_start_random_cape",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Random Health",
        PersistentFlag = "gkbrkn_random_start_random_health",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Random Flask",
        PersistentFlag = "gkbrkn_random_start_random_flask",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Random Perk",
        PersistentFlag = "gkbrkn_random_start_random_perk",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Champion Enemies",
    },
    {
        Name = "Enabled",
        SubOption = true,
        PersistentFlag = "gkbrkn_champion_enemies",
        RequiresRestart = true,
    },
    {
        Name = "Super Champions",
        SubOption = true,
        PersistentFlag = "gkbrkn_champion_enemies_super",
        RequiresRestart = true,
    },
    {
        Name = "Champions Only",
        SubOption = true,
        PersistentFlag = "gkbrkn_champion_enemies_always",
        RequiresRestart = true,
    },
    {
        Name = "Hero Mode",
    },
    {
        Name = "Enabled",
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode",
        RequiresRestart = true,
    },
    {
        Name = "Orbs Increase Difficulty",
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode_orb_scale",
        RequiresRestart = true,
    },
    {
        Name = "Distance Increases Difficulty",
        SubOption = true,
        PersistentFlag = "gkbrkn_hero_mode_distance_scale",
        RequiresRestart = true,
    },
    {
        Name = "Loadouts",
    },
    {
        Name = "Manage",
        PersistentFlag = "gkbrkn_loadouts_manage",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Enable Loadouts",
        PersistentFlag = "gkbrkn_loadouts_enabled",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Use Custom Cape Color",
        PersistentFlag = "gkbrkn_loadouts_cape_color",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Use Custom Player Sprites",
        PersistentFlag = "gkbrkn_loadouts_player_sprites",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Disable Random Spells",
        PersistentFlag = "gkbrkn_disable_spells",
        RequiresRestart = true,
    },
    {
        Name = "Charm Nerf",
        PersistentFlag = "gkbrkn_charm_nerf",
    },
    {
        Name = "Limited Ammo",
        PersistentFlag = "gkbrkn_limited_ammo",
        RequiresRestart = true,
    },
    {
        Name = "Unlimited Ammo",
        PersistentFlag = "gkbrkn_unlimited_ammo",
        RequiresRestart = true,
    },
    {
        Name = "Quick Swap",
        PersistentFlag = "gkbrkn_quick_swap",
    },
    {
        Name = "Wands Recharge While Holstered",
        PersistentFlag = "gkbrkn_passive_recharge",
    },
    {
        Name = "Wand Shops Only",
        PersistentFlag = "gkbrkn_wand_shops_only",
    },
    {
        Name = "Any Spell On Any Wand",
        PersistentFlag = "gkbrkn_loose_spell_generation",
        RequiresRestart = true,
    },
    {
        Name = "Extended Wand Generation",
        PersistentFlag = "gkbrkn_extended_wand_generation",
    },
    {
        Name = "Chaotic Wand Generation",
        PersistentFlag = "gkbrkn_chaotic_wand_generation",
    },
    {
        Name = "No Preset Wands",
        PersistentFlag = "gkbrkn_no_pregen_wands",
        RequiresRestart = true,
    },
    {
        Name = "Gold Nuggets -> Gold Powder",
        PersistentFlag = "gkbrkn_gold_decay",
    },
    {
        Name = "Target Dummy",
        PersistentFlag = "gkbrkn_target_dummy",
    },
    {
        Name = "Health Bars",
        PersistentFlag = "gkbrkn_health_bars",
    },
    {
        Name = "Show FPS",
        PersistentFlag = "gkbrkn_show_fps",
    },
    {
        Name = "Show Badges",
        PersistentFlag = "gkbrkn_show_badges",
        RequiresRestart = true,
        EnabledByDefault = true,
    },
    {
        Name = "Auto-hide Config Menu",
        PersistentFlag = "gkbrkn_auto_hide",
        RequiresRestart = true,
    }
}

ITEMS = {
    SpellBag = register_content( CONTENT_TYPE.Item, "spell_bag","Spell Bag", nil, true, nil, true ),
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
    GoldDecay = {
        Enabled = "gkbrkn_gold_decay",
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
        "Debug TYPE", -- displayed loadout name
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
                    { "TELEPORT_PROJECTILE" },
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
                    deck_capacity = {12,12}, -- capacity
                    reload_time = {34,34}, -- recharge time in frames
                    fire_rate_wait = {20,20}, -- cast delay in frames
                    spread_degrees = {-4,-4}, -- spread
                    mana_charge_speed = {163,163}, -- mana charge speed
                    mana_max = {530,530}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "MANA_REDUCE" },
                    { "LUMINOUS_DRILL" },
                    { "LASER_LUMINOUS_DRILL" },
                    { "RECHARGE" },
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
            {"GKBRKN_ACTION_WIP"},
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