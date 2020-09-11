dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_TIME_SPLIT", "time_split", ACTION_TYPE_OTHER, 
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 140, 3, -1,
    nil,
    function()
        -- hi, i'm goki
        local sum = (c.fire_rate_wait + current_reload_time) * 0.5;
        c.fire_rate_wait = sum;
        current_reload_time = sum;
        draw_actions( 1, true );
    end
) );
