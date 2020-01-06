register_legendary_wand( "blink_back", "Wormhole", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 2, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {7,7}, -- capacity
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
        { { action="LONG_DISTANCE_CAST", locked=true } },
        { { action="LIFETIME_DOWN", locked=true } },
        { { action="LIFETIME_DOWN", locked=true } },
        { { action="TELEPORT_PROJECTILE", locked=true } },
        { { action="DELAYED_SPELL", locked=true } },
        { { action="LIFETIME_DOWN", locked=true } },
        { { action="LIFETIME_DOWN", locked=true } },
        { { action="TELEPORT_PROJECTILE", locked=true } },
    }
} );