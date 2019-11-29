table.insert( actions,
{
    id          = "GKBRKN_ORDER_DECK",
    name 		= "Order Deck",
    description = "Correct the order all remaining spells will be cast",
    sprite 		= "files/gkbrkn/actions/order_deck/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/order_deck/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 1,
    action 		= function()
        local before = gun.shuffle_deck_when_empty;
        gun.shuffle_deck_when_empty = false;
        order_deck();
        gun.shuffle_deck_when_empty = before;
        draw_actions( 1, true );
    end,
});
