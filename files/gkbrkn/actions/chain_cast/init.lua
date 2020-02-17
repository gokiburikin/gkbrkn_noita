dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_CHAIN_CAST", "chain_cast", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 200, 120, -1,
    nil,
    function()
        c.speed_multiplier = c.speed_multiplier * 0.50;
		c.fire_rate_wait = c.fire_rate_wait + 45;
		c.spread_degrees = c.spread_degrees + 7;
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/chain_cast/projectile_extra_entity.xml,mods/gkbrkn_noita/files/gkbrkn/actions/chain_cast/trail.xml,"
        draw_actions( 1, true );
    end
) );