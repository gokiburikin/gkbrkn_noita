dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_SPELL_EFFICIENCY", "spell_efficiency", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 380, 0, -1,
    nil,
    function()
        --reduce_spell_usage( 0.33 );
        draw_actions( 1, true );
    end
) );