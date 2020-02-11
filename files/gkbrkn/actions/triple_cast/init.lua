dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_TRIPLE_CAST", "triple_cast", ACTION_TYPE_OTHER,
    "0,1,2,3,4,5,6", "0.3,0.3,0.3,0.3,0.3,0.3,0.3", 500, 50, -1,
    nil,
    function()
        if reflecting then return; end
		duplicate_draw_action( 1, 3, true );
    end
));