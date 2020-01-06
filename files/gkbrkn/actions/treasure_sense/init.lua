dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_TREASURE_SENSE", "treasure_sense", ACTION_TYPE_UTILITY,
    "0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 140, 2, -1,
    "mods/gkbrkn_noita/files/gkbrkn/actions/treasure_sense/custom_card.xml",
    function()
        draw_actions( 1, true );
    end
) );
