local memoize_legendary_wands = {};
function find_legendary_wand( id )
    local tweak = nil;
    if memoize_legendary_wands[id] then
        tweak = memoize_legendary_wands[id];
    else
        for _,entry in pairs(legendary_wands) do
            if entry.id == id then
                tweak = entry;
                memoize_legendary_wands[id] = entry;
            end
        end
        for _,entry in pairs(disabled_legendary_wands) do
            if entry.id == id then
                tweak = entry;
                memoize_legendary_wands[id] = entry;
            end
        end
    end
    return tweak;
end
disabled_legendary_wands = {};
legendary_wands = {
    {
        id = "blink_back",
        name = "Wormhole",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
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
                { { action="GKBRKN_TIME_COMPRESSION", locked=true } },
                { { action="TELEPORT_PROJECTILE", locked=true } },
                { { action="DELAYED_SPELL", locked=true } },
                { { action="GKBRKN_TIME_COMPRESSION", locked=true } },
                { { action="TELEPORT_PROJECTILE", locked=true } },
            }
        }
    },  

    {
        id = "telefragger",
        name = "Telefragger",
        description = "A default unique wand description.",
        author = "Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
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
                { { action="LIGHT_BULLET_TIMER", locked=false } },
                { { action="GKBRKN_TRIPLE_CAST", locked=false } },
                { { action="TELEPORT_CAST", locked=false } },
                { { action="DAMAGE", locked=false } },
                { { action="GKBRKN_TIME_COMPRESSION", locked=false } },
                { { action="GKBRKN_TRIGGER_DEATH", locked=false } },
                { { action="TELEPORT_PROJECTILE", locked=false } },
            }
        }
    },
    {
        id = "alchemic_lance",
        name = "Alchemic Lance",
        description = "A default unique wand description.",
        author = "liliumpop",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
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
        }
    },
    {
        id = "endless_alchemy",
        name = "Endless Alchemy",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
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
        }
    },
    {
        id = "pocket_black_hole",
        name = "Pocket Black Hole",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
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
        }
    },
    {
    id = "magic_popcorn",
    name = "Magic Popcorn",
    description = "A default unique wand description.",
    author = "$ui_author_name_goki_dev",
    wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.5 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {11,11}, -- capacity
                reload_time = {6,6}, -- recharge time in frames
                fire_rate_wait = {6,6}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {200,200}, -- mana charge speed
                mana_max = {300,300}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="KNOCKBACK", locked=true } },
                { { action="GRAVITY", locked=true } },
                { { action="GKBRKN_TRIGGER_TIMER", locked=true } },
                { { action="BUBBLESHOT", locked=true } },
                { { action="GRAVITY_ANTI", locked=true } },
                { { action="BUBBLESHOT", locked=false } },
            },
        }
    },
    {
        id = "spirit_familiar",
        name = "Spirit Familiar",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {12,12}, -- capacity
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
                { "GKBRKN_POWER_SHOT" },
                { "GKBRKN_FALSE_SPELL" },
            }
        }
    },
    {
        id = "noitius",
        name = "Noitius",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
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
        }
    },
    {
        id = "matra_magic",
        name = "Matra Magic",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {9,9}, -- capacity
                reload_time = {12,12}, -- recharge time in frames
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {1000,1000}, -- mana charge speed
                mana_max = {600,600}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="GKBRKN_BURST_FIRE", locked=true } },
                { { action="GKBRKN_RAPID_SHOT", locked=true } },
                { { action="GKBRKN_PAPER_SHOT", locked=true } },
                { { action="GKBRKN_ZERO_GRAVITY", locked=true } },
                { { action="GKBRKN_SEEKER_SHOT", locked=true } },
                { { action="BOUNCE", locked=true } },
                { { action="CHAOTIC_ARC", locked=true } },
                { { action="LIGHT_BULLET" } },
            }
        }
    },
    {
        id = "tabula_rasa",
        name = "Tabula Rasa",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
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
        }
    },
    {
        id = "meat_grinder",
        name = "Meat Grinder",
        description = "A default unique wand description.",
        author = "Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {7,7}, -- capacity
                reload_time = {240,240}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {300,300}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "DISC_BULLET_BIG" },
                { "ENERGY_SHIELD_SECTOR" },
            },
            actions = {
                { { action="GKBRKN_CARRY_SHOT", locked=true } },
                { { action="PIERCING_SHOT", locked=true } },
                { { action="GKBRKN_PROTECTIVE_ENCHANTMENT", locked=true } },
            }
        }
    },
    {
        id = "homing_rocket",
        name = "Slime Rocket",
        description = "A default unique wand description.",
        author = "Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {400,400}, -- mana charge speed
                mana_max = {600,600}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="GKBRKN_BOUND_SHOT", locked=true } },
                { { action="GKBRKN_GUIDED_SHOT", locked=true } },
                { { action="GKBRKN_TRIGGER_DEATH", locked=true } },
                { { action="LIGHT", locked=true } },
                { { action="SLIMEBALL", locked=true } },
                { { action="EXPLOSION", locked=true } },
            }
        }
    },
    {
        id = "bubble_burst",
        name = "Bubble Burst",
        description = "A default unique wand description.",
        author = "Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 9, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {10,10}, -- capacity
                reload_time = {81,81}, -- recharge time in frames
                fire_rate_wait = {32,32}, -- cast delay in frames
                spread_degrees = {-15,-15}, -- spread
                mana_charge_speed = {150,150}, -- mana charge speed
                mana_max = {550,550}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "GKBRKN_PROJECTILE_ORBIT" }
            },
            actions = {
                { "BUBBLESHOT" },
                { { action="BUBBLESHOT", amount=8, locked=true } },
            }
        }
    },
    {
        id = "soulshot",
        name = "Soulshot",
        description = "A default unique wand description.",
        author = "Aster Castell",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {45,45}, -- recharge time in frames
                fire_rate_wait = {45,45}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {150,150}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="HOMING_SHOOTER", locked=true } },
                { { action="GKBRKN_BOUND_SHOT", locked=true } },
                { { action="GKBRKN_CLINGING_SHOT", locked=true } },
                { { action="DAMAGE", locked=false } },
                { { action="GKBRKN_POWER_SHOT", locked=false } },
                { { action="AVOIDING_ARC", locked=true } },
                { { action="GKBRKN_SPELL_DUPLICATOR", locked=true } },
                { { action="GKBRKN_STORED_SHOT", locked=true } },
            }
        }
    },
    {
        id = "wavecast_whip",
        name = "Wavecast Whip",
        description = "A default unique wand description.",
        author = "Aster Castell",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {6,6}, -- capacity
                reload_time = {11,11}, -- recharge time in frames
                fire_rate_wait = {6,6}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {250,250}, -- mana charge speed
                mana_max = {400,400}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="GKBRKN_PROJECTILE_ORBIT", locked=true } },
                { { action="LUMINOUS_DRILL", locked=true } },
                { { action="GKBRKN_POWER_SHOT", locked=false } },
                { { action="GKBRKN_STORED_SHOT", locked=true } },
            }
        }
    },
    {
        id = "trash_bazooka",
        name = "Trash Bazooka",
        description = "A default unique wand description.",
        author = "Aster Castell",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 12, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {21,21}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {15,15}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {300,300}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LIGHT_BULLET", locked=true } },
                { { action="GKBRKN_ZAP", locked=true } },
                { { action="FIREBOMB", locked=true } },
                { { action="GKBRKN_CHAOTIC_BURST", locked=true } },
                { { action="BULLET", locked=true } },
                { { action="HEAVY_BULLET", locked=true } },
                { { action="AIR_BULLET", locked=true } },
                { { action="SLIMEBALL", locked=true } },
                { { action="BUCKSHOT", locked=true } },
                { { action="SLOW_BULLET", locked=true } },
                { { action="SPITTER", locked=true } },
                { { action="BUBBLESHOT", locked=true } },
                { { action="BOUNCY_ORB", locked=true } },
                { { action="SPITTER_TIER_2", locked=true } },
                { { action="RUBBER_BALL", locked=true } },
                { { action="LANCE", locked=true } },
                { { action="DISC_BULLET", locked=true } },
                { { action="SPITTER_TIER_3", locked=true } },
                { { action="ARROW", locked=true } },
                { { action="LASER", locked=true } },
                { { action="HEAL_BULLET", locked=true } },
            }
        }
    },
    {
        id = "spark_swarm",
        name = "Spark Swarm",
        description = "A default unique wand description.",
        author = "Aster Castell",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {10,10}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {16,16}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {200,200}, -- mana charge speed
                mana_max = {500,500}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LIFETIME", locked=true } },
                { { action="HEAVY_SPREAD", locked=true } },
                { { action="GKBRKN_FEATHER_SHOT", locked=true } },
                { { action="AVOIDING_ARC", locked=true } },
                { { action="GKBRKN_PERSISTENT_SHOT", locked=true } },
                { { action="GKBRKN_TRIPLE_CAST", locked=true } },
                { { action="GKBRKN_TRIPLE_CAST", locked=true } },
                { { action="GKBRKN_ZAP", locked=true } },
            }
        }
    },
    {
        id = "the_atomizer",
        name = "The Atomizer",
        description = "A default unique wand description.",
        author = "Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {12,12}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {900,900}, -- mana charge speed
                mana_max = {4300,4300}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LONG_DISTANCE_CAST", locked=true } },
                { { action="PIERCING_SHOT", locked=true } },
                { { action="GKBRKN_PROJECTILE_GRAVITY_WELL", locked=true } },
                { { action="LIFETIME", locked=true } },
                { { action="LIFETIME", locked=true } },
                { { action="DEATH_CROSS", locked=false } },
                { { action="GKBRKN_TRIPLE_CAST", locked=true } },
                { { action="GKBRKN_DOUBLE_CAST", locked=true } },
                { { action="GKBRKN_DOUBLE_CAST", locked=true } },
                { { action="LIGHT_BULLET", locked=false } },
            }
        }
    },
    {
        id = "twin_spiral",
        name = "Twin Spiral",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {12,12}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {200,200}, -- mana charge speed
                mana_max = {400,400}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "LIFETIME_DOWN" },
                { "SPEED" },
                { "SPIRAL_SHOT" },
            },
            actions = {
                { { action="GKBRKN_LINK_SHOT", locked=true } },
                { { action="GKBRKN_PROJECTILE_ORBIT", locked=true } },
                { { action="DEATH_CROSS", locked=true } },
                { { action="DEATH_CROSS", locked=true } },
                { { action="DEATH_CROSS", locked=true } },
                { { action="DEATH_CROSS", locked=true } },
            }
        }
    },
    {
        id = "wormy",
        name = "Wormy",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {18,18}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {500,500}, -- mana charge speed
                mana_max = {1000,1000}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "MATTER_EATER" },
            },
            actions = {
                { { action="PIERCING_SHOT", locked=true } },
                { { action="CLIPPING_SHOT", locked=true } },
                { { action="GKBRKN_PATH_CORRECTION", locked=true } },
                { { action="GKBRKN_LINK_SHOT", locked=true } },
                { { action="GKBRKN_TRAILING_SHOT", locked=true } },
                { { action="BURST_4", locked=false } },
                { { action="BOUNCY_ORB", locked=false } },
                { { action="BOUNCY_ORB", locked=false } },
                { { action="BOUNCY_ORB", locked=false } },
                { { action="BOUNCY_ORB", locked=false } },
                { { action="BOUNCY_ORB", locked=false } },
                { { action="BOUNCY_ORB", locked=false } },
            }
        }
    },
    {
        id = "emerald_splash",
        name = "Emerald Splash",
        description = "A default unique wand description.",
        author = "WITO",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {15,15}, -- capacity
                reload_time = {12,12}, -- recharge time in frames
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {600,600}, -- mana charge speed
                mana_max = {600,600}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="HEAVY_SPREAD", locked=true } },
                { { action="GKBRKN_STORED_SHOT", locked=true } },
                { { action="BOUNCE", locked=true } },
                { { action="BOUNCE", locked=true } },
                { { action="ACCELERATING_SHOT", locked=true } },
                { { action="ACCELERATING_SHOT", locked=true } },
                { { action="ACCELERATING_SHOT", locked=true } },
                { { action="RECOIL_DAMPER", locked=false } },
                { { action="BURST_3", locked=false } },
                { { action="RUBBER_BALL", locked=false } },
                { { action="RUBBER_BALL", locked=false } },
                { { action="RUBBER_BALL", locked=false } },
            }
        }
    },
    {
        id = "frost_wall",
        name = "Frost Wall",
        description = "A default unique wand description.",
        author = "goki + Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {15,15}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {200,200}, -- mana charge speed
                mana_max = {320,320}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LIGHT_BULLET_TRIGGER", locked=true } },
                { { action="WATER_TRAIL", locked=true } },
                { { action="CLIPPING_SHOT", locked=true } },
                { { action="GRAVITY_ANTI", locked=true } },
                { { action="GRAVITY_ANTI", locked=true } },
                { { action="GRAVITY_ANTI", locked=true } },
                { { action="FREEZE", locked=true } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="ACCELERATING_SHOT", locked=false } },
                { { action="GKBRKN_FEATHER_SHOT", locked=false } },
                { { action="DELAYED_SPELL", locked=false } },
            }
        }
    },
    {
        id = "sparkler",
        name = "Sparkler",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {9,9}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {20,20}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {1200,1200}, -- mana charge speed
                mana_max = {1200,1200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="GKBRKN_DOUBLE_CAST", locked=true } },
                { { action="GKBRKN_TRIPLE_CAST", locked=true } },
                { { action="GKBRKN_CARRY_SHOT", locked=true } },
                { { action="LIGHT_BULLET_TIMER", locked=false } },
                { { action="BURST_2", locked=false } },
                { { action="GKBRKN_GLITTERING_TRAIL", locked=false } },
                { { action="DEATH_CROSS", locked=false } },
            }
        }
    },
    {
        id = "auto_spell",
        name = "Auto Spell",
        description = "A default unique wand description.",
        author = "Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {25,25}, -- capacity
                reload_time = {300,300}, -- recharge time in frames
                fire_rate_wait = {60,60}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {25000,25000}, -- mana charge speed
                mana_max = {25000,25000}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LONG_DISTANCE_CAST", locked= false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="GKBRKN_CLINGING_SHOT", locked= false } },
                { { action="DELAYED_SPELL", locked= false } },
                { { action="GKBRKN_SPELL_DUPLICATOR", locked= false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="GKBRKN_FEATHER_SHOT", locked=false } },
                { { action="GKBRKN_SPELL_DUPLICATOR", locked= false } },
                { { action="RECOIL_DAMPER", locked= false } },
                { { action="GKBRKN_GUIDED_SHOT", locked= false } },
                { { action="DAMAGE", locked= false } },
                { { action="LIGHT_BULLET", locked=false } },
            }
        }
    },
    {
        id = "arcane_volley",
        name = "Arcane Volley",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {18,18}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {30,30}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {500,500}, -- mana charge speed
                mana_max = {500,500}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="LONG_DISTANCE_CAST", locked=true } },
                { { action="GKBRKN_PERSISTENT_SHOT", locked=true } },
                { { action="GKBRKN_PROJECTILE_GRAVITY_WELL", locked=true } },
                { { action="ACCELERATING_SHOT", locked=true } },
                { { action="LIFETIME_DOWN", locked=true } },
                { { action="GKBRKN_SPELL_DUPLICATOR", locked=true } },
                { { action="HORIZONTAL_ARC", locked=true } },
                { { action="LONG_DISTANCE_CAST", locked=true } },
                { { action="GKBRKN_TRIGGER_DEATH", locked=true } },
                { { action="DIGGER", locked=true } },
                { { action="GKBRKN_FORMATION_STACK", locked=false } },
                { { action="LIGHT_BULLET", locked=false } },
                { { action="LIGHT_BULLET", locked=false } },
                { { action="LIGHT_BULLET", locked=false } },
            }
        }
    },
    {
        id = "spell_burst",
        name = "Spell Burst",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {15,15}, -- capacity
                reload_time = {37,37}, -- recharge time in frames
                fire_rate_wait = {37,37}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {200,200}, -- mana charge speed
                mana_max = {500,500}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="GKBRKN_TRIGGER_HIT", locked=true } },
                { { action="LIGHT_BULLET", locked=false } },
                { { action="GKBRKN_CLINGING_SHOT", locked=true } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="PINGPONG_PATH", locked=false } },
                { { action="GKBRKN_SPELL_DUPLICATOR", locked=true } },
                { { action="GKBRKN_PERFORATING_SHOT", locked=true } },
                { { action="BOUNCE", locked=true } },
                { { action="RECOIL_DAMPER", locked=false } },
                { { action="GKBRKN_SPEED_DOWN", locked=true } },
                { { action="LIGHT_BULLET", locked=false } },
            }
        }
    },
    {
        id = "earth_mover",
        name = "Earth Mover",
        description = "A default unique wand description.",
        author = "Ivylistar",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {8,8}, -- capacity
                reload_time = {30,30}, -- recharge time in frames
                fire_rate_wait = {1,1}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {30,30}, -- mana charge speed
                mana_max = {30,30}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "SUMMON_ROCK" },
            },
            actions = {
                { { action="SPEED", locked=true } },
                { { action="AIR_BULLET", locked=false } },
            }
        }
    },
    {
        id = "the_huntress",
        name = "The Huntress",
        description = "A default unique wand description.",
        author = "Zentimental",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {12,12}, -- capacity
                reload_time = {12,12}, -- recharge time in frames
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {2,2}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {350,350}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="ENERGY_SHIELD_SECTOR", locked=true } },
                { { action="GKBRKN_TRIGGER_TIMER", locked=true } },
                { { action="BULLET", locked=false } },
                { { action="GKBRKN_PERSISTENT_SHOT", locked=true } },
                { { action="GKBRKN_TRIPLE_CAST", locked=true } },
                { { action="SCATTER_3", locked=true } },
                { { action="LIGHT_BULLET", locked=false } },
                { { action="LIGHT_BULLET", locked=false } },
            }
        }
    },
    {
        id = "creation_blue",
        name = "Creation: Blue",
        description = "A default unique wand description.",
        author = "Zentimental",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {2,2}, -- recharge time in frames
                fire_rate_wait = {2,2}, -- cast delay in frames
                spread_degrees = {2,2}, -- spread
                mana_charge_speed = {1000,1000}, -- mana charge speed
                mana_max = {1000,1000}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="SPEED", locked=true } },
                { { action="ELECTRIC_CHARGE", locked=true } },
                { { action="ARC_ELECTRIC", locked=true } },
                { { action="HORIZONTAL_ARC", locked=true } },
                { { action="GKBRKN_ZAP", locked=true } },
            }
        }
    },
    {
        id = "creation_red",
        name = "Creation: Red",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 5, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {5,5}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {20,20}, -- cast delay in frames
                spread_degrees = {1,1}, -- spread
                mana_charge_speed = {1000,1000}, -- mana charge speed
                mana_max = {1000,1000}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="FIREBALL_RAY_LINE", locked=true, permanent=true } },
                { { action="ARC_FIRE", locked=true } },
                { { action="FIREBOMB", locked=true } },
                { { action="FIREBOMB", locked=true } },
                { { action="FIREBOMB", locked=true } },
            }
        }
    },
    {
        id = "creation_green",
        name = "Creation: Green",
        description = "A default unique wand description.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = true, -- shuffle
                actions_per_round = 2, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {11,11}, -- capacity
                reload_time = {0,0}, -- recharge time in frames
                fire_rate_wait = {-10,-10}, -- cast delay in frames
                spread_degrees = {15,15}, -- spread
                mana_charge_speed = {1000,1000}, -- mana charge speed
                mana_max = {1000,1000}, -- mana max
        },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { { action="PINGPONG_PATH", locked=true, permanent=true } },
                { { action="SINEWAVE", locked=true, permanent=true } },
                { { action="CHAOTIC_ARC", locked=true, permanent=true } },
                { { action="ACCELERATING_SHOT", locked=true, permanent=true } },
                { { action="GKBRKN_SPELL_MERGE", locked=true, permanent=true } },
                { { action="RECOIL_DAMPER", locked=true, permanent=true } },
                { { action="RUBBER_BALL", locked=true } },
                { { action="HEAVY_BULLET", locked=true } },
                { { action="SPITTER_TIER_2", locked=true } },
                { { action="BULLET", locked=true } },
            }
        }
    },
    {
        id = "projectile_thrower",
        name = "Projectile Thrower",
        description = "Every thrower is personalized.",
        author = "$ui_author_name_goki_dev",
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {10,10}, -- capacity
                reload_time = {0,0}, -- recharge time in frames
                fire_rate_wait = {4,4}, -- cast delay in frames
                spread_degrees = {1,1}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {340,340}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                {},
                {},
                { { action="GKBRKN_TRIGGER_REPEAT", locked=true } },
                { { action="LIGHT_BULLET" } },
                { { action="T_SHAPE", locked=true } },
                { { action="GKBRKN_RAPID_SHOT" } },
                { { action="LIGHT_BULLET" } },
                { { action="LIGHT_BULLET" } },
            }
        }
    },
}