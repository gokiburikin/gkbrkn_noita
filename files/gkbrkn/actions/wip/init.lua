dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_ACTION_WIP", "wip", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 1, 1, -1,
    nil,
    function()
        dofile("mods/gkbrkn_noita/files/gkbrkn/actions/wip/action.lua");
    end
) );
