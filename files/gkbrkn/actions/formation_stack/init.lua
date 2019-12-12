dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_FORMATION_STACK", "formation_stack", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 160, 2, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/formation_stack/projectile_extra_entity.xml,"
        draw_actions( 3, true );
    end
));
