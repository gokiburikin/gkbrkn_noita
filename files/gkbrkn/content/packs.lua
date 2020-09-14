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
                memoize_packs[id] = entry;
            end
        end
    end
    return pack;
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
    ]]
    {
        id = "gkbrkn_critical_hits",
        name = "Critical Hits",
        -- this might become an xml to load? that way people could design specialer packs
        image_filepath = "mods/gkbrkn_noita/files/gkbrkn/packs/critical_hits/pack.png", -- the path to the pack image
        custom_xml = nil, -- this would contain a pack entity that might have cool legendary effects
        author = "goki", -- your name
        cards_in_pack = 5, -- this is how many cards the player will get when they buy the pack (default 5)
        weight = 1, -- the likelihood that this pack will show up over other packs (higher is more often)
        limit_per_run = -1, -- the max amount this pack can spawn in a run. -1 is no limit
        validation_callback = nil, -- a function callback to see if this can spawn. ignore for the most part
        actions = {
            {
                id = "SWAPPER_PROJECTILE",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "CRITICAL_HIT",
                weight = 5,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_BULLET",
                weight = 60,
                limit_per_pack = 3,
            },
            {
                id = "LIGHT_BULLET_TRIGGER",
                weight = 20,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_BULLET_TRIGGER_2",
                weight = 10,
                limit_per_pack = 1,
            },
            {
                id = "LIGHT_BULLET_TIMER",
                weight = 3,
                limit_per_pack = 1,
            },
            {
                id = "BULLET",
                weight = 50,
                limit_per_pack = 2,
            },
            {
                id = "BULLET_TRIGGER",
                weight = 10,
                limit_per_pack = 1,
            },
            {
                id = "BULLET_TIMER",
                weight = 10,
                limit_per_pack = 1,
            },
            {
                id = "HEAVY_BULLET",
                weight = 30,
                limit_per_pack = 1,
            },
            {
                id = "HEAVY_BULLET_TRIGGER",
                weight = 10,
                limit_per_pack = 1,
            },
            {
                id = "HEAVY_BULLET_TIMER",
                weight = 10,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_BURNING_CRITICAL_HIT",
                weight = 1,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_CRITICAL_WATER",
                weight = 1,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_CRITICAL_OIL",
                weight = 1,
                limit_per_pack = 1,
            },
            {
                id = "HITFX_CRITICAL_BLOOD",
                weight = 1,
                limit_per_pack = 1,
            }
        }
    },
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
    },
};