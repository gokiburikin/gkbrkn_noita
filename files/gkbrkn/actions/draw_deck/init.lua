dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_DRAW_DECK", "draw_deck", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 280, 30, -1,
    nil,
    function()
        draw_actions( #deck, true );
    end
) );