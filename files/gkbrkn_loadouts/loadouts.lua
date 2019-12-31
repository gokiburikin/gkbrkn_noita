dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
loadouts_to_parse = {};

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
                deck_capacity = {1,1}, -- capacity
                reload_time = {15,15}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {50,50}, -- mana charge speed
                mana_max = {130,130}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {},
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
        {nil, "TELEPORTITIS"},
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
                { "CHAOTIC_ARC" }
            },
            actions = {
                { "GKBRKN_CHAOTIC_BURST" }
            }
        },
        {
            name = "Unstable Wand",
            stats = {
                shuffle_deck_when_empty = 1, -- shuffle
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
                { "MINE" }
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
                fire_rate_wait = {12,12}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {100,100}, -- mana charge speed
                mana_max = {100,100}, -- mana max
            },
            stat_randoms = {},
            permanent_actions = {
                {"GKBRKN_TRIGGER_DEATH"},
            },
            actions = {
                { "GKBRKN_ZAP" },
                { "GKBRKN_ZAP" },
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
                {"ELECTRIC_CHARGE"}
            },
            actions = {
                {"LIGHT_BULLET"}
            }
        }
    },
    { -- potions
        { { {"water", 1000} } }, -- a list of random choices of material amount pairs
    },
    { -- items
    },
    { -- perks
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
                deck_capacity = {4,4}, -- capacity
                reload_time = {20,20}, -- recharge time in frames
                fire_rate_wait = {15,15}, -- cast delay in frames
                spread_degrees = {0,0}, -- spread
                mana_charge_speed = {60,60}, -- mana charge speed
                mana_max = {300,300}, -- mana max
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
        { "SPEED_DIVER" }
    }
);

