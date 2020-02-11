dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
loadouts_to_parse = {};
local register_loadout = GKBRKN_CONFIG.register_loadout;

-- this works because the register_loadout function falls back to whatever the player has equipped when there are no wands or items defined
register_loadout(
    "nolla_default", -- unique identifier
    gkbrkn_localization.loadout_default, -- displayed loadout name
    "Nolla"
);

-- Speedrunner
register_loadout(
    "gkbrkn_speedrunner", -- unique identifier
    gkbrkn_localization.loadout_speedrunner, -- displayed loadout name
    "goki",
    0xffeeeeee, -- cape color (ABGR) *can be nil
    0xffffffff, -- cape edge color (ABGR) *can be nil
    { -- wands
        {
            name = "Speed Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.5 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {130,130}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "DAMAGE" }
            },
            actions = {
                { "TELEPORT_PROJECTILE" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"magic_liquid_teleportation", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        {"REPELLING_CAPE"},
        {"MOVEMENT_FASTER"},
    }
);

-- Hero
register_loadout(
    "gkbrkn_heroic", -- unique identifier
    gkbrkn_localization.loadout_heroic, -- displayed loadout name
    "goki",
    0xff11bbff, -- cape color (ABGR)
    0xff55eeff, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Hero's Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {4,4}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {50,50}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "ENERGY_SHIELD_SECTOR" }
            },
            actions = {
                { "LUMINOUS_DRILL" }
            }
        }
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"alcohol", 1000} } },
    },
    { -- items
    },
    { -- perks
        {"GKBRKN_PROTAGONIST"},
    }
);

-- Unstable
register_loadout(
    "gkbrkn_unstable", -- unique identifier
    gkbrkn_localization.loadout_unstable, -- displayed loadout name
    "goki",
    bit.band( 0xFF000000, math.floor( math.random() * 0xFFFFFF ) ), -- cape color (ABGR)
    bit.band( 0xFF000000, math.floor( math.random() * 0xFFFFFF ) ), -- cape edge color (ABGR)
    { -- wands
        {
            name = "Unstable Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {16,16}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {220,220}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_CHAOTIC_BURST" }
            }
        },
        {
            name = "Unstable Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {24,24}, -- recharge time in frames
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {3,3}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {140,140}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "UNSTABLE_GUNPOWDER" },
                { "MINE" },
            }
        }
    },
    { -- potions
        { { {"water", 500}, {"blood", 500} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        {"GKBRKN_FRAGILE_EGO"},
    }
);

-- Demolitionist
register_loadout(
    "gkbrkn_demolitionist", -- unique identifier
    gkbrkn_localization.loadout_demolitionist, -- displayed loadout name
    "goki",
    0xFF103080, -- cape color (ABGR)
    0xFF209090, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {2,2}, -- capacity
                reload_time = {60,60}, -- recharge time in frames
                fire_rate_wait = {60,60}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {10,10}, -- mana charge speed
                mana_max = {100,100}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "PIPE_BOMB" },
                { "PIPE_BOMB" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {1,1}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {100,100}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                {"PIPE_BOMB_DETONATOR"}
            }
        }
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"gunpowder_unstable", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        {"GKBRKN_DEMOLITIONIST"},
    }
);

-- Spark
register_loadout(
    "gkbrkn_spark", -- unique identifier
    gkbrkn_localization.loadout_spark, -- displayed loadout name
    "goki",
    0xFFFFFF00, -- cape color (ABGR)
    0xFFFFFFFF, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {23,23}, -- recharge time in frames
                fire_rate_wait = {2,2}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {60,60}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                {"ELECTRIC_CHARGE"},
            },
            actions = {
                {"LIGHT_BULLET_TIMER"},
                { "GKBRKN_ZAP" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {50,50}, -- cast delay in frames
                spread_degrees = {1,1}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {120,120}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                {"THUNDERBALL"},
                {"THUNDERBALL"},
            }
        }
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        {"ELECTRICITY"}
    }
);

