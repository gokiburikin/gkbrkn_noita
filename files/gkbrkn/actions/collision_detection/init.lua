dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_COLLISION_DETECTION", "collision_detection", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 90, 4, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/collision_detection/projectile_extra_entity.xml,";
        c.speed_multiplier = c.speed_multiplier * 0.85;
        c.bounces = math.max( 1, c.bounces );
        draw_actions( 1, true );
    end
));
