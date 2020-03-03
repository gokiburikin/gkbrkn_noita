dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_REDUCE_KNOCKBACK", "reduce_knockback", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 5, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/reduce_knockback/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end
) );