-- Bubble
register_loadout(
    "gkbrkn_bubble", -- unique identifier
    gkbrkn_localization.loadout_bubble, -- displayed loadout name
    "goki",
    0xFFFF6600, -- cape color (ABGR)
    0xFFFFAA66, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.5 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {26,26}, -- recharge time in frames
                fire_rate_wait = {22,22}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {160,160}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GRAVITY" },
                { "BUBBLESHOT_TRIGGER" },
                { "MATERIAL_WATER" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {16,16}, -- recharge time in frames
                fire_rate_wait = {40,40}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {160,160}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                {"BOUNCE"},
                {"GRENADE_LARGE"},
            }
        }
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "SPEED_DIVER" },
        { "BREATH_UNDERWATER" }
    }
);

-- Charge
register_loadout(
    "gkbrkn_charge", -- unique identifier
    gkbrkn_localization.loadout_charge, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {16,16}, -- recharge time in frames
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {4,4}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {120,120}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_CARRY_SHOT" },
                { "GKBRKN_STORED_SHOT" },
                { "LIGHT_BULLET" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {2,2}, -- capacity
                reload_time = {12,12}, -- recharge time in frames
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {20,20}, -- mana charge speed
                mana_max = {100,100}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                {"BOMB"},
            }
        }
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "CRITICAL_HIT" }
    }
);

-- Alchemist
register_loadout(
    "gkbrkn_alchemist", -- unique identifier
    gkbrkn_localization.loadout_alchemist, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 2.0 -- projectile speed multiplier (hidden)
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
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 3, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {16,16}, -- recharge time in frames
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {3,3}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {120,120}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="MATERIAL_WATER", locked=true } },
                { { action="MATERIAL_WATER", locked=true } },
                { { action="MATERIAL_WATER", locked=true } },
            }
        },
    },
    { -- potions
        { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } }, -- a list of random choices of material amount pairs
        { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } },
        { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } },
        { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } },
    },
    { -- items
    },
    { -- perks
        { "GKBRKN_MATERIAL_COMPRESSION" },
        { "ATTRACT_ITEMS" },
    }
);

-- Trickster
register_loadout(
    "gkbrkn_trickster", -- unique identifier
    gkbrkn_localization.loadout_trickster, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {31,31}, -- recharge time in frames
                fire_rate_wait = {17,17}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {63,63}, -- mana charge speed
                mana_max = {242,242}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LONG_DISTANCE_CAST", locked=true } },
                { { action="I_SHAPE", locked=true } },
                { { action="BULLET", locked=true } },
                { { action="LIGHT_BULLET", locked=true } },
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
                { { action="LONG_DISTANCE_CAST", locked=true } },
                { { action="LIFETIME_DOWN", locked=true } },
                { { action="LIFETIME_DOWN", locked=true } },
                { { action="TELEPORT_PROJECTILE", locked=true } },
                { { action="DELAYED_SPELL", locked=true } },
                { { action="LIFETIME_DOWN", locked=true } },
                { { action="LIFETIME_DOWN", locked=true } },
                { { action="TELEPORT_PROJECTILE", locked=true } },
            }
        },
    },
    { -- potions
        { { {"magic_liquid_teleportation", 200}, {"magic_liquid_charm", 200}, {"magic_liquid_movement_faster", 200}, {"magic_liquid_invisibility", 200}, {"water", 200} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "EXTRA_MONEY_TRICK_KILL" },
    }
);

-- Treasure Hunter
register_loadout(
    "gkbrkn_treasure_hunter", -- unique identifier
    gkbrkn_localization.loadout_treasure_hunter, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {22,22}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {150,150}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_NUGGET_SHOT" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
                actions_per_round = 2, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {2,2}, -- capacity
                reload_time = {3,3}, -- recharge time in frames
                fire_rate_wait = {3,3}, -- cast delay in frames
                spread_degrees = {30,30}, -- spread
                mana_charge_speed = {6,6}, -- mana charge speed
                mana_max = {15,15}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "DIGGER" },
                { "POWERDIGGER" },
            }
        },
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "ATTRACT_ITEMS" },
        { "GKBRKN_TREASURE_RADAR" },
        { "WAND_RADAR" },
    }
);

-- Kamikaze
register_loadout(
    "gkbrkn_kamikaze", -- unique identifier
    gkbrkn_localization.loadout_kamikaze, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "EXPLOSIVE_PROJECTILE" },
                { "EXPLOSIVE_PROJECTILE" },
                { "TELEPORT_PROJECTILE" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {45,45}, -- recharge time in frames
                fire_rate_wait = {45,45}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {150,150}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_PROTECTIVE_ENCHANTMENT" },
                { "EXPLOSION" },
            }
        }
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "PROTECTION_FIRE" },
        { "BLEED_OIL" },
    }
);

