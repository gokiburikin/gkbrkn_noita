_GKBRKN_CONFIG = true;

SETTINGS = {
    Debug = DebugGetIsDevBuild(),
}

PERKS = {
    Enraged = {
        Enabled = true,
    },
    LivingWand = { -- NYI
        Enabled = false,
        TeleportDistance = 128,
    }, 
    DuplicateWand = {
        Enabled = true,
    },
    GoldenBlood = {
        Enabled = true,
    },
    SpellEfficiency = {
        Enabled = true,
        RetainChance = 0.33,
    },
    ManaEfficiency = {
        Enabled = true,
        Discount = 0.33,
    },
    RapidFire = {
        Enabled = true,
        RechargeTimeAdjustment = function( rechargeTime ) return rechargeTime * 0.33 end,
        CastDelayAdjustment = function( castDelay ) return castDelay * 0.33 end,
        SpreadDegreesAdjustment = function( spreadDegrees ) return spreadDegrees + 12 end,
    },
    KnockbackImmunity = {
        Enabled = true,
    },
    Resilience = {
        Enabled = true,
        Resistances = {
            fire=0.35,
            radioactive=0.35,
            poison=0.35,
            electricity=0.35,
            ice=0.35,
        },
    },
    LostTreasure = {
        Enabled = true,
    }
}

ACTIONS = {
    ManaEfficiency = {
        Enabled = false,
        Discount = 0.50,
    },
    SpellEfficiency = {
        Enabled = false,
        RetainChance = 0.66,
    },
    GoldenBlessing = {
        Enabled = true,
    },
    MagicLight = {
        Enabled = true,
    },
    Revelation = {
        Enabled = true,
    },
    MicroShield = {
        Enabled = true,
    },
    SpectralShot = {
        Enabled = true,
    },
    Buckshot = { -- Deprecated
        Enabled = false,
    },
    SniperShot = {
        Enabled = false,
    },
    DuplicateSpell = {
        Enabled = true,
    },
    SpellMerge = {
        Enabled = true,
    },
    ExtraProjectile = {
        Enabled = true,
    },
    PerfectCritical = {
        Enabled = true,
    },
    ProjectileBurst = {
        Enabled = true,
    },
    TriggerHit = {
        Enabled = true,
    },
    TriggerTimer = {
        Enabled = true,
    },
    TriggerDeath = {
        Enabled = true,
    },
    DrawDeck = {
        Enabled = true,
    },
    ProjectileGravityWell = {
        Enabled = true,
    },
    LifetimeDamage = {
        Enabled = true,
    },
    BounceDamage = {
        Enabled = true,
    },
    PathCorrection = {
        Enabled = true,
    },
    CollisionDetection = {
        Enabled = true,
    },
    PowerShot = {
        Enabled = true,
    },
    ShimmeringTreasure = {
        Enabled = true,
    },
    NgonShape = {
        Enabled = true,
    },
    ShuffleDeck = {
        Enabled = true,
    },
    BreakCast = {
        Enabled = true,
    },
    ProjectileOrbit = {
        Enabled = true,
    },
    Test = {
        Enabled = SETTINGS.Debug
    }
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
        Name = "Quick Swap",
        PersistentFlag = "gkbrkn_quick_swap",
        RequiresRestart = true,
    },
    {
        Name = "Less Particles",
        PersistentFlag = "gkbrkn_less_particles",
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
        HealToMaxEnabled = "gkbrkn_max_health_heal_full",
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
    QuickSwap = {
        Enabled = "gkbrkn_quick_swap",
    },
    LessParticles = {
        Enabled = "gkbrkn_less_particles",
    }
}