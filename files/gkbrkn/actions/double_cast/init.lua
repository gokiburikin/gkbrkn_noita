dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_DOUBLE_CAST", "double_cast", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 500, 50, -1,
    nil,
    function()
		duplicate_draw_action( 2, true );
    end
));