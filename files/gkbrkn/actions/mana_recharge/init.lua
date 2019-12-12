dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_MANA_RECHARGE", "mana_recharge", ACTION_TYPE_PASSIVE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 1, -1,
    "mods/gkbrkn_noita/files/gkbrkn/actions/mana_recharge/custom_card.xml",
    function()
        draw_actions(1, true);
    end
) );
