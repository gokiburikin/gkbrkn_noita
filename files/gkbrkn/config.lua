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
        RechargeTimeAdjustment = function( rechargeTime ) return rechargeTime * 0.5 end,
        CastDelayAdjustment = function( castDelay ) return castDelay * 0.5 end,
        SpreadDegreesAdjustment = function( spreadDegrees ) return spreadDegrees + 8 end,
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
    NgonPattern = {
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

MISC = {
    GoldPickupTracker = {
        Enabled = true,
        TrackDuration = 120, -- in game frames
        ShowMessage = false,
        ShowTracker = true
    },
    CharmNerf = {
        Enabled = false,
    },
    InvincibilityFrames = {
        Enabled = false,
        Duration = 40,
        Flash = true,
    },
    HealOnMaxHealthUp = {
        Enabled = false,
        HealToMax = false
    },
    LooseSpellGeneration = {
        Enabled = false,
    },
    LimitedAmmo = {
        Enabled = false,
    }
}