-- Glitter
register_loadout(
    "gkbrkn_glitter", -- unique identifier
    gkbrkn_localization.loadout_glitter, -- displayed loadout name
    "goki",
    0xFFD755BE, -- cape color (ABGR)
    0xFFF295E0, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {20,20}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {300,300}, -- mana charge speed
                mana_max = {100,100}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_PERSISTENT_SHOT" },
                { "GKBRKN_PROTECTIVE_ENCHANTMENT" },
                { "GKBRKN_DESTRUCTIVE_SHOT" },
                { "GKBRKN_GLITTERING_TRAIL" },
                { "GKBRKN_STORED_SHOT" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {40,40}, -- recharge time in frames
                fire_rate_wait = {20,20}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {90,90}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GLITTER_BOMB" },
            }
        }
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
    }
);

-- Zoning
register_loadout(
    "gkbrkn_zoning", -- unique identifier
    gkbrkn_localization.loadout_zoning, -- displayed loadout name
    "goki",
    0xFF666666, -- cape color (ABGR)
    0xFF333333, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {17,17}, -- recharge time in frames
                fire_rate_wait = {9,9}, -- cast delay in frames
                spread_degrees = {2,2}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {160,160}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "HORIZONTAL_ARC" },
                { "FLY_UPWARDS" },
                { "FLY_DOWNWARDS" },
                { "GKBRKN_FEATHER_SHOT" },
                { "BOUNCY_ORB" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LIFETIME" },
                { "DEATH_CROSS_BIG" },
            }
        }
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
    }
);

-- Seeker
register_loadout(
    "gkbrkn_seeker", -- unique identifier
    gkbrkn_localization.loadout_seeker, -- displayed loadout name
    "goki",
    0xFF666666, -- cape color (ABGR)
    0xFF333333, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {13,13}, -- recharge time in frames
                fire_rate_wait = {11,11}, -- cast delay in frames
                spread_degrees = {4,4}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {90,90}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "LIFETIME" },
            },
            actions = {
                { "GKBRKN_PERSISTENT_SHOT" },
                { "BOUNCE" },
                { "AVOIDING_ARC" },
                { "DIGGER" },
                { "DIGGER" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {80,80}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "DYNAMITE" },
            }
        }
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
    }
);

-- Blood
register_loadout(
    "gkbrkn_blood", -- unique identifier
    gkbrkn_localization.loadout_blood, -- displayed loadout name
    "goki",
    0xFF666666, -- cape color (ABGR)
    0xFF333333, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {20,20}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {30,30}, -- mana charge speed
                mana_max = {50,50}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "BULLET" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {50,50}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "ROCKET" },
            }
        }
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "GKBRKN_BLOOD_MAGIC" }
    },
    -- actions
    nil,
    -- sprites
    nil,
    -- custom_message
    nil, 
    -- callback
    nil,
    --condition_callback
    function( player )
        return CONTENT[PERKS.BloodMagic].enabled();
    end
);

-- Wandsmith
register_loadout(
    "gkbrkn_wandsmith", -- unique identifier
    gkbrkn_localization.loadout_wandsmith, -- displayed loadout name
    "goki",
    0xFF666666, -- cape color (ABGR)
    0xFF333333, -- cape edge color (ABGR)
    { -- wands
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
        { "data/entities/items/starting_wand.xml" },
        { "data/entities/items/starting_bomb_wand.xml" },
    },
    { -- perks
        { "EDIT_WANDS_EVERYWHERE" }
    },
    -- actions
    nil,
    -- sprites
    nil,
    -- custom message
    nil,
    -- callback
    function( player_entity )
        local x, y = EntityGetTransform( player_entity );
        local full_inventory = nil;
        local player_child_entities = EntityGetAllChildren( player_entity );
        if player_child_entities ~= nil then
            for i,child_entity in ipairs( player_child_entities ) do
                local child_entity_name = EntityGetName( child_entity );
                
                if child_entity_name == "inventory_full" then
                    full_inventory = child_entity;
                end
            end
        end

        -- set inventory contents
        if full_inventory ~= nil then
            for i=1,8 do
                local action = GetRandomAction( x, y, Random( 0, 6 ), Random( 1, 9999999 ) );
                local action_card = CreateItemActionEntity( action, x, y );
                EntitySetComponentsWithTagEnabled( action_card, "enabled_in_world", false );
                EntityAddChild( full_inventory, action_card );
            end
        end
    end
);

