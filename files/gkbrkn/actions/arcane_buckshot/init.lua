dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_ARCANE_BUCKSHOT", "arcane_buckshot", ACTION_TYPE_PROJECTILE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 210, 12, -1,
    nil, 
    function()
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" );
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" );
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" );
        c.fire_rate_wait = c.fire_rate_wait + 16;
        current_reload_time = current_reload_time + 42;
    end
));