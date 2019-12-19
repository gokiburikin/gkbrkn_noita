dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PATH_CORRECTION", "path_correction", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 200, 30, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/path_correction/projectile_extra_entity.xml,";
        c.speed_multiplier = c.speed_multiplier * 0.75;
        draw_actions( 1, true );
    end
) );