-- Goo Mode
register_loadout(
    "gkbrkn_goo_mode", -- unique identifier
    gkbrkn_localization.loadout_goo_mode, -- displayed loadout name
    "goki",
    0xFF2F3249, -- cape color (ABGR)
    0xFF7D53B0, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {1,1}, -- capacity
                reload_time = {10,10}, -- recharge time in frames
                fire_rate_wait = {10,10}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {120,120}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "TELEPORT_PROJECTILE" },
            }
        }
    },
    { -- potions
        { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
    },
    { -- items
        { "data/entities/items/starting_wand.xml" },
        { "data/entities/items/starting_bomb_wand.xml" },
    },
    { -- perks
        { "MOVEMENT_FASTER" }
    },
    -- actions
    nil,
    -- sprites
    nil,
    -- custom message
    nil,
    -- callback
    function( player_entity )
        local x, y = EntityGetTransform( player_entity );
        GameCreateParticle( "creepy_liquid", x, y -100, 1, 0, 0, false, false );
        GameAddFlagRun( "gkbrkn_goo_mode" );
    end
);

-- Duplicator
register_loadout(
    "gkbrkn_duplicator", -- unique identifier
    gkbrkn_localization.loadout_duplicator, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {20,20}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {150,150}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LIFETIME_DOWN" },
                { "GKBRKN_SPELL_DUPLICATOR" },
                { "HORIZONTAL_ARC" },
                { "LIGHT_BULLET" },
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
                deck_capacity = {4,4}, -- capacity
                reload_time = {60,60}, -- recharge time in frames
                fire_rate_wait = {60,60}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_SPELL_DUPLICATOR" },
                { "GRAVITY" },
                { "SLOW_BULLET" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "GKBRKN_EXTRA_PROJECTILE" },
    }
);

-- Conjurer
register_loadout(
    "gkbrkn_conjurer", -- unique identifier
    gkbrkn_localization.loadout_conjurer, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
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
                { "DEATH_CROSS" },
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
                deck_capacity = {3,3}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {20,20}, -- mana charge speed
                mana_max = {80,80}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "BOMB" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "PROJECTILE_HOMING_SHOOTER" },
    }
);

-- Convergent
register_loadout(
    "gkbrkn_convergent", -- unique identifier
    gkbrkn_localization.loadout_convergent, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {10,10}, -- capacity
                reload_time = {40,40}, -- recharge time in frames
                fire_rate_wait = {40,40}, -- cast delay in frames
                spread_degrees = {-3,-3}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {140,140}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LIGHT_BULLET_TRIGGER" },
                { "HEAVY_SPREAD" },
                { "GKBRKN_TRIPLE_CAST" },
                { "LONG_DISTANCE_CAST" },
                { "I_SHAPE" },
                { "LIGHT_BULLET" },
                { "DIGGER" },
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
                deck_capacity = {3,3}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {20,20}, -- mana charge speed
                mana_max = {80,80}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "BOMB" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
    }
);

-- Legendary
register_loadout(
    "gkbrkn_legendary", -- unique identifier
    gkbrkn_localization.loadout_legendary, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
        { "data/entities/items/starting_wand.xml" },
        { "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml" },
    },
    { -- perks
    }
);

-- Knockback
register_loadout(
    "gkbrkn_knockback", -- unique identifier
    gkbrkn_localization.loadout_knockback, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {10,10}, -- capacity
                reload_time = {10,10}, -- recharge time in frames
                fire_rate_wait = {10,10}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="RECOIL", locked=true } },
                { { action="SPEED", locked=true } },
                { { action="KNOCKBACK", locked=true } },
                { { action="KNOCKBACK", locked=true } },
                { { action="KNOCKBACK", locked=true } },
                { { action="AIR_BULLET", locked=false } },
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
                deck_capacity = {3,3}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {20,20}, -- mana charge speed
                mana_max = {80,80}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "BOMB" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "GKBRKN_LEAD_BOOTS" }
    }
);

