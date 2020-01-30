if loadouts_to_parse ~= nil then
    for _,loadout_data in pairs( loadouts_to_parse ) do
        local id = "parse_"..loadout_data.folder;
        local name = loadout_data.name;
        local cape_color = loadout_data.cape_color;
        local cape_edge_color = loadout_data.cape_edge_color;
        local items = {};
        for _,item_data in pairs( loadout_data.items or {} ) do
            if type( item_data ) == "table" then
                for i=1,item_data.amount do
                    if item_data.options ~= nil then
                        table.insert( items, item_data.options );
                    else
                        table.insert( items, { item_data[1] } );
                    end
                end
            else
                table.insert( items, { item_data } );
            end
        end
        local perks = {};
        for _,perk_data in pairs( loadout_data.perks or {} ) do
            table.insert( perks, { perk_data } );
        end
        GKBRKN_CONFIG.register_loadout( id, name, loadout_data.author, cape_color, cape_edge_color, {}, {}, items, perks, {}, loadout_data.sprites );
    end
end

--[[

"gkbrkn_speedrunner", -- unique identifier
"Speedrunner TYPE", -- displayed loadout name
0xffeeeeee, -- cape color (ABGR)
0xffffffff, -- cape edge color (ABGR)
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
            reload_time = {12,18}, -- recharge time in frames
            fire_rate_wait = {12,18}, -- cast delay in frames
            spread_degrees = {0,2}, -- spread
            mana_charge_speed = {40,60}, -- mana charge speed
            mana_max = {100,160}, -- mana max
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
},
-- this function is called when the player spawns as this loadout
]]

--[[

    {
		name = "Summoner TYPE",
		folder = "summoner",
		-- NOTE: Usually the game uses ARGB format for colours, but the cape colour uses ABGR here instead
		cape_color = 0xff60a1a2,
		cape_color_edge = 0xff3c696a,
		items = 
		{
			"mods/starting_loadouts/files/summoner/wands/wand_1.xml",
			"mods/starting_loadouts/files/summoner/wands/wand_2.xml",
			"data/entities/items/pickup/potion_water.xml",
			{ 
			options = { "data/entities/items/pickup/egg_fire.xml", "data/entities/items/pickup/egg_red.xml", "data/entities/items/pickup/egg_monster.xml", "data/entities/items/pickup/egg_slime.xml" },
			amount = 3,
			},
		},
	},
    ]]