dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_CHAOTIC_BURST", "chaotic_burst", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 320, 5, -1,
    nil,
    function()
		c.extra_entities = c.extra_entities .. "data/entities/misc/chaotic_arc.xml,data/entities/misc/chaotic_arc.xml,"
        c.fire_rate_wait = c.fire_rate_wait - 10;
        current_reload_time = current_reload_time - 10;
        c.spread_degrees = c.spread_degrees + 9999;
        c.speed_multiplier = c.speed_multiplier * 0.67;
        c.bounces = c.bounces + 1;
        extra_projectiles( Random( 2, 5 ) );
        draw_actions( 1, true );
    end
) );