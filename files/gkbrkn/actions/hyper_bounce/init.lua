dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_HYPER_BOUNCE", "hyper_bounce", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 500, 50, -1,
    nil,
    function()
        c.bounces = c.bounces + 999;
        draw_actions( 1, true );
    end
) );