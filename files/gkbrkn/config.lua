_GKBRKN_CONFIG = true;

CONTENT_TYPE = {
    Action = 1,
    Perk = 2,
    Misc = 3,
}

CONTENT_TYPE_PREFIX = {
    [CONTENT_TYPE.Action] = "action_",
    [CONTENT_TYPE.Perk] = "perk_",
    [CONTENT_TYPE.Misc] = "misc_",
}

CONTENT_TYPE_DISPLAY_NAME_PREFIX = {
    [CONTENT_TYPE.Action] = "Action: ",
    [CONTENT_TYPE.Perk] = "Perk: ",
    [CONTENT_TYPE.Misc] = "Misc: ",
}

CONTENT = {}
function register_content( type, key, display_name, options, disabled_by_default )
    local content_id = #CONTENT + 1;
    local content = {
        id = content_id,
        type = type,
        key = key,
        name = CONTENT_TYPE_DISPLAY_NAME_PREFIX[type]..display_name,
        disabled_by_default = disabled_by_default,
        enabled = function() return HasFlagPersistent( get_content_flag( content_id ) ) == false end,
        toggle = function( force )
            local flag = get_content_flag( content_id );
            if force == true then
                RemoveFlagPersistent( flag );
            elseif force == false then
                AddFlagPersistent( flag );
            else
                if HasFlagPersistent( flag ) then
                    RemoveFlagPersistent( flag );
                else
                    AddFlagPersistent( flag );
                end
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

SETTINGS = {
    Debug = DebugGetIsDevBuild(),
}

PERKS = {
    Enraged = register_content( CONTENT_TYPE.Perk, "enraged","Enraged" ),
    LivingWand = register_content( CONTENT_TYPE.Perk, "living_wand","Living Wand", {
        TeleportDistance = 128
    }, true ),
    DuplicateWand = register_content( CONTENT_TYPE.Perk, "duplicate_wand","Duplicate Wand" ),
    GoldenBlood = register_content( CONTENT_TYPE.Perk, "golden_blood","Golden Blood" ),
    SpellEfficiency = register_content( CONTENT_TYPE.Perk, "spell_efficiency","Spell Efficiency", {
        RetainChance = 0.33
    }, true ),
    MaterialCompression = register_content( CONTENT_TYPE.Perk, "material_compression","Material Compression" ),
    ManaEfficiency = register_content( CONTENT_TYPE.Perk, "mana_efficiency","Mana Efficiency", {
        Discount = 0.33
    }, true ),
    RapidFire = register_content( CONTENT_TYPE.Perk, "rapid_fire","Rapid Fire", {
        RechargeTimeAdjustment = function( rechargeTime ) return rechargeTime - rechargeTime * 0.50 / #hand end,
        CastDelayAdjustment = function( castDelay ) return castDelay - castDelay * 0.50 / #hand end,
        SpreadDegreesAdjustment = function( spreadDegrees ) return spreadDegrees + 12 / #hand end,
    } ),
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
    WIP = register_content( CONTENT_TYPE.Perk, "perk_wip","Work In Progress (Perk)", nil, true ),
}

ACTIONS = {
    ManaEfficiency = register_content( CONTENT_TYPE.Action, "mana_efficiency","Mana Efficiency", nil, true ),
    SpellEfficiency =  register_content( CONTENT_TYPE.Action, "spell_efficiency","Spell Efficiency", nil, true ),
    GoldenBlessing = register_content( CONTENT_TYPE.Action, "golden_blessing","Golden Blessing" ),
    MagicLight = register_content( CONTENT_TYPE.Action, "magic_light","Magic Light" ),
    Revelation = register_content( CONTENT_TYPE.Action, "revelation","Revelation" ),
    MicroShield = register_content( CONTENT_TYPE.Action, "micro_shield","Micro Shield", nil, true ),
    ModificationField = register_content( CONTENT_TYPE.Action, "modification_field","Modification Field" ),
    SpectralShot = register_content( CONTENT_TYPE.Action, "spectral_shot","Spectral Shot" ),
    ArcaneBuckshot = register_content( CONTENT_TYPE.Action, "arcane_buckshot","Arcane Buckshot", nil, true ),
    ArcaneShot = register_content( CONTENT_TYPE.Action, "arcane_shot","Arcane Shot", nil, true ),
    DoubleCast = register_content( CONTENT_TYPE.Action, "double_cast","Double Cast" ),
    SpellMerge = register_content( CONTENT_TYPE.Action, "spell_merge","Spell Merge" ),
    ExtraProjectile = register_content( CONTENT_TYPE.Action, "extra_projectile","Extra Projectile" ),
    OrderDeck = register_content( CONTENT_TYPE.Action, "order_deck","Order Deck" ),
    PerfectCritical = register_content( CONTENT_TYPE.Action, "perfect_critical","Perfect Critical" ),
    ProjectileBurst = register_content( CONTENT_TYPE.Action, "projectile_burst","Projectile Burst" ),
    TriggerHit = register_content( CONTENT_TYPE.Action, "trigger_hit","Trigger - Hit" ),
    TriggerTimer = register_content( CONTENT_TYPE.Action, "trigger_timer","Trigger - Timer" ),
    TriggerDeath = register_content( CONTENT_TYPE.Action, "trigger_death","Trigger - Death" ),
    DrawDeck = register_content( CONTENT_TYPE.Action, "draw_deck","Draw Deck" ),
    ProjectileEqualization = register_content( CONTENT_TYPE.Action, "projectile_equalization","Projectile Equalization" ),
    ProjectileGravityWell = register_content( CONTENT_TYPE.Action, "projectile_gravity_well","Projectile Gravity Well" ),
    LifetimeDamage = register_content( CONTENT_TYPE.Action, "damage_lifetime","Damage Plus - Lifetime" ),
    BounceDamage = register_content( CONTENT_TYPE.Action, "damage_bounce","Damage Plus - Bounce" ),
    PathCorrection = register_content( CONTENT_TYPE.Action, "path_correction","Path Correction" ),
    CollisionDetection = register_content( CONTENT_TYPE.Action, "collision_detection","Collection Detection" ),
    PowerShot = register_content( CONTENT_TYPE.Action, "power_shot","Power Shot" ),
    ShimmeringTreasure = register_content( CONTENT_TYPE.Action, "shimmering_treasure","Shimmering Treasure" ),
    NgonShape = register_content( CONTENT_TYPE.Action, "ngon_shape","N-gon Shape" ),
    ShuffleDeck = register_content( CONTENT_TYPE.Action, "shuffle_deck","Shuffle Deck" ),
    BreakCast = register_content( CONTENT_TYPE.Action, "break_cast","Break Cast" ),
    ProjectileOrbit = register_content( CONTENT_TYPE.Action, "projectile_orbit","Projectile Orbit" ),
    PassiveRecharge = register_content( CONTENT_TYPE.Action, "passive_recharge","Passive Recharge" ),
    ManaRecharge = register_content( CONTENT_TYPE.Action, "mana_recharge","Mana Recharge" ),
    SuperBounce = register_content( CONTENT_TYPE.Action, "super_bounce","Super Bounce" ),
    CopySpell = register_content( CONTENT_TYPE.Action, "copy_spell","Copy Spell" ),
    WIP = register_content( CONTENT_TYPE.Action, "action_wip","Work In Progress (Action)", nil, true )
}

OPTIONS = {
    {
        Name = "Gold Tracking",
    },
    {
        Name = "Show Log Message",
        PersistentFlag = "gkbrkn_gold_tracking_message",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Show In World",
        PersistentFlag = "gkbrkn_gold_tracking_in_world",
        SubOption = true,
        RequiresRestart = true,
        EnabledByDefault = true,
    },
    {
        Name = "Invincibility Frames",
    },
    {
        Name = "Enabled",
        PersistentFlag = "gkbrkn_invincibility_frames",
        SubOption = true,
        RequiresRestart = true,
    },
    {
        Name = "Show Flashing",
        PersistentFlag = "gkbrkn_invincibility_frames_flashing",
        SubOption = true,
        RequiresRestart = true,
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
        Name = "Enabled",
        PersistentFlag = "gkbrkn_random_start",
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
        Name = "Charm Nerf",
        PersistentFlag = "gkbrkn_charm_nerf",
        RequiresRestart = true,
    },
    {
        Name = "Any Spell On Any Wand",
        PersistentFlag = "gkbrkn_loose_spell_generation",
        RequiresRestart = true,
    },
    {
        Name = "Limited Ammo",
        PersistentFlag = "gkbrkn_limited_ammo",
        RequiresRestart = true,
    },
    {
        Name = "Disable Random Spells",
        PersistentFlag = "gkbrkn_disable_spells",
        RequiresRestart = true,
    },
    {
        Name = "Champion Enemies",
        PersistentFlag = "gkbrkn_champion_enemies",
    },
    {
        Name = "Quick Swap",
        PersistentFlag = "gkbrkn_quick_swap",
        RequiresRestart = true,
    },
    {
        Name = "Tweak Spells",
        PersistentFlag = "gkbrkn_tweak_spells",
        RequiresRestart = true,
    },
    {
        Name = "Wand Shops Only",
        PersistentFlag = "gkbrkn_wand_shops_only",
        RequiresRestart = true,
    },
    {
        Name = "Gold Nuggets -> Gold Powder",
        PersistentFlag = "gkbrkn_gold_decay",
    },
    {
        Name = "Show FPS",
        PersistentFlag = "gkbrkn_show_fps",
    }
}

MISC = {
    GoldPickupTracker = {
        TrackDuration = 120, -- in game frames
        ShowMessageEnabled = "gkbrkn_gold_tracking_message",
        ShowTrackerEnabled = "gkbrkn_gold_tracking_in_world",
    },
    CharmNerf = {
        Enabled = "gkbrkn_gold_tracking_in_world",
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
    DisableSpells = {
        Enabled = "gkbrkn_disable_spells",
    },
    ChampionEnemies = {
        Enabled = "gkbrkn_champion_enemies",
    },
    QuickSwap = {
        Enabled = "gkbrkn_quick_swap",
    },
    LessParticles = {
        Enabled = "gkbrkn_less_particles",
        DisableCosmeticParticles = "gkbrkn_less_particles_disable"
    },
    TweakSpells = {
        Enabled = "gkbrkn_tweak_spells",
    },
    RandomStart = {
        Enabled = "gkbrkn_random_start",
        RandomFlasks = 1,
        MinimumHP = 50,
        MaximumHP = 150,
        DefaultWandGenerationEnabled = "gkbrkn_random_start_default_wands",
        RandomCapeColorEnabled = "gkbrkn_random_start_random_cape",
    },
    WandShopsOnly = {
        Enabled = "gkbrkn_wand_shops_only",
    },
    ShowFPS = {
        Enabled = "gkbrkn_show_fps",
    },
    GoldDecay = {
        Enabled = "gkbrkn_gold_decay",
    }
}

--LogTableCompact( map( function( o ) return o.name end, CONTENT ) );
--LogTableCompact( map( function( o ) return o.name end, CONTENT ) );
