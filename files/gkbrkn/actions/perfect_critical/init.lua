dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PERFECT_CRITICAL", "perfect_critical", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 300, 20, -1,
    nil,
    function()
        c.damage_critical_multiplier = math.max( 1, c.damage_critical_multiplier ) + 1;
        draw_actions( 1, true );
    end
) );