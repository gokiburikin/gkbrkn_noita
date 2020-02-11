dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_DOUBLE_CAST", "double_cast", ACTION_TYPE_OTHER,
    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 400, 30, -1,
    nil,
    function()
        if reflecting then return; end
		duplicate_draw_action( 1, 2, true );
    end
));