--[[ reference this example of bringing the base starting loadouts into the new method
    -- Nolla Summoner
    register_loadout(
        "nolla_summoner", -- unique identifier
        "Summoner TYPE", -- displayed loadout name
        0xff60a1a2, -- cape color (ABGR)
        0xff3c696a, -- cape edge color (ABGR)
        { -- wands
            {
                name = "Summoner Wand",
                stats = {
                    shuffle_deck_when_empty = 1, -- shuffle
                    actions_per_round = 2, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {2,3}, -- capacity
                    reload_time = {30,50}, -- recharge time in frames
                    fire_rate_wait = {30,50}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {170,190}, -- mana charge speed
                    mana_max = {220,260}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    {"PEBBLE"}
                }
            },
            {
                name = "Summoner Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {2,3}, -- capacity
                    reload_time = {30,50}, -- recharge time in frames
                    fire_rate_wait = {30,50}, -- cast delay in frames
                    spread_degrees = {5,10}, -- spread
                    mana_charge_speed = {15,35}, -- mana charge speed
                    mana_max = {120,150}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                },
                callback = function( wand, ability )
                    if ( Random( 1, 400 > 1 ) ) then
                        AddGunActionPermanent( wand, "SUMMON_ROCK" );
                    else
                        ComponentObjectSetValue( ability, "gun_config", "reload_time", 500 );
                        ComponentObjectSetValue( ability, "gunaction_config", "spread_degrees", 15 );
                        ComponentObjectSetValue( ability, "gun_config", "shuffle_deck_when_empty", 1 );
                        AddGunActionPermanent( wand, "SUMMON_EGG" );
                    end
                end
            }
        },
        { -- potions
            { { {"water", 1000} } }, -- a list of random choices of material amount pairs
        },
        { -- items
            { "data/entities/items/pickup/egg_fire.xml", "data/entities/items/pickup/egg_red.xml", "data/entities/items/pickup/egg_monster.xml", "data/entities/items/pickup/egg_slime.xml" },
            { "data/entities/items/pickup/egg_fire.xml", "data/entities/items/pickup/egg_red.xml", "data/entities/items/pickup/egg_monster.xml", "data/entities/items/pickup/egg_slime.xml" },
            { "data/entities/items/pickup/egg_fire.xml", "data/entities/items/pickup/egg_red.xml", "data/entities/items/pickup/egg_monster.xml", "data/entities/items/pickup/egg_slime.xml" },
        },
        { -- perks
        }
    );

    -- Nolla Fire
    register_loadout(
        "nolla_fire", -- unique identifier
        "Fire TYPE", -- displayed loadout name
        0xff5a60dd, -- cape color (ABGR)
        0xff3e43af, -- cape edge color (ABGR)
        { -- wands
            {
                name = "Fire Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {2,3}, -- capacity
                    reload_time = {4,10}, -- recharge time in frames
                    fire_rate_wait = {5,10}, -- cast delay in frames
                    spread_degrees = {0,4}, -- spread
                    mana_charge_speed = {20,40}, -- mana charge speed
                    mana_max = {120,160}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    --{ "FIRE_TRAIL","OIL_TRAIL","BURN_TRAIL" },
                    --{ "FIREBOMB", "GRENADE" }
                },
                callback = function( wand, ability )
                    local actions = { "FIREBOMB", "GRENADE" };
                    local modifiers = {"FIRE_TRAIL","OIL_TRAIL","BURN_TRAIL" };
                    local action_count = 1;
                    local deck_capacity = tonumber( ComponentObjectGetValue( ability, "gun_config", "deck_capacity" ) );
                    local modifier_count = math.min( deck_capacity - action_count, Random( 1, 2 ) );

                    for i=1,modifier_count do
                        local modifier = modifiers[ Random( 1, #modifiers ) ];
                        
                        if i == 1 and Random( 1, 200 ) == 5 then
                            AddGunActionPermanent( wand, modifier );
                            deck_capacity = deck_capacity + 1;
                            ComponentObjectSetValue( ability, "gun_config", "deck_capacity", deck_capacity );
                        else
                            AddGunAction( wand, modifier );
                        end
                    end

                    for i=1,action_count do
                        local action = actions[ Random( 1, #actions ) ];
                        AddGunAction( wand, action );
                    end
                end
            },
            {
                name = "Fire Wand 2",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                    spread_degrees = 0, -- spread
                },
                stat_ranges = {
                    deck_capacity = {2,3}, -- capacity
                    reload_time = {35,65}, -- recharge time in frames
                    fire_rate_wait = {35,65}, -- cast delay in frames
                    mana_charge_speed = {20,40}, -- mana charge speed
                    mana_max = {130,160}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "FIREBALL","ROCKET" },
                },
                callback = function( wand, ability )
                    if ( Random( 1, 10 ) > 2 ) then
                        AddGunActionPermanent( wand, "OIL_TRAIL" );
                    else
                        AddGunAction( wand, "TORCH" );
                    end
                end
            }
        },
        { -- potions
            { { {"liquid_fire", 1000} } }, -- a list of random choices of material amount pairs
            { { {"liquid_fire", 500}, {"oil", 500} } },
        },
        { -- items
        },
        { -- perks
            {"PROTECTION_FIRE"},
            {"BLEED_OIL"},
        }
    );

    -- Nolla Slime
    register_loadout(
        "nolla_slime", -- unique identifier
        "Slime TYPE", -- displayed loadout name
        0xff9a6f9b, -- cape color (ABGR)
        0xff76547f, -- cape edge color (ABGR)
        { -- wands
            {
                name = "Slime Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {2,3}, -- capacity
                    reload_time = {10,30}, -- recharge time in frames
                    fire_rate_wait = {5,10}, -- cast delay in frames
                    mana_charge_speed = {20,40}, -- mana charge speed
                    mana_max = {90,140}, -- mana max
                    spread_degrees = {0,5}, -- spread
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "LIGHT_BULLET_TIMER", "LIGHT_BULLET_TRIGGER" },
                    { "MIST_SLIME" },
                }
            },
            {
                name = "Slime Wand 2",
                stats = {
                    shuffle_deck_when_empty = 1, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {3,4}, -- capacity
                    reload_time = {30,60}, -- recharge time in frames
                    fire_rate_wait = {20,40}, -- cast delay in frames
                    spread_degrees = {0,0}, -- spread
                    mana_charge_speed = {20,40}, -- mana charge speed
                    mana_max = {120,160}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {
                    {"HITFX_EXPLOSION_SLIME"}
                },
                actions = {
                    {"SPEED"},
                    {"SLIMEBALL", "ACIDSHOT"},
                }
            },
            {
                name = "Slime Wand 3",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {1,1}, -- capacity
                    reload_time = {1,1}, -- recharge time in frames
                    fire_rate_wait = {5,10}, -- cast delay in frames
                    mana_charge_speed = {20,20}, -- mana charge speed
                    mana_max = {40,40}, -- mana max
                    spread_degrees = {0,5}, -- spread
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "HITFX_EXPLOSION_SLIME_GIGA" },
                },
                callback = function( wand, ability )
                    EntityAddComponent( wand, "LuaComponent", {
                        execute_on_added="1",
                        remove_after_executed="1",
                        script_source_file="data/scripts/gun/procedural/handgun.lua",
                    });
                end
            },
        },
        { -- potions
            { {{"slime",1000}} },
            { {{"slime",1000}} },
        },
        { -- items
        },
        { -- perks
            {"BLEED_SLIME"},
        }
    );

    -- Nolla Thunder
    register_loadout(
        "nolla_thunder", -- unique identifier
        "Thunder TYPE", -- displayed loadout name
        0xff9d7b4d, -- cape color (ABGR)
        0xff846235, -- cape edge color (ABGR)
        { -- wands
            {
                name = "Thunder Wand",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {1,2}, -- capacity
                    reload_time = {70,100}, -- recharge time in frames
                    fire_rate_wait = {50,90}, -- cast delay in frames
                    spread_degrees = {3,9}, -- spread
                    mana_charge_speed = {25,35}, -- mana charge speed
                    mana_max = {120,140}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    --{ "FIRE_TRAIL","OIL_TRAIL","BURN_TRAIL" },
                    --{ "LIGHTNING", "THUNDERBALL" }
                },
                callback = function( wand, ability )
                    local deck_capacity = tonumber( ComponentObjectGetValue( ability, "gun_config", "deck_capacity" ) );

                    local actions = { "LIGHTNING", "THUNDERBALL" };
                    if deck_capacity == 2 then
                        if ( Random( 1, 10 ) > 2 ) then
                            AddGunAction( wand, "ELECTRIC_CHARGE" )
                        else
                            AddGunAction( wand, "TORCH_ELECTRIC" )
                        end
                    end

                    local action = actions[ Random( 1, #actions ) ];
                    AddGunAction( wand, action );
                end
            },
            {
                name = "Thunder Wand 2",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                    spread_degrees = 0, -- spread
                },
                stat_ranges = {
                    deck_capacity = {3,4}, -- capacity
                    reload_time = {30,50}, -- recharge time in frames
                    fire_rate_wait = {10,45}, -- cast delay in frames
                    mana_charge_speed = {10,30}, -- mana charge speed
                    mana_max = {140,170}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "SPITTER_TIMER", "SLOW_BULLET_TIMER", "LIGHT_BULLET_TIMER" },
                    { "ELECTROCUTION_FIELD","THUNDER_BLAST","PROJECTILE_THUNDER_FIELD" },
                }
            }
        },
        { -- potions
        },
        { -- items
            {"data/entities/items/pickup/thunderstone.xml"}
        },
        { -- perks
            {"ELECTRICITY"},
        }
    );

    -- Nolla Eldritch
    register_loadout(
        "nolla_eldritch", -- unique identifier
        "Eldritch TYPE", -- displayed loadout name
        0xff7d4e53, -- cape color (ABGR)
        0xff6b4144, -- cape edge color (ABGR)
        { -- wands
            {
                name = "Eldritch Wand",
                stats = {
                    shuffle_deck_when_empty = 1, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 0.75 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {2,3}, -- capacity
                    reload_time = {30,40}, -- recharge time in frames
                    fire_rate_wait = {20,30}, -- cast delay in frames
                    spread_degrees = {3,8}, -- spread
                    mana_charge_speed = {10,30}, -- mana charge speed
                    mana_max = {100,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                },
                callback = function( wand, ability )
                    if Random(1,20) == 1 then
                        ComponentObjectSetValue( ability, "gun_config", "actions_per_round", 2 );
                    end

                    local action_count = Random(1,2);

                    for i=1,action_count do
                        if Random( 1, 6 ) == 1 then
                            AddGunAction( wand, "TENTACLE_TIMER" );
                        else
                            AddGunAction( wand, "TENTACLE" );
                        end
                    end
                end
            },
            {
                name = "Eldritch Wand 2",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                    spread_degrees = 0, -- spread
                },
                stat_ranges = {
                    deck_capacity = {1,1}, -- capacity
                    reload_time = {85,105}, -- recharge time in frames
                    fire_rate_wait = {65,85}, -- cast delay in frames
                    mana_charge_speed = {10,20}, -- mana charge speed
                    mana_max = {200,200}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                    { "TENTACLE_PORTAL" }
                }
            }
        },
        { -- potions
            { {{"magic_liquid_teleportation",1000}} },
            { {{"water",1000}} },
        },
        { -- items
        },
        { -- perks
            {"REVENGE_TENTACLE"},
        }
    );

    -- Nolla Butcher
    register_loadout(
        "nolla_butcher", -- unique identifier
        "Butcher TYPE", -- displayed loadout name
        0xff4f626b, -- cape color (ABGR)
        0xff465258, -- cape edge color (ABGR)
        { -- wands
            {
                name = "Butcher Wand",
                stats = {
                    shuffle_deck_when_empty = 1, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 0.75 -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {2,3}, -- capacity
                    reload_time = {15,15}, -- recharge time in frames
                    fire_rate_wait = {30,50}, -- cast delay in frames
                    spread_degrees = {1,4}, -- spread
                    mana_charge_speed = {25,45}, -- mana charge speed
                    mana_max = {80,120}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {
                },
                callback = function( wand, ability )
                    if ( Random( 1, 10 ) > 1 ) then
                        AddGunAction( wand, "CHAINSAW" );
                    else
                        AddGunAction( wand, "LUMINOUS_DRILL" );
                        ComponentSetValue( ability, "mana_charge_speed", Random( 45, 55 ) );
                    end
                end
            },
            {
                name = "Butcher Wand 2",
                stats = {
                    shuffle_deck_when_empty = 0, -- shuffle
                    actions_per_round = 1, -- spells per cast
                    speed_multiplier = 1, -- projectile speed multiplier (hidden)
                },
                stat_ranges = {
                    deck_capacity = {3,4}, -- capacity
                    reload_time = {20,50}, -- recharge time in frames
                    fire_rate_wait = {20,45}, -- cast delay in frames
                    spread_degrees = {2,5}, -- spread
                    mana_charge_speed = {15,35}, -- mana charge speed
                    mana_max = {110,140}, -- mana max
                },
                stat_randoms = {},
                permanent_actions = {},
                actions = {},
                callback = function( wand, ability )
                    local actions = { "DISC_BULLET", "DISC_BULLET_BIG", "DISC_BULLET" }
                    for i=1,2 do
                        local action = actions[ Random( 1, #actions ) ];
                        AddGunAction( wand, action );
                    end

                    local speed = 1.0 + Random( 0, 5 ) * 0.1;
                    ComponentObjectSetValue( ability, "gunaction_config", "speed_multiplier", speed );
                end
            }
        },
        { -- potions
            { {{"magic_liquid_berserk",1000}} },
            { {{"blood",1000}} },
        },
        { -- items
        },
        { -- perks
            {"GLOBAL_GORE"},
            {"STRONG_KICK"},
        }
    );
]]