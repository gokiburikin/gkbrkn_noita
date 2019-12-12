dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_SHIMMERING_TREASURE", "shimmering_treasure", ACTION_TYPE_PASSIVE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 7, -1,
    "mods/gkbrkn_noita/files/gkbrkn/actions/shimmering_treasure/custom_card.xml",
    function()
    end
) );
