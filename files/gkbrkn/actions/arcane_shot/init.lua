table.insert( actions, generate_action_entry(
    "GKBRKN_ARCANE_SHOT", "arcane_shot", ACTION_TYPE_PROJECTILE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 375, 65, -1,
    nil,
    function()
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_shot/projectile.xml" );
		c.fire_rate_wait = c.fire_rate_wait + 30;
		current_reload_time = current_reload_time + 90
    end
) );