SETTINGS = {
    Debug = DebugGetIsDevBuild(),
}

PERKS = {
    Enraged = {
        Enabled = true,
    },
    LivingWand = { -- NYI
        Enabled = true,
        TeleportDistance = 128,
    }, 
    Duplicate = {
        Enabled = true,
    },
    BleedGold = {
        Enabled = true,
    },
    SpellEfficiency = {
        Enabled = true,
        RetainChance = 0.33,
    },
    ManaEfficiency = {
        Enabled = true,
        Discount = 0.20,
    },
    RapidFire = {
        Enabled = true,
        RechargeTimeAdjustment = function( rechargeTime ) return rechargeTime * 0.5 end,
        CastDelayAdjustment = function( castDelay ) return castDelay * 0.5 end,
        SpreadDegreesAdjustment = function( spreadDegrees ) return spreadDegrees + 8 end,
    },
    Sturdy = {
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
    Curse = {
        Enabled = true,
    },
    MagicLight = {
        Enabled = true,
    },
    MicroShield = {
        Enabled = true,
    },
    Spectral = {
        Enabled = true,
    },
    Buckshot = { -- Deprecated
        Enabled = false,
    },
    SniperShot = {
        Enabled = false,
    },
    Multiply = {
        Enabled = false,
    },
    SpellMerge = {
        Enabled = true,
    },
    ExtraProjectile = {
        Enabled = true,
    },
    GuaranteedCritical = {
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
    Orbit = {
        Enabled = true,
    },
    LifetimeDamage = {
        Enabled = true,
    },
    BounceDamage = {
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
        Enabled = true,
    }
}