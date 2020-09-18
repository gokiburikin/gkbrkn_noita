--[[ Pack to consider

Alchemy - useful for finding alchemic recipes
Book - Encyclopedias, paper shot
Multicast - 
Explosives - 
Summoning - 
Digging/Mining - 
Exploration - 
Ocean Friends 2 - 
Danger - 
Electric - 
Celebration/Festive - 
Velocity - 
Archery - homing????????????????????????????????????????
Fields - 
Geometry - 


]]

local memoize_packs = {};
function find_pack( id )
    local pack = nil;
    if memoize_packs[id] then
        pack = memoize_packs[id];
    else
        for _,entry in pairs(packs) do
            if entry.id == id then
                pack = entry;
                parse_pack_action_weights( entry );
                memoize_packs[id] = entry;
            end
        end
    end
    return pack;
end

local RARITY = {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    VeryRare = 4,
    Legendary = 5
}

local RARITY_RATIOS = {
    [RARITY.Common] = 0.38,
    [RARITY.Uncommon] = 0.28,
    [RARITY.Rare] = 0.18,
    [RARITY.VeryRare] = 0.10,
    [RARITY.Legendary] = 0.06,
}

function parse_pack_action_weights( pack_data )
    local rarity_buckets = {};
    for _,action in pairs( pack_data.actions ) do
        local action_rarity = action.rarity or RARITY.Common;
        rarity_buckets[action_rarity] = ( rarity_buckets[action_rarity] or {} );
        table.insert( rarity_buckets[action_rarity], action );
    end
    local rarity_weights = {};
    for rarity,bucket in pairs( rarity_buckets ) do
        local weight = RARITY_RATIOS[rarity] / ( #bucket or 1 );
        for _,action_data in pairs( bucket ) do
            --action_data.weight = math.ceil( weight * 100 );
            action_data.weight = weight;
        end
    end
end

function crack_pack( pack_data, x, y, i )
    local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua");
    if i == nil then
        i = 0;
    end
    SetRandomSeed( x + i, y + i );
    local spawn_attempts = 100;
    local card_amounts = {};
    local card_weight_table = {};
    local chosen_cards = {};
    for card_data_index,action in pairs( pack_data.actions ) do
        card_weight_table[card_data_index] = action.weight;
    end
    while #chosen_cards < MISC.PackShops.CardsPerPack and spawn_attempts > 0 do
        local chosen_card_index = WeightedRandomTable( card_weight_table );
        local chosen_card_data = pack_data.actions[ chosen_card_index ];
        if chosen_card_data and ( chosen_card_data.limit_per_pack or -1 ) > 0 then
            if ( card_amounts[chosen_card_data.id] or 0 ) < chosen_card_data.limit_per_pack then
                card_amounts[chosen_card_data.id] = (card_amounts[chosen_card_data.id] or 0) + 1;
                table.insert( chosen_cards, chosen_card_data.id );
            end
        else
            spawn_attempts = spawn_attempts - 1;
        end
    end
    for j=1,MISC.PackShops.RandomCardsPerPack do
        table.insert( chosen_cards, GetRandomAction( x + i, y + i, 6, j ) );
    end
    return chosen_cards;
end

function simulate_cracking_packs( pack_id, amount, x, y )
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
    local cards_pulled = {};
    for i=1,amount do
        local cards_in_pack = crack_pack( find_pack( pack_id ), x, y, i );
        for _,action_id in pairs( cards_in_pack ) do
            cards_pulled[ action_id ] = ( cards_pulled[ action_id ] or 0 ) + 1;
        end
    end
    print( "\nSimulated opening "..pack_id.." "..amount.." times:" );
    cards_pulled = sort_keyed_table( cards_pulled, function( a, b ) return a.value > b.value; end );
    for k,v in pairs(cards_pulled) do
        print("\t"..v.key..": "..v.value);
    end
end

packs = {
    --[[
    {
        id = "gkbrkn_test",
        name = "Test Pack",
        -- this might become an xml to load? that way people could design specialer packs
        image_filepath = "mods/gkbrkn_noita/files/gkbrkn/packs/test/pack.png", -- the path to the pack image
        custom_xml = nil, -- this would contain a pack entity that might have cool legendary effects
        author = "goki", -- your name
        cards_in_pack = 5, -- this is how many cards the player will get when they buy the pack (default 5)
        weight = 1, -- the likelihood that this pack will show up over other packs (higher is more often)
        limit_per_run = -1, -- the max amount this pack can spawn in a run. -1 is no limit
        validation_callback = nil, -- a function callback to see if this can spawn. ignore for the most part
        deprecated = true,
        actions = {
            {
                id = "LIGHT_BULLET", -- the action id. this one is sparkbolt
                weight = 5, -- the likelihood this card will be chosen to be in the pack. higher is more often
                limit_per_pack = 3, -- the max amount of this spell you can get in one pack
            },
            {
                id = "HEAVY_BULLET", -- magic bolt
                weight = 2,
                limit_per_pack = 2,
            },
            {
                id = "SLOW_BULLET", -- energy orb
                weight = 1,
                limit_per_pack = 1,
            }
        }
    },
    {
        id = "gkbrkn_alchemy",
        name = "Alchemy",
        -- this might become an xml to load? that way people could design specialer packs
        image_filepath = "mods/gkbrkn_noita/files/gkbrkn/packs/pack.png", -- the path to the pack image
        custom_xml = nil, -- this would contain a pack entity that might have cool legendary effects
        author = "goki", -- your name
        cards_in_pack = 5, -- this is how many cards the player will get when they buy the pack (default 5)
        weight = 1, -- the likelihood that this pack will show up over other packs (higher is more often)
        limit_per_run = -1, -- the max amount this pack can spawn in a run. -1 is no limit
        validation_callback = nil, -- a function callback to see if this can spawn. ignore for the most part
        actions = {
            {
                id = "ACIDSHOT",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "CIRCLE_ACID",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "MATERIAL_ACID",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "MATERIAL_CEMENT",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "BLOOD_TO_ACID",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "TOXIC_TO_ACID",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "SEA_ACID",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "SEA_ACID_GAS",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "CLOUD_ACID",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "ACID_TRAIL",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "",
                weight = 5,
                limit_per_pack = 1,
            },
        }
    },
    ]]
    {
        id = "gkbrkn_critical_hits",
        name = "Critical Hits",
        -- this might become an xml to load? that way people could design specialer packs
        image_filepath = "mods/gkbrkn_noita/files/gkbrkn/packs/critical_hits/pack.png", -- the path to the pack image
        custom_xml = nil, -- this would contain a pack entity that might have cool legendary effects
        author = "goki", -- your name
        weight = 1, -- the likelihood that this pack will show up over other packs (higher is more often)
        limit_per_run = -1, -- the max amount this pack can spawn in a run. -1 is no limit
        validation_callback = nil, -- a function callback to see if this can spawn. ignore for the most part
        actions = {
            {
                id = "SWAPPER_PROJECTILE",
                rarity = RARITY.VeryRare,
                limit_per_pack = 1,
            },
            {
                id = "CRITICAL_HIT",
                rarity = RARITY.VeryRare,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_BULLET",
                rarity = RARITY.Common,
                limit_per_pack = 3,
            },
            {
                id = "LIGHT_BULLET_TRIGGER",
                rarity = RARITY.Uncommon,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_BULLET_TRIGGER_2",
                rarity = RARITY.Rare,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_BULLET_TIMER",
                rarity = RARITY.Uncommon,
                limit_per_pack = 1,
            },
            {
                id = "BULLET",
                rarity = RARITY.Common,
                limit_per_pack = 2,
            },
            {
                id = "BULLET_TRIGGER",
                rarity = RARITY.Uncommon,
                limit_per_pack = 1,
            },
            {
                id = "BULLET_TIMER",
                rarity = RARITY.Uncommon,
                limit_per_pack = 1,
            },
            {
                id = "HEAVY_BULLET",
                rarity = RARITY.Uncommon,
                limit_per_pack = 1,
            },
            {
                id = "HEAVY_BULLET_TRIGGER",
                rarity = RARITY.Rare,
                limit_per_pack = 1,
            },
            {
                id = "HEAVY_BULLET_TIMER",
                rarity = RARITY.Rare,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_BURNING_CRITICAL_HIT",
                rarity = RARITY.Legendary,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_CRITICAL_WATER",
                rarity = RARITY.Legendary,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_CRITICAL_OIL",
                rarity = RARITY.Legendary,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_CRITICAL_BLOOD",
                rarity = RARITY.Legendary,
                limit_per_pack = 1,
            }
        }
    }--[[,
    {
        id = "pasta_1",
        name = "Hard to Breathe",
        author = "pasta",
        cards_in_pack = 5,
        weight = 1,
        limit_per_run = -1,
        actions = {
            {
                id = "MIST_ALCOHOL",
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "MIST_BLOOD",
                weight = 2,
                limit_per_pack = 1,
            },
            {
                id = "MIST_RADIOACTIVE",
                weight = 3,
                limit_per_pack = 1,
            },
            {
                id = "MIST_SLIME",
                weight = 3,
                limit_per_pack = 2,
            }
        }
    },
    {
        id = "pasta_2",
        name = "Touch of Magic",
        author = "pasta",
        cards_in_pack = 5,
        weight = 1,
        limit_per_run = -1,
        actions = {
            {
                id = "touch_alcohol",
                weight = 20,
                limit_per_pack =3,
            },
            {
                id = "touch_blood",
                weight = 10,
                limit_per_pack =1,
            },
            {
                id = "touch_oil",
                weight = 20,
                limit_per_pack =2,
            },
            {
                id = "touch_smoke",
                weight = 10,
                limit_per_pack =3,
            },
            {
                id = "touch_water",
                weight = 5,
                limit_per_pack =2,
            },
            {
                id = "touch_gold",
                weight = 1,
                limit_per_pack =1,
            },
        }
    },
    {
        id = "gkbrkn_starter",
        name = "Starter Pack",
        author = "lilyhops",
        cards_in_pack = 5,
        weight = 1,
        actions = {
            {
                id = "BOMB", -- bomb
                weight = 5,
                limit_per_pack = 3,
            },
             {
                id = "SPITTER", -- spitter bolt
                weight = 5,
                limit_per_pack = 5,
            },
             {
                id = "LIGHT_BULLET", -- light bullet
                weight = 5,
                limit_per_pack = 3,
            },
             {
                id = "HORIZONTAL_ARC", -- horizontal path
                weight = 5,
                limit_per_pack = 2,
            },
             {
                id = "DISC_BULLET", -- disc projectile
                weight = 3,
                limit_per_pack = 2,
            },
             {
                id = "SCATTER_2", -- double scatter
                weight = 3,
                limit_per_pack = 2,
            },
             {
                id = "FREEZE_FIELD", -- circle of stillness
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "CHAIN_BOLT", -- chain bolt
                weight = 1,
                limit_per_pack = 1,
            },
            {
                id = "BLACK_HOLE", -- black hole
                weight = 1,
                limit_per_pack = 3,
            },
            {
                id = "HOMING", -- homing
                weight = 1,
                limit_per_pack = 1,
            },
        }
    },
    {
        id = "gkbrkn_fire",
        name = "Fire Starter",
        author = "lilyhops",
        cards_in_pack = 5,
        weight = 1,
        actions = {
            {
                id = "FIREBOMB", -- firebomb
                weight = 3,
                limit_per_pack = 3,
            },
             {
                id = "BURN_TRAIL", -- burning trail
                weight = 3,
                limit_per_pack = 2,
            },
             {
                id = "TORCH", -- torch
                weight = 5,
                limit_per_pack = 2,
            },
             {
                id = "GRENADE", -- firebolt
                weight = 5,
                limit_per_pack = 2,
            },
            {
                id = "GRENADE_ANTI", -- odd firebolt
                weight = 5,
                limit_per_pack = 2,
            },
            {
                id = "METEOR", -- meteor
                weight = 1,
                limit_per_pack = 1,
            },
             {
                id = "CIRCLE_FIRE", -- circle of fire
                weight = 1,
                limit_per_pack = 1,
            },
             {
                id = "SEA_LAVA", -- sea of lava
                weight = 1,
                limit_per_pack = 2,
            },
             {
                id = "FIREBALL", -- fireball
                weight = 5,
                limit_per_pack = 3,
            },
             {
                id = "GRENADE_ANTI", -- odd firebolt
                weight = 5,
                limit_per_pack = 2,
            },
             {
                id = "FIRE_BLAST", -- explosion of brimstone
                weight = 3,
                limit_per_pack = 2,
            },
        }
    },
    {
        id = "gkbrkn_chaos",
        name = "Chaos Magic",
        author = "lilyhops",
        cards_in_pack = 5,
        weight = 1,
        actions = {
            {
                id = "CHAOTIC_ARC", -- chaotic path
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "TINY_GHOST", -- tiny ghost
                weight = 5,
                limit_per_pack = 5,
            },
             {
                id = "BUBBLESHOT", -- bubble spark
                weight = 5,
                limit_per_pack = 5,
            },
            {
                id = "SUMMON_WANDGHOST", -- summon taikasauva
                weight = 5,
                limit_per_pack = 2,
            },
             {
                id = "ROCKET_DOWNWARDS", -- downwards bolt bundle
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "TRANSMUTATION", -- chaotic transmutation
                weight = 3,
                limit_per_pack = 1,
            },
              {
                id = "GRAVITY_FIELD_ENEMY", -- personal gravity field
                weight = 3,
                limit_per_pack = 1,
            },
             {
                id = "CHAOS_POLYMORPH_FIELD", -- circle of unstable metamorphosis
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "gkbrkn_chaotic_burst", -- chaotic burst
                weight = 1,
                limit_per_pack = 5,
            },
             {
                id = "gkbrkn_false_spell", -- false spell
                weight = 1,
                limit_per_pack = 5,
            }
        }
    },
    {
        id = "gkbrkn_death",
        name = "Death Magic",
        author = "lilyhops",
        cards_in_pack = 5,
        weight = 1,
        actions = {
            {
                id = "DEATH_CROSS", -- death cross
                weight = 5,
                limit_per_pack = 5,
            },
            {
                id = "SUMMON_HOLLOW_EGG", -- summon hollow egg
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "DESTRUCTION", -- destruction
                weight = 5,
                limit_per_pack = 5,
            },
            {
                id = "NECROMANCY", -- necromancy
                weight = 3,
                limit_per_pack = 2,
            },
             {
                id = "PENTAGRAM_SHAPE", -- formation - pentagon
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "MATERIAL_BLOOD", -- blood
                weight = 3,
                limit_per_pack = 3,
            },
            {
                id = "GKBRKN_TRIGGER_DEATH", -- trigger death
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "GKBRKN_TRIGGER_TAKE_DAMAGE", -- trigger take damage
                weight = 1,
                limit_per_pack = 1,
            },
             {
                id = "TOUCH_BLOOD", -- touch of blood
                weight = 1,
                limit_per_pack = 1,
            }
        }
    },
    {
        id = "gkbrkn_venom",
        name = "Venomous Sting",
        author = "lilyhops",
        cards_in_pack = 5,
        weight = 1,
        actions = {
            {
                id = "POISON_TRAIL", -- poison trail
                weight = 5,
                limit_per_pack = 3,
            },
            {
                id = "ACIDSHOT", -- acid ball
                weight = 5,
                limit_per_pack = 3,
            },
            {
                id = "POISON_BLAST", -- explosion of poison
                weight = 5,
                limit_per_pack = 5,
            },
            {
                id = "MIST_RADIOACTIVE", -- toxic mist
                weight = 5,
                limit_per_pack = 5,
            },
            {
                id = "SINEWAVE", -- slithering path
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "WATER_TO_POISON", -- water to poison
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "ARC_POISON", -- poison arc
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "HIT_FX_TOXIC_CHARM", -- charm on toxic sludge
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "PIERCING_SHOT", -- piercing shot
                weight = 1,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_SHOT", -- light shot
                weight = 1,
                limit_per_pack = 1,
            }
        }
    },
    {
        id = "gkbrkn_density",
        name = "Density Manipulation",
        author = "lilyhops",
        cards_in_pack = 5,
        weight = 1,
        limit_per_run = -1,
        validation_callback = nil,
        actions = {
            {
                id = "LEVITATION_FIELD", -- circle of buoyancy
                weight = 5,
                limit_per_pack = 3,
            },
            {
                id = "GKBRKN_TIME_COMPRESSION", -- time compression
                weight = 5,
                limit_per_pack = 3,
            },
            {
                id = "LASER", -- concentrated light
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "GKBRKN_ZERO_GRAVITY", -- zero gravity
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "GKBRKN_TIME_SPLIT", -- time split
                weight = 5,
                limit_per_pack = 5,
            },
            {
                id = "BLACK_HOLE_BIG", -- giga black hole
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "GRAVITY", -- gravity
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "TELEPORT_PROJECTILE", -- teleport
                weight = 3,
                limit_per_pack = 2,
            },
            {
                id = "HEAVY_SHOT", -- heavy shot
                weight = 1,
                limit_per_pack = 1,
            },
            {
                id = "MATTER_EATER", -- matter eater
                weight = 1,
                limit_per_pack = 3,
            }
        }
    },
    {
        id = "pasta_3",
        name = "Steve Slayer",
        author = "pasta",
        cards_in_pack = 4,
        weight = 1,
        limit_per_run = 1,
        actions = {
            {
                id = "ELECTROCUTION_FIELD",
                weight = 2,
                limit_per_pack = 1,
            },
            {
                id = "FREEZE_FIELD",
                weight = 2,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_BULLET_TRIGGER",
                weight = 1,
                limit_per_pack = 1,
            },
            {
                id = "CHAINSAW",
                weight = 1,
                limit_per_pack = 1,
            }
        }
    },]]
};