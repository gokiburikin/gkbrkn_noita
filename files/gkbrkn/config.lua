SETTINGS = {
    Debug = DebugGetIsDevBuild(),
}

PERKS = {
    Enraged = {
        Enabled = true,
    },
    LivingWand = { -- NYI
        Enabled = true,
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
    }
}

ACTIONS = {
    ManaEfficiency = {
        Enabled = false,
        Discount = 0.50,
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
    }
}

MISC = {
    GoldPickupTracker = {
        Enabled = true,
        TrackDuration = 120, -- in game frames
        ShowMessage=false,
        ShowTracker=true
    }
}