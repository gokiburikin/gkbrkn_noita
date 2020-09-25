local memoize_loadouts = {};
function find_loadout( id )
    local tweak = nil;
    if memoize_loadouts[id] then
        tweak = memoize_loadouts[id];
    else
        for _,entry in pairs(loadouts) do
            if entry.id == id then
                tweak = entry;
                memoize_loadouts[id] = entry;
            end
        end
        for _,entry in pairs(disabled_loadouts) do
            if entry.id == id then
                tweak = entry;
                memoize_loadouts[id] = entry;
            end
        end
    end
    return tweak;
end

disabled_loadouts = {};
loadouts_to_parse = {};
-- id, name, description, author, cape_color, cape_color_edge, wands, potions, items, perks, actions, sprites, custom_message, callback, condition_callback
loadouts = {
    { -- Default
        id = "nolla_default", -- unique identifier
        name = "$loadout_default", -- displayed loadout name
        description = "The default loadout",
        author = "Nolla",
        cape_color = nil,
        cape_color_edge = nil,
        wands = nil,
        potions = nil,
        items = nil,
        perks = nil,
        actions = nil,
        sprites = nil,
        custom_message = nil,
        callback = nil,
        condition_callback = nil,
        menu_note = nil
    },
    { -- Speedrunner
        id = "gkbrkn_speedrunner", -- unique identifier
        name = "$loadout_speedrunner", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xffeeeeee, -- cape color (ABGR) *can be nil
        cape_color_edge = 0xffffffff, -- cape edge color (ABGR) *can be nil
        wands = { -- wands
            {
                name = "Speed Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"magic_liquid_teleportation", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            {"REPELLING_CAPE"},
            {"MOVEMENT_FASTER"},
        },
        actions = nil,
        sprites = nil,
        custom_message = nil,
        callback = nil,
        condition_callback = nil,
        menu_note = nil
    },
    { -- Hero
        id = "gkbrkn_heroic", -- unique identifier
        name = "$loadout_heroic", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff11bbff, -- cape color (ABGR)
        cape_color_edge = 0xff55eeff, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Hero's Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {4,4}, -- capacity
                    reload_time = {18,18}, -- recharge time in frames
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
        potions ={ -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"alcohol", 1000} } },
        },
        items ={ -- items
        },
        perks ={ -- perks
            {"GKBRKN_PROTAGONIST"},
        }
    },
    { -- Unstable
        id = "gkbrkn_unstable", -- unique identifier
        name = "$loadout_unstable", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = bit.band( 0xFF000000, math.floor( math.random() * 0xFFFFFF ) ), -- cape color (ABGR)
        cape_color_edge = bit.band( 0xFF000000, math.floor( math.random() * 0xFFFFFF ) ), -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Unstable Wand",
                stats = {
                    shuffle_deck_when_empty = true, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 500}, {"blood", 500} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            {"GKBRKN_FRAGILE_EGO"},
        }
    },
    { -- Demolitionist
        id = "gkbrkn_demolitionist", -- unique identifier
        name = "$loadout_demolitionist", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF103080, -- cape color (ABGR)
        cape_color_edge = 0xFF209090, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"gunpowder_unstable", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            {"GKBRKN_DEMOLITIONIST"},
        }
    },
    { -- Spark
        id = "gkbrkn_spark", -- unique identifier
        name = "$loadout_spark", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFFFFFF00, -- cape color (ABGR)
        cape_color_edge = 0xFFFFFFFF, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            {"ELECTRICITY"}
        }
    },
    {-- Bubble
        id = "gkbrkn_bubble", -- unique identifier
        name = "$loadout_bubble", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFFFF6600, -- cape color (ABGR)
        cape_color_edge = 0xFFFFAA66, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    { "SPREAD_REDUCE" },
                    { "BUBBLESHOT_TRIGGER" },
                    { "MATERIAL_WATER" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "SPEED_DIVER" },
            { "BREATH_UNDERWATER" }
        }
    },
    { -- Charge
        id = "gkbrkn_charge", -- unique identifier
        name = "$loadout_charge", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions ={ -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
        },
        perks ={ -- perks
            { "CRITICAL_HIT" }
        }
    },
    { -- Alchemist
        id = "gkbrkn_alchemist", -- unique identifier
        name = "$loadout_alchemist", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions ={ -- potions
            { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } }, -- a list of random choices of material amount pairs
            { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } },
            { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } },
            { { {"water", 2000} }, { { "oil", 2000 } }, { { "blood", 2000 } }, { { "alcohol", 2000 } }, { { "slime", 2000 } } },
        },
        items ={ -- items
        },
        perks ={ -- perks
            { "GKBRKN_MATERIAL_COMPRESSION" },
            { "ATTRACT_ITEMS" },
        }
    },
    { -- Trickster
        id = "gkbrkn_trickster", -- unique identifier
        name = "$loadout_trickster", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions ={ -- potions
            { { {"magic_liquid_teleportation", 200}, {"magic_liquid_charm", 200}, {"magic_liquid_movement_faster", 200}, {"magic_liquid_invisibility", 200}, {"water", 200} } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
        },
        perks ={ -- perks
            { "EXTRA_MONEY_TRICK_KILL" },
        }
    },
    { -- Treasure Hunter
        id = "gkbrkn_treasure_hunter", -- unique identifier
        name = "$loadout_treasure_hunter", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = true, -- shuffle
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
        potions ={ -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
        },
        perks ={ -- perks
            { "ATTRACT_ITEMS" },
            { "GKBRKN_TREASURE_RADAR" },
            { "WAND_RADAR" },
        }
    },
    { -- Kamikaze
        id = "gkbrkn_kamikaze", -- unique identifier
        name = "$loadout_kamikaze", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {3,3}, -- capacity
                    reload_time = {45,45}, -- recharge time in frames
                    fire_rate_wait = {45,45}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {150,150}, -- mana charge speed
                    mana_max = {300,300}, -- mana max
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
        potions ={ -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
        },
        perks ={ -- perks
            { "PROTECTION_FIRE" },
            { "BLEED_OIL" },
        }
    },
    { -- Glitter
        id = "gkbrkn_glitter", -- unique identifier
        name = "$loadout_glitter", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFFD755BE, -- cape color (ABGR)
        cape_color_edge = 0xFFF295E0, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {8,8}, -- capacity
                    reload_time = {20,20}, -- recharge time in frames
                    fire_rate_wait = {20,20}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {300,300}, -- mana charge speed
                    mana_max = {200,200}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "GKBRKN_PERSISTENT_SHOT" },
                    { "GKBRKN_DESTRUCTIVE_SHOT" },
                    { "GKBRKN_GLITTERING_TRAIL" },
                    { "GKBRKN_PROTECTIVE_ENCHANTMENT" },
                    { "GKBRKN_STORED_SHOT" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Zoning
        id = "gkbrkn_zoning", -- unique identifier
        name = "$loadout_zoning", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF666666, -- cape color (ABGR)
        cape_color_edge = 0xFF333333, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {7,7}, -- capacity
                    reload_time = {17,17}, -- recharge time in frames
                    fire_rate_wait = {9,9}, -- cast delay in frames
                    spread_degrees = {2,2}, -- spread
                    mana_charge_speed = {60,60}, -- mana charge speed
                    mana_max = {500,500}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "LONG_DISTANCE_CAST" },
                    { "GKBRKN_PROTECTIVE_ENCHANTMENT" },
                    { "BURST_2" },
                    { "WALL_VERTICAL" },
                    { "WALL_HORIZONTAL" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Seeker
        id = "gkbrkn_seeker", -- unique identifier
        name = "$loadout_seeker", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF666666, -- cape color (ABGR)
        cape_color_edge = 0xFF333333, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {9,9}, -- capacity
                    reload_time = {13,13}, -- recharge time in frames
                    fire_rate_wait = {11,11}, -- cast delay in frames
                    spread_degrees = {4,4}, -- spread
                    mana_charge_speed = {50,50}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                    { "LIFETIME" },
                },
                actions = {
                    { "GKBRKN_PERSISTENT_SHOT" },
                    { "GKBRKN_SEEKER_SHOT" },
                    { "BOUNCE" },
                    { "AVOIDING_ARC" },
                    { "DIGGER" },
                    { "DIGGER" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions ={ -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
        },
        perks ={ -- perks
        }
    },
    { -- Taikasauva Terror
        id = "gkbrkn_taikasauva_terror", -- unique identifier
        name = "$loadout_taikasauva_terror", -- displayed loadout name
        description = "A default loadout description",
        author = "AsterCastell",
        cape_color = 0xFF666666, -- cape color (ABGR)
        cape_color_edge = 0xFF333333, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {1,1}, -- capacity
                    reload_time = {120,120}, -- recharge time in frames
                    fire_rate_wait = {120,120}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {9999,9999}, -- mana charge speed
                    mana_max = {9999,9999}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "SUMMON_WANDGHOST" }
                },
                callback = function( wand, ability )
                    GameAddFlagRun( FLAGS.UnlimitedAmmo );
                    EntitySetVariableNumber( wand, "gkbrkn_challenge_wand", 1 );
                end
            }
        },
        potions = { -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        },
        enabled_by_default = false
    },
    { -- Event Horizon
        id = "gkbrkn_event_horizon", -- unique identifier
        name = "$loadout_event_horizon", -- displayed loadout name
        description = "A default loadout description",
        author = "AsterCastell",
        cape_color = 0xFF666666, -- cape color (ABGR)
        cape_color_edge = 0xFF333333, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {2,2}, -- capacity
                    reload_time = {60,60}, -- recharge time in frames
                    fire_rate_wait = {60,60}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {9999,9999}, -- mana charge speed
                    mana_max = {9999,9999}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "LONG_DISTANCE_CAST" },
                    { "BLACK_HOLE_BIG" },
                },
                callback = function( wand, ability )
                    GameAddFlagRun( FLAGS.UnlimitedAmmo );
                    EntitySetVariableNumber( wand, "gkbrkn_challenge_wand", 1 );
                end
            }
        },
        potions = { -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        },
        enabled_by_default = false
    },
    { -- Wandsmith
        id = "gkbrkn_wandsmith", -- unique identifier
        name = "$loadout_wandsmith", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF666666, -- cape color (ABGR)
        cape_color_edge = 0xFF333333, -- cape edge color (ABGR)
        wands = { -- wands
        },
        potions = { -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
            { "data/entities/items/starting_wand.xml" },
            { "data/entities/items/starting_bomb_wand.xml" },
        },
        perks = { -- perks
            { "EDIT_WANDS_EVERYWHERE" }
        },
        -- actions
        actions = nil,
        -- sprites
        sprites = nil,
        -- custom message
        custom_message = nil,
        -- callback
        callback = function( player_entity )
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
    },
    { -- Goo Mode
        id = "gkbrkn_goo_mode", -- unique identifier
        name = "$loadout_goo_mode", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF2F3249, -- cape color (ABGR)
        cape_color_edge = 0xFF7D53B0, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions ={ -- potions
            { { {"water", 1000}  } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
            { "data/entities/items/starting_wand.xml" },
            { "data/entities/items/starting_bomb_wand.xml" },
        },
        perks ={ -- perks
            { "MOVEMENT_FASTER" }
        }
    },
    { -- Duplicator
        id = "gkbrkn_duplicator", -- unique identifier
        name = "$loadout_duplicator", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {6,6}, -- capacity
                    reload_time = {20,20}, -- recharge time in frames
                    fire_rate_wait = {20,20}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {80,80}, -- mana charge speed
                    mana_max = {160,160}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "GKBRKN_TIME_COMPRESSION" },
                    { "GKBRKN_SPELL_DUPLICATOR" },
                    { "HORIZONTAL_ARC" },
                    { "LIGHT_BULLET" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "GKBRKN_EXTRA_PROJECTILE" },
        }
    },
    { -- Conjurer
        id = "gkbrkn_conjurer", -- unique identifier
        name = "$loadout_conjurer", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {9,9}, -- capacity
                    reload_time = {180,180}, -- recharge time in frames
                    fire_rate_wait = {120,120}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {30,30}, -- mana charge speed
                    mana_max = {200,200}, -- mana max
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
                    { "GKBRKN_AREA_SHOT" },
                    { "AVOIDING_ARC" },
                    { "GKBRKN_POWER_SHOT" },
                    { "GKBRKN_FALSE_SPELL" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "PROJECTILE_HOMING_SHOOTER" },
        }
    },
    { -- Convergent
        id = "gkbrkn_convergent", -- unique identifier
        name = "$loadout_convergent", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {12,12}, -- capacity
                    reload_time = {40,40}, -- recharge time in frames
                    fire_rate_wait = {40,40}, -- cast delay in frames
                    spread_degrees = {-3,-3}, -- spread
                    mana_charge_speed = {90,90}, -- mana charge speed
                    mana_max = {210,210}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { { action="GKBRKN_TRIGGER_HIT", locked=true} },
                    { { action="LIGHT_BULLET", locked=false} },
                    { { action="GKBRKN_BURST_FIRE", locked=true} },
                    { { action="GKBRKN_BURST_FIRE", locked=true} },
                    { { action="HEAVY_SPREAD", locked=true} },
                    { { action="GKBRKN_SPEED_DOWN", locked=true} },
                    { { action="LONG_DISTANCE_CAST", locked=true} },
                    { { action="I_SHAPE", locked=true} },
                    { { action="LIGHT_BULLET", locked=false} },
                    { { action="DIGGER", locked=false} },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        item = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Legendary
        id = "gkbrkn_legendary", -- unique identifier
        name = "$loadout_legendary", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands = { -- wands
        },
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
            { "data/entities/items/starting_wand.xml" },
            { "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml" },
        },
        perks = { -- perks
        }
    },
    { -- Knockback
        id = "gkbrkn_knockback", -- unique identifier
        name = "$loadout_knockback", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "GKBRKN_LEAD_BOOTS" }
        }
    },
    { -- Sniper
        id = "gkbrkn_sniper", -- unique identifier
        name = "$loadout_sniper", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {1,1}, -- capacity
                    reload_time = {3,3}, -- recharge time in frames
                    fire_rate_wait = {3,3}, -- cast delay in frames
                    spread_degrees = {30,30}, -- spread
                    mana_charge_speed = {60,60}, -- mana charge speed
                    mana_max = {600,600}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "LIGHT_BULLET" },
                }
            },
        },
        potions ={ -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"gunpowder_unstable", 1000} } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
        },
        perks ={ -- perks
            { "GKBRKN_HYPER_CASTING" }
        }
    },
    { -- Spellsword
        id = "gkbrkn_spellsword", -- unique identifier
        name = "$loadout_spellsword", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {12,12}, -- capacity
                    reload_time = {30,30}, -- recharge time in frames
                    fire_rate_wait = {30,30}, -- cast delay in frames
                    spread_degrees = {5,5}, -- spread
                    mana_charge_speed = {280,280}, -- mana charge speed
                    mana_max = {280,280}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { { action="GKBRKN_DOUBLE_CAST", locked=true } },
                    { { action="GKBRKN_TRIPLE_CAST", locked=true } },
                    { { action="GKBRKN_CARRY_SHOT", locked=true } },
                    { { action="GKBRKN_TRIGGER_TIMER", locked=true } },
                    { { action="RUBBER_BALL", locked=false } },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {1,1}, -- capacity
                    reload_time = {5,5}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {1,1}, -- spread
                    mana_charge_speed = {20,20}, -- mana charge speed
                    mana_max = {100,100}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "BOMB" },
                }
            },
        },
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Grease (More Loadouts Update)
        id = "gkbrkn_grease", -- unique identifier
        name = "$loadout_grease", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff2c5e7b, -- cape color (ABGR)
        cape_color_edge = 0xff2b937a, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"oil", 500}, {"gunpowder_unstable", 500} } },
        },
        items = { -- items
        },
        perks = { -- perks
            { "BLEED_OIL" }
        }
    },
    { -- Toxic (More Loadouts Update)
        id = "gkbrkn_toxic", -- unique identifier
        name = "$loadout_toxic", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff27c28e, -- cape color (ABGR)
        cape_color_edge = 0xff11f2d4, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = true, -- shuffle
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
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions ={ -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"radioactive_liquid", 1000} } },
        },
        items ={ -- items
        },
        perks ={ -- perks
            { "PROTECTION_RADIOACTIVITY" }
        }
    },
    { -- Vampire (More Loadouts Update)
        id = "gkbrkn_vampire", -- unique identifier
        name = "$loadout_vampire", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff3d3d3d, -- cape color (ABGR)
        cape_color_edge = 0xff00007a, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = true, -- shuffle
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
                    shuffle_deck_when_empty = true, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"blood", 1000} } },
            { { {"acid", 1000} } },
        },
        items = { -- items
        },
        perks = { -- perks
            { "VAMPIRISM" },
            { "GLOBAL_GORE" },
        }
    },
    { -- Poison (More Loadouts Update; was Frost)
        id = "gkbrkn_poison", -- unique identifier
        name = "$loadout_poison", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff929292, -- cape color (ABGR)
        cape_color_edge = 0xfff0ea6d, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = true, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"blood_cold", 1000} } },
        },
        items = { -- items
        },
        perks = { -- perks
            { "FREEZE_FIELD" },
        }
    },
    { -- Bomb (More Loadouts Update)
        id = "gkbrkn_bomb", -- unique identifier
        name = "$loadout_bomb", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff727272, -- cape color (ABGR)
        cape_color_edge = 0xff4d8da8, -- cape edge color (ABGR)
        wands ={ -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    shuffle_deck_when_empty = true, -- shuffle
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
        potions ={ -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items ={ -- items
            { "data/entities/misc/custom_cards/bomb_holy.xml" },
        },
        perks ={ -- perks
            { "ABILITY_ACTIONS_MATERIALIZED" },
        }
    },
    { -- Melting (More Loadouts Update)
        id = "gkbrkn_melting", -- unique identifier
        name = "$loadout_melting", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff2c7b50, -- cape color (ABGR)
        cape_color_edge = 0xff3f9b69, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
            { { {"acid", 1000} } },
            { { {"lava", 1000} } },
        },
        items = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Combustion (More Loadouts Update)
        id = "gkbrkn_combustion", -- unique identifier
        name = "$loadout_combustion", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff2154a9, -- cape color (ABGR)
        cape_color_edge = 0xff3570d3, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {7,7}, -- capacity
                    reload_time = {50,50}, -- recharge time in frames
                    fire_rate_wait = {24,24}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {50,50}, -- mana charge speed
                    mana_max = {150,150}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "BOUNCE" },
                    { "LASER" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {6,6}, -- capacity
                    reload_time = {14,14}, -- recharge time in frames
                    fire_rate_wait = {18,18}, -- cast delay in frames
                    spread_degrees = {3,3}, -- spread
                    mana_charge_speed = {50,50}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "BURN_TRAIL" },
                    { "GRAVITY" },
                    { "RUBBER_BALL" },
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
            { { { "fire", 500 }, { "gunpowder_unstable", 500 } } },
        },
        items = { -- items
        },
        perks = { -- perks
            { "REVENGE_EXPLOSION" }
        }
    },
    { -- Hydromancy (More Loadouts Update)
        id = "gkbrkn_hydromancy", -- unique identifier
        name = "$loadout_hydromancy", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff7b572c, -- cape color (ABGR)
        cape_color_edge = 0xff9b703f, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 0.5 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {7,7}, -- capacity
                    reload_time = {50,50}, -- recharge time in frames
                    fire_rate_wait = {24,24}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {50,50}, -- mana charge speed
                    mana_max = {150,150}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                    { "LIGHT_SHOT" },
                },
                actions = {
                    { "WATER_TO_POISON" },
                    { "LANCE" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {4,4}, -- capacity
                    reload_time = {5,5}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {7,7}, -- spread
                    mana_charge_speed = {50,50}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                    { "WATER_TRAIL" },
                },
                actions = {
                    { "HEAVY_SPREAD" },
                    { "LONG_DISTANCE_CAST" },
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "SPEED_DIVER" },
            { "SPEED_DIVER" },
        }
    },
    { -- Critical (More Loadouts Update; was Blood)
        id = "gkbrkn_critical", -- unique identifier
        name = "$loadout_critical", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff1e1a87, -- cape color (ABGR)
        cape_color_edge = 0xff2f2aa9, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = true, -- shuffle
                    actions_per_round = 5, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {5,5}, -- capacity
                    reload_time = {15,15}, -- recharge time in frames
                    fire_rate_wait = {18,18}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {60,60}, -- mana charge speed
                    mana_max = {140,140}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "LIGHT_BULLET" },
                    { "LIGHT_BULLET" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {3,3}, -- capacity
                    reload_time = {1800,1800}, -- recharge time in frames
                    fire_rate_wait = {60,60}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {10,10}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                    { "CLOUD_BLOOD" },
                },
                actions = {
                    { "GKBRKN_PASSIVE_RECHARGE" },
                    { "HOMING_SHOOTER" },
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "GLOBAL_GORE" },
        }
    },
    { -- Geomancer (More Loadouts Update)
        id = "gkbrkn_geomancer", -- unique identifier
        name = "$loadout_geomancer", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff526e50, -- cape color (ABGR)
        cape_color_edge = 0xff3a4d39, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {5,5}, -- capacity
                    reload_time = {30,30}, -- recharge time in frames
                    fire_rate_wait = {8,8}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {40,40}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "SUMMON_HOLLOW_EGG" },
                    { "SOILBALL" },
                    { "AIR_BULLET" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = true, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {4,4}, -- capacity
                    reload_time = {16,16}, -- recharge time in frames
                    fire_rate_wait = {12,12}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {90,90}, -- mana charge speed
                    mana_max = {360,360}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "SUMMON_HOLLOW_EGG" },
                    { "BOMB_HOLY" },
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
            { { { "void_liquid", 1000 } } },
        },
        items = { -- items
        },
        perks = { -- perks
            { "DISSOLVE_POWDERS" },
        }
    },
    { -- Light (More Loadouts Update)
        id = "gkbrkn_light", -- unique identifier
        name = "$loadout_light", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff4da877, -- cape color (ABGR)
        cape_color_edge = 0xff29d277, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {8,8}, -- capacity
                    reload_time = {34,34}, -- recharge time in frames
                    fire_rate_wait = {78,78}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {64,64}, -- mana charge speed
                    mana_max = {200,200}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "GKBRKN_TRIGGER_TIMER" },
                    { "SPEED" },
                    { "LASER" },
                    { "GKBRKN_FORMATION_STACK" },
                    { "LASER" },
                    { "LASER" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {7,7}, -- capacity
                    reload_time = {48,48}, -- recharge time in frames
                    fire_rate_wait = {60,60}, -- cast delay in frames
                    spread_degrees = {1,1}, -- spread
                    mana_charge_speed = {150,150}, -- mana charge speed
                    mana_max = {150,150}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "UNSTABLE_GUNPOWDER" },
                    { "GKBRKN_FORMATION_STACK" },
                    { "LASER" },
                    { "LASER" },
                    { "LASER" },
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "INVISIBILITY" },
        }
    },
    { -- Speed (More Loadouts Update)
        id = "gkbrkn_speed", -- unique identifier
        name = "$loadout_speed", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff0c00d4, -- cape color (ABGR)
        cape_color_edge = 0xff6059e2, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {5,5}, -- capacity
                    reload_time = {18,18}, -- recharge time in frames
                    fire_rate_wait = {11,11}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {45,45}, -- mana charge speed
                    mana_max = {180,180}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                    {"LIGHT_SHOT"},
                },
                actions = {
                    {"BOUNCY_ORB"}
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = true, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {4,4}, -- capacity
                    reload_time = {16,16}, -- recharge time in frames
                    fire_rate_wait = {12,12}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {60,60}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    {"ROCKET"},
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
            { { { "magic_liquid_movement_faster", 1000 } } },
        },
        items = { -- items
        },
        perks = { -- perks
            { "MOVEMENT_FASTER" },
            { "SPEED_DIVER" },
        }
    },
    { -- Rapid (More Loadouts Update)
        id = "gkbrkn_rapid", -- unique identifier
        name = "$loadout_rapid", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff0c00d4, -- cape color (ABGR)
        cape_color_edge = 0xff6059e2, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {5,5}, -- capacity
                    reload_time = {10,10}, -- recharge time in frames
                    fire_rate_wait = {7,7}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {35,35}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    {"SPITTER"}
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {4,4}, -- capacity
                    reload_time = {16,16}, -- recharge time in frames
                    fire_rate_wait = {12,12}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {90,90}, -- mana charge speed
                    mana_max = {360,360}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    {"DYNAMITE"},
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "GKBRKN_RAPID_FIRE" },
        }
    },
    { -- Eldritch (More Loadouts Update)
        id = "gkbrkn_eldritch", -- unique identifier
        name = "$loadout_eldritch", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff7d4e53, -- cape color (ABGR)
        cape_color_edge = 0xff6b4144, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {5,5}, -- capacity
                    reload_time = {15,15}, -- recharge time in frames
                    fire_rate_wait = {15,15}, -- cast delay in frames
                    spread_degrees = {2,2}, -- spread
                    mana_charge_speed = {30,30}, -- mana charge speed
                    mana_max = {100,100}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                    {"TENTACLE_RAY"},
                },
                actions = {
                    {"TENTACLE"},
                }
            },
            {
                name = "Wand",
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
                    mana_charge_speed = {60,60}, -- mana charge speed
                    mana_max = {120,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    {"TENTACLE_TIMER"},
                    {"BURST_2"},
                    {"POISON_BLAST"},
                    {"FIRE_BLAST"},
                }
            },
        },
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Bouncy (More Loadouts Update)
        id = "gkbrkn_bouncy", -- unique identifier
        name = "$loadout_bouncy", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xff00FF00, -- cape color (ABGR)
        cape_color_edge = 0xff00FF00, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {8,8}, -- capacity
                    reload_time = {15,15}, -- recharge time in frames
                    fire_rate_wait = {15,15}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {80,80}, -- mana charge speed
                    mana_max = {180,180}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { { action="GKBRKN_HYPER_BOUNCE",locked=true} },
                    { { action="ACCELERATING_SHOT",locked=true} },
                    { { action="GKBRKN_ZERO_GRAVITY",locked=true} },
                    { "LIGHT" },
                    { "RUBBER_BALL" },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
                    { "BOUNCE" },
                    { "GRENADE_LARGE" },
                }
            },
        },
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Lancer (More Loadouts Update)
        id = "gkbrkn_lancer", -- unique identifier
        name = "$loadout_lancer", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFFFFFFFF, -- cape color (ABGR)
        cape_color_edge = 0xFFFFFFFF, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 4, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {12,12}, -- capacity
                    reload_time = {23,23}, -- recharge time in frames
                    fire_rate_wait = {23,23}, -- cast delay in frames
                    spread_degrees = {1,1}, -- spread
                    mana_charge_speed = {80,80}, -- mana charge speed
                    mana_max = {180,180}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { { action="DAMAGE",locked=true } },
                    { { action="LONG_DISTANCE_CAST",locked=true } },
                    { { action="GKBRKN_SPEED_DOWN",locked=true } },
                    { { action="HEAVY_SHOT",locked=true } },
                    { { action="LONG_DISTANCE_CAST",locked=true } },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { { "water", 1000 } } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        }
    },
    { -- Debug
        id = "gkbrkn_debug", -- unique identifier
        name = "$loadout_debug", -- displayed loadout name
        description = "A loadout useful for development.",
        author = "$ui_author_name_goki_dev",
        cape_color = nil, -- cape color (ABGR)
        cape_color_edge = nil, -- cape edge color (ABGR)
        enabled_by_default = false,
        wands = { -- wands
            {
                name = "Debug Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {25,25}, -- capacity
                    reload_time = {10,10}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {30,30}, -- spread
                    mana_charge_speed = {1000,1000}, -- mana charge speed
                    mana_max = {5000,5000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { "GKBRKN_TRIPLE_CAST" },
                    nil,
                    nil,
                    { "BUBBLESHOT" },
                }
            },
            {
                name = "Debug Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {25,25}, -- capacity
                    reload_time = {10,10}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {1000,1000}, -- mana charge speed
                    mana_max = {5000,5000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "GKBRKN_TRIGGER_REPEAT" },
                    { "SLOW_BULLET" },
                    { "GKBRKN_DUPLICAST" },
                    { "HEAVY_SPREAD" },
                    { "LIGHT_BULLET" },
                }
            },
            {
                name = "Debug Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {25,25}, -- capacity
                    reload_time = {10,10}, -- recharge time in frames
                    fire_rate_wait = {5,5}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {1000,1000}, -- mana charge speed
                    mana_max = {5000,5000}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "GKBRKN_TRIPLE_CAST" },
                    { "GKBRKN_TRIPLE_CAST" },
                }
            },
            {
                name = "Wand",
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
                { { action="LONG_DISTANCE_CAST", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="TELEPORT_PROJECTILE", locked=false } },
                { { action="DELAYED_SPELL", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="LIFETIME_DOWN", locked=false } },
                { { action="TELEPORT_PROJECTILE", locked=false } },
            }
            }
        },
        potions = { -- potions
            { { {"water", 250} } }, -- a list of random choices of material amount pairs
            { { {"alcohol", 500}, {"lava",500} } }, -- a list of random choices of material amount pairs
            { { {"magic_liquid_random_polymorph", 750} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
        },
        actions = { -- actions
            {"LIGHT_BULLET"},
            {"GKBRKN_MAGIC_LIGHT"},
            {"LIGHT_BULLET","HEAVY_BULLET","SLOW_BULLET"},
            {"CHAINSAW"},
            {"DIGGER"},
            {"POWERDIGGER"},
            {"GKBRKN_SPELL_MERGE"},
            {"BURST_2"},
            {"GKBRKN_GLITTERING_TRAIL"},
            {"GKBRKN_STORED_SHOT"},
        },
        sprites = nil, -- sprites
        custom_message = "", -- custom message
        callback = function( player )
            local x, y = EntityGetTransform( player );
            local target_dummy = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x + 500, y - 80 );
            local effect = GetGameEffectLoadTo( player, "EDIT_WANDS_EVERYWHERE", true );
            if effect ~= nil then ComponentSetValue2( effect, "frames", -1 ); end
            local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
            if inventory2 ~= nil then
                ComponentSetValue2( inventory2, "full_inventory_slots_y", 5 );
            end
            EntityLoad( "data/entities/items/pickup/goldnugget_10000.xml", x + 50, y - 30 );
            --EntityAddComponent( player, "LuaComponent", {
            --    script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/regen.lua"
            --});
        end,
        condition_callback = function() return HasFlagPersistent( FLAGS.DebugMode ) end,
        enabled_by_default = false
    },
    { id = "gkbrkn_gunner", -- unique identifier
        name = "$loadout_gunner", -- displayed loadout name
        description = "A default loadout description",
        author = "$ui_author_name_goki_dev",
        cape_color = 0xFF333333, -- cape color (ABGR)
        cape_color_edge = 0xFF666666, -- cape edge color (ABGR)
        wands = { -- wands
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1.0 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {5,5}, -- capacity
                    reload_time = {14,14}, -- recharge time in frames
                    fire_rate_wait = {22,22}, -- cast delay in frames
                    spread_degrees = {3,3}, -- spread
                    mana_charge_speed = {50,50}, -- mana charge speed
                    mana_max = {100,100}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                },
                actions = {
                    { { action="GKBRKN_BURST_FIRE", locked=false } },
                    { { action="LIGHT_BULLET", locked=false } },
                }
            },
            {
                name = "Wand",
                stats = {
                    shuffle_deck_when_empty = false, -- shuffle
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
        potions = { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        items = { -- items
        },
        perks = { -- perks
            { "GKBRKN_LEAD_BOOTS" }
        }
    },
}