-- Sniper
register_loadout(
    "gkbrkn_sniper", -- unique identifier
    gkbrkn_localization.loadout_sniper, -- displayed loadout name
    "goki",
    0xFF333333, -- cape color (ABGR)
    0xFF666666, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {11,11}, -- capacity
                reload_time = {120,120}, -- recharge time in frames
                fire_rate_wait = {120,120}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {240,240}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="GKBRKN_PASSIVE_RECHARGE", locked=true } },
                { { action="RECOIL", locked=true } },
                { { action="CRITICAL_HIT", locked=true } },
                { { action="CRITICAL_HIT", locked=false } },
                { { action="CRITICAL_HIT", locked=false } },
                { { action="SPREAD_REDUCE", locked=true } },
                { { action="GKBRKN_POWER_SHOT", locked=true } },
                { { action="SLIMEBALL", locked=false } },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {1,1}, -- capacity
                reload_time = {3,3}, -- recharge time in frames
                fire_rate_wait = {3,3}, -- cast delay in frames
                spread_degrees = {30,30}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {60,60}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LIGHT_BULLET" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"gunpowder_unstable", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "GKBRKN_HYPER_CASTING" }
    }
);

-- Grease (More Loadouts Update)
register_loadout(
    "gkbrkn_grease", -- unique identifier
    gkbrkn_localization.loadout_grease, -- displayed loadout name
    "goki",
    0xff2c5e7b, -- cape color (ABGR)
    0xff2b937a, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {10,10}, -- recharge time in frames
                fire_rate_wait = {16,16}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {100,100}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "HITFX_CRITICAL_OIL" },
                { "HITFX_BURNING_CRITICAL_HIT" },
                { "LIGHT_BULLET" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.5 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {23,23}, -- recharge time in frames
                fire_rate_wait = {25,25}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "OIL_TRAIL" },
                { "LONG_DISTANCE_CAST" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"oil", 500}, {"gunpowder_unstable", 500} } },
    },
    { -- items
    },
    { -- perks
        { "BLEED_OIL" }
    }
);

-- Toxic (More Loadouts Update)
register_loadout(
    "gkbrkn_toxic", -- unique identifier
    gkbrkn_localization.loadout_toxic, -- displayed loadout name
    "goki",
    0xff27c28e, -- cape color (ABGR)
    0xff11f2d4, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {7,7}, -- capacity
                reload_time = {12,12}, -- recharge time in frames
                fire_rate_wait = {16,16}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "HITFX_TOXIC_CHARM" },
                { "LIGHT_BULLET" },
                { "LIGHT_BULLET" },
                { "LIGHT_BULLET" },
                { "LIGHT_BULLET" },
                { "LIGHT_BULLET" },
                --{ "TOXIC_TO_ACID" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.5 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {23,23}, -- recharge time in frames
                fire_rate_wait = {25,25}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {40,40}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_TRIGGER_HIT" },
                { "SLIMEBALL" },
                { "MIST_RADIOACTIVE" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"radioactive_liquid", 1000} } },
    },
    { -- items
    },
    { -- perks
        { "PROTECTION_RADIOACTIVITY" }
    }
);

-- Vampire (More Loadouts Update)
register_loadout(
    "gkbrkn_vampire", -- unique identifier
    gkbrkn_localization.loadout_vampire, -- displayed loadout name
    "goki",
    0xff3d3d3d, -- cape color (ABGR)
    0xff00007a, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
                actions_per_round = 3, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "ARROW" },
                { "ARROW" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.5 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {3,3}, -- capacity
                reload_time = {10,10}, -- recharge time in frames
                fire_rate_wait = {10,10}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {220,220}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "NECROMANCY" },
                { "ARROW" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"blood", 1000} } },
        { { {"acid", 1000} } },
    },
    { -- items
    },
    { -- perks
        { "VAMPIRISM" },
        { "GLOBAL_GORE" },
    }
);

