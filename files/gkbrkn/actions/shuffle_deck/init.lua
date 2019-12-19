dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_SHUFFLE_DECK", "shuffle_deck", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 1, -1,
    nil,
    function()
        local shuffle_deck = {};
        for i=1, #deck do
            local index = Random( 1, #deck );
            local action = deck[ index ];
            table.remove( deck, index );
            table.insert( shuffle_deck, action );
        end
        for index,action in pairs(shuffle_deck) do
            table.insert( deck, action );
        end
        draw_actions( 1, true );
    end
) );
