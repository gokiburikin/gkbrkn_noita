dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PROJECTILE_GRAVITY_WELL", "projectile_gravity_well", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 3, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_gravity_well/projectile_extra_entity.xml,";
        c.speed_multiplier = c.speed_multiplier * 0.75;
        draw_actions( 3, true );
    end
) );