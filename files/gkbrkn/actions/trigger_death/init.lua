dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_TRIGGER_DEATH", "trigger_death", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 10, -1,
    nil,
    function()
        set_trigger_death( 1 );
        draw_actions( 1, true );
    end
) );