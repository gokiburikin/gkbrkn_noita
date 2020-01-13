dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_ORDER_DECK", "order_deck", ACTION_TYPE_PASSIVE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 7, -1,
    "mods/gkbrkn_noita/files/gkbrkn/actions/order_deck/custom_card.xml",
    function()
        draw_actions( 1, true );
    end
) );
