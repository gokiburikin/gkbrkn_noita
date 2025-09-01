local memoize_legendary_wands = {}
function find_legendary_wand( id )
    local tweak = nil
    if memoize_legendary_wands[id] then
        tweak = memoize_legendary_wands[id]
    else
        for _,entry in pairs(legendary_wands) do
            if entry.id == id then
                tweak = entry
                memoize_legendary_wands[id] = entry
            end
        end
        for _,entry in pairs(disabled_legendary_wands) do
            if entry.id == id then
                tweak = entry
                memoize_legendary_wands[id] = entry
            end
        end
    end
    return tweak
end
disabled_legendary_wands = {}
legendary_wands = {
    {
        id = "blink_back",
        name = "Wormhole",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "LONG_DISTANCE_CAST" },
                { "GKBRKN_TIME_COMPRESSION" },
                { "TELEPORT_PROJECTILE" },
                { "DELAYED_SPELL" },
                { "GKBRKN_TIME_COMPRESSION" },
                { "TELEPORT_PROJECTILE" },
            }
        }
    },  

    {
        id = "assassin",
        name = "Assassin",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {10,10}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {10,10}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {200,200}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "TELEPORT_CAST" },
                { "HEAVY_SHOT" },
                { "GKBRKN_FALSE_SPELL" },
            }
        }
    },
    {
        id = "alchemic_lance",
        name = "Alchemic Lance",
        description = "A default unique wand description.",
        author = "lilyhops",
        local_content = true,
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
                { "GKBRKN_SPELL_MERGE" },
                { "WATER_TO_POISON" },
                { "LAVA_TO_BLOOD" },
                { "BLOOD_TO_ACID" },
                { "TOXIC_TO_ACID" },
                { "GKBRKN_NUGGET_SHOT" },
                { "LANCE" },
            }
        }
    },
    {
        id = "endless_alchemy",
        name = "Endless Alchemy",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
        author = "goki_dev",
        local_content = true,
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
            },
            actions = {
                { "GKBRKN_FORMATION_SWORD" },
                { "BLACK_HOLE" },
            }
        }
    },
    {
    id = "magic_popcorn",
    name = "Magic Popcorn",
    description = "A default unique wand description.",
    author = "goki_dev",
    local_content = true,
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
                { "KNOCKBACK" },
                { "GRAVITY" },
                { "ADD_TIMER" },
                { "BUBBLESHOT" },
                { "GRAVITY_ANTI" },
                { "BUBBLESHOT" },
            },
        }
    },
    {
        id = "spirit_familiar",
        name = "Spirit Familiar",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                mana_charge_speed = {60,60}, -- mana charge speed
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
                { "HOMING_AREA" },
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
        author = "goki_dev",
        local_content = true,
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
                { "GKBRKN_ZERO_GRAVITY" },
            },
            actions = {
                { "GKBRKN_PERSISTENT_SHOT" },
                { "GKBRKN_FORMATION_STACK" },
                { "BURST_4" },
                { "RUBBER_BALL" },
                { "LIGHT_BULLET" },
                { "BULLET" },
                { "BULLET" },
                { "LIGHT_BULLET" },
                { "RUBBER_BALL" },
            }
        }
    },
    {
        id = "matra_magic",
        name = "Matra Magic",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "GKBRKN_RAPID_SHOT" },
                { "GKBRKN_BURST_FIRE" },
                { "GKBRKN_ZERO_GRAVITY" },
                { "GKBRKN_SEEKER_SHOT" },
                { "BOUNCE" },
                { "CHAOTIC_ARC" },
                { "LIGHT_BULLET" },
            }
        }
    },
    {
        id = "tabula_rasa",
        name = "Tabula Rasa",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
        local_content = true,
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
                { "GKBRKN_FORMATION_SWORD" },
                { "PIERCING_SHOT" },
                { "GKBRKN_PROTECTIVE_ENCHANTMENT" },
            }
        }
    },
    {
        id = "homing_rocket",
        name = "Slime Rocket",
        description = "A default unique wand description.",
        author = "Ivylistar",
        local_content = true,
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
                { "GKBRKN_FEATHER_SHOT" },
                { "GKBRKN_CONTROL" },
                { "ADD_DEATH_TRIGGER" },
                { "LIGHT" },
                { "SLIMEBALL" },
                { "EXPLOSION" },
            }
        }
    },
    {
        id = "bubble_burst",
        name = "Bubble Burst",
        description = "A default unique wand description.",
        author = "Ivylistar",
        local_content = true,
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
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
            },
            actions = {
                { "GKBRKN_PROJECTILE_ORBIT" },
                { "BURST_4" },
                { "BUBBLESHOT" },
                { "BUBBLESHOT" },
                { "BUBBLESHOT" },
                { "BUBBLESHOT" },
                { "BUBBLESHOT" },
                { "BUBBLESHOT" },
                { "BUBBLESHOT" },
                { "BUBBLESHOT" },
            }
        }
    },
    {
        id = "essence",
        name = "Essence",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {250,250}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                { "GKBRKN_BOUND_SHOT" },
                { "HOMING_AREA" },
                { "CLIPPING_SHOT" },
                { "ESSENCE_TO_POWER" },
            },
            actions = {
                { "GKBRKN_CURSOR" },
                { "HOMING_SHOOTER" },
                { "GKBRKN_POWER_SHOT"  },
                { "AVOIDING_ARC" },
                { "GKBRKN_FALSE_SPELL" },
            }
        }
    },
    {
        id = "wavecast_whip",
        name = "Wavecast Whip",
        description = "A default unique wand description.",
        author = "Aster Castell",
        local_content = true,
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
                { "GKBRKN_PROJECTILE_ORBIT" },
                { "LUMINOUS_DRILL" },
                { "GKBRKN_POWER_SHOT" },
                { "GKBRKN_STORED_SHOT" },
            }
        }
    },
    {
        id = "trash_bazooka",
        name = "Trash Bazooka",
        description = "A default unique wand description.",
        author = "Aster Castell",
        local_content = true,
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
                { "LIGHT_BULLET" },
                { "GKBRKN_ZAP" },
                { "FIREBOMB" },
                { "GKBRKN_CHAOTIC_BURST" },
                { "BULLET" },
                { "HEAVY_BULLET" },
                { "AIR_BULLET" },
                { "SLIMEBALL" },
                { "BUCKSHOT" },
                { "SLOW_BULLET" },
                { "SPITTER" },
                { "BUBBLESHOT" },
                { "BOUNCY_ORB" },
                { "SPITTER_TIER_2" },
                { "RUBBER_BALL" },
                { "LANCE" },
                { "DISC_BULLET" },
                { "SPITTER_TIER_3" },
                { "ARROW" },
                { "LASER" },
                { "HEAL_BULLET" },
            }
        }
    },
    {
        id = "spark_swarm",
        name = "Spark Swarm",
        description = "A default unique wand description.",
        author = "Aster Castell",
        local_content = true,
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
                { "LIFETIME" },
                { "HEAVY_SPREAD" },
                { "GKBRKN_FEATHER_SHOT" },
                { "AVOIDING_ARC" },
                { "GKBRKN_PERSISTENT_SHOT" },
                { "GKBRKN_TRIPLE_CAST" },
                { "GKBRKN_TRIPLE_CAST" },
                { "GKBRKN_ZAP" },
            }
        }
    },
    {
        id = "the_atomizer",
        name = "The Atomizer",
        description = "A default unique wand description.",
        author = "Ivylistar",
        local_content = true,
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
                { "LONG_DISTANCE_CAST" },
                { "PIERCING_SHOT" },
                { "GKBRKN_PROJECTILE_GRAVITY_WELL" },
                { "LIFETIME" },
                { "LIFETIME" },
                { "DEATH_CROSS" },
                { "GKBRKN_TRIPLE_CAST" },
                { "GKBRKN_DOUBLE_CAST" },
                { "GKBRKN_DOUBLE_CAST" },
                { "LIGHT_BULLET" },
            }
        }
    },
    {
        id = "twin_spiral",
        name = "Twin Spiral",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 2, -- spells per cast
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
            },
            actions = {
                { "LIFETIME_DOWN" },
                { "SPEED" },
                { "SPIRAL_SHOT" },
                { "GKBRKN_LINK_SHOT" },
                { "GKBRKN_PROJECTILE_ORBIT" },
                { "DEATH_CROSS" },
                { "DEATH_CROSS" },
                { "DEATH_CROSS" },
                { "DEATH_CROSS" },
            }
        }
    },
    {
        id = "wormy",
        name = "Wormy",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "GKBRKN_PERFORATING_SHOT" },
                { "CLIPPING_SHOT" },
                { "GKBRKN_PATH_CORRECTION" },
                { "GKBRKN_LINK_SHOT" },
                { "GKBRKN_TRAILING_SHOT" },
                { "BURST_4" },
                { "BOUNCY_ORB" },
                { "BOUNCY_ORB" },
                { "BOUNCY_ORB" },
                { "BOUNCY_ORB" },
                { "BOUNCY_ORB" },
                { "BOUNCY_ORB" },
            }
        }
    },
    {
        id = "emerald_splash",
        name = "Emerald Splash",
        description = "A default unique wand description.",
        author = "WITO",
        local_content = true,
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
                { "HEAVY_SPREAD" },
                { "GKBRKN_STORED_SHOT" },
                { "BOUNCE" },
                { "BOUNCE" },
                { "ACCELERATING_SHOT" },
                { "ACCELERATING_SHOT" },
                { "ACCELERATING_SHOT" },
                { "RECOIL_DAMPER" },
                { "BURST_3" },
                { "RUBBER_BALL" },
                { "RUBBER_BALL" },
                { "RUBBER_BALL" },
            }
        }
    },
    {
        id = "frost_wall",
        name = "Frost Wall",
        description = "A default unique wand description.",
        author = "goki + Ivylistar",
        local_content = true,
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
                { "LIGHT_BULLET_TRIGGER" },
                { "WATER_TRAIL" },
                { "GKBRKN_BURROW_SHOT" },
                { "GRAVITY_ANTI" },
                { "GRAVITY_ANTI" },
                { "GRAVITY_ANTI" },
                { "FREEZE" },
                { "LIFETIME_DOWN" },
                { "LIFETIME_DOWN" },
                { "SPEED" },
                { "GKBRKN_FEATHER_SHOT" },
                { "DELAYED_SPELL" },
            }
        }
    },
    {
        id = "sparkler",
        name = "Sparkler",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "GKBRKN_DOUBLE_CAST" },
                { "GKBRKN_TRIPLE_CAST" },
                { "GKBRKN_FORMATION_SWORD" },
                { "LIGHT_BULLET_TIMER" },
                { "BURST_2" },
                { "GKBRKN_GLITTERING_TRAIL" },
                { "DEATH_CROSS" },
            }
        }
    },
    {
        id = "auto_spell",
        name = "Auto Spell",
        description = "A default unique wand description.",
        author = "Ivylistar",
        local_content = true,
        deprecated = true, -- I think this broke because I can't tell what it's supposed to do
        wand = {
            stats = {
                shuffle_deck_when_empty = false, -- shuffle
                actions_per_round = 1, -- spells per cast
                speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
            },
            stat_ranges = {
                deck_capacity = {15,15}, -- capacity
                reload_time = {240,240}, -- recharge time in frames
                fire_rate_wait = {60,60}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {300,300}, -- mana charge speed
                mana_max = {1250,1250}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
            },
            actions = {
                { "LONG_DISTANCE_CAST" },
                { "GKBRKN_SPELL_DUPLICATOR" },
                { "LIFETIME_DOWN" },
                { "GKBRKN_SPELL_DUPLICATOR" },
                { "RECOIL_DAMPER" },
                { "GKBRKN_GUIDED_SHOT" },
                { "DAMAGE" },
                { "LIGHT_BULLET" },
            }
        }
    },
    {
        id = "arcane_volley",
        name = "Arcane Volley",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "DECELERATING_SHOT" },
                { "FLY_UPWARDS" },
                { "GRAVITY" },
                { "GKBRKN_PROXIMITY_BURST" },
                { "LIGHT_BULLET" },
            }
        }
    },
    {
        id = "spell_burst",
        name = "Spell Burst",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "ADD_TRIGGER" },
                { "LIGHT_BULLET" },
                { "HOMING_AREA" },
                { "LIFETIME_DOWN" },
                { "PINGPONG_PATH" },
                { "GKBRKN_SPELL_DUPLICATOR" },
                { "GKBRKN_PERFORATING_SHOT" },
                { "BOUNCE" },
                { "RECOIL_DAMPER" },
                { "GKBRKN_SPEED_DOWN" },
                { "LIGHT_BULLET" },
            }
        }
    },
    {
        id = "earth_mover",
        name = "Earth Mover",
        description = "A default unique wand description.",
        author = "Ivylistar",
        local_content = true,
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
                { "SPEED" },
                { "AIR_BULLET" },
            }
        }
    },
    {
        id = "the_huntress",
        name = "The Huntress",
        description = "A default unique wand description.",
        author = "Zentimental",
        local_content = true,
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
                { "ENERGY_SHIELD_SECTOR" },
                { "ADD_TIMER" },
                { "BULLET" },
                { "GKBRKN_PERSISTENT_SHOT" },
                { "GKBRKN_TRIPLE_CAST" },
                { "SCATTER_3" },
                { "LIGHT_BULLET" },
            }
        }
    },
    {
        id = "creation_blue",
        name = "Creation: Blue",
        description = "A default unique wand description.",
        author = "Zentimental",
        local_content = true,
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
                { "SPEED" },
                { "ELECTRIC_CHARGE" },
                { "ARC_ELECTRIC" },
                { "HORIZONTAL_ARC" },
                { "GKBRKN_ZAP" },
            }
        }
    },
    {
        id = "creation_red",
        name = "Creation: Red",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "FIREBALL_RAY_LINE" },
                { "ARC_FIRE" },
                { "FIREBOMB" },
                { "FIREBOMB" },
                { "FIREBOMB" },
            }
        }
    },
    {
        id = "creation_green",
        name = "Creation: Green",
        description = "A default unique wand description.",
        author = "goki_dev",
        local_content = true,
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
                { "PINGPONG_PATH" },
                { "SINEWAVE" },
                { "CHAOTIC_ARC" },
                { "ACCELERATING_SHOT" },
                { "GKBRKN_SPELL_MERGE" },
                { "RECOIL_DAMPER" },
                { "RUBBER_BALL" },
                { "HEAVY_BULLET" },
                { "SPITTER_TIER_2" },
                { "BULLET" },
            }
        }
    },
    {
        id = "projectile_thrower",
        name = "Projectile Thrower",
        description = "Every thrower is personalized.",
        author = "goki_dev",
        local_content = true,
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
                { "GKBRKN_RAPID_SHOT" },
                { "GKBRKN_TRIGGER_REPEAT" },
                { "BUBBLESHOT" },
                { "T_SHAPE" },
                { "LIGHT_BULLET" },
                { "LIGHT_BULLET" },
            }
        }
    }
}