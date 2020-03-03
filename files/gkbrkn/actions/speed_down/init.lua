dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_SPEED_DOWN", "speed_down", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 50, -3, -1,
    nil,
    function()
        c.speed_multiplier = c.speed_multiplier * 0.33;
		draw_actions( 1, true );
    end
) );