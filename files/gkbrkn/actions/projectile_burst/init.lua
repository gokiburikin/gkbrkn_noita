dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PROJECTILE_BURST", "projectile_burst", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 320, 24, 24,
    nil,
    function()
        c.fire_rate_wait = c.fire_rate_wait + 10;
        current_reload_time = current_reload_time + 10;
        c.speed_multiplier = c.speed_multiplier * (1 + ( math.random() - 0.5 ) * 0.2 );
        extra_projectiles( 4 );
        draw_actions( 1, true );
    end
) );