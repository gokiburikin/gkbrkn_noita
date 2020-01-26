dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_TIME_COMPRESSION", "time_compression", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 150, 4, -1,
    nil,
    function()
        c.lifetime_add = c.lifetime_add - 9999;
        draw_actions( 1, true );
    end
) );