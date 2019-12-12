dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PERFECT_CRITICAL", "perfect_critical", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 190, 0, 7,
    nil,
    function()
        c.damage_critical_chance = c.damage_critical_chance + 100;
        draw_actions( 1, true );
    end
) );