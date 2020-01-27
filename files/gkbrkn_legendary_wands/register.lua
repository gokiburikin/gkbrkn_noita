local register_legendary_wand = GKBRKN_CONFIG.register_legendary_wand;

register_legendary_wand( "blink_back", "Wormhole", "goki", {
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

register_legendary_wand( "telefragger", "Telefragger", "Ivylistar", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {20,20}, -- capacity
        reload_time = {60,60}, -- recharge time in frames
        fire_rate_wait = {30,30}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {250,250}, -- mana charge speed
        mana_max = {600,600}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
    },
    actions = {
        { { action="LIGHT_BULLET_TIMER", locked=true } },
        { { action="TELEPORT_CAST", locked=true } },
        { { action="DAMAGE", locked=true } },
        { { action="GKBRKN_TIME_COMPRESSION", locked=true } },
        { { action="GKBRKN_TRIGGER_DEATH", locked=true } },
        { { action="TELEPORT_PROJECTILE", locked=true } },
        { { action="TELEPORT_CAST", locked=true } },
        { { action="DAMAGE", locked=true } },
        { { action="GKBRKN_TIME_COMPRESSION", locked=true } },
        { { action="GKBRKN_TRIGGER_DEATH", locked=true } },
        { { action="TELEPORT_PROJECTILE", locked=true } },
        { { action="TELEPORT_CAST", locked=true } },
        { { action="DAMAGE", locked=true } },
        { { action="GKBRKN_TIME_COMPRESSION", locked=true } },
        { { action="GKBRKN_TRIGGER_DEATH", locked=true } },
        { { action="TELEPORT_PROJECTILE", locked=true } },
    }
} );

register_legendary_wand( "alchemic_lance", "Alchemic Lance", "liliumpop", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {8,8}, -- capacity
        reload_time = {27,27}, -- recharge time in frames
        fire_rate_wait = {27,27}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {120,120}, -- mana charge speed
        mana_max = {400,400}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
    },
    actions = {
        { { action="GKBRKN_SPELL_MERGE", locked=true } },
        { { action="WATER_TO_POISON", locked=true } },
        { { action="LAVA_TO_BLOOD", locked=true } },
        { { action="BLOOD_TO_ACID", locked=true } },
        { { action="TOXIC_TO_ACID", locked=true } },
        { { action="GKBRKN_NUGGET_SHOT", locked=true } },
        { { action="LANCE", locked=true } },
    }
} );

register_legendary_wand( "endless_alchemy", "Endless Alchemy", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {3,3}, -- capacity
        reload_time = {16,16}, -- recharge time in frames
        fire_rate_wait = {12,12}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {40,40}, -- mana charge speed
        mana_max = {120,120}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
        { "TRANSMUTATION" },
        { "ACIDSHOT" },
    },
    actions = {
    }
} );

register_legendary_wand( "pocket_black_hole", "Pocket Black Hole", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {3,3}, -- capacity
        reload_time = {60,60}, -- recharge time in frames
        fire_rate_wait = {60,60}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {0,0}, -- mana charge speed
        mana_max = {0,0}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
        { "GKBRKN_CARRY_SHOT" },
        { "BLACK_HOLE" },
    },
    actions = {
    }
} );

register_legendary_wand( "magic_popcorn", "Magic Popcorn", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {7,7}, -- capacity
        reload_time = {14,14}, -- recharge time in frames
        fire_rate_wait = {14,14}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {100,100}, -- mana charge speed
        mana_max = {300,300}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
    },
    actions = {
        { "KNOCKBACK" },
        { "GRAVITY" },
        { "BUBBLESHOT_TRIGGER" },
        { "HEAVY_SPREAD" },
        { "GRAVITY_ANTI" },
        { "BUBBLESHOT" },
    },
} );

register_legendary_wand( "spirit_familiar", "Spirit Familiar", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {9,9}, -- capacity
        reload_time = {180,180}, -- recharge time in frames
        fire_rate_wait = {120,120}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {30,30}, -- mana charge speed
        mana_max = {150,150}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
        { "GKBRKN_BOUND_SHOT" },
    },
    actions = {
        { "LIGHT" },
        { "CHAOTIC_ARC" },
        { "SINEWAVE" },
        { "GKBRKN_GUIDED_SHOT" },
        { "GKBRKN_CLINGING_SHOT" },
        { "AVOIDING_ARC" },
        { "HOMING_SHOOTER" },
        { "DEATH_CROSS" },
    }
} );

register_legendary_wand( "noitius", "Noitius", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {9,9}, -- capacity
        reload_time = {15,15}, -- recharge time in frames
        fire_rate_wait = {15,15}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {300,300}, -- mana charge speed
        mana_max = {102,102}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
    },
    actions = {
        { { action="GKBRKN_PERSISTENT_SHOT", locked=true } },
        { { action="GKBRKN_FORMATION_STACK", locked=true } },
        { { action="BURST_4", locked=true } },
        { { action="RUBBER_BALL", locked=true } },
        { { action="LIGHT_BULLET", locked=true } },
        { { action="BULLET", locked=true } },
        { { action="BULLET", locked=true } },
        { { action="LIGHT_BULLET", locked=true } },
        { { action="RUBBER_BALL", locked=true } },
    }
} );

register_legendary_wand( "matra_magic", "Matra Magic", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {8,8}, -- capacity
        reload_time = {15,15}, -- recharge time in frames
        fire_rate_wait = {15,15}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {1000,1000}, -- mana charge speed
        mana_max = {300,300}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
    },
    actions = {
        { { action="ACCELERATING_SHOT", locked=true } },
        { { action="GKBRKN_PERSISTENT_SHOT", locked=true } },
        { { action="GKBRKN_PERSISTENT_SHOT", locked=true } },
        { { action="CHAOTIC_ARC", locked=true } },
        { { action="GKBRKN_CHAIN_CAST", locked=true } },
        { { action="HEAVY_SPREAD", locked=true } },
        { { action="LASER", locked=true } },
    }
} );

register_legendary_wand( "tabula_rasa", "Tabula Rasa", "goki", {
    name = "Wand",
    stats = {
        shuffle_deck_when_empty = 0, -- shuffle
        actions_per_round = 1, -- spells per cast
        speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
    },
    stat_ranges = {
        deck_capacity = {25,25}, -- capacity
        reload_time = {4,4}, -- recharge time in frames
        fire_rate_wait = {4,4}, -- cast delay in frames
        spread_degrees = {0,0}, -- spread
        mana_charge_speed = {0,0}, -- mana charge speed
        mana_max = {25000,25000}, -- mana max
    },
    stat_randoms = {},
    permanent_actions = {
    },
    actions = {
    }
} );