dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_MULTI_DEATH_TRIGGER", "multi_death_trigger", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 200, 12, -1,
    nil,
    function()
        for i=1,2,1 do
            set_trigger_death( 1 );
        end
        draw_actions( 1, true );
    end
) );