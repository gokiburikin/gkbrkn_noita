dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_BARRIER_TRAIL", "barrier_trail", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 200, 20, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/barrier_trail/wall_builder.xml,";
        draw_actions( 1, true );
    end
) );