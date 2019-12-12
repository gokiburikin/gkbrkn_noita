dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_BREAK_CAST", "break_cast", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 50, 2, -1,
    nil,
    function()
        c.fire_rate_wait = c.fire_rate_wait - 10.2;
        current_reload_time = current_reload_time - 10.2;
        skip_cards();
    end
));
