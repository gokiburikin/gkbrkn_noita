dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_EXTRA_PROJECTILE", "extra_projectile", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 320, 12, -1,
    nil,
    function()
        c.spread_degrees = c.spread_degrees + 3;
        c.fire_rate_wait = c.fire_rate_wait + 8;
        current_reload_time = current_reload_time + 8;
        extra_projectiles( 1 );
        draw_actions( 1 , true );
    end
) );