-- Frost (More Loadouts Update)
register_loadout(
    "gkbrkn_frost", -- unique identifier
    gkbrkn_localization.loadout_frost, -- displayed loadout name
    "goki",
    0xff929292, -- cape color (ABGR)
    0xfff0ea6d, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LIGHT_BULLET_TRIGGER" },
                { "POISON_BLAST" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {45,45}, -- recharge time in frames
                fire_rate_wait = {32,32}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {160,160}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "FREEZE_FIELD" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"blood_cold", 1000} } },
    },
    { -- items
    },
    { -- perks
        { "FREEZE_FIELD" },
    }
);

-- Bomb (More Loadouts Update)
register_loadout(
    "gkbrkn_bomb", -- unique identifier
    gkbrkn_localization.loadout_bomb, -- displayed loadout name
    "goki",
    0xff727272, -- cape color (ABGR)
    0xff4d8da8, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {54,54}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "DYNAMITE" },
            },
            actions = {
                { "UNSTABLE_GUNPOWDER" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {2,2}, -- recharge time in frames
                fire_rate_wait = {2,2}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {160,160}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "MINE" },
                { "MINE" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
        { "data/entities/misc/custom_cards/bomb_holy.xml" },
    },
    { -- perks
        { "ABILITY_ACTIONS_MATERIALIZED" },
    }
);

-- Melting (More Loadouts Update)
register_loadout(
    "gkbrkn_melting", -- unique identifier
    gkbrkn_localization.loadout_melting, -- displayed loadout name
    "goki",
    0xff2c7b50, -- cape color (ABGR)
    0xff3f9b69, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {54,54}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LIGHT_BULLET_TRIGGER" },
                { "I_SHAPE" },
                { "GKBRKN_TRIPLE_CAST" },
                { "ACCELERATING_SHOT" },
                { "ACID_TRAIL" },
                { "LONG_DISTANCE_CAST" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"acid", 1000} } },
        { { {"lava", 1000} } },
    },
    { -- items
    },
    { -- perks
    }
);

--[[

-- Blade (More Loadouts Update)
register_loadout(
    "gkbrkn_blade", -- unique identifier
    gkbrkn_localization.loadout_blade, -- displayed loadout name
    "goki",
    0xff00366b, -- cape color (ABGR)
    0xff00478c, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {8,8}, -- recharge time in frames
                fire_rate_wait = {8,8}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_PROTECTIVE_ENCHANTMENT" },
                { "CHAOTIC_ARC" },
                { "BOUNCE" },
                { "DISC_BULLET" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {14,14}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {80,80}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_TRIPLE_CAST" },
                { "GKBRKN_CARRY_SHOT" },
                { "LIGHT_BULLET_TIMER" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
        { "SHIELD" },
    }
);

-- Relic (More Loadouts Update)
register_loadout(
    "gkbrkn_relic", -- unique identifier
    gkbrkn_localization.loadout_relic, -- displayed loadout name
    "goki",
    0xff3c5f61, -- cape color (ABGR)
    0xff73c3c7, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {5,5}, -- cast delay in frames
                spread_degrees = {3,3}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "GKBRKN_PROJECTILE_GRAVITY_WELL" },
                { "ARROW" },
                { "ARROW" },
                { "ARROW" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {40,40}, -- recharge time in frames
                fire_rate_wait = {40,40}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {320,320}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LIGHT_BULLET_TRIGGER" },
                { "BLACK_HOLE_BIG" },
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"fire", 1000} } },
    },
    { -- items
    },
    { -- perks
        { "EXPLODING_CORPSES" },
    }
);

-- Berserk (More Loadouts Update)
register_loadout(
    "gkbrkn_berserk", -- unique identifier
    gkbrkn_localization.loadout_berserk, -- displayed loadout name
    "goki",
    0xff4d1295, -- cape color (ABGR)
    0xff6621b9, -- cape edge color (ABGR)
    { -- wands
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {5,5}, -- cast delay in frames
                spread_degrees = {3,3}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {180,180}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "CHAINSAW" },
            }
        },
        {
            name = "Wand",
            stats = {
                shuffle_deck_when_empty = 0, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {4,4}, -- capacity
                reload_time = {40,40}, -- recharge time in frames
                fire_rate_wait = {40,40}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {80,80}, -- mana charge speed
                mana_max = {320,320}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
            }
        },
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        { { {"magic_liquid_berserk", 1000} } },
    },
    { -- items
    },
    { -- perks
        { "GKBRKN_SHORT_TEMPER" },
    }
);

]]