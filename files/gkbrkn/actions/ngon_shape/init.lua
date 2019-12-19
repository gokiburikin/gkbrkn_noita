dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_NGON_SHAPE", "ngon_shape", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 120, 24, -1,
    nil,
    function()
        c.pattern_degrees = 180;
        draw_actions( #deck, true );
    end
) );
