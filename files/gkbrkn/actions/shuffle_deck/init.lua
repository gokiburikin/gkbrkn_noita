table.insert( actions,
{
    id          = "GKBRKN_SHUFFLE_DECK",
    name 		= "Shuffle Deck",
    description = "Randomize the order of all remaining spells",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/shuffle_deck/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/shuffle_deck/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 1,
    action 		= function()
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

        draw_actions( 1 ,true );
    end,
});
