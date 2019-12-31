dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_STORED_SHOT", "stored_shot", ACTION_TYPE_STATIC_PROJECTILE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 160, 4, -1,
    nil,
    function()
        add_projectile_trigger_death( "mods/gkbrkn_noita/files/gkbrkn/actions/stored_shot/projectile.xml", 1 );
		current_reload_time = current_reload_time + 12;
    end
) );