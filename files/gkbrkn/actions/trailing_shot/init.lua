dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_TRAILING_SHOT", "trailing_shot", ACTION_TYPE_DRAW_MANY, 
    "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 10, 5, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/trailing_shot/projectile_extra_entity.xml,";
        draw_actions( 4, true );
    end
) );